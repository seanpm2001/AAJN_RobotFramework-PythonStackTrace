*** Settings ***
Library    ExceptionalLibrary


*** Test Cases ***
Passing test
    No Operation

Failing BuiltIn
    Fail    Oh no!

Failing library keyword
    Raises An Exception

Failing library keyword with WUKS
    Wait Until Keyword Succeeds
    ...    5x    0ms    Raises An Exception