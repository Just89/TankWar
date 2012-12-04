:: iPhone IPA generator
:: More information:
:: http://labs.adobe.com/technologies/packagerforiphone/
:: http://download.macromedia.com/pub/labs/packagerforiphone/packagerforiphone_devguide.pdf
::
:: FlashDevelop Project Template
:: http://blubl.geoathome.at (german)

cls
@echo off

:: Path to Flex SDK binaries
set FLEX_SDK=C:\Program Files\FlashDevelop\Tools\flexsdk
set PATH=%PATH%;%FLEX_SDK%

:: Certificate files
set CERTIFICATE_FILE=certificates\iphone_dev.p12
set PROVISIONIG_FILE=certificates\iphone_dev.mobileprovision

:menu
echo iPhone IPA generator
echo.
echo. What kind of ipa do you wish to create?
echo.
echo.  [1]test (ipa-test)
echo.  [2]debug (ipa-debug)
echo.  [3]store (ipa-app-store)
echo.  [4]ad-hoc (ipa-ad-hoc)
echo.

:choice
set /P C=[Option]:
if "%C%"=="1" set IPATYPE=ipa-test
if "%C%"=="2" set IPATYPE=ipa-debug
if "%C%"=="3" set IPATYPE=ipa-app-store
if "%C%"=="4" set IPATYPE=ipa-ad-hoc
echo. You have chosen '%IPATYPE%'.
echo. 
goto pass

:pass
echo Before you enter your password, make sure no-one is looking!
set /p PASSWORD=Enter Certificate Password:
cls
echo iPhone IPA generator
echo.
echo. Thanks, password input done.
echo.
goto ipa

:ipa
echo. IPA creation may take up to 3 minutes, please be patient
echo. --------------------------------------------------------
call pfi -package -target ipa-test -provisioning-profile %PROVISIONIG_FILE% -storetype pkcs12 -keystore %CERTIFICATE_FILE% -storepass %PASSWORD% iphone/SpaceInvadersClientIphone-%IPATYPE%.ipa application.xml bin/SpaceInvadersClientIphone.swf bin/Default.png bin/icons
if errorlevel 1 goto failed
echo. --------------------------------------------------------
echo. SUCCESS: IPA created in (./iphone/SpaceInvadersClientIphone-%IPATYPE%.ipa)
echo.
goto end

:failed
echo. --------------------------------------------------------
echo. ERROR: IPA creation FAILED.
echo.
echo. Troubleshotting: did you configure the Flex SDK path in this Batch file?
echo.

:end
pause