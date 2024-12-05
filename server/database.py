

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker


DB_URL = 'postgresql://postgres:postgres@localhost:5433/musicapp'

engine = create_engine(DB_URL)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()