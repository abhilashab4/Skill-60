from sqlmodel import Field, SQLModel, create_engine, Session, Relationship, select
from datetime import datetime
from typing import Optional, List

class StudentCourseLink(SQLModel, table=True):
    student_id: int | None = Field(foreign_key="student.id", primary_key=True)
    course_id: int | None = Field(foreign_key="course.id", primary_key=True)

    enrollment_date: Optional[datetime] = None
    grade: Optional[str] = None

class Department(SQLModel, table=True):
    id: int | None = Field(default=None, primary_key=True)
    name: str = Field(unique=True)
    building: str | None = Field(default=None)
    courses: list["Course"] = Relationship(back_populates="department")

class Student(SQLModel, table=True):
    id: int | None = Field(default=None, primary_key=True)
    first_name: str
    last_name: str 
    email: str = Field( unique=True)
    
    courses: list["Course"] = Relationship(back_populates="students", link_model=StudentCourseLink)

class Course(SQLModel, table=True):
    id: int | None = Field(default=None, primary_key=True)
    title: str = Field( index=True)
    code: str = Field( unique=True)

    department_id: int | None = Field(foreign_key="department.id")
    department:  Department | None = Relationship(back_populates="courses")
    students: list["Student"] = Relationship(back_populates="courses", link_model=StudentCourseLink)



sqlite_file_name = "task2.db"
sqlite_url = f"sqlite:///{sqlite_file_name}"

engine = create_engine(sqlite_url, echo=True)


def create_department(name: str, building: str):
    department = Department(name=name, building=building)
    with Session(engine) as session:
        session.add(department)
        session.commit()
        session.refresh(department)
        print(f"Department created: {department}")
    return department

def create_student(first_name: str, last_name: str, email: str):
    student = Student(first_name=first_name, last_name=last_name, email=email)
    with Session(engine) as session:
        session.add(student)
        session.commit()
        session.refresh(student)
        print(f"Student created: {student}")
    return student

def create_course(title: str, code: str, department_id: int):
    course = Course(title=title, code=code, department_id=department_id)
    with Session(engine) as session:
        session.add(course)
        session.commit()
        session.refresh(course)
        print(f"Course created: {course}")
    return course
def get_department_by_name(name: str):
    with Session(engine) as session:
        statement = select(Department).where(Department.name == name)
        result = session.exec(statement).first()
        # if result:
        #     print(f"Department found: {result}")
        # else:
        #     print(f"No department found with name: {name}")
        return result

def get_student_by_email(email: str):
    with Session(engine) as session:
        statement = select(Student).where(Student.email == email)
        result =  session.exec(statement).first()
        # if result:
        #     print(f"Student found: {result}")
        # else:
        #     print(f"No student found with email: {email}")
        return result

def get_course_by_code(code:str):
    with Session(engine) as session:
        statement = select(Course).where(Course.code == code)
        result =  session.exec(statement).first()
        # if result:
        #     print(f"Course found: {result}")
        # else:
        #     print(f"No course found with code: {code}")
        return result

def student_list():
    with Session(engine) as session:
        statement = select(Student)
        results = session.exec(statement).all()
        # for student in results:
        #     print(student)
        
        return results

def update_student_email(student_id: int, new_email: str):
    with Session(engine) as session:
        statement = select(Student).where(Student.id == student_id)
        student = session.exec(statement).first()
        if student:
            student.email = new_email
            session.add(student)
            session.commit()
            session.refresh(student)
            print(f"Student email updated: {student}")
        else:
            print(f"No student found with id: {student_id}")

def delete_course(course_id: int):
    with Session(engine) as session:
        statement = select(Course).where(Course.id == course_id)
        result = session.exec(statement).first()
        session.delete(result)
        session.commit()


def enroll_student(student_id: int, course_id: int, enrollment_date: Optional[datetime] = None):
    with Session(engine) as session:
        statement = select(Student).where(Student.id == student_id)
        student = session.exec(statement).first()
        statement = select(Course).where(Course.id == course_id)
        course = session.exec(statement).first()
        if student and course:
            enrollment = StudentCourseLink(student_id=student.id, course_id=course.id, enrollment_date=enrollment_date)
            session.add(enrollment)
            session.commit()
            session.refresh(enrollment)
            print(f"Student enrolled: {enrollment}")
        else:
            print(f"Student or course not found. Student ID: {student_id}, Course ID: {course_id}")

def get_courses_for_student(student_id: int):
    with Session(engine) as session:
        statement = select(Course).join(StudentCourseLink).where(StudentCourseLink.student_id == student_id)
        results = session.exec(statement).all()
        for course in results:
            print(course.title)

def get_students_for_course(course_id: int):
    with Session(engine) as session:
        statement = select(Student).join(StudentCourseLink).where(StudentCourseLink.course_id == course_id)
        results = session.exec(statement).all()
        for student in results:
            print(student.first_name, student.last_name) 

def set_enrollment_grade(student_id: int, course_id: int, grade: str):
    statement = select(StudentCourseLink).where(StudentCourseLink.student_id == student_id)



def create_db_and_tables():
    SQLModel.metadata.create_all(engine)


def main():
    create_db_and_tables()
    create_department("Computer Science", "Building A")
    create_department("Mathematics", "Building B")
    create_department("Physics", "Building C")

if __name__ == "__main__":
    main()