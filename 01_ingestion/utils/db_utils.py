from dotenv import load_dotenv
from pathlib import Path
import os
from sqlalchemy import create_engine
import pandas as pd
import uuid

# Load file .env in 00_setup
env_path = Path(__file__).resolve().parents[2] / "00_setup" / ".env"
load_dotenv(env_path)

DB_HOST = os.getenv("DB_HOST")
PORT = os.getenv("DB_PORT")
USER = os.getenv("DB_USER")
PWD = os.getenv("DB_PASSWORD")
DB_NAME = os.getenv("DB_NAME")


engine = create_engine(
    f"postgresql+psycopg2://{USER}:{PWD}@{DB_HOST}:{PORT}/{DB_NAME}"
)


def add_metadata(df, file_name):

    df["_source_file"] = file_name
    df["_source_platform"] = "Local"
    df["_ingested_at"] = pd.Timestamp.now()
    df["_batch_id"] = str(uuid.uuid4())

    return df
