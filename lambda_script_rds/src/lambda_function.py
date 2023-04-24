from config.database import DatabaseService
from config.rds_config import get_db_info
from datetime import datetime

database_service = DatabaseService(**get_db_info())

QUERY = """
    DROP DATABASE dbgp3 IF EXISTS;
    CREATE DATABASE dbgp3;
    USE dbgp3;

    CREATE TABLE s3_notification_event (
        event_name  VARCHAR(100),
        bucket_name VARCHAR(64),
        object_name VARCHAR(300),
        user_name   VARCHAR(100),
        updated_at  TIMESTAMP
    );
"""

def lambda_handler(event, context):
    try:
        with database_service:
            print("Invocando DB para executar query")

            database_service.execute(QUERY)
            database_service.commit()
        
    except Exception as e:
        print(f"Deu ruim no DB: {e}")