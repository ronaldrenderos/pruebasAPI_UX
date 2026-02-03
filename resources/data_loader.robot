*** Settings ***
Library    yaml
Library    OperatingSystem

*** Keywords ***
Load Base Urls
    [Documentation]    Load base URLs from a YAML file.
    ${yaml_text}=    Get File    data/base_urls.yaml
    ${urls}=    Evaluate    __import__('yaml').safe_load('''${yaml_text}''')
    RETURN     ${urls}

Load Filters PLP Data
    [Documentation]    Load Filters PLP data from a YAML file.
    ${yaml_text}=    Get File    data/filters_plp.yaml
    ${filters}=    Evaluate    __import__('yaml').safe_load('''${yaml_text}''')
    RETURN    ${filters}
