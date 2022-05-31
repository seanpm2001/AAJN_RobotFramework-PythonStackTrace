*** Settings ***
Library     Process
Library     String


*** Variables ***
${ROBOT_EXE}        robot
${ATEST_DATA}       ./atest_data


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
    ...    --test    atest_data.${test name}
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

Last Test Should Contain A Single Stack Trace
    Check That Test Has Been Executed
    Should Start With    ${TEST_OUT.stdout}    Python Traceback
    ...    Last test output does not contain a stack trace
    ...    strip_spaces=LEADING

    ${matches}    Get Regexp Matches    ${TEST_OUT.stdout}    Python
    Length Should Be    ${matches}    1
    ...    Last test output contains more than one stack trace

Last Test Should Not Contain A Stack Trace
    Check That Test Has Been Executed
    Should Be Empty    ${TEST_OUT.stdout}
    ...    Last test contains a stack trace output
