import pytest
import csv
from unittest.mock import patch

TEST_DATABASE_FILE = "test_tasks.csv"

TEST_TASKS_CSV = [
    {
        "id": "1",
        "title" : "Test Task One",
        "description" : "Test Description One",
        "status" : "Incomplete"

    },
     {
        "id": "1",
        "title" : "Test Task Two",
        "description" : "Test Description Two",
        "status" : "Ongoing"
        
    },
]

TEST_TASKS = [
    {**task_json, "id": int(task_json["id"])} for task_json in TEST_TASKS_CSV
]



@pytest.fixture(autouse=True)
def create_test_database():
    database_file_location = str(Path(__file__).parent / TEST_DATABASE_FILE)