@echo off
rem Sample script to backup files from local system to another network PC using xcopy with logging
rem ab 18/07/2008 - updated 26/01/2023 FD
rem batch file to be used for automated recurring backup - v1.0

rem Instructions: Set the source and destination folders in src and dest variables in the first part below. 
rem Set the number of backup copies to keep in xCopies below.Do not modify below the marked line.
rem Set up the batch file as an automated task in Task Manager
rem The program will make one backup at each execution and keep n=dailyCopies daily backup version, n=weeklycopies weekly backup version, etc.

rem -----------------------SET SOURCE AND DESTINATION FOLDERS HERE-------------------------------------------

set src=C:\Users\fdoskas\OneDrive - University of Edinburgh\Tools\Batch files
set dest=C:\Users\fdoskas\OneDrive - University of Edinburgh\Tools\bu

set /a dailyCopies=1
set /a weeklyCopies=1
set /a monthlyCopies=1
set /a yearlyCopies=1

rem -------------------------------- DO NOT MODIFY BELOW THIS LINE ------------------------------------------------

rem set log file
set logFile="xcopy_log.txt"

rem insert separator for new log entry + date & time
echo ~~~~~~~~~~ New log entry ~~~~~~~~~~ > %logFile%

for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set datetime=%%I
set logYear=%datetime:~0,4%
set logMonth=%datetime:~4,2%
set logDay=%datetime:~6,2%
set logDate=%logYear%-%logMonth%-%logDay%
set logTime=%datetime:~8,2%:%datetime:~10,2%:%datetime:~12,2%
set logDateTime=%logDate%_%logTime%
echo %logDateTime% >> %logFile%

rem start xcopy of new & changed files
set src="%src%\*"
set output="%dest%\%logDate%"
set dest=%dest%\
echo xcopy %src% to %output% >> %logFile%

rem daily bu
xcopy %src% %output%\daily_bu /s /e /h /y /z /i /k /d /r >> %logFile%


rem sort through files and keep x daily, weekly, monthly and yearly backup
echo sorting "%dest%" >> %logFile%
dir "%dest%" /ad /o-d /tc >> %logFile%
dir "%dest%" /ad /o-d /tc > dailyBu.txt
echo "reading test" >> %logFile%
set /a count=0-7
echo %count% >> %logFile%
for /F "tokens=*" %%i in (dailyBu.txt) do (
 echo %%i >> %logFile%
 set /a count+=1
 if %count% gtr %dailyCopies% do(
   echo %%i" to be deleted" >> %logFile%
   )
  )
  
set /a count-=7
echo %count% >> %logFile%

if %count% gtr %dailyCopies% do(
 echo "too big" >> %logFile%
 
 
 )

echo number of copies to keep: >> %logFile%
set copyN=%dailyCopies% %weeklyCopies% %monthlyCopies% %yearlyCopies%
echo %copyN% >> %logFile%
for %%a in (%copyN%) do (
 echo %%a >> %logFile%
 )

set /a count=0 0 0 0
echo "%dest%" >> %logFile%
for /d %%b in ("%dest%*") do (
 echo %%~nb >> %logFile%

 rem echo %count%:%%b >> %logFile%
 rem set /a count+=1 
 )


echo ~~~~~~~~~~~ End of job ~~~~~~~~~~~~ >> %logFile%
echo: >> %logFile%

