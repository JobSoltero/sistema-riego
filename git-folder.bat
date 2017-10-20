@echo off
cls
goto %1
goto Fin
:Paso1
 rem %2 = "Job Soltero" \
 if [%2]==[] goto Paso1Error1
 echo npm config set init.author.name %2
 npm config set init.author.name %2
 goto fin
 :Paso1Error1
   echo ---Error: Falto que indicara el nombre del autor para npm
   goto fin
:Paso2
  echo Crea el folder y registro de paquetes de nodejs
  if [%2]==[] goto Paso2Error1
  @echo on
  mkdir %2
  cd %2
  npm init
  @echo off
  goto Fin
 :Paso2Error1
   echo ---Error: Falto que indicara el nombre del folder 
   goto fin
:Paso3 
  echo Indique el usuario y email registrado en github
  rem %2 = "Romelhr9@yahoo.com", %3 = "Romelhr9"
  if [%2]==[] goto Paso3Error1
  if [%3]==[] goto Paso3Error1
  @echo on
  git config  --global user.email %2
  git config --global user.name %3
  @echo off
  goto fin
 :Paso3Error1
   echo ---Error: Falto que indicara el nombre del email o del usuario 
   goto fin
   
:Paso4
  echo Crea los archivos de texto para el folder de github
  rem %2 = hsl-to-rgb
  if [%2]==[] goto Paso4Error1
  if NOT [%3]==[] goto Paso4Error1
  @echo on
  echo "# %2" >> README.md
  echo -e "node_modules\n*.log" > .gitignore
  git init
  git add .
  rem git add README.md
  @echo off
  goto fin
 :Paso4Error1
   echo ---Error: Falto que indicara el comentario a poner en README.md  o indico un parametro 3
   goto fin

:Paso5
  echo Actualiza el repositorio localmente y fija comentario de la razon
  rem %2 = "1st commit" 
  if [%2]==[] goto Paso5Error1
  if NOT [%3]==[] goto Paso5Error1
  @echo on
  git add .
  git commit -m %2
  @echo off
  goto fin
 :Paso5Error1
   echo ---Error: Falto que indicara la nota que describe este commit o puso un parametro de mas 
   goto fin

:Paso6
  echo Listar la bitacora de los commit que ha hecho
  if NOT [%2]==[] goto Paso6Error1
  if NOT [%3]==[] goto Paso6Error1
  git log
  @echo off
  goto fin
 :Paso6Error1
   echo ---Error: No se requieren parametros
   goto fin

:Paso7 
  echo Traer solo los archivos del commit id indicado (solo de los primeros 5 caracteres)
  echo si recupera estos archivos y no recuerda despues el id mas nuevo
  echo entonces use got checkout master
  git log
  pause
  if [%2]==[] goto Paso7Error1
  if NOT [%3]==[] goto Paso7Error1
  git checkout %2
  @echo off
  goto fin
 :Paso7Error1
   echo --- Falto que indicara el id del commit, entonces
   echo --- Regresando a lo ultima version
   git checkout master
   goto fin
   
:Paso8
  echo Indicar el folder remoto en github 
  rem %2 = Romelhr9, %3  = hsl-to-rgb
  echo ---------------------------------------------------------------
  echo Vaya a github.com y asegurese de tener un usuario o creelo
  echo En github cree el repositorio
  echo Instale en la pc a Github desktop
  echo ---------------------------------------------------------------
  pause
  if [%2]==[] goto Paso8Error1
  if [%3]==[] goto Paso8Error1
  @echo on
  git remote add origin https://github.com/%2/%3.git
  @echo off
  goto paso8_2
 :Paso8Error1
   echo ---Error: Falto que indicara el nombre del usuario de github o el del folder de github
   goto fin
    

:Paso8_2
  echo Paso siguiente: Sincroniza los folders local y remoto
  @echo on
  git push -u origin master
  npm init
  @echo off
  goto fin

:Paso9
  echo Aumentar el numero de patch de la version
  npm version patch
  goto fin  

:Paso10a
  echo Aumentar el numero de subversion
  npm version minor
  goto fin   
:Paso10b
  echo Aumentar el numero de version
  npm version major
  goto fin     
:Paso10c
  echo visualizar el numero de version
  npm version
  goto fin

:Paso11
  echo para indicar una dependencia de otro repositorio
  echo buscar en http://npmjs.com el proyecto hsl to rgb  
  echo si lo hay en hsl-to-rgb-for-reals entonces aplicar un npm install --save 
  rem %2 = hsl-to-rgb-for-reals
  if [%2]==[] goto Paso11Error1
  if NOT [%3]==[] goto Paso11Error1
  npm install --save %2
  more package.json
  @echo off
  goto fin
 :Paso11Error1
   echo ---Error: Falto que indicara el reposiorio de donde copiara archivos hacia este o tiene un parametro 3 de mas
   goto fin

:fin
  echo listo
  
  