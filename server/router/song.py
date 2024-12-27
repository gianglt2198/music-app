

import uuid
import cloudinary
import cloudinary.uploader
from fastapi import APIRouter, Depends, File, Form, UploadFile
from sqlalchemy.orm import Session
from database import get_db
from server.middlewares import auth_middleware

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
                auth_dict=Depends(auth_middleware)):
    song_id = str(uuid.uuid4())
    thumbnail_id = str(uuid.uuid4())
    
    song_res = cloudinary.uploader.upload(song.file, resource_type='auto', folder=f'songs/{song_id}') 
    thumbnail_res = cloudinary.uploader.upload(thumbnail.file, resource_type='image', folder=f'songs/{song_id}') 