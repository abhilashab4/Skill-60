from sqlmodel import Field, SQLModel, create_engine, Session, select
from fastapi import FastAPI
from database import create_db_and_tables, engine
from models import User

app = FastAPI()

@app.on_event("startup")
def on_startup():
    create_db_and_tables()

#create new users
@app.post("/users/")
def create_user(user: User):
    with Session(engine) as session:
        session.add(user)
        session.commit()
        session.refresh(user)
        return user

@app.get("/users/")
def read_all_users():
    with Session(engine) as session:
        users = session.exec(select(User)).all()
        return users
    

@app.put("/users/{user_id}")
def update_user(user_id: int, user: User):
    with Session(engine) as session:
        db_user = session.exec(select(User).where(User.id == user_id)).first()
        if db_user:
            db_user.name = user.name
            db_user.email = user.email
            session.commit()
            session.refresh(db_user)
            return db_user
        else:
            return {"error": "User not found"}
        
@app.delete("/users/{user_id}")
def delete_user(user_id: int):
    with Session(engine) as session:
        db_user = session.exec(select(User).where(User.id == user_id)).first()
        if db_user:
            session.delete(db_user)
            session.commit()
            return {"message": "User deleted successfully"}
        else:
            return {"error": "User not found"}

@app.get("/users/{user_id}")
def read_user_by_id(user_id: int):
    with Session(engine) as session:
        user = session.exec(select(User).where(User.id == user_id)).first()
        if user:
            return user
        else:
            return {"error": "User not found"}
        

        
