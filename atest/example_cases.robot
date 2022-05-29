*** Settings ***
Library    Process

Test Teardown    Log Test Stdout And Stderr On Failure

*** Variables ***
${ROBOT_EXE}    robot
${ATEST_DATA}    ./atest_data

*** Keywords ***
Log Test Stdout And Stderr On Failure
    ${result}    Get Variable Value    ${TEST_OUT}
    IF    $result is None or $TEST_STATUS == "PASS"    RETURN

    IF    $result.stdout
        Log To Console    ${{ "\rSTDOUT " + "=" * 71}}
        Log To Console    ${result.stdout}
        Log To Console    ${{ "=" * 78 }}
    END

    IF    $result.stderr
        Log To Console    ${{ "\rSTDERR " + "=" * 71}}
        Log To Console    ${result.stderr}
        Log To Console    ${{ "=" * 78 }}
    END

Run Test With Tracer
    [Arguments]    ${test name}
    ${out}    Run Process    ${ROBOT_EXE}
    ...    --console    quiet
    ...    --test    atest_data.example.${test name}
    ...    --argumentfile    ${ATEST_DATA}/arguments.txt

    Set Test Variable    ${TEST_OUT}    ${out}
    RETURN    ${out}

Check That Test Has Been Executed
    ${result}    Get Variable Value    ${TEST_OUT}
    IF    $result is None    Fail    A Test has not been executed

Last Test Should Have Passed
    Check That Test Has Been Executed
    Should Be Equal As Integers    ${TEST_OUT.rc}    0
    ...    Last test expected to pass but has failed

Last Test Should Have Failed
    Check That Test Has Been Executed
    Should Not Be Equal As Integers    ${TEST_OUT.rc}    0
    ...    Last test expected to fail but has passed

Last Test Should Contain A Stack Trace
    Check That Test Has Been Executed
    IF    "Python Traceback" not in $TEST_OUT.stdout
    ...    Fail    Last test does not contain a stack trace

Last Test Should Not Contain A Stack Trace
    Check That Test Has Been Executed
    Run Keyword And Expect Error
    ...    Last test does not contain a stack trace    Last Test Should Contain A Stack Trace

*** Test Cases ***
Passing test results in no stack trace
    Run Test With Tracer    Passing test
    Last Test Should Have Passed
    Last Test Should Not Contain A Stack Trace

    Should Be Empty    ${TEST_OUT.stdout}
    ...    Listener must not output anything to stdout if test has passed
    Should Be Empty    ${TEST_OUT.stderr}
    ...    Listener must not output anything to stderr if test has passed

Test failing because of a BuiltIn library keyword results in no stack trace
    Run Test With Tracer    Failing BuiltIn
    Last Test Should Have Failed
    Last Test Should Not Contain A Stack Trace

Test failing because of a failing library keyword results in a stack trace
    Run Test With Tracer    Failing library keyword
    Last Test Should Have Failed
    Last Test Should Contain A Stack Trace

Test failing because of "Wait Until Keyword Succeeds" results in a stack trace
    Run Test With Tracer    Failing library keyword with WUKS
    Last Test Should Have Failed
    Last Test Should Contain A Stack Trace
