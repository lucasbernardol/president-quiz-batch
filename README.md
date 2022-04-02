<div align="center">
  <h2 align="center">
    <img src="./assets/logo.svg" alt="President Quiz" />
  </h2>

  <p align="center">
    President Quiz, é um jogo de perguntas e respostas relacionadas ao atual presidente (2022) do Brasil.<br/> Construído com Batch Script (atenção: é uma atividade lúdica do curso de informática). 🎓🇧🇷
  </p>
</div>

<div align="center">
  <img alt="GitHub top language" src="https://img.shields.io/github/languages/top/lucasbernardol/president-quiz-batch">

  <img alt="GitHub" src="https://img.shields.io/github/license/lucasbernardol/president-quiz-batch">

  <img alt="GitHub language count" src="https://img.shields.io/github/languages/count/lucasbernardol/president-quiz-batch">

  <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/lucasbernardol/president-quiz-batch">

  <img src="https://img.shields.io/badge/author-Jos%C3%A9%20Lucas-brightgreen" alt="Author" />
</div>

<p align="center">
  <small>
    Build with ❤️ by: <a href="https://github.com/lucasbernardol">José Lucas</a>
  </small>
</p>

## 💻 Binários e executáveis do Windows

1. O arquivo binário ou ".EXE", fornece a compatibilidade do código Batch
   (Batch Script) com diversos sistemas operacionais como, por exemplo, do Windows 98
   eté Windows 11. Abaixo você encontra o comando/instrução responsável por
   gerar o arquivo binário/executável do Windows. Uso do ⚙📂 "Bat to exe converter":

```batch
:: Observações. Não remova o "President.exe" do diretório raiz, pois é necessário
:: ter acesso ao diretório/pasta "resources" que contém algumas funções
:: adicionais. (/includes "resources")

.\converter.exe /bat President.bat /exe President.exe /icon assets/icon.ico /inclu
de resources /productversion 0.0.1 /productname "President QUIZ" /fileversion 0.
0.0.1 /internalname "President QUIZ - Brazil" /copyright "Copyright © 2022" /des
cription "President QUIZ: Game construído no Batch Script."
```

## :wrench: Como executar no ambiente local?

### Guia de instalação

1. Faça um clone do repositório através do git. Use o comando abaixo:

   1.2. Se você não instalou o Git (sistema de versionamento de código), existem
   outras formas e opções para realizar o **download** do projeto (código principal).
   Na interface gráfica ou no próprio sistema de arquivos do Github, abra o arquivo
   `President.bat`, em seguida, selecione a opção _raw_ no menu superior, você
   será redirecionado para um página externa que contém todo o código fonte. Basta
   copiar, criar um arquivo com a extensão `.bat` em qualquer diretório, e executar.
   Fique à vontade para usar outros métodos. (Minha recomendação pessoal).

```bash
$ git clone https://github.com/lucasbernardol/president-quiz-batch.git

$ cd president-quiz-batch/
```

2. Para executar o código ou um arquivo `.bat`, é necessário abrir uma instância
   do seu Command Prompt ou CMD no mesmo diretório onde o arquivo `President.bat`
   está localizado e, em outras situações, você pode executar manualmente, ou seja,
   atráves da interface gráfica (GUI) do próprio Windows.

```batch
:: Nevegue até o diretório root (principal)
cd president-quiz-batch/

REM .\Presitent.bat
REM Presitent.bat

:: Uma nova janela (instância) do Command Prompt será aberta. A minha
:: recomendação é o uso de alguma das instruções acima (que estão comentadas).
start Presitent.bat
```

Após realizar os procedimentos acima, acredito que esse mimi tutorial te ajudou,
parabéns. Gostou do projeto? Faça a sua contribuição com (pull requests) ou me
dê uma estrelinha. 👋 Até mais!

## :boy: Autor

<table class="author">
  <tr>
    <td align="center">
      <a href="https://github.com/lucasbernardol">
        <img src="https://avatars.githubusercontent.com/u/82418341?v=4" 
        width="100px;" alt="José Lucas"/>
        <br/>
        <sub>
          <b>José Lucas</b>
        </sub>
      </a>
    </td>
  </tr>
</table>

## 📝 Licença

O projeto o possui a licença _MIT_, veja o arquivo [LICENÇA](LICENSE) para mais informações.
