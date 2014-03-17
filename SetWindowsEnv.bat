@echo off

echo Warning, if this has already been done it will add duplicate vars to your path
set /p setpath=Proceede [y/n]?: 

if NOT %setpath% == y exit 1

setx CODEUTILS "%CD%"

for /F "tokens=2* delims= " %%f IN ('reg query "HKCU\Environment" /v PATH ^| findstr /i path') do set OLD_SYSTEM_PATH=%%g
  setx PATH "%OLD_SYSTEM_PATH%;%CD%"

@echo on
