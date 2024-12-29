from models.base import Base
from sqlalchemy import TEXT, VARCHAR, Column, String

class Song(Base):
    __tablename__ = 'songs'

    id = Column(TEXT, primary_key=True)
    song_name = Column(VARCHAR(100))
    artist = Column(String)
    hex_code = Column(VARCHAR(6))
    song_url = Column(String)
    thumbnail_url = Column(String)