@echo off
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
set test=Caso01
set archivo=Tarea3
@echo off
(
echo !module C:\pub\Tarea3\SRC\InCorreo.mod
echo !module C:\pub\Tarea3\Prog2IO.lib
) > "Tarea3.prj"
xc =p %archivo%.prj
if exist "%archivo%.exe" %archivo%.exe < src\test\resultados\%test%.in > src\test\resultados\%test%.sal

taskkill /F /im diffuse.exe

if exist "SRC\test\resultados\%test%.sal" diffuse SRC\test\resultados\%test%.out SRC\test\resultados\%test%.sal
if exist "%test%.pout" diffuse %test%.pout %test%.psal
if exist "%test%a.pout" diffuse %test%a.pout %test%a.psal
if exist "%test%b.pout" diffuse %test%b.pout %test%b.psal
if exist "%test%c.pout" diffuse %test%c.pout %test%c.psal
if exist "%test%d.pout" diffuse %test%d.pout %test%d.psal
del %archivo%.exe
del *.psal
