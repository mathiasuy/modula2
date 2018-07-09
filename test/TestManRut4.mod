MODULE TestManRut4;
(******************************************************************************
Modulo de prueba unitaria del TAD ManejadorRutas.

Prueba el uso de memoria del TAD.

Laboratorio de Programacion 2.
InCo-FI-UDELAR
******************************************************************************)

FROM Rutas IMPORT Rutas, DestruirRutas;
FROM STextIO IMPORT WriteString, WriteLn;
FROM TramosHabilitados IMPORT TramosHabilitados, CrearTramosHabilitados, 
DestruirTramosHabilitados, InsertarTramo;
FROM ManejadorRutas IMPORT ConstruirRutas, RutaOptima;
FROM Tramo IMPORT CrearTramo;
FROM Strings     IMPORT Concat;
FROM WholeStr    IMPORT CardToStr;
FROM CDP  IMPORT TIdCDP, CrearCDP;
FROM CnjCDPs IMPORT CnjCDPs, InsertarCnjCDPs, CrearCnjCDPs, DestruirCnjCDPs;
FROM Ruta IMPORT Ruta, DestruirRuta;

VAR
    rutas               : Rutas;
    th                  : TramosHabilitados;
    i                   : CARDINAL;
    cnj                 : CnjCDPs;
    ruta                : Ruta;

PROCEDURE CrearTHTest(VAR th:TramosHabilitados; VAR  cnj: CnjCDPs); 
VAR
   i        : CARDINAL;
   sufijo   : ARRAY [0..3] OF CHAR;
   ori, des : TIdCDP;
BEGIN

   Concat ('DEP','000', ori);
   InsertarCnjCDPs(CrearCDP(ori,1,'Pais','Ciudad'),cnj);
   FOR i := 1 TO 50 DO
      CardToStr (i, sufijo);
      Concat ('DEP', sufijo, des);
      InsertarCnjCDPs(CrearCDP(des,1,'Pais','Ciudad'),cnj);
      InsertarTramo(CrearTramo(ori,des, 100), th);
      ori := des;  
   END;
   
   InsertarTramo(CrearTramo('DEP20','DEP19', 100), th);

END CrearTHTest;

BEGIN

       WriteString ("Prueba ConstruirRutas"); WriteLn;

       th  := CrearTramosHabilitados ();
       cnj := CrearCnjCDPs();
       CrearTHTest(th,cnj);

       FOR i := 1 TO 1000 DO  
          rutas := ConstruirRutas('DEP000','DEP50',100,th);
          DestruirRutas(rutas);
       END;


       WriteString ("Prueba RutaOptima"); WriteLn;
       
       rutas := ConstruirRutas('DEP000','DEP50',100,th);

       FOR i := 1 TO 1000 DO  
          ruta := RutaOptima(rutas, cnj);
          DestruirRuta(ruta);
       END;

       DestruirTramosHabilitados(th);
       DestruirCnjCDPs(cnj);
       DestruirRutas(rutas);

       WriteString ("OK-Fin prueba"); WriteLn;    

END TestManRut4.
