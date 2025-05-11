from sqlmodel import Field, SQLModel, create_engine, Session, select
from fastapi import FastAPI

class User(SQLModel, table=True):
    id: int | None = Field(default=None, primary_key=True)
    name: str = Field(index=True) 
    email: str

