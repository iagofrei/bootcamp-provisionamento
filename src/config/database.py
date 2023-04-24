import pymysql
from typing import Any, Dict, Optional, Tuple

class DatabaseService:
    def __init__(
            self,
            host: str,
            database: str,
            user: str,
            password: str,
            port: str
    ):
        self.host = host
        self.database = database
        self.user = user
        self.password = password
        self.port = int(port)

    def __enter__(self):
        if not self._is_conn_open():
            print("Abrindo conexao")
            self.conn = pymysql.connect(
                host=self.host,
                database=self.database,
                user=self.user,
                password=self.password,
                autocommit=True,
                cursorclass=pymysql.cursors.DictCursor,
                port=self.port,
                connect_timeout=600
            )
            return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        pass

    def execute(self, statement: str, params=None) -> Optional[Tuple[Dict[str, Any], ...]]:
        if self._is_conn_open():
            return _execute(self.conn, statement, params)
        else:
            raise TypeError("Impossivel operar em conexao fechada")

    def commit(self):
        if self._is_conn_open():
            self.conn.commit()
        else:
            raise TypeError("Impossivel operar em conexao fechada")

    def _is_conn_open(self) -> bool:
        return hasattr(self, "conn") and self.conn.open
    

def _execute(
        conn: pymysql.connections.Connection, stmt: str, params=None
) -> Optional[Tuple]:
    with conn.cursor() as cur:
        print(f"Executando a query {repr(stmt)} com parametros {repr(params)}")
        cur.execute(stmt, params)
        results = cur.fetchall()
        print("Query executada com sucesso")

    return results