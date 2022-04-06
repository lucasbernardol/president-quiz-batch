@echo off && cls

:: President quiz - Batch script
:: Version: 0.0.1
::
:: Copyright (c) 2022-present, José Lucas B.Lira.
:: License: MIT
:: Repository: https://github.com/lucasbernardol/president-quiz-batch/

set VERSION=0.0.2

REM Path variables/directories
set desktop_dir_path=%userprofile%\Desktop
set documents_dir_path=%userprofile%\Documents
set temp_dir_path=%temp%

set resources_folder=resources
set resoruces_functions_folder=%resources_folder%\functions

set welcome_path=%temp_dir_path%\welcome.quiz.vbs
set winner_details_file_path=%desktop_dir_path%\winner.txt

set extension_config_file_path=.\config.bat
set personal_config_text_file=config.personal.txt

set personal_config_batch_file=%resoruces_functions_folder%\personal-config.bat

set easter_egg_batch_file=%resoruces_functions_folder%\easter-egg-function.bat
set easter_egg_vbs_message_file=%resources_folder%\vbs\easter-egg.message.vbs

set expires_message_seconds=20

set try_again_message="Tentativas esgotadas. Jogue novamente!"
set valid_question_message="Resposta correta!"

REM LOGS
set logs_directory=%documents_dir_path%\logs

:: File format BR: "president.quiz-(day)-(month)-(year).txt"
set logs_filename_path="president.quiz-%date:~0,2%-%date:~3,2%-%date:~6,4%.txt"

REM Variables: main colors
set command_color=07
set command_prompt_alert_color=0c

REM Questions custom/colors
set question_one_color=0a
set question_two_color=0f
set question_three_color=03
set question_four_color=05
set question_five_color=06
set question_six_color=0c

:: Variável de "state" (estado) que irá permitir a utilização das cores
:: customizadas/personalizadas. Para que isso funcione, é  necessário criar 
:: um arquivo "config.bat" na raiz do projeto ou no mesmo diretório do arquivo 
:: "President.bat". Em geral, usaremos a instrução "call".
set allow_custom_colors=0

set ALLOW_LOGS=1

set allow_personal_config=1

REM Global variables
set /a max_repeat_questions=2
set /a total_displayed_errors=0

:: A variável "menu_returned" controla a quantida de vezes em que a hora atual, 
:: ou seja, o horário inicial do jogo será exibido em tela. (variável de estado).
set /a menu_returned=1

set displayed_error_argument=0

REM Current time format: HH:MM:SS - 14:05:85
:: As variáveis abaixo, armazenam o horário inicial e final do jogo. Em suma, 
:: o horário final será alterado quando ouver um ganhador.
set president_game_start_time=%time:~0,8%
set president_game_end_time=0

set personal_config_param_defualt="import"

REM Create if exits "logs" directory.
if not exist %logs_directory% (
  mkdir %logs_directory%
)

:: A seção abaixo será responsável por carregar as minhas configurações pessoais
:: do Command Prompt (CMD) como cores, tamanhos, entre outos.
if exist %personal_config_text_file% (
  set /p personal_config_param=<%personal_config_text_file%
)

if not defined personal_config_param ( 
  set personal_config_param=%personal_config_param_defualt%
)

if exist %personal_config_batch_file% (
  :: A variável "personal_config_param" armazena "import" ou "revert".
  if %allow_personal_config% EQU 1 (
    call %personal_config_batch_file% %personal_config_param% && cls
  )
)


REM Start GAME:
:start_application
mode 64,32
if exist %extension_config_file_path% (
  call %extension_config_file_path%
) else (
  :: Antes tudo, só será possível exibir/criar LOGS se a variável 
  :: "ALLOW_LOGS" for igual a 1, ou seja, verdadeiro na lógica booleana.
  if %ALLOW_LOGS% EQU 1 call :log_with_timestamp "PRE-LOG: Batch started."
)

if exist %welcome_path% ( goto menu ) else ( goto welcome_view )


REM Open welcome message / global message
:open_welcome_view
cls && start /wait %welcome_path%
goto start_application

:welcome_view
:: Variáveis auxiliares para a construção da mensage "welcome" ou de
:: boas vindas! (vbs_body, vbs_title, vbs_context)
set vbs_body="Seja bem-vindo(a) ao President Quiz!"
set vbs_title="President quiz - Version: %VERSION%"
set vbs_context=64

echo MsgBox %vbs_body%, %vbs_context%, %vbs_title%>%welcome_path%

:: A instrução "Attrib" será usada para deixar o arquvio "welcome.vbs"
:: oculto (+H) e somente leitura (+R).
attrib +H +R %welcome_path%

if %ALLOW_LOGS% EQU 1 call :log_with_timestamp "PRE-LOG: Saved 'welcome.vbs'."
goto open_welcome_view


:update_menu_returned
set /a menu_returned=%menu_returned% + 1
goto menu

:reset_max_repeat_questions
set /a max_repeat_questions=2
goto start_application


:: Essa seção é responsável por exibir o menu/opções de jogador. Permitindo
:: que o usuário tenha duas opções: jogar ou sair (as escolhas podem ser alteradas)
:menu
title President Quiz - version: %VERSION%
color %command_color% && cls
if %ALLOW_LOGS% EQU 1 call :log_with_timestamp "LOG: MENU."
echo.
echo [+]----------------------------------------------[+]
echo.
echo          President Quiz - Jair Bolsonaro
echo.
echo   Coded by: @lucasbernardol - github/lucasbernardol
echo.
echo [+]----------------------------------------------[+]
echo.
echo Info: Para mais detalhes digite "help" ou "c"!
echo.
:: O horário atual ou horáio de início de jogo só será exibito
:: se a variável "menu_returned" for menor ou igual a 1.
if %menu_returned% LEQ 1 (
  echo Inicial: %president_game_start_time% && echo.
)

echo  1) Jogar   2) Sair
echo.
set /p "menu_selected_option=Digite>: "

if "%menu_selected_option%" == "" ( goto menu_error_options_view )

if /i "%menu_selected_option%" == "help" ( goto application_help )

:: A instrução "if" abaixo cria um "alias" ou "apelido" para o parâmetro de 
:: entrada "help", que redireciona o fluxo para a seção "application_help"
if /i "%menu_selected_option%" == "h" ( goto application_help )

if /i "%menu_selected_option%" == "c" ( goto changelog )

if /i "%menu_selected_option%" == "egg" (
  :: A instrução abaixo será responsável por executar o arquivo "egg.bat".
  :: Basicamente é uma mensagem "secreta".
  cls && call %easter_egg_batch_file% %easter_egg_vbs_message_file%
 
  if %ALLOW_LOGS% EQU 1 (
    call :log_with_timestamp "LOG: EASTER EGG"
  )

  goto update_menu_returned
)

if "%menu_selected_option%" == "1" ( goto question_one )

if "%menu_selected_option%" == "2" ( 
  goto close_application 
) else if "%menu_selected_option%" NEQ "2" ( 
  :: O fluxo do programa é redirecionado para o menu principal, isso ocorre
  :: porque o argumento/opção de entrada é diferente de "2", ou seja, a última
  :: opção válida e disponível.
  goto menu
)


:: Question 01
:: O usuário/jogador será retornado para esse menu se a opção escolhida é inválida.
:question_one
set allowed=%allow_custom_colors%

:question_one_reload
cls && if %allowed% EQU 1 ( color %question_one_color% ) else ( color %command_color% )

if %max_repeat_questions% EQU 0 (
  :: A instrução abaixo irá mostrar ao jogador uma pequena caixa de diálogo,
  :: e se o jogador não pressionar o botão "OK", em 30 segundos ela será 
  :: removida da tela.
  cls && msg /w /time %expires_message_seconds% %username% %try_again_message%

  goto reset_max_repeat_questions
)

echo.
echo [+]--------------------------------------------[+]
echo.
echo    01) Qual a idade do Presidente Jair?
echo.
echo [+]--------------------------------------------[+]
echo.
echo Total de tentativas: %max_repeat_questions%
echo.
echo  1) 54 anos  
echo  2) 59 anos   
echo  3) 60 anos
echo  4) 67 anos
echo.
set /p "question_option=Digite>: "

if "%question_option%" == "" ( goto question_one )

if "%question_option%" == "4" (
  msg /w %username% %valid_question_message%

  set /a max_repeat_questions=2

  goto question_two
)

:: A variável abaixo é responsável por controlar o estado "state", das questão
:: que podem ser repetidas ou não. (padrão 2 vezes)
set /a max_repeat_questions=%max_repeat_questions% - 1

if "%question_option%" == "1" (set displayed_error_argument="54 anos")
if "%question_option%" == "2" (set displayed_error_argument="59 anos")
if "%question_option%" == "3" (set displayed_error_argument="60 anos")

if %displayed_error_argument% EQU 0 (
  set displayed_error_argument="Desconhecido"
)

:: Idependentemente da opção escolhida o contador de erros deve ser
:: aumento ou "incrementado" com +1
set /a total_displayed_errors=%total_displayed_errors% + 1

:: Abaixo será exibido a "interface" de error/resposta incorreta.
:question_one_error_reload
color %command_prompt_alert_color% && cls
echo.
echo [+]-------------------------------------[+]
echo.
echo    Oops, Resposta incorreta!
echo.
echo    Sua resposta: %displayed_error_argument%
echo    Tentativas restantes: %max_repeat_questions%
echo.
echo    Erros: %total_displayed_errors%
echo.
echo [+]-------------------------------------[+]
echo.
echo  1) Tentar novamente   2) Sair
echo.
set /p "question_one_error_option=Digite>: "

if "%question_one_error_option%" == "1" (
  set displayed_error_argument=0
  goto question_one_reload
)

if "%question_one_error_option%" == "2" (
  goto close_application
) else if "%question_one_error_option%" NEQ "2" (
  goto question_one_error_reload
)


:: Question 02
:question_two
set allowed=%allow_custom_colors%

:question_two_reload
cls && if %allowed% EQU 1 ( color %question_two_color% ) else ( color %command_color% )

if %max_repeat_questions% EQU 0 (
  cls && msg /w /time %expires_message_seconds% %username% %try_again_message%

  goto reset_max_repeat_questions
)

echo.
echo [+]--------------------------------------------[+]
echo.
echo    02) Qual o nome completo do Presidente?
echo.
echo [+]--------------------------------------------[+]
echo.
echo Total de tentativas: %max_repeat_questions%
echo.
echo  1) Jair Bolsonaro Messias 
echo  2) Jair Messias Bolsonaro
echo  3) Jair Bolsonaro
echo  4) Presidente Jair Messias Bolsonaro
echo.
set /p "question_option=Digite>: "

if  "%question_option%" == "" ( goto question_two )

if  "%question_option%" == "2" (
  msg /w %username% %valid_question_message%

  set /a max_repeat_questions=2

  goto question_three
)

set /a max_repeat_questions=%max_repeat_questions% - 1

if "%question_option%" == "1" (set displayed_error_argument="Jair Bolsonaro Messias")
if "%question_option%" == "3" (set displayed_error_argument="Jair Bolsonaro")
if "%question_option%" == "4" (set displayed_error_argument="Presidente Jair Messias Bolsonaro")

if %displayed_error_argument% EQU 0 (
  set displayed_error_argument="Desconhecido"
)

set /a total_displayed_errors=%total_displayed_errors% + 1

:question_two_error_reload
color %command_prompt_alert_color% && cls
echo.
echo [+]-------------------------------------[+]
echo.
echo    Oops, Resposta incorreta!
echo.
echo    Sua resposta: %displayed_error_argument%
echo    Tentativas restantes: %max_repeat_questions%
echo.
echo    Erros: %total_displayed_errors%
echo.
echo [+]-------------------------------------[+]
echo.
echo  1) Tentar novamente   2) Sair
echo.
set /p "question_two_error_option=Digite>: "

if "%question_two_error_option%" == "1" (
  set displayed_error_argument=0
  
  goto question_two_reload
)

if "%question_two_error_option%" == "2" (
  goto close_application
) else if "%question_two_error_option%" NEQ "2" (
  goto question_two_error_reload
)


:: Question: 03
:question_three
set allowed=%allow_custom_colors%

:question_three_reload
cls && if %allowed% EQU 1 ( color %question_three_color% ) else ( color %command_color% )

if %max_repeat_questions% EQU 0 (
  cls && msg /w /time %expires_message_seconds% %username% %try_again_message%

  goto reset_max_repeat_questions
)

echo.
echo [+]--------------------------------------------[+]
echo.
echo    03) Quantos filhos tem o presidente?
echo.
echo [+]--------------------------------------------[+]
echo.
echo Total de tentativas: %max_repeat_questions%
echo.
echo  1) Tem 2 filho(s) 
echo  2) Tem 3 filho(s)
echo  3) Tem 5 filho(s)
echo  4) Tem 1 filho(s)
echo.
set /p "question_option=Digite>: "

if "%question_option%" == "" ( goto question_three )

if "%question_option%" == "3" (
  msg /w %username% %valid_question_message%

  set /a max_repeat_questions=2

  goto question_four
)

set /a max_repeat_questions=%max_repeat_questions% - 1

if "%question_option%" == "1" (set displayed_error_argument="Tem 2 filhos")
if "%question_option%" == "2" (set displayed_error_argument="Tem 3 filhos")
if "%question_option%" == "4" (set displayed_error_argument="Tem 1 filho")

if %displayed_error_argument% EQU 0 (
  set displayed_error_argument="Desconhecido"
) 

set /a total_displayed_errors=%total_displayed_errors% + 1

:question_three_error_reload
color %command_prompt_alert_color% && cls
echo.
echo [+]-------------------------------------[+]
echo.
echo    Oops, Resposta incorreta!
echo.
echo    Sua resposta: %displayed_error_argument%
echo    Tentativas restantes: %max_repeat_questions%
echo.
echo    Erros: %total_displayed_errors%
echo.
echo [+]-------------------------------------[+]
echo.
echo  1) Tentar novamente   2) Sair
echo.
set /p "question_three_error_option=Digite>: "

if "%question_three_error_option%" == "1" (
  set displayed_error_argument=0

  goto question_three_reload
)

if "%question_three_error_option%" == "2" (
  goto close_application
) else if "%question_three_error_option%" NEQ "2" (
  goto question_three_error_option
)


:: Question: 04
:question_four
set allowed=%allow_custom_colors%

:question_four_reload
cls && if %allowed% EQU 1 ( color %question_four_color% ) else ( color %command_color% )

if %max_repeat_questions% EQU 0 (
  cls && msg /w /time %expires_message_seconds% %username% %try_again_message%

  goto reset_max_repeat_questions
)

echo.
echo [+]--------------------------------------------[+]
echo.
echo    04) Qual a patente militar do Jair?
echo.
echo [+]--------------------------------------------[+]
echo.
echo Total de tentativas: %max_repeat_questions%
echo.
echo  1) USA Navy SEALS / Soldier
echo  2) Atirador de Elite
echo  3) Tenente
echo  4) Capitao
echo  5) Especialista dos UDTS
echo  6) Infantaria
echo.
set /p "question_option=Digite>: "

if "%question_option%" == "" ( goto question_four )

if "%question_option%" == "4" (
  msg /w %username% %valid_question_message%

  set /a max_repeat_questions=2

  goto question_five
)

set /a max_repeat_questions=%max_repeat_questions% - 1

if "%question_option%" == "1" (set displayed_error_argument="USA Navy SEALS / Soldier")
if "%question_option%" == "2" (set displayed_error_argument="Atirador de elite")
if "%question_option%" == "3" (set displayed_error_argument="Tenente da Infantaria")
if "%question_option%" == "5" (set displayed_error_argument="Especialista dos UDTS")
if "%question_option%" == "6" (set displayed_error_argument="Infantaria")

if %displayed_error_argument% EQU 0 (
  set displayed_error_argument="Desconhecido"
) 

set /a total_displayed_errors=%total_displayed_errors% + 1

:question_four_error_reload
color %command_prompt_alert_color% && cls
echo.
echo [+]-------------------------------------[+]
echo.
echo    Oops, Resposta incorreta!
echo.
echo    Sua resposta: %displayed_error_argument%
echo    Tentativas restantes: %max_repeat_questions%
echo.
echo    Erros: %total_displayed_errors%
echo.
echo [+]-------------------------------------[+]
echo.
echo  1) Tentar novamente   2) Sair
echo.
set /p "question_four_error_option=Digite>: "

if "%question_four_error_option%" == "1" (
  set displayed_error_argument=0

  goto question_four_reload
)

if "%question_four_error_option%" == "2" (
  goto close_application
) else if "%question_four_error_option%" NEQ "2" (
  goto question_four_error_reload
)


:: Question: 05
:question_five
set allowed=%allow_custom_colors%

:question_five_reload
cls && if %allowed% EQU 1 ( color %question_five_color% ) else ( color %command_color% )

if %max_repeat_questions% EQU 0 (
  cls && msg /w /time %expires_message_seconds% %username% %try_again_message%

  goto reset_max_repeat_questions
)

echo.
echo [+]--------------------------------------------[+]
echo.
echo    05) Em 1986 Jair Bolsonaro foi preso, qual o 
echo      motivo desse acontecimento?
echo.
echo [+]--------------------------------------------[+]
echo.
echo Total de tentativas: %max_repeat_questions%
echo.
echo  1) Reclamar do salario
echo  2) Atirar em um dos companheiros de equipe
echo  3) Xingamentos
echo  4) Respostas inadequadas
echo  5) Brigar com os superiores (ambiente militar)
echo.
set /p "question_option=Digite>: "

if "%question_option%" == "" ( goto question_five )

if  "%question_option%" == "1" (
  msg /w %username% %valid_question_message%

  set /a max_repeat_questions=2

  goto question_six
)

set /a max_repeat_questions=%max_repeat_questions% - 1

if "%question_option%" == "2" (set displayed_error_argument="Atirar em um dos companheiros de equipe")
if "%question_option%" == "3" (set displayed_error_argument="Xingamentos")
if "%question_option%" == "4" (set displayed_error_argument="Respostas inadequadas")
if "%question_option%" == "5" (set displayed_error_argument="Brigar com os superiores (ambiente militar)")

if %displayed_error_argument% EQU 0 (
  set displayed_error_argument="Desconhecido"
)

set /a total_displayed_errors=%total_displayed_errors% + 1

:question_five_error_reload
color %command_prompt_alert_color% && cls
echo.
echo [+]-------------------------------------[+]
echo.
echo    Oops, Resposta incorreta!
echo.
echo    Sua resposta: %displayed_error_argument%
echo    Tentativas restantes: %max_repeat_questions%
echo.
echo    Erros: %total_displayed_errors%
echo.
echo [+]-------------------------------------[+]
echo.
echo  1) Tentar novamente   2) Sair
echo.
set /p "question_five_error_option=Digite>: "

if "%question_five_error_option%" == "1" (
  set displayed_error_argument=0

  goto question_five_reload
)

if "%question_five_error_option%" == "2" (
  goto close_application
) else if "%question_five_error_reload%" NEQ "2" (
  goto question_five_error_reload
)


:: Question 06
:question_six
set allowed=%allow_custom_colors%

:question_six_reload
cls && if %allowed% EQU 1 ( color %question_six_color% ) else ( color %command_color% ) 

if %max_repeat_questions% EQU 0 (
  cls && msg /w /time %expires_message_seconds% %username% %try_again_message%

  goto reset_max_repeat_questions
)

echo.
echo [+]--------------------------------------------[+]
echo.
echo   06) Qual a altura e apelido (respectivamente) 
echo      do Jair Bolsonaro?
echo.
echo [+]--------------------------------------------[+]
echo.
echo Total de tentativas: %max_repeat_questions%
echo.
echo  1) 1.80m, Mito 
echo  2) Mito, 1.85m
echo  3) 1.78m, Bolsonaro Mito
echo  4) 1.83m, Jair Mito
echo  5) 1.85m, Mito
echo  6) 1.85m, Senhor da mitologia
echo.
set /p "question_option=Digite>: "

if "%question_option%" == "" ( goto question_six )

if "%question_option%" == "5" (
  :: A mensagem de "resposta correta" não será exibida, porque a questão de
  :: número 6, até o momento, é a última. Em outras palavras, o ganhador será
  :: redireciomando para a "interface" de comemoração e/ou vitória.
  goto winner
)

set /a max_repeat_questions=%max_repeat_questions% - 1

if "%question_option%" == "1" (set displayed_error_argument="1.80m, Mito")
if "%question_option%" == "2" (set displayed_error_argument="Mito, 1.85m")
if "%question_option%" == "3" (set displayed_error_argument="1.78m, Bolsonaro Mito")
if "%question_option%" == "4" (set displayed_error_argument="1.83m, Jair Mito")
if "%question_option%" == "6" (set displayed_error_argument="1.85m, Senhor da mitologia")

if %displayed_error_argument% EQU 0 (
  set displayed_error_argument="Desconhecido"
)

set /a total_displayed_errors=%total_displayed_errors% + 1

:question_six_error_reload
color %command_prompt_alert_color% && cls
echo.
echo [+]-------------------------------------[+]
echo.
echo    Oops, Resposta incorreta!
echo.
echo    Sua resposta: %displayed_error_argument%
echo    Tentativas restantes: %max_repeat_questions%
echo.
echo    Erros: %total_displayed_errors%
echo.
echo [+]-------------------------------------[+]
echo.
echo  1) Tentar novamente   2) Sair
echo.
set /p "question_six_error_option=Digite>: "

if "%question_six_error_option%" == "1" (
  set displayed_error_argument=0

  goto question_six_reload
)

if "%question_six_error_option%" == "2" ( 
  goto close_application 
) else if "%question_six_error_reload%" NEQ "2" ( 
  goto question_six_error_reload 
)


rem Error: selected option
:menu_error_options_view
color %command_color% && cls
if %ALLOW_LOGS% EQU 1 call :log_with_timestamp "LOG: View/Options ERROR."
title Error: Entradas
echo.
echo [+]--------------------------------------------[+]
echo.
echo    OBS: Informe os parametros corretos, ou isso
echo      pode gerar Bugs, seja honesto!
echo.
echo [+]--------------------------------------------[+]
echo.
echo Pressione qualquer tecla para voltar ao Menu...
pause >nul
goto update_menu_returned


rem HELP
:application_help
title President Quiz - HELP
if %ALLOW_LOGS% EQU 1 call :log_with_timestamp "LOG: Open HELP context."
cls
echo.
echo [+]-----------------------------------------------------[+]    
echo.
echo    1) Este programa foi desenvolvido 
echo      visando o entretenimento - version: %VERSION%
echo.	
echo    2) Todos os dereitos reservados.
echo.
echo    3) github.com/lucasbernardol/president-quiz-bath
echo.
echo [+]-----------------------------------------------------[+]   
echo.
echo Pressione qualquer tecla para voltar ao Menu...
pause >nul
goto update_menu_returned


REM changelog
:changelog
color %command_color% && cls
title Changelog - version: %VERSION%
echo.
echo  Changelog
echo    Version: 0.0.1
echo      - Author: @lucasbernardol
echo      - Release/date: 28/03/2022
echo.
echo    Version: 0.0.2
echo      - Author: @lucasbernardol
echo      - Message: Fix bugs
echo      - Release/date: 06/04/2022
echo.
echo Pressione qualquer tecla para voltar ao Menu...
pause >nul
goto update_menu_returned


:: Winner
:winner
color %command_color%
title Vencedor: %username%
if %ALLOW_LOGS% EQU 1 call :log_with_timestamp "LOG: Winner %username%!"
mode 64,28 && cls

set president_game_end_time=%time:~0,8%

echo.
echo [+]--------*****----------------*****--------[+]
echo.
echo    Vencedor: %username%
echo    Gostou? Compartilhe com os amigos!
echo.
echo    Erros: (%total_displayed_errors%)
echo.
echo [+]--------*****----------------*****--------[+]
echo. 
echo Info: Jogar novamente apaga as estatisticas.
echo.
echo   1) Voltar ao menu  2) Sair
echo.
set /p "winner_option=Digite>: "

if "%winner_option%" == "" (
  goto winner
)

if "%winner_option%" == "1" (
  goto winner_create_stats_file
) else (
  goto close_application
)


REM Application stats
:winner_create_stats_file
:: Crate winner details
echo Info: detalhes do jogo - (%username%)>%winner_details_file_path%
echo  Hora inicial: "%president_game_start_time%">>%winner_details_file_path%
echo  Hora final: "%president_game_end_time%">>%winner_details_file_path%
echo  Total de erros: "%total_displayed_errors%">>%winner_details_file_path%

if %ALLOW_LOGS% EQU 1 call :log_with_timestamp "LOG: Created details file."

:: As pricipais variáveis (ou variáveis de estado) serão resetadas, ou seja,
:: irão possuir, novamanete, o valor inicial.
set displayed_error_argument=0
set /a total_displayed_errors=0
set /a max_repeat_questions=2
set /a menu_returned=1
set president_game_start_time=%time:~0,8%

:winner_file_view
REM Open "winner.txt" file
start /wait notepad %winner_details_file_path%
if %ALLOW_LOGS% EQU 1 call :log_with_timestamp "LOG: Opened details file."

:winner_file_view_reload
color %command_prompt_alert_color% && cls
echo.
echo [+]--------*****----------------*****--------[+]
echo.
echo   Info: Deseja deletar o arquivo "winner.txt"
echo     que foi criado no Desktop?
echo.
echo [+]--------*****----------------*****--------[+]
echo.
set /p "delete_winner_file_option=Digite[y - YES | n - NO]> "

if "%delete_winner_file_option%" == "" (
  goto winner_file_view_reload
)

if /i "%delete_winner_file_option%" == "y" (
  REM Observações: o comando "ERASE" também é usado para remover ou excluir
  REM arquivos, porèm, optei por usado o "DEL", visto que a quantidade de carac-
  REM teres é menor, ou seja, "DEL" (termo) possui memos caracteres se comparado
  REM com "ERASE". É apenas um escolha pessoal.

  REM Example: erase /f /q %winner_details_file_path%

  del /f /q  %winner_details_file_path%
  
  if %ALLOW_LOGS% EQU 1 (
    call :log_with_timestamp "LOG: Remove '%winner_details_file_path%' file."
  )
) else if /i "%delete_winner_file_option%" NEQ "n" (
  goto winner_file_view_reload
) else (
  if %ALLOW_LOGS% EQU 1 (
    call :log_with_timestamp "LOG: File '%winner_details_file_path%' not removed."
  )
)

REM REST application/realod
goto start_application

REM EXIT:

:: Minhas observações finais: você é livre para modificar, distribuir, entre 
:: outros. Mas não esqueça de mencionar o autor original. Fique à vontade.
:close_application
if %ALLOW_LOGS% EQU 1 call :log_with_timestamp "LOG: Goodbye."
cls && exit /b

REM LOG:

:: A "label" ou seção abaixo, é uma espécie de função, responsável por criar
:: um histórico das principais instruções que foram executadas (Debug). 
:: Basicamente, os dados/informações são armazenadas no arquivo "president.log", 
:: localizado no diretório de "documentos" do computador.
:log
echo:%~1 >>%logs_directory%\%logs_filename_path%
goto :EOF

:log_with_timestamp
echo:%time:~0,8% %date% %~1 >>%logs_directory%\%logs_filename_path%
goto :EOF
