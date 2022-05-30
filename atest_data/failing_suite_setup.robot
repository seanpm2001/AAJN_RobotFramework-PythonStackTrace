*** Settings ***
Library         ExceptionalLibrary

Suite Setup     Raises An Exception


*** Test Cases ***
Failing in suite setup
    No Operation
