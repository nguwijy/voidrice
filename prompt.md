1/ Write a python function that returns output_1 and output_2 depending on the input input_1, input_2, input_3. The relationship between the input and output will be described using if-else statements.
2/ Then, write a unit test function to test the function you have written. Make sure the unit test covers all edge cases.
3/ Finally, after you wrote the function and the unit test, please format all the unit test cases using json format.

Relationship:
1/ output_1 = input_2 + input_3, if input_1 = 'addition'
2/ output_2 = 0, if input_1 = 'addition'
3/ output_2 = input_2 * input_3, if input_1 = 'multiplication'
4/ output_1 = 0, if input_1 = 'multiplication'
5/ output_1 = 'invalid!!!', otherwise

Write your python function:
```python
def relationship(input_1, input_2, input_3):
    '''implement your logic'''
    return output_1, output_2
```

Write your unit test:
```python

def unit_test():
    '''define your test_cases'''
    for test in test_cases:
        result = relationship(test["input_1"], test["input_2"], test["input_3"])
        assert result == (test["output_1"], test["output_2"])

    print("All test cases passed!")

unit_test()
```

Write your json output for all unit test examples with the format:
```json
[
    {
        "input_1": ...,
        "input_2": ...,
        "input_3": ...,
        "output_1": ...,
        "output_2": ...
    }
]
```
