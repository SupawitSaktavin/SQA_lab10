*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${CHROME_BROWSER_PATH}     ${EXECDIR}${/}ChromeForTesting${/}chrome-win64${/}chrome.exe
${CHROME_DRIVER_PATH}      ${EXECDIR}${/}ChromeForTesting${/}chromedriver-win64${/}chromedriver.exe
${REG_URL}                 http://localhost:7272/Registration.html

${FIRST_NAME}              Somsri
${LAST_NAME}               Sodsai
${ORG}                     CS KKU
${EMAIL}                   somsri@kkumail.com
${PHONE}                   081-001-1234

*** Keywords ***
Open Chrome
    ${opts}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    ${svc}=     Evaluate    sys.modules["selenium.webdriver.chrome.service"].Service(executable_path=r"${CHROME_DRIVER_PATH}")
    Create Webdriver    Chrome    options=${opts}    service=${svc}
    Set Selenium Speed  0

*** Test Cases ***
Register Success:
    Open Chrome
    Go To    ${REG_URL}

    Input Text    id=firstname      ${FIRST_NAME}
    Input Text    id=lastname       ${LAST_NAME}
    Input Text    id=organization   ${ORG}
    Input Text    id=email          ${EMAIL}
    Input Text    id=phone          ${PHONE}

    Click Button  id=registerButton

    Wait Until Page Contains    Success    3s
    ${title}=    Get Title
    Should Be Equal    ${title}    Success
	
Register Success No Organization Info:
    Open Chrome
    Go To    ${REG_URL}

    Input Text    id=firstname      ${FIRST_NAME}
    Input Text    id=lastname       ${LAST_NAME}
    Input Text    id=email          ${EMAIL}
    Input Text    id=phone          ${PHONE}

    Click Button  id=registerButton

    Wait Until Page Contains    Success    3s
    ${title}=    Get Title
    Should Be Equal    ${title}    Success

Empty First Name:
    Open Chrome
    Go To    ${REG_URL}

    Input Text    id=lastname        ${LAST_NAME}
    Input Text    id=organization    ${ORG}
    Input Text    id=email           ${EMAIL}
    Input Text    id=phone           ${PHONE}

    Click Button  id=registerButton

    ${title}=    Get Title
    Should Contain       ${title}    Registration
    Wait Until Element Is Visible    id=errors    3s
    Element Should Contain    id=errors    Please enter your first name!!

Empty Last Name:
    Open Chrome
    Go To    ${REG_URL}

    Input Text    id=firstname		${FIRST_NAME}
    Input Text    id=organization    ${ORG}
    Input Text    id=email           ${EMAIL}
    Input Text    id=phone           ${PHONE}

    Click Button  id=registerButton

    ${title}=    Get Title
    Should Contain       ${title}    Registration
    Wait Until Element Is Visible    id=errors    3s
    Element Should Contain    id=errors    Please enter your last name!!
	
Empty First Name and Last Name:
    Open Chrome
    Go To    ${REG_URL}

    Input Text    id=organization    ${ORG}
    Input Text    id=email           ${EMAIL}
    Input Text    id=phone           ${PHONE}

    Click Button  id=registerButton

    ${title}=    Get Title
    Should Contain       ${title}    Registration
    Wait Until Element Is Visible    id=errors    3s
    Element Should Contain    id=errors    Please enter your name!!

Empty Email:
    Open Chrome
    Go To    ${REG_URL}

    Input Text    id=firstname		${FIRST_NAME}
    Input Text    id=lastname		${LAST_NAME}
    Input Text    id=organization    ${ORG}
    Input Text    id=phone           ${PHONE}

    Click Button  id=registerButton

    ${title}=    Get Title
    Should Contain    ${title}    Registration
    Wait Until Element Is Visible    id=errors    3s
    Element Should Contain    id=errors    Please enter your email!!
	
Empty Phone Number:
    Open Chrome
    Go To    ${REG_URL}

    Input Text    id=firstname		${FIRST_NAME}
    Input Text    id=lastname		${LAST_NAME}
    Input Text    id=organization    ${ORG}
	Input Text    id=email           ${EMAIL}

    Click Button  id=registerButton

    ${title}=    Get Title
    Should Contain       ${title}    Registration
    Wait Until Element Is Visible    id=errors    3s
    Element Should Contain    id=errors    Please enter your phone number!!
	
Invalid Phone Number:
    Open Chrome
    Go To    ${REG_URL}

    Input Text    id=firstname		${FIRST_NAME}
    Input Text    id=lastname		${LAST_NAME}
    Input Text    id=organization    ${ORG}
	Input Text    id=email           ${EMAIL}
	Input Text    id=phone           1234

    Click Button  id=registerButton

    ${title}=    Get Title
    Should Contain       ${title}    Registration
    Wait Until Element Is Visible    id=errors    3s
    Element Should Contain    id=errors    Please enter a valid phone number, e.g., 081-234-5678, 081 234 5678, or 081.234.5678)