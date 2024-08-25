import uuid
import bcrypt
from fastapi import Depends, HTTPException
from database import get_db
from models.user import User
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter
from sqlalchemy.orm import Session
from pydantic_schemas.user_login import UserLogin
import jwt
from sqlalchemy.orm import joinedload

router = APIRouter()

@router.post('/signup', status_code=201)
def signup_user(user: UserCreate, db: Session=Depends(get_db)):
     #extract data that's coming from request
     # check if the user already exists in db
     user_db = db.query(User).filter(User.email == user.email).first()
     if user_db:
          raise HTTPException(400, 'User with the same email already exists!') 
     
     # hash the password before storing it in the database
     hashed_pw = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt(16))

     #instance of User class
     user_db = User(id=str(uuid.uuid4()), email=user.email, password=hashed_pw, name=user.name)

     #add the user to the database
     db.add(user_db)
     db.commit()
     db.refresh(user_db)

     return user_db

@router.post('/login')
def login_user(user: UserLogin, db: Session=Depends(get_db)):
     #Check if the user exists
     user_db = db.query(User).filter(User.email == user.email).first()
     if not user_db:
          raise HTTPException(400, 'User with the given email does not exist!')
     
     #Check if the password is correct
     if not bcrypt.checkpw(user.password.encode(), user_db.password):
          raise HTTPException(status_code=400, detail='Incorrect password!')
     
     token = jwt.encode({'id': user_db.id},'password_key')
     
     return {'token' : token , 'user' : user_db}