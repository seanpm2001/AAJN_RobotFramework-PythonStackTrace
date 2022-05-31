*** Settings ***
Resource            ./atest/common.resource

Test Teardown       Log Test Stdout And Stderr On Failure


*** Test Cases ***
Passing test results in no stack trace
    Run Test With Tracer    Example.Passing test
    Last Test Should Have Passed
    Last Test Should Not Contain A Stack Trace

    Should Be Empty    ${TEST_OUT.stdout}
    ...    Listener must not output anything to stdout if test has passed
    Should Be Empty    ${TEST_OUT.stderr}
    ...    Listener must not output anything to stderr if test has passed

Passing "Run Keyword And Ignore Error" results in no stack trace
    Run Test With Tracer    Example.Passing Run Keyword And Ignore Error
    Last Test Should Have Passed
    Last Test Should Not Contain A Stack Trace

Test failing because of a BuiltIn library keyword results in no stack trace
    Run Test With Tracer    Example.Failing BuiltIn
    Last Test Should Have Failed
    Last Test Should Not Contain A Stack Trace
