from models import User
from sqlmodel import Field, SQLModel, create_engine, Session, select


sql_file_name = "user.db"
sqlite_url = f"sqlite:///{sql_file_name}"

engine = create_engine(sqlite_url, echo=True)

def create_db_and_tables():
    SQLModel.metadata.create_all(engine)

