import bcrypt

from fastapi import FastAPI, HTTPException
from models.base import Base
from router import auth
from database import engine

app = FastAPI()

app.include_router(auth.router, prefix='/auth')

Base.metadata.create_all(engine)

