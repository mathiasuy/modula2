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
set archivo=VariosTramosL1
set modulo=TestPersistencia
del testPersistencia\*.psal
del OBJ\*.*
del SYM\*.*
xc =make src\test\%modulo%.mod
%modulo%.exe 
taskkill /F /im diffuse.exe

diffuse testPersistencia\%archivo%.pout testPersistencia\%archivo%.psal
del %modulo%.exe
