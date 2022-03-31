@echo off

REM Arquivo de personalização/configurações

:: Para usar as configurações externas, altere o nome desse arquivo, em outras
:: palavras, "config.example.bat" para "config.bat", deixe no mesmo deiretório.

:: Habilitar o uso de cores personalizadas. Use a lógica booleana, ou seja,
:: 1 representa "true" e 0 representa "false", o valor padrão é 0 
set allow_custom_colors=1

REM Adicionado cores personalizadas

:: Você pode definer uma cor especifíca para cada questão/pergunta, e lembre-se, 
:: só funciona se a variável acima "allow_custom_colors" = 1 (boolean).

:: Remova o comentário das variáveis abaixo e adicione a sua cor favorita.
:: Minha recomendação é que você veja as opções de cores disponíveis, use: 
:: "color /?" no seu Command Prompt ou CMD.

rem set question_one_color=0a
rem set question_two_color=0f
rem set question_three_color=03
rem set question_four_color=05
rem set question_five_color=06
rem set question_six_color=0c

:: Atualmente essas são as opções de customização válidas
