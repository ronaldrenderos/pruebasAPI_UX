*** Settings ***
Resource    ../resources/data_loader.robot
Resource    ../resources/http_keywords.robot
Library     ../libraries/excel_writer.py

*** Keywords ***
Test API 
    [Tags]    filters_plp    api    regression
    [Arguments]    ${base_file}    ${path_file}
    ${base_urls}=    Load Yaml File    ${base_file}
    ${path_data}=    Load Yaml File    ${path_file}
    init_excel_for_test    ${TEST NAME}

    ${envs}=    Evaluate    list(${base_urls}.keys())
    FOR    ${env}    IN    @{envs}
        ${base_url}=    Set Variable    ${base_urls}[${env}]
        #Log To Console    Testing environment: ${env}
            ${urls}=    Evaluate    list(${base_url}.values())
            FOR    ${url}    IN    @{urls}
                #Log To Console    Testing URL: ${url}
                ${node_keys}=    Evaluate    list(${path_data}.keys())
                FOR    ${node}    IN    @{node_keys}
                    ${endpoint}=    Set Variable    ${path_data}[${node}]
                    #Log To Console   Using node: ${node}
                    ${path}=    Set Variable    ${endpoint['path']}
                    #Log To Console    Using path: ${path}
                    FOR    ${method}    IN    @{endpoint['methods']}
                        Log To Console    Testing environment ${env} url ${url} endpoint ${node} with path: ${path} and method: ${method}
                        ${response}=    Create API Session And Execute    ${url}    ${method}    ${path}
                        ${expected}=    Set Variable If    '${method}' == 'POST'    200    405
                        ${passed}=    Run Keyword And Return Status    Should Be Equal As Integers    ${response.status_code}    ${expected}
                        IF    ${passed}    Log    Unexpected response ${response.status_code} (expected ${expected}) — continuing
                        ${result}=    Set Variable If    ${passed}    PASS    FAIL
                        append_result  ${env}    ${url}    ${node}    ${path}    ${method}    ${result}
                    END     
                END
            END
    END