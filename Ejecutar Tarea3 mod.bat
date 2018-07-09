@echo on
cd ..
cd ..
cd ..
cd ..
cd ..
cd ..
cd ..
c:
cd pub
cd Tarea3
del SRC\test\resultados\*.sal
del OBJ\*.*
del SYM\*.*
set archivo=TestTramo2
del Tarea3.prj
@echo off
(
echo !module C:\pub\Tarea3\SRC\test\%archivo%.mod
echo !module C:\pub\Tarea3\Prog2IO.lib
) > "Tarea3.prj"
xc =p Tarea3.prj
if exist "Tarea3.exe" Tarea3.exe > SRC\test\resultados\%archivo%.sal
if exist "Tarea3.exe" del Tarea3.exe
taskkill /F /im diffuse.exe
cd SRC\test\resultados
if exist "%archivo%.sal" diffuse %archivo%.out %archivo%.sal