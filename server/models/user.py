from models.base import Base
from sqlalchemy import TEXT, Column, LargeBinary, String

class User(Base):
    __tablename__ = 'users'

    id = Column(TEXT, primary_key=True)
    username = Column(String, unique=True)
    email = Column(String, unique=True)
    password = Column(LargeBinary)