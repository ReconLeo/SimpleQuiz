@echo off
title UniQuiz
setlocal enabledelayedexpansion
set version=1.0
set round=1
set right=0
set mode=1
set no_dict=0
if exist settings.ini (
  for /f "eol=> delims=, tokens=1,2" %%i in (settings.ini) do (
  set wrong_col=%%i
  set debug=%%j
  )
)^
else (
  set debug=0
  set wrong_col=0
)
set wrong_collection=%date:~2,2%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%
if %debug% neq 0 echo --Engineering Mode--
color 0e
:dict_preload
set dict_num=0
set dict_num_list=0
if not exist %~dp0\Dicts md Dicts
for %%i in (%~dp0\Dicts\*.ini) do ( set /a dict_num_list+=1 )
if !dict_num_list! equ 0 set no_dict=1&&echo No dict was found.&&call %~dp0\dict_editor.exe quiz %~n0
cd /d %~dp0\Dicts
if !dict_num_list! equ 1 echo Total !dict_num_list! dict was found.
if !dict_num_list! gtr 1 echo Total !dict_num_list! dicts were found.
echo -------------------------------
echo Index Number Dict Name
for %%i in (*.ini) do ( 
  set /a dict_num+=1
  set se_!dict_num!=!dict_num!
  set file_dis=%%i
  set file_dis=!file_dis:~0,-4!
  set se_!dict_num!_file=!file_dis!
  echo !dict_num!            !file_dis!
)
:read_data_arc
echo Enter the Reference Number(Enter "new" to edit avalible dict(s) or create a new dict):
set /p read_data_arc_num=
if "%read_data_arc_num%" == "new" (
  cls
  cd /d %~dp0
  call dict_editor.exe quiz %~n0
)
set read_data_arc_file_pre=se_%read_data_arc_num%_file
set read_data_arc_file=!%read_data_arc_file_pre%!
if exist %read_data_arc_file%.ini goto reader
echo File do not exist.
goto read_data_arc
:reader
title UniQuiz[Dict %read_data_arc_file%]
set /p mode=Enter quiz mode:
if %mode% equ 1 (
  echo [Normal Mode]
  title UniQuiz[Dict %read_data_arc_file%] - Normal Mode
  goto reader_on
)
if %mode% equ 2 (
  echo [Reversed Mode]
  title UniQuiz[Dict %read_data_arc_file%] - Reversed Mode
  goto reader_on
)
cls
set mode=
goto reader
:reader_on
cls
if %debug% neq 0 echo --Engineering Mode--
echo (c) Recon^&LY Inc. All rights reserved.
echo Loading data...
set entry_num=0
set entry_order=0
for /f "eol=> delims=, tokens=1,2,*" %%i in (%read_data_arc_file%.ini) do (
  set /a entry_num+=1
  set entry_title_!entry_order!=%%i
  set entry_content_!entry_order!=%%j
  set entry_note_!entry_order!=%%k
  set /a entry_order+=1
)
timeout /t 1 >nul 2>nul
cls
:test_pre
if %mode% equ 1 (
  goto test_pre_1
)^
else (
  goto test_pre_2
)
:test_pre_1
set /a rnd=%random%%%!entry_num! >nul 2>nul
set question=!entry_title_%rnd%!
set key=!entry_content_%rnd%!
set note=!entry_note_%rnd%!
if not defined question (
  echo Invalid dict data.
  timeout /t 1 >nul 2>nul
  cls
  title UniQuiz
  goto dict_preload
)
timeout /t 1 >nul 2>nul
cls
goto test
:test_pre_2
set /a rnd=%random%%%!entry_num! >nul 2>nul
set key=!entry_title_%rnd%!
set question=!entry_content_%rnd%!
set note=!entry_note_%rnd%!
if not defined question (
  echo Invalid dict data.
  timeout /t 1 >nul 2>nul
  cls
  title Quiz
  goto dict_preload
)
echo Data loaded.
goto test
:test
if %debug% neq 0 echo --Engineering Mode--
echo Question %round%
echo -------------------------------
if not defined rate (echo Accuracy:NaN%%) else (echo Accuracy:%rate%%%)
if not defined right_row (echo Right in a row:NaN%%) else (echo Right in a row:%right_row%)
echo -------------------------------
echo Question:%question%
if %debug% neq 0 echo Key:%key%
if "%note%" neq "(NaN)" echo Tips:%note%
if %debug% neq 0 set ans=%key%
set /p ans=A:
if not defined ans cls&&goto test
if "%ans%"=="%key%" (
  set /a right+=1
  set /a right_row+=1
  echo -------------------------------
  echo Right.
)^
else (
  echo -------------------------------
  echo Wrong.
  echo Answer: %key%
  set right_row=0
  if %wrong_col% equ 1 (
    echo [Question%round%]Question:%question%>>wrong_collection_%wrong_collection%[%read_data_arc_file%].txt
    echo [Question%round%]Your Answer:%ans%>>wrong_collection_%wrong_collection%[%read_data_arc_file%].txt
    echo [Question%round%]Answer:%key%>>wrong_collection_%wrong_collection%[%read_data_arc_file%].txt
    echo ------------------------------->>wrong_collection_%wrong_collection%[%read_data_arc_file%].txt
  )^
  else (echo Function Disabled. >nul 2>nul)
  pause
)
set /a rate_pre=%right%*10000/%round%
if %rate_pre% equ 0 (set rate=0) else (set rate=%rate_pre:~0,-2%.%rate_pre:~-2%)
set /a round+=1
set ans=
timeout /t 1 >nul 2>nul
cls
if %no_dict% equ 1 set no_dict=0&&goto dict_preload
goto test_pre
