MODULE TestCDP2;
(******************************************************************************
Módulo de prueba unitaria del TAD CDP.

Prueba el uso de memoria dinámica del TAD.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM STextIO   IMPORT WriteLn, WriteString;                        
FROM Strings   IMPORT Concat;
FROM WholeStr  IMPORT CardToStr;
FROM CDP IMPORT TIdCDP, CDP, CrearCDP, DestruirCDP;

CONST
    MAX_ITERACIONES = 100000;
VAR
    c1: CDP;
    i:CARDINAL;
    subFijo: ARRAY [0..4] OF CHAR;
    id:TIdCDP;
    
BEGIN
    FOR i := 1 TO MAX_ITERACIONES DO
        CardToStr(i,subFijo);
        Concat('Centro', subFijo, id);
        c1 := CrearCDP (id, 100, "Uruguay", "Montevideo");
        DestruirCDP(c1)
    END;
	
    WriteString("OK-Fin de la prueba");WriteLn()
END TestCDP2.