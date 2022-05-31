*** Settings ***
Library     ExceptionalLibrary


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

Failing in test setup
    [Setup]    Raises An Exception
    No Operation

Failing in test teardown
    No Operation
    [Teardown]    Raises An Exception

Failing in a keyword
    Call A Failing Library Keyword


*** Keywords ***
Call A Failing Library Keyword
    Raises An Exception
