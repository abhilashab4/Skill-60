# Basic Fixture
# Define a fixture that returns the string "hello".
# Write a test function that uses this fixture and asserts that the string is "hello".

# import pytest

# @pytest.fixture
# def string():
#     return 'hello'

# def test_string(string):
#     assert string == 'hello'

# Fixture with List 

# Define a fixture that returns a list of integers, e.g., [1, 2, 3].
#  Write a test function that uses this fixture and asserts that the sum of the list is 6.

import pytest

@pytest.fixture
def list():
    return [1, 2, 3]

def test(list):
    assert sum(list) == 6


# Define a fixture that returns a dictionary representing a user, e.g., {"name": "Alice", "age": 30}.

# Write a test function that uses this fixture and asserts that the user's age is 30.44

import pytest

@pytest.fixture
def dict():
    return {"name" : "Alice", "age" : 30}

def test2(dict):
    assert dict['age'] == 30

