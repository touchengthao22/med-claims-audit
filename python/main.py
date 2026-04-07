import pandas as pd
from sqlalchemy import create_engine, text
import os
from dotenv import load_dotenv

def csv_to_sql(path: str, db_name: str, table_name: str) -> None:
    chunksize = 50000
    count = 0

    load_dotenv()
    username = os.getenv('DB_USERNAME')
    password = os.getenv('DB_PASSWORD')

    engine = create_engine(f'mysql+pymysql://{username}:{password}@localhost:3306')

    with engine.connect() as conn:
        conn.execute(text(f'CREATE DATABASE IF NOT EXISTS {db_name}'))

    engine = create_engine(f'mysql+pymysql://{username}:{password}@localhost:3306/{db_name}')
    
    try:
        for chunk in pd.read_csv(path, chunksize=chunksize, low_memory=False):
            chunk.to_sql(
                table_name,
                engine,
                if_exists='append' if count > 0 else 'replace',
                index=False,
                method='multi'
            )

            print(f"Inserted chunk {count}")
            count +=1
        
        print('Successfully loaded data in sql!')
    
    except Exception as e:
        print(f'An eorr occred: {e}')


def file_path() -> str:
    current_dir = os.path.dirname(os.path.abspath(__file__))
    data_dir = os.path.join(current_dir,"../data")

    if not os.path.exists(data_dir):
        raise FileNotFoundError("The 'data' folder does not exist!")
    
    csv_file = next((f for f in os.listdir(data_dir) if f.endswith('.csv')), None)

    if csv_file is None:
        raise FileNotFoundError("No CSV file found in the 'data' folder!")

    csv_path = os.path.join(data_dir, csv_file)

    return csv_path


if __name__ == "__main__":
    db_name = 'claims_qc'
    table_name = 'claims'
    csv_to_sql(file_path(), db_name, table_name)