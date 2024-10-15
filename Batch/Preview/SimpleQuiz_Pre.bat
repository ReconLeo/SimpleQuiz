@echo off
title Quiz
setlocal enabledelayedexpansion
set round=1
set right=0
set wrong_collection=%time:~0,2%%time:~3,2%%time:~6,2%%time:~9,2%
color 0e
:reader
echo Loading data...
set entry_num=0
set entry_order=0
if not exist dict.txt echo Data do not exist.&&pause&&cls&&call Quiz_gen.exe quiz %~n0
for /f "eol=> delims=, tokens=1,2,*" %%i in (dict.txt) do (
  set /a entry_num+=1
  set entry_title_!entry_order!=%%i
  set entry_content_!entry_order!=%%j
  set entry_note_!entry_order!=%%k
  set /a entry_order+=1
)
echo Data loaded.
timeout /t 1 >nul 2>nul
cls
:test_pre
set /a rnd=%random%%%!entry_num!
set question=!entry_title_%rnd%!
set key=!entry_content_%rnd%!
set note=!entry_note_%rnd%!
:test
echo Question %round%
echo -------------------------------
if not defined rate (echo Accuracy:NaN) else (echo Accuracy:%rate%%%)
echo -------------------------------
echo Question:%question%
echo Tips:%note%
set /p ans=A:
if not defined ans cls&&goto test
if "%ans%"=="%key%" (
  set /a right+=1
  echo -------------------------------
  echo Right.
)^
else (
  echo -------------------------------
  echo Wrong.
  echo Answer: %key%
  echo [Question%round%]Question:%question%>>%wrong_collection%.txt
  echo [Question%round%]Your Answer:%ans%>>%wrong_collection%.txt
  echo [Question%round%]Answer:%key%>>%wrong_collection%.txt
  echo ------------------------------->>%wrong_collection%.txt
  pause
)
set /a rate_pre=%right%*10000/%round%
if %rate_pre% equ 0 (set rate=0) else (set rate=%rate_pre:~0,-2%.%rate_pre:~-2%)
set /a round+=1
set ans=
timeout /t 1 >nul 2>nul
cls
goto test_pre
