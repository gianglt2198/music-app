import uuid
import bcrypt
from fastapi import APIRouter, Depends, HTTPException, Header
from database import get_db
from models.user import User
from schemas.auth import UserCreate, UserLogin
from sqlalchemy.orm import Session, joinedload
import jwt

from middlewares.auth_middleware import auth_middleware

router = APIRouter()

@router.post('/signup', status_code=201)
def post_users(user: UserCreate, db: Session = Depends(get_db)):

    user_db = db.query(User).filter(User.email == user.email).first()
    if user_db:
        raise HTTPException(status_code=400, detail='Email already registered')

    hashed_password = bcrypt.hashpw(user.password.encode('utf-8'), bcrypt.gensalt())
    user_db = User(id=str(uuid.uuid4()), name=user.name, email=user.email, password=hashed_password)
    db.add(user_db)
    db.commit()
    db.refresh(user_db)

    return user_db

@router.post('/login')
def post_login(user: UserLogin, db: Session = Depends(get_db)):

    user_db = db.query(User).filter(User.email == user.email).first()
    if not user_db or not bcrypt.checkpw(user.password.encode('utf-8'), user_db.password):
        raise HTTPException(status_code=400, detail='Invalid email or password')

    token =  jwt.encode({"id": user_db.id}, "secret", algorithm="HS256")
    
    return {'token': token, 'user': user_db}

@router.get('/')
def current_user_data(db: Session=Depends(get_db), 
                      user_dict = Depends(auth_middleware)):
    user_db = db.query(User).filter(User.id == user_dict['uid']).options(
        joinedload(User.favorites)
    ).first()
    if not user_db:
        raise HTTPException(404, "User not found!")
    return user_db