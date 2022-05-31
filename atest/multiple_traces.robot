*** Settings ***
Resource            ./atest/common.resource

Test Teardown       Log Test Stdout And Stderr On Failure


*** Test Cases ***
Two failing tests in the same suite result in two tracebacks
    Run Test With Tracer    two_failing.*
    Last Test Should Contain Multiple Stack Traces    2
