@echo off
title Downloading and installing your new computer
echo This tool is for private use by Marnix Bloeiman only.
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
pause
cd /d "%userprofile%\Downloads\"
md "%userprofile%\Downloads\Auto_downloaded_for_setup_of_computer"
cd /d "%userprofile%\Downloads\Auto_downloaded_for_setup_of_computer"
echo downloading software list...
powershell -command "& { (New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Marnix0810/Computer-almostunnatended-autosetup/master/listofdependencies.txt', 'listofdependencies.txt') }"
cls
FOR /F "usebackq tokens=1,2* delims=," %%G IN ("listofdependencies.txt") DO (
title Downloading and installing
echo ======================================================================================
echo:
echo The installation of:
echo:
echo downloading the file %%H
powershell -command "& { (New-Object Net.WebClient).DownloadFile('%%H', '%%I') }"
echo download of %%I complete. Executing installation...
start /wait "" "%%I" %%G || echo the setup reported an error.
echo the file is closed or completed execution, either way, the next file is selected.
)
echo:
echo ======================================================================================
Echo it seems like the list is done, please check above for errors.
color f0
pause
cls
echo press any key to remove installation downloads (located at "%userprofile%\Downloads\Auto_downloaded_for_setup_of_computer") ...
pause >NUL
del *.* /s /q
CD /D "%~dp0"
rd /s /q "%userprofile%\Downloads\Auto_downloaded_for_setup_of_computer"