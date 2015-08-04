::set paramater
@echo off

set PRJ_DIR=%CD%
set LINT_DIR=%~dp0
set LINT_CFG_DIR=%LINT_DIR%conf\
set PRJ_LNT=%LINT_CFG_DIR%project.lnt
set PRJ_INC=%LINT_CFG_DIR%project_inc_path.lnt
set PRJ_INC_TMP=%LINT_CFG_DIR%project_inc_path.tmp


::parse project files
cd /d %PRJ_DIR%
dir /b /s /a:-d *.cpp *.cc *.c *.cxx *.c++ > %PRJ_LNT%
dir /b /s /a:-d *.h *.hpp > %PRJ_INC%

echo 0>%PRJ_INC_TMP%
FOR /F %%I in (%PRJ_INC%) DO echo -i"%%~dpI" >> %PRJ_INC_TMP%

echo 0>%PRJ_INC%
for /f "delims=" %%i in (%PRJ_INC_TMP%) do (
    if not defined %%i set %%i=s & echo %%i>>%PRJ_INC%)

:: run pc-lint
cd /d %LINT_DIR%
%LINT_DIR%\lint-nt -b -i%LINT_CFG_DIR% std env-si project_inc_path project 
::C:\lint\lint-nt -b -iC:\lint\conf std env-si project_inc_path project 