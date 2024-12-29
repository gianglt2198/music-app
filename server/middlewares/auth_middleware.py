

from fastapi import HTTPException, Header
import jwt


def auth_middleware(x_auth_token=Header()):
    try: 
        if not x_auth_token:
            raise HTTPException(400, 'No auth token, access denied!')

        verified_token =  jwt.decode(x_auth_token, 'secret', algorithms="HS256")
        
        if not verified_token:
            raise HTTPException(401, 'Token verificantion failed, authorization!')
 
        uid = verified_token.get('id')
        return {'uid': uid, 'token': x_auth_token}
    except jwt.PyJWTError:
        raise HTTPException(401, "Token is not valid, authorization failed!")
    
    