@echo off

echo  
echo   #######        ####               ####          ####   ##      ##  ########## 
echo   ##     ##    ##    ##              ##            ##    ###     ##      ##     
echo   ##      ##  ##      ##             ##            ##    ## #    ##      ##     
echo   ##     ##   ##                     ##            ##    ##  #   ##      ##     
echo   #######     ##          ########   ##            ##    ##  ##  ##      ##     
echo   ##          ##                     ##            ##    ##   #  ##      ##     
echo   ##          ##                     ##            ##    ##    # ##      ##     
echo   ##           ##    ##              ##       #    ##    ##     ###      ##     
echo   ###            ####                ##########   ####   ##      ##     ####    
echo ---------------------------------------------------------------------------------



::set paramater
set BAT_DIR=%~dp0
set CURR_DIR=%CD%
set LINT_DIR=C:\lint
set LINT_CFG_DIR=C:\lint\conf

cd /d %BAT_DIR%
cd ..
set PRJ_DIR=%CD%
cd /d %CURR_DIR% 
if "%1" NEQ "" ( set PRJ_DIR=%~df1 )

set PRJ_LNT=%BAT_DIR%project.lnt
set PRJ_INCLUDES=%BAT_DIR%include_path.lnt
set PRJ_FILES=%BAT_DIR%files.lnt
set PRJ_TMP=%BAT_DIR%lint.tmp


::parse project files
cd /d %PRJ_DIR%

if not exist %PRJ_FILES% (
dir /b /s /a:-d *.cpp *.cc *.c *.cxx *.c++ > %PRJ_FILES% )

if not exist %PRJ_INCLUDES% (
	dir /b /s /a:-d *.h *.hpp > %PRJ_INCLUDES%
	
	echo 0>%PRJ_TMP%
	FOR /F %%I in (%PRJ_INCLUDES%) DO echo -i"%%~dpI" >> %PRJ_TMP%

	echo 0>%PRJ_INCLUDES%
	for /f "delims=" %%i in (%PRJ_TMP%) do (
    	if not defined %%i set %%i=s & echo %%i>>%PRJ_INCLUDES% )
	if exist %PRJ_TMP% del %PRJ_TMP% )


:: run pc-lint
cd /d %BAT_DIR%
echo In Progress ... ...
%LINT_DIR%\lint-nt -b -os(LINT.OUT) -i%LINT_CFG_DIR% std env-si %PRJ_LNT% %PRJ_INCLUDES% %PRJ_FILES%

cd /d %CURR_DIR%