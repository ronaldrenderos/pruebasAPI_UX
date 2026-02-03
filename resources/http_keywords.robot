*** Settings ***
Library    RequestsLibrary

*** Keywords ***
Create API Session And Execute
    [Documentation]    Create an API session and execute the request.
    [Arguments]    ${base_url}    ${method}    ${path}
    Create Session    api    ${base_url}    verify=true

    ${status}    ${result}=    Run Keyword And Ignore Error
    ...    Execute API Request    ${method}    ${path}

    IF    '${status}' == 'PASS'
        Log To Console    ${result.status_code}
        RETURN   ${result}
    ELSE
        Log To Console    Error with method: ${method} and path: ${path} - ${result}
        RETURN   ${result}
    END

Execute API Request
    [Documentation]    Execute an API request based on the method and path.
    [Arguments]    ${method}    ${path}
    IF    '${method}' == 'GET'
        ${response}=    GET On Session    api    ${path}
        Log To Console    ${response.status_code}
        RETURN    ${response}
    ELSE IF    '${method}' == 'POST'
        ${response}=    POST On Session    api    ${path}
        Log To Console    ${response.status_code}
        RETURN    ${response}
    ELSE IF    '${method}' == 'PUT'
        ${response}=    PUT On Session    api    ${path}
        Log To Console    ${response.status_code}
        RETURN    ${response}
    ELSE IF    '${method}' == 'DELETE'
        ${response}=    DELETE On Session    api    ${path}
        Log To Console    ${response.status_code}
        RETURN    ${response}
    END

