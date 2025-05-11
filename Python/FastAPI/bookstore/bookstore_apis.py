from fastapi import FastAPI, HTTPException
from fastapi import APIRouter
from models import Book, BookResponse

router = APIRouter()


@router.post("/book")
async def create_book(book: Book):
    return book

@router.get("/books/{book_id}")
async def read_book(book_id: int):
    return {
        "book_id": book_id,
        "title": "Harry Potter",
        "author": "J.K. Rowling",
        }

@router.get("/authors/{author_id}")
async def read_author(author_id: int):
    return {
        "author_id": author_id,
        "name": "J.K. Rowling",
        "books": ["Harry Potter", "Fantastic Beasts"],
        }

@router.get("/books")
async def read_book(year: int = None):
    if year:
        return {
            "year" : year,
            "books" : ["Harry Potter", "Fantastic Beasts"]
        }
    
    return {"books" : ["All Books"]}

@router.get("/allbooks", response_model = list[BookResponse])
async def read_all_books(): #you can also specify -> list[BookResponse] in the function signature instead of response_model
    return[ {
        "id" : 1,
        "title" : "1984",
        "author" : "George Shettu"
    },
    {
        "id" : 2,
        "title" : "Harry Potter",
        "author" : "J.K. Rowling"
    },
    {
        "id" : 3,
        "title" : "The Hobbit",
        "author" : "J.R.R. Tolkien" 

    }
    ]

# @router.exception_handler(HTTPException)
# async def http_exception_handler(request, exc):
#     return {
#         "error": {
#             "status_code": exc.status_code,
#             "detail": exc.detail
#         }
#     }