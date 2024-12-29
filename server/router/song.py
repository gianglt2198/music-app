

import uuid
import cloudinary
import cloudinary.uploader
from fastapi import APIRouter, Depends, File, Form, Request, UploadFile
from sqlalchemy.orm import Session
from database import get_db
from models.song import Song
from models.favorite import Favorite

from middlewares.auth_middleware import auth_middleware
from schemas.song import FavoriteSong
from sqlalchemy.orm import joinedload

router = APIRouter()

cloudinary.config( 
    cloud_name = "desmasmh2", 
    api_key = "399651394964652", 
    api_secret = "kp2bxo7COFYvA18M28CXS_P1Gn4", # Click 'View API Keys' above to copy your API secret
    secure=True
)


@router.post('/upload')
def upload_song(song: UploadFile = File(...),
                thumbnail: UploadFile = File(...),
                artist: str = Form(...),
                song_name: str = Form(...),
                hex_code: str = Form(...),
                db: Session=Depends(get_db),
                auth_details=Depends(auth_middleware)):
    
    song_id = str(uuid.uuid4())
    
    song_res = cloudinary.uploader.upload(song.file, resource_type='auto', folder=f'songs/{song_id}') 
    thumbnail_res = cloudinary.uploader.upload(thumbnail.file, resource_type='image', folder=f'songs/{song_id}') 
    
    new_song = Song(
        id=song_id,
        song_name=song_name,
        artist=artist,
        hex_code=hex_code,
        song_url=song_res['url'],
        thumbnail_url=thumbnail_res['url']
    )

    db.add(new_song)
    db.commit()
    db.refresh(new_song)
    return new_song

@router.get('/songs')
def list_songs(db: Session=Depends(get_db), 
               auth_details=Depends(auth_middleware)):
    songs = db.query(Song).all()
    return songs

@router.post('/favorite')
def favorite_song(fav_song: FavoriteSong,
                    db: Session=Depends(get_db), 
                  auth_details=Depends(auth_middleware)):
    
    
    user_id = auth_details['uid']
    song = db.query(Favorite).filter(Favorite.song_id == fav_song.song_id, Favorite.user_id == user_id).first()

    if song:
        db.delete(song)
        db.commit()
        return {'message': False}

    new_fav = Favorite(id=str(uuid.uuid4()), song_id=fav_song.song_id, user_id=user_id)
    db.add(new_fav)
    db.commit()
    return {'message': True}


@router.get('/list/favorites')
def list_fav_songs(db: Session=Depends(get_db), 
               auth_details=Depends(auth_middleware)):
    user_id = auth_details['uid']
    fav_songs  = db.query(Favorite).filter(Favorite.user_id == user_id).options(
        joinedload(Favorite.song)
    ).all()
    
    return fav_songs