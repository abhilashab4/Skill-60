from pydantic import BaseModel

class Book(BaseModel):
    title: str
    author: str
    year : int
    

class BookResponse(BaseModel):
    title: str
    author: str