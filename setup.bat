@ECHO OFF
cls
@setlocal enableextensions
@cd /d "%~dp0"
:README
	ECHO.
	ECHO ******************************************************************************
	ECHO.
	ECHO		ManageEngine Endpoint Central Setup Wizard
	ECHO.
	ECHO This script will install the Endpoint Central agent in the computer.
	ECHO.
	ECHO ******************************************************************************
	ECHO.
	ECHO.
	:GETINPUT
	ECHO  1 - Install Endpoint Central Agent in this computer
	ECHO.
	ECHO  2 - Exit
	ECHO.
	set INPUT=
	set /P INPUT=Enter the option: %=%
	IF "%INPUT%" == "1" GOTO INSTALLAGENT
	IF "%INPUT%" == "2" GOTO :EOF
	IF "%INPUT%" == "q" GOTO :EOF
		
GOTO INVALID

:INSTALLAGENT
	
	
	start /wait msiexec /i UEMSAgent.msi TRANSFORMS="UEMSAgent.mst" ENABLESILENT=yes REBOOT=ReallySuppress INSTALLSOURCE=Manual SERVER_ROOT_CRT="%cd%\DMRootCA-Server.crt" DS_ROOT_CRT="%cd%\DMRootCA.crt" /lv Agentinstalllog.txt 
	
	IF "%ERRORLEVEL%" == "0" GOTO AGENTINSTALLSUCCESS
	IF "%ERRORLEVEL%" == "3010" GOTO AGENTINSTALLSUCCESS
	IF "%ERRORLEVEL%" == "1603" GOTO AGENTINSTALLFAIL_FATAL
	IF "%ERRORLEVEL%" == "1612" GOTO AGENTINSTALLFAIL_FATAL
	IF "%ERRORLEVEL%" == "1619" GOTO AGENTINSTALLFAIL_UNZIP
	IF "%ERRORLEVEL%" == "13826" GOTO AGENTINSTALLFAIL_SIGNATURE_MISMATCH
GOTO AGENTINSTALLFAIL

:AGENTINSTALLSUCCESS
ECHO.
ECHO Endpoint Central Agent installed successfully.
ECHO.
GOTO ENDFILE

:AGENTINSTALLFAIL
ECHO.
ECHO -----------------------------------------------------------------------------
ECHO Endpoint Central Agent installation failed. ErrorCode: %ERRORLEVEL%."
net helpmsg %ERRORLEVEL%
ECHO -----------------------------------------------------------------------------
GOTO GETINPUT

:AGENTINSTALLFAIL_UNZIP
SET ERROR=%ERRORLEVEL%
ECHO.
ECHO -----------------------------------------------------------------------------
Msg %username% /TIME:0 /V /W "Please Un-Zip/ Extract the contents and try running setup.bat." 
ECHO.
ECHO Endpoint Central Agent installation failed. ErrorCode: %ERROR%
net helpmsg %ERROR%
ECHO -----------------------------------------------------------------------------
GOTO ENDFILE

:AGENTINSTALLFAIL_FATAL
SET ERROR=%ERRORLEVEL%
ECHO.
ECHO -----------------------------------------------------------------------------
Msg %username% /TIME:0 /V /W "Please run setup.bat in 'Run as administrator' mode."
ECHO.
ECHO Endpoint Central Agent installation failed. ErrorCode: %ERROR%
net helpmsg %ERROR%
ECHO -----------------------------------------------------------------------------
GOTO ENDFILE

:AGENTINSTALLFAIL_SIGNATURE_MISMATCH
SET ERROR=%ERRORLEVEL%
ECHO.
ECHO -----------------------------------------------------------------------------
Msg %username% /TIME:0 /V /W "MSI signature mismatch, please try again."
ECHO.
ECHO Endpoint Central Agent installation failed. ErrorCode: %ERROR%
net helpmsg %ERROR%
ECHO -----------------------------------------------------------------------------
GOTO ENDFILE


:INVALID
Msg %username% /TIME:0 /V /W "Please enter the valid option."
ECHO.
GOTO GETINPUT


:ENDFILE
ECHO.
PAUSE
