@echo off
setlocal
cd /d "%~dp0"
echo ================================ > startup-log.txt
echo Prezzo Artigiano startup >> startup-log.txt
echo %date% %time% >> startup-log.txt
echo Directory: %CD% >> startup-log.txt
echo. >> startup-log.txt
echo Launching prezzo_artigiano.exe... >> startup-log.txt
prezzo_artigiano.exe >> startup-log.txt 2>&1
set ERR=%ERRORLEVEL%
echo. >> startup-log.txt
echo Exit code: %ERR% >> startup-log.txt
echo. >> startup-log.txt
echo If the application closes immediately, send this startup-log.txt to support.
pause
exit /b %ERR%
