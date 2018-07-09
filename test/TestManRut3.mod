MODULE TestManRut3;
(******************************************************************************
Modulo de prueba unitaria del TAD ManejadorRutas.

Prueba las funcionalidades basicas del TAD. 
En la prueba se construye 'rutas' con las operaciones del TAD Rutas, 
dado que el objetivo de este caso de prueba es solamente probar DistanciaMinima 
sin introducir posibles errores derivados de la operación ConstruirRutas.
En la Tarea 'rutas' se debe construir a partir de la operación ConstruirRutas.

Laboratorio de Programacion 2.
InCo-FI-UDELAR
******************************************************************************)

FROM Rutas IMPORT Rutas, DestruirRutas, AgregarHijoRutas,
CrearHojaRutas, HijoRutas;
FROM STextIO IMPORT WriteString, WriteLn;
FROM ManejadorRutas IMPORT DistanciaMinima;

VAR
    rutas, hijo             : Rutas;

BEGIN

       (************ DistanciaMinima *************)

       rutas := CrearHojaRutas('MVD',0);

       IF DistanciaMinima('MVD',rutas) = 0 THEN
           WriteString('OK - La distancia minima es 0');
       ELSE
           WriteString('ERROR - La distancia minima No es 0');
       END;
       WriteLn;

       IF DistanciaMinima('ZAZ',rutas) = 1 THEN
           WriteString('OK - La distancia minima es 1');
       ELSE
           WriteString('ERROR - La distancia minima No es 1');
       END;
       WriteLn;

       AgregarHijoRutas(CrearHojaRutas('USA',20),rutas);

       IF DistanciaMinima('USA',rutas) = 1 THEN
           WriteString('OK - La distancia minima es 1');
       ELSE
           WriteString('ERROR - La distancia minima No es 1');
       END;
       WriteLn;

       AgregarHijoRutas(CrearHojaRutas('ZAZ',5),rutas);
       hijo := HijoRutas('ZAZ',rutas);
       AgregarHijoRutas(CrearHojaRutas('BCN',10),hijo);
 
       IF DistanciaMinima('BCN',rutas) = 2 THEN
           WriteString('OK - La distancia minima es 2');
       ELSE
           WriteString('ERROR - La distancia minima No es 2');
       END;
       WriteLn;

       AgregarHijoRutas(CrearHojaRutas('BCN',1),rutas);

       IF DistanciaMinima('BCN',rutas) = 1 THEN
           WriteString('OK - La distancia minima es 1');
       ELSE
           WriteString('ERROR - La distancia minima No es 1');
       END;
       WriteLn;


      IF DistanciaMinima('MAD',rutas) = 3 THEN
           WriteString('OK - La distancia minima es 3');
       ELSE
           WriteString('ERROR - La distancia minima No es 3');
       END;
       WriteLn;

       IF DistanciaMinima('ZAZ',rutas) = 1 THEN
           WriteString('OK - La distancia minima es 1');
       ELSE
           WriteString('ERROR - La distancia minima No es 1');
       END;
       WriteLn;

       hijo := HijoRutas('BCN',rutas);
       AgregarHijoRutas(CrearHojaRutas('IBZ',5),hijo);
       AgregarHijoRutas(CrearHojaRutas('ODB',10),hijo);

       hijo := HijoRutas('IBZ',hijo);
       AgregarHijoRutas(CrearHojaRutas('ODB',15),hijo);

       IF DistanciaMinima('ODB',rutas) = 2 THEN
           WriteString('OK - La distancia minima es 2');
       ELSE
           WriteString('ERROR - La distancia minima No es 2');
       END;
       WriteLn;
      
       AgregarHijoRutas(CrearHojaRutas('ODB',2),rutas);


       IF DistanciaMinima('ODB',rutas) = 1 THEN
           WriteString('OK - La distancia minima es 1');
       ELSE
           WriteString('ERROR - La distancia minima No es 1');
       END;
       WriteLn;
        
       DestruirRutas(rutas);

END TestManRut3.
