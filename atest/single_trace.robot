
*** Settings ***
Resource    ./atest/common.resource
Test Teardown    Log Test Stdout And Stderr On Failure
Test Template    Run Test And Check That It Contains A Trace



*** Test Cases ***    TEST
Test failing because of a failing library keyword results in a stack trace    Example.Failing library keyword
Test failing because of "Wait Until Keyword Succeeds" results in a stack trace    Example.Failing library keyword with WUKS
Keyword failing in test setup results in a stack trace    Example.Failing in test setup
Keyword failing in suite setup results in a stack trace    failing_suite.failing in suite setup


*** Keywords ***
Run Test And Check That It Contains A Trace
    [Arguments]    ${test}
    Run Test With Tracer    ${test}
    Last Test Should Have Failed
    Last Test Should Contain A Stack Trace