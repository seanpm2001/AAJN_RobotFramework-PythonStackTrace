# PythonStackTracer

Robot Framework listener that prints Python traceback for failing keywords in
the console.

This listener prints only the trace from Python modules. For Robot Framework stack trace, check out [robotframework-stacktrace](https://github.com/MarketSquare/robotframework-stacktrace).

## Installation

```shell
pip install robotframework-pythonstacktrace
```

## Usage

```shell
robot --listener PythonStackTracer
```

## Example

```shell
Atest Data & Atest Data.Atest Data.Example
==============================================================================
Python Traceback (most recent call last):                             F
  File "C:\Users\flant\Desktop\pytrace\atest_data\ExceptionalLibrary.py", line 9, in raises_an_exception
    first_call()
  File "C:\Users\flant\Desktop\pytrace\atest_data\ExceptionalLibrary.py", line 3, in first_call
    second_call()
  File "C:\Users\flant\Desktop\pytrace\atest_data\ExceptionalLibrary.py", line 6, in second_call
    raise Exception()
Exception
______________________________________________________________________________
```
