@echo off&setlocal enabledelayedexpansion
set /p dir_path=drag the folder into here which need to rename items
echo %dir_path%
set index=1

for %%f in (%dir_path%) do (set myfolder=%%~nxf)
rem echo %myfolder%
echo: 

for /r %dir_path% %%c in (_*_.png) do (
echo !index! :
echo %%~nc

echo %%c %dir_path%\symbol_!index!.png 
ren %%c symbol_!index!.png
echo: 

echo !index! : %%~nc >> %myfolder%.txt
set /a index=!index!+1

)
echo finish! 
pause