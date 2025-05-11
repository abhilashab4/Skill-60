from my_strings import to_uppercase

def test_to_uppercase():
    assert to_uppercase('test') == 'TEST'
    assert to_uppercase('Test') == 'TEST'
    assert to_uppercase('TEST') == 'TEST'
    assert to_uppercase('') == ''