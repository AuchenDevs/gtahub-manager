@echo off 

set "installer=%temp%\gtahub-installer.exe"

set "gtahub=%localappdata%\Programs\launcher-gtahub"

set "launcher=%gtahub%\GTAHub Launcher.exe"
set "uninstaller=%gtahub%\Uninstall GTAHub Launcher.exe"

set "version=v-1.1.0"



::buenas skidder. Alias ImRex_
title GTAHub installer ^| By craciu25_YT ^| %version%
if not exist "C:\GTAHub\RAGEMP\updater.exe" (
	color 4
	echo [INTEGRITY] There's something wrong with GTAHub instalation. ^(RAGE^)
	timeout 3 >nul
	goto install
)
if not exist "%localappdata%\Programs\launcher-gtahub\GTAHub Launcher.exe" (
	color 4
	echo [INTEGRITY] There's something wrong with GTAHub instalation. ^(Launcher^)
	timeout 3 >nul
	goto install
)

cd C:\GTAHub\

color 2
echo [INTEGRITY] All the files seems to be correct
timeout 2>nul


:menu
color b
cls
echo.
echo    GTA HUB MANAGER - BY CRACIU25_YT
echo.
echo.
echo  [1]. Launch
echo.
echo  [2]. Uninstall
echo.
echo.

set /p "choose="

:: Due to a weird behaviour by GTAHUB Launcher it would be not posible to run it and close it. This is because for some reason it injects a child process to the current command prompt and it just left it in stand by because it is logging the output and if you close the command prompt the child process gets closed and the launcher closes itself too though it is in a separated process. 
if %choose% == 1 ( start /b /SEPARATE cmd /c "%launcher%" && timeout 1 && exit)
if %choose% == 2 ( goto uninstall )
echo You should answer with the number 1 or 2

timeout 2 /nobreak >nul
goto menu

:uninstall
cls
tasklist | findstr /c:"GTAHub Launcher.exe" && (color 4 & echo [ERROR] Please, close GTAHub launcher & timeout 5 /nobreak >nul & exit)
tasklist | findstr /c:"GTAV.exe"  && (color 4 & echo [ERROR] Please, close GTA V & timeout 5 /nobreak >nul & exit)

::saves the client recourses
echo [INFO] Saving client resources data
if not exist "%temp%\GTAHUB MANAGER\" (
	md "%temp%\GTAHUB MANAGER\" >nul
)
move "C:\GTAHub\RAGEMP\client_resources" "%temp%\GTAHUB MANAGER\" >nul

::/S forces to uninstall without the "Are you sure" prompt
echo [INFO] Uninstalling GTAHUB...
"%uninstaller%" /S >nul
timeout 5 /nobreak >nul

cd ..

echo [INFO] Removing other folders...
rmdir /s /q "C:\GTAHUB" >nul

echo [INFO] Removing "C:\GTAHUB"...
rmdir /s /q "%appdata%\GTAHub Launcher" >nul

echo [INFO] Removing "%appdata%\GTAHub Launcher"...
rmdir /s /q "%localappdata%\launcher-gtahub-updater" >nul

echo [INFO] Removing "%localappdata%\Programs\launcher-gtahub"...
rmdir /s /q "%localappdata%\Programs\launcher-gtahub">nul

echo [INFO] All weird folders deleted...

echo sucessfully uninstalled!!
timeout 10 >nul
exit

:install 
color b
cls
echo.
echo.
echo [INFO] You want to install/re-install GTAHUB Launcher? [Y/n]
echo.
echo.
set /p "choice="
if /i "%choice%"=="no" (goto menu)
if /i "%choice%"=="n" (goto menu)

echo [INTEGRITY] Checking installer

if not exist %installer% (
	echo.
	echo [INTEGRITY] GTAHUB installer not found. Downloading
	curl https://cdn.gtahub.gg/gtahub-launcher.exe -o "%installer%"
)
echo.
echo [INFO] Installing...
%installer%
echo [INFO] Installed sucessfully!
timeout 4 /nobreak >nul
cls 
echo. 
echo [INFO] Checking if there's saved info
if exist "%temp%\GTAHUB MANAGER\client_resources" (
	echo [INFO] Client recourses data backup found. Restoring. GTAHUB Launcher will be closed
	taskkill /f /t /im "GTAHub Launcher.exe" >nul
	move "%temp%\GTAHUB MANAGER\client_resources" "C:\GTAHub\RAGEMP\client_resources" >nul
	echo [INFO] Data sucessfully restored!
)

timeout 5 /nobreak >nul
goto menu
