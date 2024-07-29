from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

DATABASE_URL = 'postgresql://postgres:harsh123@localhost:5432/music_app'
# connect to your database
engine = create_engine(DATABASE_URL) #accepts a database url
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# create a session
def get_db():
     db = SessionLocal()
     try:
          yield db
     finally:
          db.close()