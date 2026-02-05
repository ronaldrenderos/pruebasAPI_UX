*** Settings ***
Library    OperatingSystem
Library    yaml

*** Keywords ***
Load Yaml File
    [Documentation]    Load any YAML file from the data directory.
    [Arguments]    ${file_name}
    ${yaml_text}=    Get File    data/${file_name}
    ${data}=    Evaluate    __import__('yaml').safe_load('''${yaml_text}''')
    RETURN    ${data}    

Load Base Urls
    [Documentation]    Load base URLs from a YAML file.
    [Arguments]    ${base_file}=base_urls.yaml    
    ${urls}=    Load Yaml File    ${base_file}
    RETURN     ${urls}

Load Filters PLP Data
    [Documentation]    Load Filters PLP data from a YAML file.
    [Arguments]    ${filters_file}=filters_plp.yaml
    ${filters}=    Load Yaml File    ${filters_file}
    RETURN    ${filters}

Load SizeApp Data
    [Documentation]    Load SizeApp data from a YAML file.
    [Arguments]    ${sizeapp_file}=sizeapp.yaml
    ${sizeapp}=    Load Yaml File    ${sizeapp_file}
    RETURN    ${sizeapp}

