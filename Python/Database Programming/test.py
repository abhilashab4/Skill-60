from sqlmodel import Field, SQLModel, create_engine, Session, select, or_, Relationship


class HeroTeamLink(SQLModel, table=True):
    team_id : int | None  = Field(default=None, foreign_key="team.id", primary_key=True)
    hero_id : int | None = Field(default=None, foreign_key="hero.id", primary_key=True)


class Team(SQLModel, table=True):
    id: int | None = Field(default=None, primary_key=True)
    name: str = Field(index=True)
    headquarters: str

    heroes: list["Hero"] = Relationship(back_populates="team", link_model=HeroTeamLink) 
class Hero(SQLModel, table=True):
    id: int | None = Field(default=None, primary_key=True)
    name: str = Field(index=True) #ix_hero_name   [ix_tablename_columnname]
    secret_name: str
    age: int | None = Field(default=None, index=True)  # nullable column

    team_id: int | None = Field(default=None, foreign_key="team.id") # foreign key to the Team table
    # team: Team | None = Relationship(back_populates="heroes") # relationship to the Team table #not a column in the database4
    team : list["Team"] = Relationship(back_populates="heroes", link_model=HeroTeamLink) #relationship to the Team table



sqlite_file_name = "database.db"
sqlite_url = f"sqlite:///{sqlite_file_name}"

engine = create_engine(sqlite_url, echo=True) #echo=True will log all SQL statements to the console


def create_heroes():
    # hero_1 = Hero(name="Batman", secret_name="Bruce Wayne")
    # hero_2 = Hero(name="Ironman", secret_name="Tony Stark", age=45)
    # hero_3 = Hero(name="Superman", secret_name="Clark Kent", age=35)
    # hero_4 = Hero(name="Spiderman", secret_name="Peter Parker", age=18)
    # hero_5 = Hero(name="Wonder Woman", secret_name="Diana Prince")
    # hero_6 = Hero(name="Black Panther", secret_name="T'Challa", age=40)
    # hero_7 = Hero(name="Doctor Strange", secret_name="Stephen Strange", age=42)
    # hero_8 = Hero(name="Captain Marvel", secret_name="Carol Danvers")




   


    with Session(engine) as session:

       
        #with Session(engine) as session: # This is a context manager that automatically closes the session when done
        # Session is a temporary workspace for interacting with the database
        # It allows you to add, update, delete, and query data
        # session.add(hero_1)
        # session.add(hero_2)
        # session.add(hero_3)
        # session.add(hero_4)
        # session.add(hero_5)
        # session.add(hero_6)
        # session.add(hero_7)
        # session.add(hero_8)

        # session.commit() # commit() will save the changes to the database

        # session.refresh(hero_1) #refresh() is used to update the instance with the latest data from the database
        # session.refresh(hero_2)
        # print(hero_1)
        # print(hero_2)
        

        # ------------- FOREIGN KEY -------------
        # team_avengers = Team(name="Avengers", headquarters="Stark Tower")
        # team_x_men = Team(name="X-Men", headquarters="X-Mansion")
        #adding teams to the database
        # session.add(team_avengers)
        # session.add(team_x_men)
        # session.commit()

        # #refreshing teams to get the latest data from the database
        # session.refresh(team_avengers)
        # session.refresh(team_x_men)

        # hero_1 = Hero(name="Batman", secret_name="Bruce Wayne", team_id=team_avengers.id)   # team_id is the foreign key to the Team table
        # hero_2 = Hero(name="Cyclops", secret_name="Scott Summers", team_id=team_x_men.id)  #setting foreign key
        # hero_3 = Hero(name="Superman", secret_name="Clark Kent", age=35)  
        # session.add(hero_1)
        # session.add(hero_2) 
        # session.add(hero_3)
        # session.commit()  

 # ------------------- Updation of foreign key ---------------------

        # team_avengers = Team(name="Avengers", headquarters="Stark Tower")
        # team_x_men = Team(name="X-Men", headquarters="X-Mansion")
        # Adding teams to the database
        # session.add(team_avengers)
        # session.add(team_x_men)
        # session.commit()

        # Refresh teams to get their generated IDs
        # session.refresh(team_avengers)
        # session.refresh(team_x_men)

        # ---------updating foregn key---------

        # Create a hero without a team at first (optional)
        # hero_3 = Hero(name="Superman", secret_name="Clark Kent", age=35)

        # Assign foreign key after teams are created and IDs are available
        # hero_3.team_id = team_avengers.id

        # Add hero to session
        # session.add(hero_3)
        # session.commit()

        # Refresh hero to get updated data from DB
        # session.refresh(hero_3)

        # Print hero details
        # print(hero_3)
        # print("Hero's Team ID:", hero_3.team_id)




    #------------------- RELATIONSHIP -----------------------
    #creating team first then adding heroes which automatically adds teams to the database
        team_avengers = Team(name="Avengers", headquarters="Stark Tower")
        team_x_men = Team(name="X-Men", headquarters="X-Mansion")

        hero_deadpool = Hero(
            name="Deadpool", 
            secret_name="Wade Wilson", 
            team=team_avengers # automatically creates team_avengers in database when this hero is committed to the database
            )  
        hero_cyclops = Hero(
            name="Cyclops",
            secret_name="Scott Summers",
        )
        session.add(hero_deadpool)
        session.add(hero_cyclops)
        session.commit()

        session.refresh(hero_deadpool)
        session.refresh(hero_cyclops)

        #updating team id
        hero_cyclops.team = team_x_men
        session.add(hero_cyclops)
        session.commit()


        #creating hero first then adding team which automatically adds heroes to the database
        hero_black_panther = Hero(
            name="Black Panther",
            secret_name="T'Challa",
            age=40,
        )
        hero_shuri = Hero(
            name="Shuri",
            secret_name="Shuri",
            age=25,
        )

        team_wakanda = Team(
            name="Wakanda",
            headquarters="Wakanda HQ",
            heroes = [hero_black_panther, hero_shuri],
        )      
        session.add(team_wakanda)
        session.commit()
        session.refresh(team_wakanda)
        print("Team Wakanda: ", team_wakanda)

        #list["Hero"] 

        hero_dr_strange = Hero(
            name="Doctor Strange",
            secret_name="Stephen Strange",
            age=42,
        )

        hero_captain_marvel = Hero(
            name="Captain Marvel",
            secret_name="Carol Danvers",
            age=35,
        )

        #append() adds the hero to the list of heroes in the team object, but does not add it to the database until the team object is added to the session and committed

        team_avengers.heroes.append(hero_dr_strange)
        team_avengers.heroes.append(hero_captain_marvel)
        session.add(team_avengers)
        session.commit()


        # Many-to-Many Relationship
        #hero with multiple teams
        hero_deadpool = Hero(
            name="Deadpool", 
            secret_name="Wade Wilson", 
            team=[team_avengers, team_x_men] # automatically creates team_avengers in database when this hero is committed to the database
            )  
        #rest of the process are same

        
  


        
def select_heroes():
    with Session(engine) as session:
            # --------- READ -----------
            # statement = select(Hero)
            # results = session.exec(statement)
            # for hero in results:
            #      print(hero)
            # heroes = results.all()#returns a list of all rows
            # print(heroes)

            # ---------- FILTER -----------
            # statement = select(Hero).where(Hero.name == "Ironman", Hero.age == "45") #AND condition
            # statement = select(Hero).where(or_(Hero.name == "Ironman", Hero.name == "Batman")) #OR condition
            # results = session.exec(statement)
            # for hero in results:
            #      print(hero)

            # ------------------ FIRST AND ONE ------------------                                
            # one() will return the first row of the result set, and raise an error if there are no rows or more than one row
            # first() will return the first row of the result set, and return None if there are no rows
            statement = select(Hero).where(Hero.name == "Superman") 
            result = session.exec(statement)
            hero = result.first() #result.one()
            print('Hero : ', hero)

            # ------------------- OFFSET AND LIMIT ------------------
            # offset() will skip the first n rows of the result set
            # limit() will limit the result set to n rows
            # statement = select(Hero).offset(3).limit(3)
            # results = session.exec(statement)
            # heroes = results.all()
            # print('Heroes : ', heroes)

            # --------------------- JOINS --------------------
            # statement = select(Hero, Team).where(Hero.team_id == Team.id) # join query
            statement = select(Hero, Team).join(Team, isouter=True)
            results = session.exec(statement)
            for hero, team in results:
                print(f"Hero: {hero.name}, Team: {team.name}")  



#---------- UPDATE --------------
def update_heroes():
    with Session(engine) as session:
        statement = select(Hero).where(Hero.name == "Superman")
        results  = session.exec(statement)
        hero_1 = results.one()
     

        statement = select(Hero).where(Hero.name == "Captain Marvel")
        results  = session.exec(statement)
        hero_2 = results.one()

        #before updation
        print("Hero : ", hero_1)
        print("Hero : ", hero_2)

        #updation
        hero_1.name = "Superman-Teenager"
        hero_2.name = "Captain Canada"
        session.add(hero_1)
        session.add(hero_2)
        session.commit()
        session.refresh(hero_1)
        session.refresh(hero_2)

        #after updation
        print(" Updated Hero : ", hero_1)
        print(" Updated Hero : ", hero_2)

def delete_heroes():
    with Session(engine) as session:
        statement = select(Hero).where(Hero.name == "Superman - Teenager")
        results  = session.exec(statement)
        hero_1 = results.one()
        
        #before deletion
        print("Hero : ", hero_1)


        #deletion
        session.delete(hero_1)
        session.commit()   #session.refresh(hero_1) #refresh() will raise an error since the object is deleted

        #after deletion
        print("Deleted Hero : ", hero_1)


# def addDataWithParams(name:str,age:int|None,secret:str):
#     hero_temp=Hero(name=name,secret_name=secret,age=age)

#     with Session(engine) as session:
#         session.add(hero_temp)
#         session.commit()
#         session.refresh(hero_temp)
#         print("New item added:",hero_temp)


#     addDataWithParams("Nan",-12,"none")
       
def create_db_and_tables():
    SQLModel.metadata.create_all(engine)

def main():
    create_db_and_tables()
    create_heroes() 
    # update_heroes() 
    # delete_heroes()
    # select_heroes()

if __name__ == "__main__":
    main()