*** Settings ***
Resource    ../resources/data_loader.robot
Resource    ../resources/http_keywords.robot
Library     ../libraries/excel_writer.py

*** Test Cases ***
Test Filters API PLP
    [Tags]    filters_plp    api    regression
    ${base_urls}=    Load Base Urls
    ${filters_data}=    Load Filters PLP Data

    ${envs}=    Evaluate    list(${base_urls}.keys())
    FOR    ${env}    IN    @{envs}
        ${base_url}=    Set Variable    ${base_urls}[${env}]
        #Log To Console    Testing environment: ${env}
            ${urls}=    Evaluate    list(${base_url}.values())
            FOR    ${url}    IN    @{urls}
                #Log To Console    Testing URL: ${url}
                ${filter_keys}=    Evaluate    list(${filters_data}.keys())
                FOR    ${filter}    IN    @{filter_keys}
                    ${endpoint}=    Set Variable    ${filters_data}[${filter}]
                    #Log To Console   Using filter: ${filter}
                    ${path}=    Set Variable    ${endpoint['path']}
                    #Log To Console    Using path: ${path}
                    FOR    ${method}    IN    @{endpoint['methods']}
                        Log To Console    Testing environment ${env} url ${url} filter ${filter} with path: ${path} and method: ${method}
                        ${response}=    Create API Session And Execute    ${url}    ${method}    ${path}
                        ${expected}=    Set Variable If    '${method}' == 'POST'    200    405
                        ${passed}=    Run Keyword And Return Status    Should Be Equal As Integers    ${response.status_code}    ${expected}
                        IF    ${passed}    Log    Unexpected response ${response.status_code} (expected ${expected}) — continuing
                        ${result}=    Set Variable If    ${passed}    PASS    FAIL
                        append_result  ${env}    ${url}    ${filter}    ${path}    ${method}    ${result}
                    END     
                END
            END
    END
        
