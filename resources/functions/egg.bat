@echo off

:: (%~1) representa o primeiro argumento.
set vbs_message_file_path=%~1

start /wait %vbs_message_file_path%
