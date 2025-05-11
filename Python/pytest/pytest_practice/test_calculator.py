
import pytest
from calculator import add, subtract, multiply, divide

def test_add():
    assert add(2, 3) == 5
    assert add(-1, -1) == -2
    assert add(1.5, 2.5) == 4.0

def test_subtract():
    assert subtract(10, 5) == 5
    assert subtract(0, 5) == -5
    assert subtract(2.5, 1.0) == 1.5

def test_multiply():
    assert multiply(3, 4) == 12
    assert multiply(-2, 3) == -6
    assert multiply(0, 10) == 0

def test_divide():
    assert divide(10, 2) == 5
    assert divide(3, 2) == 1.5
    assert divide(-6, 3) == -2

def test_divide_by_zero():
    assert divide(5, 0) == "Error! Division by zero."
