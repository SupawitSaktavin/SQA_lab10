*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${CHROME_BROWSER_PATH}     ${EXECDIR}${/}ChromeForTesting${/}chrome-win64${/}chrome.exe
${CHROME_DRIVER_PATH}      ${EXECDIR}${/}ChromeForTesting${/}chromedriver-win64${/}chromedriver.exe
${REG_URL}                 http://localhost:5500/Registration.html

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
1) Valid: Full Register
	[Documentation]  กรอกข้อมูลครบทุกช่องในฟอร์ม Registration (First Name, Last Name, Organization, Email, Phone) แล้วกด Register ระบบควรพาไปหน้า Success.html และแสดงผลว่า “Success”
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
	
2) Valid: Register Without Organization
	[Documentation]  กรอกข้อมูลครบทุกช่อง ยกเว้น Organization แล้วกด Register ระบบยังคงต้องพาไปหน้า Success.html และแสดงผลว่า “Success”
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

3) Invalid: Empty First Name
	[Documentation]  ไม่กรอก First Name แต่กรอกช่องอื่นครบ กด Register ระบบควรยังอยู่ที่หน้า Registration และแสดงข้อความ error “*Please enter your first name!!”
    Open Chrome
    Go To    ${REG_URL}

    Input Text           id=lastname        ${LAST_NAME}
    Input Text           id=organization    ${ORG}
    Input Text           id=email           ${EMAIL}
    Input Text           id=phone           ${PHONE}

    Click Button         id=registerButton

    ${title}=    Get Title
    Should Contain       ${title}    Registration
    Wait Until Element Is Visible    id=errors    3s
    Element Should Contain    id=errors    *Please enter your first name!!

4) Invalid: Empty Last Name
	[Documentation]  ไม่กรอก Last Name แต่กรอกช่องอื่นครบ กด Register ระบบควรยังอยู่ที่หน้า Registration และแสดงข้อความ error “*Please enter your last name!!”
    Open Chrome
    Go To    ${REG_URL}

    Input Text           id=firstname		${FIRST_NAME}
    Input Text           id=organization    ${ORG}
    Input Text           id=email           ${EMAIL}
    Input Text           id=phone           ${PHONE}

    Click Button         id=registerButton

    ${title}=    Get Title
    Should Contain       ${title}    Registration
    Wait Until Element Is Visible    id=errors    3s
    Element Should Contain    id=errors    *Please enter your last name!!
	
5) Invalid: Empty Last Name and Last Name
	[Documentation]  ไม่กรอกทั้ง First Name และ Last Name แต่กรอกช่องอื่นครบ กด Register ระบบควรยังอยู่ที่หน้า Registration และแสดงข้อความ error “*Please enter your name!!”
    Open Chrome
    Go To    ${REG_URL}

    Input Text           id=organization    ${ORG}
    Input Text           id=email           ${EMAIL}
    Input Text           id=phone           ${PHONE}

    Click Button         id=registerButton

    ${title}=    Get Title
    Should Contain       ${title}    Registration
    Wait Until Element Is Visible    id=errors    3s
    Element Should Contain    id=errors    *Please enter your name!!

6) Invalid: Empty Email
	[Documentation]  ไม่กรอก Email แต่กรอกช่องอื่นครบ กด Register ระบบควรยังอยู่ที่หน้า Registration และแสดงข้อความ error “*Please enter your email!!”
    Open Chrome
    Go To    ${REG_URL}

    Input Text           id=firstname		${FIRST_NAME}
    Input Text           id=lastname		${LAST_NAME}
    Input Text           id=organization    ${ORG}
    Input Text           id=phone           ${PHONE}

    Click Button         id=registerButton

    ${title}=    Get Title
    Should Contain       ${title}    Registration
    Wait Until Element Is Visible    id=errors    3s
    Element Should Contain    id=errors    *Please enter your email!!
	
7) Invalid: Empty Phone
	[Documentation]  ไม่กรอก Phone แต่กรอกช่องอื่นครบ กด Register ระบบควรยังอยู่ที่หน้า Registration และแสดงข้อความ error “*Please enter your phone number!!”
    Open Chrome
    Go To    ${REG_URL}

    Input Text           id=firstname		${FIRST_NAME}
    Input Text           id=lastname		${LAST_NAME}
    Input Text           id=organization    ${ORG}
	Input Text           id=email           ${EMAIL}

    Click Button         id=registerButton

    ${title}=    Get Title
    Should Contain       ${title}    Registration
    Wait Until Element Is Visible    id=errors    3s
    Element Should Contain    id=errors    *Please enter your phone number!!
	
8) Invalid: Wrong Phone Format
	[Documentation]  กรอกหมายเลขโทรศัพท์ไม่ถูกต้อง (ตัวเลขไม่ครบ เช่น “1234”) แล้วกด Register ระบบควรยังอยู่ที่หน้า Registration และแสดงข้อความ error “Please enter a valid phone number!!”
    Open Chrome
    Go To    ${REG_URL}

    Input Text           id=firstname		${FIRST_NAME}
    Input Text           id=lastname		${LAST_NAME}
    Input Text           id=organization    ${ORG}
	Input Text           id=email           ${EMAIL}
	Input Text           id=phone           1234

    Click Button         id=registerButton

    ${title}=    Get Title
    Should Contain       ${title}    Registration
    Wait Until Element Is Visible    id=errors    3s
    Element Should Contain    id=errors    Please enter a valid phone number!!