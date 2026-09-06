from calculs import addition, division
import pytest

def test_addition():
    assert addition(2, 3) == 5

def test_division():
    assert division(10, 2) == 5

def test_division_par_zero():
    with pytest.raises(ValueError):
        division(10, 0)
