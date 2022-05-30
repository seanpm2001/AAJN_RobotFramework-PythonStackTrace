*** Settings ***
Library             ExceptionalLibrary

Suite Teardown      Raises An Exception


*** Test Cases ***
Failing in suite teardown
    No Operation
