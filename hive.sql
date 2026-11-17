-- create db
CREATE DATABASE IF NOT EXISTS tweet_db;

USE tweet_db;

-- create table 
CREATE TABLE IF NOT EXISTS tweets_new (
    sentiment INT,
    id BIGINT,
    tweet_date STRING,
    query STRING,
    username STRING,
    text STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
STORED AS TEXTFILE;

-- Vérification  des données
SELECT * FROM tweets_new LIMIT 10;
SELECT COUNT(*) FROM tweets_new;

-- recherche valeur null
SELECT COUNT(*) FROM tweets_new WHERE sentiment IS NULL
   OR id IS NULL OR  tweet_date IS NULL OR query IS NULL OR
   username IS NULL OR text IS NULL;

-- suppression des lignes null
CREATE TABLE tweets_clean AS SELECT * FROM tweets_new
WHERE sentiment IS NOT NULL
   OR id IS NOT NULL OR  tweet_date IS NOT NULL OR query IS NOT NULL OR 
   username IS NOT NULL OR text IS NOT NULL;

-- suppression tweet vide 
CREATE TABLE tweets_clean2 AS
SELECT *
FROM tweets_clean
WHERE TRIM(text) <> '';

-- clean complet
DROP TABLE IF EXISTS tweets_cleaned;
CREATE TABLE tweets_cleaned AS
SELECT
    sentiment,
    id,
    TRIM(tweet_date) AS tweet_date,
    TRIM(query) AS query,
    TRIM(username) AS username,
    TRIM(
        REGEXP_REPLACE(
            REGEXP_REPLACE(text, '[\r\n]+', ' '),
            '[ ]+',
            ' '
        )
    ) AS text
FROM tweets_new
WHERE sentiment IS NOT NULL
  AND id IS NOT NULL
  AND text IS NOT NULL
  AND TRIM(text) <> '';
SELECT COUNT(*) FROM tweets_cleaned;

-- conversion date
CREATE TABLE tweets_cleaned_f AS
SELECT
    sentiment,
    id,

    FROM_UNIXTIME(
        UNIX_TIMESTAMP(
            tweet_date,
            'EEE MMM dd HH:mm:ss z yyyy'
        )
    ) AS tweet_date,

    query,
    username,
    text
FROM tweets_cleaned
WHERE sentiment IS NOT NULL;
 -- query 
SELECT
    MONTH(tweet_date),
    COUNT(*)
FROM tweets_cleaned_f
GROUP BY MONTH(tweet_date);

-- voir sentiemt
SELECT sentiment, COUNT(*) AS total
FROM tweets_cleaned_F
GROUP BY sentiment
ORDER BY sentiment;
-- labeliser sentiment
SELECT
    CASE
        WHEN sentiment = 0 THEN 'NEGATIF'
        WHEN sentiment = 2 THEN 'NEUTRE'
        WHEN sentiment = 4 THEN 'POSITIF'
        ELSE 'INCONNU'
    END AS sentiment_label,
    COUNT(*) AS total
FROM tweets_cleaned_f
GROUP BY sentiment;

 -- export table 
beeline -u jdbc:hive2://localhost:10000/default \
--outputformat=csv2 \
-e "SELECT sentiment,id,tweet_date,query,username,text FROM twitter_db.tweets_cleaned;" \
> /tmp/tweets_cleaned.csv
-- copy data local machine 
docker cp myhiveserver:/tmp/tweets_cleaned.csv /home/djodj/tweets_cleaned.csv
