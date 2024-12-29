from models.base import Base
from sqlalchemy import TEXT, Column, LargeBinary, String
from sqlalchemy.orm import relationship 

class User(Base):
    __tablename__ = 'users'

    id = Column(TEXT, primary_key=True)
    name = Column(String, unique=True)
    email = Column(String, unique=True)
    password = Column(LargeBinary)

    favorites = relationship("Favorite", back_populates="user")