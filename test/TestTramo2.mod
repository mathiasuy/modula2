MODULE TestTramo2;
(******************************************************************************
Módulo de prueba unitaria del TAD Tramo.

Prueba el uso de memoria dinámica del TAD.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM STextIO    IMPORT WriteLn, WriteString;                        
FROM Strings    IMPORT Concat;
FROM WholeStr   IMPORT CardToStr;


FROM Tramo IMPORT Tramo, CrearTramo, DestruirTramo;
FROM CDP IMPORT TIdCDP;

CONST
    MAX_ITERACIONES = 100000;
VAR
    t1: Tramo;
    i:CARDINAL;
    subFijo: ARRAY [0..4] OF CHAR;
    id1, id2:TIdCDP;
    
BEGIN
    FOR i := 1 TO MAX_ITERACIONES DO
        CardToStr(i,subFijo);
        Concat('Centro 1', subFijo, id1);
        Concat('Centro 2', subFijo, id2);
        t1 := CrearTramo (id1, id2, 100);
        DestruirTramo(t1)
    END;
	
    WriteString("OK-Fin de la prueba"); WriteLn()
END TestTramo2.