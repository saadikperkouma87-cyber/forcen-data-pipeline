from kafka import KafkaProducer
import pandas as pd
import json
import time
from datetime import datetime

producer = KafkaProducer(
    bootstrap_servers="localhost:9092",
    value_serializer=lambda v: json.dumps(v).encode("utf-8")
)

# Chargement du dataset
df = pd.read_csv(
    "/home/djodj/data/training.1600000.processed.noemoticon.csv",
    encoding="latin-1",
    header=None
)

# Envoi des tweets
for _, row in df.iterrows():

    tweet = {
        "Sentiment": row[0],
        "id": int(row[1]),
        "date": row[2],
        "Query": row[3],
        "user": row[4],
        "text": row[5]
    }

    producer.send("tweet", tweet)
producer.flush()
producer.close()

    #print(tweet)

    #time.sleep(1)
