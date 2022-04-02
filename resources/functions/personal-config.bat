@echo off && cls
:: Use "CALL" command (cmd)!

set REG_CURRENT_MACHINE_PATH="HKCU\Software\Microsoft\Command Processor"
set PERSONAL_COMMAND_PROMPT_COLOR=0a

REM Variables/paths
set desktop_dir=%userprofile%\Desktop
set regedit_exported_file_path=%desktop_dir%\command.exported.reg

:: ACTION
set command=%~1

if exist %regedit_exported_file_path% (
  if "%command%" == "import" (
    echo "Info: CREATED!" && goto commnad_exit
  )
)

if not defined command (
  echo "Error: COMMAND..." && goto commnad_exit
)

if "%command%" == "import" ( goto import )  
if "%command%" == "revert" ( goto revert ) else ( goto commnad_exit )

REM IMPORT CONFIG
:import 
call :function_export_regedit

goto function_set_regedit

REM REVERT CONFIG
:revert
goto function_backup_import


:function_set_regedit
set data="cls && color %personal_cmd_color% && title Terminal && prompt $p$g "

reg add %REG_CURRENT_MACHINE_PATH% /v Autorun /t REG_SZ /d %data% /f

goto commnad_exit


:function_backup_import
:: Remover os atributos de arquivos existentes. (-H) remove a propriedade
:: somente leitura, Por outro lado, (-H) remove a propriedade de arquivo oculto.
attrib -R -H %regedit_exported_file_path%

reg import %regedit_exported_file_path% REM && attrib +R +H %regedit_exported_file_path%

del /f /q %regedit_exported_file_path%

goto commnad_exit


REM EXIT
:commnad_exit
exit /b


REM BACKUP
:function_export_regedit
:: A instrução abaixo, é responsável por remover o último arquivo de "backup"
:: do REGEDIT do Windows (CMD). Forçando a exclusão de arquivos ocultos.
del /f /a /q %regedit_exported_file_path%>nul 2>nul

reg export %REG_CURRENT_MACHINE_PATH% %regedit_exported_file_path% /y
attrib +H +R %regedit_exported_file_path%

goto :EOF
