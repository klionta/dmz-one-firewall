from flask import Flask
import os
import psycopg2


app = Flask(__name__)

DB_HOST = os.environ.get('DB_HOST','172.19.0.2')
DB_PORT = int(os.environ.get('DB_PORT','5432'))
DB_USER = os.environ.get('DB_USER','test')
DB_PASS = os.environ.get('DB_PASS','test')
DB_NAME = os.environ.get('DB_NAME','company')

@app.route('/')
def index():
    return "Hello from DMZ web server! Try /db to query the DB."


@app.route('/db')
def db_check():
    try:
        conn = psycopg2.connect(host=DB_HOST, port=DB_PORT, user=DB_USER, password=DB_PASS, dbname=DB_NAME, connect_timeout=3)
        cur = conn.cursor()
        cur.execute("SELECT 'OK' as status")
        result = cur.fetchone()
        cur.close()
        conn.close()
        return f"DB response: {result[0]}"
    except Exception as e:
        return f"DB connection failed: {e}", 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)