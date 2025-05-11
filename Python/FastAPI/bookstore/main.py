from fastapi import FastAPI
import bookstore_apis

app = FastAPI()

app.include_router(bookstore_apis.router)

