from fastapi import FastAPI


app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.get("/hello")
def say_hello(name: str = "Guest"):
    return {"message" : f"Hello {name}"}


@app.get("/calculator")
def calculate(num1 : int, num2: int):
    return{
        "sum" : num1 + num2,
        "difference" : abs(num1 - num2),
        "product" : num1 * num2,
        "quotient" : num1 / num2 if num2 != 0 else "Cannot divide by zero"
    }

#Path parameters
@app.get("/items/{item_id}")
def read_item(item_id: int):
    return {"item_id":  item_id}

#/users/{user_id}/items  /users/10/items (returns list of items for user 10)
# @app.get("/users/{user_id}/items")
# def get_user_items(user_id: int):
#     return {"user_id": user_id, "items": [ "item1", "item2", "item3"]}


@app.post("/items/")
def create_item(item: dict):
    return {"item_created": item}

@app.post("/users/")
def user_data(username: str, email: str):
   return {"id" : 1, "username": username, "email": email}