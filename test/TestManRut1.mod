MODULE TestManRut1;
(******************************************************************************
Modulo de prueba unitaria del TAD ManejadorRutas.

Prueba las funcionalidades basicas del TAD.

Laboratorio de Programacion 2.
InCo-FI-UDELAR
******************************************************************************)

FROM Rutas IMPORT Rutas, EsVaciaRutas, DestruirRutas, ImprimirRutas, CostoRutas,
HijoRutas;
FROM STextIO IMPORT WriteString, WriteLn;
FROM TramosHabilitados IMPORT TramosHabilitados, CrearTramosHabilitados, 
DestruirTramosHabilitados, InsertarTramo;
FROM ManejadorRutas IMPORT ConstruirRutas;
FROM Tramo IMPORT CrearTramo;

VAR
    rutas, hijo         : Rutas;
    th                  : TramosHabilitados;

BEGIN

       (************ ConstruirRutas *************)

       (* TramosHabiltados vacio *)

       th := CrearTramosHabilitados ();
       rutas := ConstruirRutas('MVD', 'USA', 10, th);
       
       IF EsVaciaRutas(rutas) THEN
          WriteString('OK - Rutas es vacia');
       ELSE
          WriteString('ERROR - Rutas No es vacia');
       END; 
       WriteLn;

       DestruirRutas(rutas);

       (* TramosHabilitados No Vacio *)

       InsertarTramo(CrearTramo('MVD', 'USA', 100), th);

       (* espero vacio*)
       rutas := ConstruirRutas('MVD', 'USA', 0, th);

       IF EsVaciaRutas(rutas) THEN
          WriteString('OK - Rutas es vacia');
       ELSE
          WriteString('ERROR - Rutas No es vacia');
       END; 
       WriteLn;

       DestruirRutas(rutas);
       
       (* espero: MVD-USA *)
       rutas := ConstruirRutas('MVD', 'USA', 1, th);

       WriteString('1: Rutas es '); WriteLn;
       ImprimirRutas(rutas);
       WriteLn;

       IF CostoRutas(rutas) = 0 THEN
           WriteString('1: OK - El costo de la raiz es 0');
       ELSE
          WriteString('1: ERROR - El costo de la raiz No es 0');
       END; 
       WriteLn;

       hijo := HijoRutas('USA',rutas);
       IF CostoRutas(hijo) = 100 THEN 
           WriteString('1: OK - El costo de MVD-USA es 100');
       ELSE
          WriteString('1: ERROR - El costo de MVD-USA No es 100');
       END; 
       WriteLn;

       DestruirRutas(rutas);
       
       InsertarTramo(CrearTramo('MVD', 'BCN', 50), th);
       InsertarTramo(CrearTramo('BCN', 'USA', 40), th);

       (* espero: MVD-USA *)
       rutas := ConstruirRutas('MVD', 'USA', 1, th);

       WriteString('2: Rutas es '); WriteLn;
       ImprimirRutas(rutas);
       WriteLn;

       DestruirRutas(rutas);

       (* espero: MVD-USA, MVD-BCN-USA *)
       rutas := ConstruirRutas('MVD', 'USA', 2, th);

       WriteString('3: Rutas es '); WriteLn;
       ImprimirRutas(rutas);
       WriteLn;

       IF CostoRutas(rutas) = 0 THEN 
           WriteString('3: OK - El costo de la raiz es 0');
       ELSE
          WriteString('3: ERROR - El costo de la raiz No es 0');
       END; 
       WriteLn;

       hijo := HijoRutas('USA',rutas);
       IF CostoRutas(hijo) = 100 THEN 
           WriteString('3: OK - El costo de MVD-USA es 100');
       ELSE
          WriteString('3: ERROR - El costo de MVD-USA raiz No es 100');
       END; 
       WriteLn;

       hijo := HijoRutas('BCN',rutas);
       IF CostoRutas(hijo) = 50 THEN 
           WriteString('3: OK - El costo de MVD-BCN es 50');
       ELSE
          WriteString('3: ERROR - El costo de MVD-BCN No es 50');
       END; 
       WriteLn;

       hijo := HijoRutas('USA',hijo);
       IF CostoRutas(hijo) = 90 THEN 
           WriteString('3: OK - El costo de MVD-BCN-USA es 90');
       ELSE
          WriteString('3: ERROR - El costo de MVD-BCN-USA No es 90');
       END; 
       WriteLn;

       DestruirRutas(rutas);


       InsertarTramo(CrearTramo('BCN', 'ZAZ', 30), th);
       InsertarTramo(CrearTramo('ZAZ', 'USA', 40), th);
       InsertarTramo(CrearTramo('MVD', 'ZAZ', 45), th);
       
       (* espero: MVD-USA *)
       rutas := ConstruirRutas('MVD', 'USA', 1, th);

       WriteString('4: Rutas es '); WriteLn;
       ImprimirRutas(rutas);
       WriteLn;

       DestruirRutas(rutas);

       (* espero: MVD-USA, 
                  MVD-BCN-USA, MVD-ZAZ-USA 
       *)
       rutas := ConstruirRutas('MVD', 'USA', 2, th);

       WriteString('5: Rutas es '); WriteLn;
       ImprimirRutas(rutas);
       WriteLn;

       DestruirRutas(rutas);

      (* espero: MVD-USA, 
                 MVD-BCN-USA, MVD-ZAZ-USA, 
                 MVD-BCN-ZAZ-USA 
      *)
       rutas := ConstruirRutas('MVD', 'USA', 3, th);

       WriteString('6: Rutas es '); WriteLn;
       ImprimirRutas(rutas);
       WriteLn;

       hijo := HijoRutas('BCN',rutas);
       IF CostoRutas(hijo) = 50 THEN 
           WriteString('6: OK - El costo de MVD-BCN es 50');
       ELSE
          WriteString('6: ERROR - El costo de MVD-BCN No es 50');
       END; 
       WriteLn;
        
       hijo := HijoRutas('USA',hijo);
       IF CostoRutas(hijo) = 90 THEN 
           WriteString('6: OK - El costo de MVD-BCN-USA es 90');
       ELSE
          WriteString('6: ERROR - El costo de MVD-BCN-USA No es 90');
       END; 
       WriteLn;

       hijo := HijoRutas('USA',rutas);
       IF CostoRutas(hijo) = 100 THEN 
           WriteString('6: OK - El costo de MVD-USA es 100');
       ELSE
          WriteString('6: ERROR - El costo de MVD-USA No es 100');
       END; 
       WriteLn;

       hijo := HijoRutas('ZAZ',rutas);
       IF CostoRutas(hijo) = 45 THEN 
           WriteString('6: OK - El costo de MVD-ZAZ es 45');
       ELSE
          WriteString('6: ERROR - El costo de MVD-ZAZ No es 45');
       END; 
       WriteLn;

       hijo := HijoRutas('USA',hijo);
       IF CostoRutas(hijo) = 85 THEN 
           WriteString('6: OK - El costo de MVD-ZAZ-USA es 85');
       ELSE
          WriteString('6: ERROR - El costo de MVD-ZAZ-USA No es 85');
       END; 
       WriteLn;

       hijo := HijoRutas('BCN',rutas);
       hijo := HijoRutas('ZAZ',hijo);
       IF CostoRutas(hijo) = 80 THEN 
           WriteString('6: OK - El costo de MVD-BCN-ZAZ es 80');
       ELSE
          WriteString('6: ERROR - El costo de MVD-BCN-ZAZ No es 80');
       END; 
       WriteLn;

       hijo := HijoRutas('USA',hijo);
       IF CostoRutas(hijo) = 120 THEN 
           WriteString('6: OK - El costo de MVD-BCN-ZAZ-USA es 120');
       ELSE
          WriteString('6: ERROR - El costo de MVD-BCN-ZAZ-USA No es 120');
       END; 
       WriteLn;

       DestruirRutas(rutas);

       (* Agrego Ciclo *)
       InsertarTramo(CrearTramo('BCN', 'MVD', 65), th);

      (* espero: MVD-USA, 
                 MVD-BCN-USA, MVD-ZAZ-USA, 
                 MVD-BCN-ZAZ-USA, MVD-BCN-MVD-USA 
      *)
       rutas := ConstruirRutas('MVD', 'USA', 3, th);

       WriteString('7: Rutas es '); WriteLn;
       ImprimirRutas(rutas);
       WriteLn;

       IF CostoRutas(rutas) = 0 THEN 
           WriteString('7: OK - El costo de la raiz 0');
       ELSE
          WriteString('7: ERROR - El costo de la raiz No es 0');
       END; 
       WriteLn;

       hijo := HijoRutas('BCN',rutas);
       hijo := HijoRutas('MVD',hijo);
       IF CostoRutas(hijo) = 115 THEN 
           WriteString('7: OK - El costo de MVD-BCN-MVD es 115');
       ELSE
          WriteString('7: ERROR - El costo de MVD-BCN-MVD No es 115');
       END; 
       WriteLn;


       hijo := HijoRutas('USA',hijo);
       IF CostoRutas(hijo) = 215 THEN 
           WriteString('7: OK - El costo de MVD-BCN-MVD-USA es 215');
       ELSE
          WriteString('7: ERROR - El costo de MVD-BCN-MVD-USA No es 215');
       END; 
       WriteLn;

       DestruirRutas(rutas);

       (* espero: MVD-USA, 
                  MVD-BCN-USA, MVD-ZAZ-USA, 
                  MVD-BCN-ZAZ-USA, MVD-BCN-MVD-USA, 
                  MVD-BCN-MVD-ZAZ-USA, MVD-BCN-MVD-BCN-USA 
       *)
       rutas := ConstruirRutas('MVD', 'USA', 4, th);

       WriteString('8: Rutas es '); WriteLn;
       ImprimirRutas(rutas);
       WriteLn;

       DestruirRutas(rutas);


      (* Agrego Segundo Ciclo *)
       InsertarTramo(CrearTramo('LEN', 'MVD', 15), th);
       InsertarTramo(CrearTramo('LEN', 'ZAZ', 35), th);
       InsertarTramo(CrearTramo('ZAZ', 'BCN', 60), th);

      (* espero: LEN-ZAZ-USA, LEN-MVD-USA*)
       rutas := ConstruirRutas('LEN', 'USA',2, th);

       WriteString('9: Rutas es '); WriteLn;
       ImprimirRutas(rutas);
       WriteLn;

       DestruirRutas(rutas);


       (* espero: LEN-ZAZ-USA, LEN-MVD-USA,
                  LEN-MVD-BCN-USA, LEN-ZAZ-BCN-USA,LEN-MVD-ZAZ-USA  
       *)
       rutas := ConstruirRutas('LEN', 'USA',3, th);

       WriteString('10: Rutas es '); WriteLn;
       ImprimirRutas(rutas);
       WriteLn;

      (* espero: LEN-ZAZ-USA, LEN-MVD-USA,
                 LEN-MVD-BCN-USA, LEN-ZAZ-BCN-USA, LEN-MVD-ZAZ-USA
                 LEN-MVD-BCN-MVD-USA, LEN-MVD-BCN-ZAZ-USA, LEN-MVD-ZAZ-BCN-USA 
                    LEN-ZAZ-BCN-MVD-USA, LEN-ZAZ-BCN-ZAZ-USA
       *)
       rutas := ConstruirRutas('LEN', 'USA',4, th);

       WriteString('11: Rutas es '); WriteLn;
       ImprimirRutas(rutas);
       WriteLn;

       DestruirRutas(rutas);

      (* espero: LEN-ZAZ-USA, LEN-MVD-USA,
                 LEN-MVD-BCN-USA, LEN-ZAZ-BCN-USA, LEN-MVD-ZAZ-USA
                 LEN-MVD-BCN-MVD-USA, LEN-MVD-BCN-ZAZ-USA, LEN-MVD-ZAZ-BCN-USA 
                    LEN-ZAZ-BCN-MVD-USA, LEN-ZAZ-BCN-ZAZ-USA,
                 LEN-MVD-BCN-MVD-BCN-USA, LEN-MVD-BCN-MVD-ZAZ-USA, LEN-MVD-BCN-MVD-ZAZ-USA
                   LEN-MVD-ZAZ-BCN-ZAZ-USA, LEN-MVD-ZAZ-BCN-MVD-USA
                   LEN-ZAZ-BCN-ZAZ-USA, LEN-ZAZ-BCN-MVD-BCN-USA, LEN-ZAZ-BCN-MVD-ZAZ-USA
       *)  

       rutas := ConstruirRutas('LEN', 'USA',5, th);

       WriteString('12: Rutas es '); WriteLn;
       ImprimirRutas(rutas);
       WriteLn;

       hijo := HijoRutas('MVD',rutas);
       IF CostoRutas(hijo) = 15 THEN 
           WriteString('12: OK - El costo de LEN-MVD es 15');
       ELSE
          WriteString('12: ERROR - El costo de LEN-MVD No es 15');
       END; 
       WriteLn;

       hijo := HijoRutas('BCN',hijo);
       IF CostoRutas(hijo) = 65 THEN 
           WriteString('12: OK - El costo de LEN-MVD-BCN es 65');
       ELSE
          WriteString('12: ERROR - El costo de LEN-MVD-BCN No es 65');
       END; 
       WriteLn;

       hijo := HijoRutas('MVD',hijo);
       IF CostoRutas(hijo) = 130 THEN 
           WriteString('12: OK - El costo de LEN-MVD-BCN-MVD es 130');
       ELSE
          WriteString('12: ERROR - El costo de LEN-MVD-BCN-MVD No es 130');
       END; 
       WriteLn;

       hijo := HijoRutas('USA',hijo);
       IF CostoRutas(hijo) = 230 THEN 
           WriteString('12: OK - El costo de LEN-MVD-BCN-MVD-USA es 230');
       ELSE
          WriteString('12: ERROR - El costo de LEN-MVD-BCN-MVD-USA No es 230');
       END; 
       WriteLn; 

       DestruirRutas(rutas);

       DestruirTramosHabilitados(th);       
END TestManRut1.
