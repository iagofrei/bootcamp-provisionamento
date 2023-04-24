from config.database import DatabaseService
from config.rds_config import get_db_info
from datetime import datetime

database_service = DatabaseService(**get_db_info())

QUERY_DROP = """DROP DATABASE IF EXISTS dbgp3"""
QUERY_CREATE_DATABASE = """CREATE DATABASE dbgp3"""
QUERY_USE_DATABASE = """USE dbgp3"""
QUERY_CREATE_TABLE = """
    CREATE TABLE s3_notification_event (
        event_name  VARCHAR(100),
        bucket_name VARCHAR(64),
        object_name VARCHAR(300),
        user_name   VARCHAR(100),
        updated_at  TIMESTAMP
    )
"""

def lambda_handler(event, context):
    try:
        with database_service:
            print("Invocando DB para executar query")

            database_service.execute(QUERY_DROP)
            database_service.commit()

            database_service.execute(QUERY_CREATE_DATABASE)
            database_service.commit()

            database_service.execute(QUERY_USE_DATABASE)
            database_service.commit()

            database_service.execute(QUERY_CREATE_TABLE)
            database_service.commit()
        
    except Exception as e:
        print(f"Deu ruim no DB: {e}")