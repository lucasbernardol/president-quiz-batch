@echo off

REM Arquivo de personaliza��o/configura��es

:: Para usar as configura��es externas, altere o nome desse arquivo, em outras
:: palavras, "config.example.bat" para "config.bat", deixe no mesmo deiret�rio.

:: Habilitar o uso de cores personalizadas. Use a l�gica booleana, ou seja,
:: 1 representa "true" e 0 representa "false", o valor padr�o � 0 
set allow_custom_colors=1

REM Adicionado cores personalizadas

:: Voc� pode definer uma cor especif�ca para cada quest�o/pergunta, e lembre-se, 
:: s� funciona se a vari�vel acima "allow_custom_colors" = 1 (boolean).

:: Remova o coment�rio das vari�veis abaixo e adicione a sua cor favorita.
:: Minha recomenda��o � que voc� veja as op��es de cores dispon�veis, use: 
:: "color /?" no seu Command Prompt ou CMD.

rem set question_one_color=0a
rem set question_two_color=0f
rem set question_three_color=03
rem set question_four_color=05
rem set question_five_color=06
rem set question_six_color=0c

:: Atualmente essas s�o as op��es de customiza��o v�lidas
