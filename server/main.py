import bcrypt

from fastapi import FastAPI, HTTPException
from models.base import Base
from router import auth
from database import engine
from server.router import song

app = FastAPI()

app.include_router(auth.router, prefix='/auth')
app.include_router(song.router, prefix='/song')

Base.metadata.create_all(engine)

