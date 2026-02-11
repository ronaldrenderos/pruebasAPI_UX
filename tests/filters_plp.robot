*** Settings ***
Resource    ../resources/data_loader.robot
Resource    ../resources/http_keywords.robot
Resource    ../resources/filters_keywords.robot
Library     ../libraries/excel_writer.py

*** Test Cases ***
Test Filters PLP 
    [Documentation]    API endpoints for filters on the PLP.
    [Tags]    filters_plp    api    regression
    Test API    base_urls_prod.yaml    filters_plp_prod.yaml    

Test SizeApp 
    [Documentation]    API endpoints for SizeApp.
    [Tags]    sizeapp    api    regression    
    Test API    base_urls_prod.yaml    sizeapp_prod.yaml