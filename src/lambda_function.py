from config.database import DatabaseService
from config.rds_config import get_db_info
from datetime import datetime

database_service = DatabaseService(**get_db_info())

QUERY = """
    INSERT INTO
        dbgp3.movimentacoes_projeto
    VALUES (
        %s, %s, %s, %s, %s
    )
"""

def lambda_handler(event, context):
    
    print(f"Evento recebido: {event}")
    
    try:
        s3_event = event['Records'][0]

        with database_service:
            params = (
                s3_event['eventName'],
                s3_event['s3']['bucket']['name'],
                s3_event['s3']['object']['key'],
                s3_event['userIdentity']['principalId'],
                str(datetime.now())
            )

            print("Invocando DB para executar query")
            database_service.execute(QUERY, params)
            database_service.commit()

    except KeyError as ke:
        print(f"Body de requisição incorreto: {ke}")
        
    except Exception as e:
        print(f"Deu ruim no DB: {e}")