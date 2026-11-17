from kafka import KafkaConsumer
import json
import csv
import os
import subprocess

# Création du consumer Kafka
consumer = KafkaConsumer(
    "tweet",
    bootstrap_servers="localhost:9092",
    auto_offset_reset="earliest",
    enable_auto_commit=True,
    group_id="tweet-group",
    value_deserializer=lambda v: json.loads(v.decode("utf-8"))
)
print("Consumer connecté à Kafka...")
print("Stockage des tweets dans Hive...")

for message in consumer:
        tweet = message.value

        tweet_sentiment = tweet.get("Sentiment")
        tweet_id = tweet.get("id")
        tweet_date = tweet.get("date")
        tweet_query = tweet.get("Query")
        tweet_user = tweet.get("user")
        tweet_text = tweet.get("text")
        
        # Protection des apostrophes
        tweet_text = tweet_text.replace("'", "\\'")

        # Requête Hive
        query = f"""
        INSERT INTO TABLE tweet_db.tweets_new
        VALUES (
        {tweet_sentiment},
        {tweet_id},
        '{tweet_date}',
        '{tweet_query}',
        '{tweet_user}',
        '{tweet_text}'
        )
        """

    # Exécution de la requête Hive
        subprocess.run([
        "sudo",
        "docker",
        "exec",
        "myhiveserver",
         "beeline", 
         "-u",
        "jdbc:hive2://localhost:10000/default",
        "-e",
        query
             ])

print("Tweet stocké dans Hive")
