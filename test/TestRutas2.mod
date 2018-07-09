MODULE TestRutas2;
(******************************************************************************
Modulo de prueba unitaria del TAD Rutas.

Prueba el uso de memoria dinamica del TAD.

Laboratorio de Programacion 2.
InCo-FI-UDELAR
******************************************************************************)

FROM Rutas IMPORT Rutas, CrearHojaRutas, DestruirRutas, AgregarHijoRutas,
HijoRutas, EliminarHijoRutas;
FROM CDP IMPORT TIdCDP;
FROM STextIO IMPORT WriteString, WriteLn;
FROM Strings     IMPORT Concat;
FROM WholeStr    IMPORT CardToStr;


VAR
    r, cursor, hijo, aux  : Rutas;
    i, j                  : CARDINAL;
    id : TIdCDP;    
    sufijo: ARRAY [0..3] OF CHAR;

PROCEDURE CrearRutasTest(id: TIdCDP):Rutas;
VAR
  r : Rutas;
BEGIN
       r := CrearHojaRutas(id, 100); 
       AgregarHijoRutas(CrearHojaRutas("DEP001", 100), r);
       AgregarHijoRutas(CrearHojaRutas("DEP002", 100), r);
       AgregarHijoRutas(CrearHojaRutas("DEP003", 100), r);
       AgregarHijoRutas(CrearHojaRutas("DEP004", 100), r);
       RETURN r;
END CrearRutasTest;

BEGIN

        WriteString ("Prueba EliminarHijoRutas"); WriteLn;

        r := CrearHojaRutas("DEP000", 100);
        cursor := r;
        FOR i := 1 TO 100 DO  
            FOR j := 1 TO 500 DO
                 CardToStr (j, sufijo);
                  Concat ('DEP', sufijo, id);
               hijo := CrearRutasTest(id);
               AgregarHijoRutas(hijo,cursor);
            END;

 
            aux := HijoRutas("DEP250",cursor);
            FOR j := 1 TO 500 DO
               CardToStr (j, sufijo);
                  Concat ('DEP', sufijo, id);
               hijo := CrearRutasTest(id);
               AgregarHijoRutas(hijo,aux);
            END;
            
            FOR j := 1 TO 499 DO
               CardToStr (j, sufijo);
                  Concat ('DEP', sufijo, id);
               EliminarHijoRutas (id, cursor);
            END;

            cursor := HijoRutas("DEP500",cursor);
       END;

       DestruirRutas(r);

        WriteString ("Prueba DestruirRutas"); WriteLn;


       FOR i := 1 TO 100 DO  
            r := CrearHojaRutas("DEP000", 100);
            cursor := r;

            FOR j := 1 TO 500 DO
                 CardToStr (j, sufijo);
                  Concat ('DEP', sufijo, id);
               hijo := CrearRutasTest(id);
               AgregarHijoRutas(hijo,cursor);
            END;

 
            aux := HijoRutas("DEP250",cursor);
            FOR j := 1 TO 500 DO
               CardToStr (j, sufijo);
                  Concat ('DEP', sufijo, id);
               hijo := CrearRutasTest(id);
               AgregarHijoRutas(hijo,aux);
            END;

            DestruirRutas(r);     
       END;

       WriteString ("OK-Fin prueba"); WriteLn;    

END TestRutas2.
