import os

def get_db_info():
    print("Retornando as informacoes para conexao com o banco de dados")

    host = os.environ["DB_HOST"]
    username = os.environ["DB_USERNAME"]
    password = os.environ["DB_PASSWORD"]
    port = os.environ["DB_PORT"]
    db_name = os.environ["DB_NAME"]

    return {
        "host": host,
        "user": username,
        "password": password,
        "port": int(port),
        "database": db_name
    }
