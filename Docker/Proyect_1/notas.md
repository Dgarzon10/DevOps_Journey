# Aprenndizaje

## Problema nodemon

Problema con nodemon en el entorno de desarrollo, este no escuchaba los cambios y reinicaba el servidor.
Esto sucedia ya que "volumes" en windows NO comparte los eventos a la MV de linux, es decir, el contenedor No recibia las notificaciones de
que se modifico el codigo, por ende, nodemon no se reiniciaba y actualizaba.

**SOLUCION**

"nodemon --legacy-watch index.js" //Solucion al error de nodemon

Bibliografia
https://stackoverflow.com/questions/39239686/nodemon-doesnt-restart-in-windows-docker-environment