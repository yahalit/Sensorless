@echo off
cd /d %~dp0
setlocal enabledelayedexpansion

:: Specify the input text file and the output file
set "input_file=.\Application\ConstDef.h"
set "output_file="kukuku.txt"

:: Specify the search term
set "search_term1=SRV_FIRM_YR"
set "search_term2=SRV_FIRM_MONTH"
set "search_term3=SRV_FIRM_DAY"
set "search_term4=SRV_FIRM_VER"
set "search_term5=SRV_FIRM_SUBVER"
set "search_term6=SRV_FIRM_PATCH"

rem Initialize the variable to hold the result
set "result="

rem Search for "SRV_FIRM_YR" in the file and store the result in a variable
for /f "tokens=*" %%a in ('findstr "%search_term1%" "%input_file%"') do (
    set "result=%%a"
	goto :foundyr
)
:foundyr
    for /f "delims=" %%b in ('powershell -command "$result='%result%'; if ($result -match 'SRV_FIRM_YR\s*(\d+)') {echo $matches[1]}"') do (
        set "YR=%%b"
    )

for /f "tokens=*" %%a in ('findstr "%search_term2%" "%input_file%"') do (
    set "result=%%a"
	goto :foundmo
)
:foundmo
    for /f "delims=" %%b in ('powershell -command "$result='%result%'; if ($result -match 'SRV_FIRM_MONTH\s*(\d+)') {echo $matches[1]}"') do (
        set "MON=%%b"
    )

for /f "tokens=*" %%a in ('findstr "%search_term3%" "%input_file%"') do (
    set "result=%%a"
	goto :foundday
)
:foundday
    for /f "delims=" %%b in ('powershell -command "$result='%result%'; if ($result -match 'SRV_FIRM_DAY\s*(\d+)') {echo $matches[1]}"') do (
        set "DAY=%%b"
    )
	
for /f "tokens=*" %%a in ('findstr "%search_term4%" "%input_file%"') do (
    set "result=%%a"
	goto :foundver
)
:foundver
    for /f "delims=" %%b in ('powershell -command "$result='%result%'; if ($result -match 'SRV_FIRM_VER\s*(\d+)') {echo $matches[1]}"') do (
        set "VER=%%b"
    )
	
	
for /f "tokens=*" %%a in ('findstr "%search_term5%" "%input_file%"') do (
    set "result=%%a"
	goto :foundsubver
)
:foundsubver
    for /f "delims=" %%b in ('powershell -command "$result='%result%'; if ($result -match 'SRV_FIRM_SUBVER\s*(\d+)') {echo $matches[1]}"') do (
        set "SUBVER=%%b"
    )
	
	
for /f "tokens=*" %%a in ('findstr "%search_term6%" "%input_file%"') do (
    set "result=%%a"
	goto :foundpat
)
:foundpat
    for /f "delims=" %%b in ('powershell -command "$result='%result%'; if ($result -match 'SRV_FIRM_PATCH\s*(\d+)') {echo $matches[1]}"') do (
        set "PAT=%%b"
    )
	
set /a RELYEAR="%YR%-2000"
::echo %RELYEAR%
set /a "VERCODE=%RELYEAR%*16777216+%MON%*1048576+%DAY%*32768+%VER%*256+%SUBVER%*16+%PAT%"	

set "outfile=..\Exe\NeckDrive_%VER%_%SUBVER%_%PAT%_%YR%_%MON%_%DAY%_%VERCODE%.out"
set "hexfile=..\Exe\NeckDrive_%VER%_%SUBVER%_%PAT%_%YR%_%MON%_%DAY%_%VERCODE%.hex"

echo Out file: %outfile%
echo Hex file: %hexfile%

copy .\CPU1_FLASH\BESensoreless.hex %hexfile%  /y
copy .\CPU1_FLASH\BESensoreless.out %outfile%  /y


::%fname" >>%output_file%
pause