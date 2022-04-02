## Binário

1. O arquivo binário ou ".EXE", fornece a compatibilidade do código Batch
   (Batch Script) com diversos sistemas operacionais como, por exemplo, do Windows 98
   eté Windows 11. Abaixo você encontra o comando/instrução responsável por
   gerar o arquivo binário/executável do Windows. Uso do "Bat to exe converter":

```batch
:: Observações. Não remova o "President.exe" do diretório raiz, pois é necessário
:: ter acesso ao diretório/pasta "resources" que contém algumas funções
:: adicionais. (/includes "resources")

.\converter.exe /bat President.bat /exe President.exe /icon assets/icon.ico /inclu
de resources /productversion 0.0.1 /productname "President QUIZ" /fileversion 0.
0.0.1 /internalname "President QUIZ - Brazil" /copyright "Copyright © 2022" /des
cription "President QUIZ: Game construído no Batch Script."
```
