from typing import Optional
from sqlmodel import Field,SQLModel,Session,create_engine,select

class Product(SQLModel,table=True):
    id : int | None = Field(default=None,primary_key=True)
    name: str = Field(index=True)
    description: str | None
    price: float 
    quantity: int =Field(default=0)



sqlite_file_name = "inventory.db"
sqlite_url = f"sqlite:///{sqlite_file_name}"

engine = create_engine(sqlite_url, echo=True)

def add_product(name:str, description:Optional[str], price:float, quantity:int):
    product1=Product(name=name,description=description,price=price,quantity=quantity)

    with Session(engine) as session:
        session.add(product1)
        session.commit()
        session.refresh(product1)
        print(f"product {product1} added")


def list_all_products():
    with Session(engine) as session:
        statement=select(Product)
        results=session.exec(statement)
        productlist=results.all()
        print(productlist)

def find_product_by_name(name: str):
    with Session(engine) as session:
        product=session.exec(select(Product).where(Product.name==name)).first()
        if product:
            print(f"\n Found Product: {product}")
        else:
            print(f"\n Product with name '{name}' not found.")

def update_product_quantity(name: str, new_quantity: int):
    with Session(engine) as session:
        product=session.exec(select(Product).where(Product.name==name)).first()

        if product:
            product.quantity=new_quantity
            session.add(product)
            session.commit()
            session.refresh(product)
            print(f"\n Updated quantity of '{name}' to {new_quantity}.")
        else:
            print(f"\n Product with name '{name}' not found. Cannot update.")

def delete_product(name: str):
    with Session(engine) as session:
        product = session.exec(select(Product).where(Product.name == name)).first()
        if product:
            session.delete(product)
            session.commit()
            print(f"\n Deleted product {name}.")
        else:
            print(f"\n Product with name '{name}' not found. Cannot delete.")



def create_db_and_tables():
    SQLModel.metadata.create_all(engine)

def main():
    # create_db_and_tables()
    # add_product("Laptop", "High performance laptop", 1200.0, 10)
    # add_product("Smartphone", "Latest model smartphone", 800.0, 25)
    # add_product("Headphones", "Noise-cancelling headphones", 150.0, 50)



    list_all_products()

    find_product_by_name("Smartphone")

    # Update quantity
    update_product_quantity("Laptop", 15)

    # List all products again
    list_all_products()

    # Delete a product
    delete_product("Headphones")

    # # Final list
    # list_all_products()

if __name__ == "__main__":
    main()