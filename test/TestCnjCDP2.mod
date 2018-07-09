MODULE TestCnjCDP2;
(******************************************************************************
Módulo de prueba unitaria del TAD CnjCDPs.

Prueba el uso de memoria dinámica del TAD.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM CDP      IMPORT CDP, CrearCDP, TIdCDP;
FROM CnjCDPs  IMPORT CnjCDPs, CrearCnjCDPs, InsertarCnjCDPs, EliminarCnjCDPs,
                      DestruirCnjCDPs;
FROM STextIO  IMPORT WriteString, WriteLn;
FROM Strings  IMPORT Assign, Concat;
FROM WholeStr IMPORT CardToStr;



PROCEDURE WriteStrLn(msg : ARRAY OF CHAR);
BEGIN
    WriteString(msg);
    WriteLn;
END WriteStrLn;



CONST 
    MAX_EXT = 500;
    MAX_INT = 500;

VAR
	cdp   : CDP;
    cnj   : CnjCDPs;
    i,j   : CARDINAL;
    idCdp : TIdCDP;
    str   : ARRAY [1..20] OF CHAR;
BEGIN
    cnj := CrearCnjCDPs();
	
    FOR i := 1 TO MAX_EXT DO
        FOR j := 1 TO MAX_INT DO
            CardToStr(j, str);
            Assign('cdp_', idCdp);
            Concat(idCdp, str, idCdp);
            cdp := CrearCDP(idCdp, j, 'Pais', 'Cuidad');
            InsertarCnjCDPs(cdp, cnj)
        END;
        
        FOR j := MAX_INT DIV 2 TO MAX_INT DO
            CardToStr(j, str);
            Assign('cdp_', idCdp);
            Concat(idCdp, str, idCdp);
            EliminarCnjCDPs(idCdp, cnj)
        END;
        
        FOR j := MAX_INT DIV 2 -1 TO 1 BY -1 DO
            CardToStr(j, str);
            Assign('cdp_', idCdp);
            Concat(idCdp, str, idCdp);
            EliminarCnjCDPs(idCdp, cnj)
        END
    END;
	
    DestruirCnjCDPs(cnj);
    
    FOR i := 1 TO MAX_EXT DO
        cnj := CrearCnjCDPs();
		
        FOR j := 1 TO MAX_INT DO
            CardToStr(j, str);
            Assign('cdp_', idCdp);
            Concat(idCdp, str, idCdp);
            cdp := CrearCDP(idCdp, j, 'Pais', 'Cuidad');
            InsertarCnjCDPs(cdp, cnj)
        END;
		
        DestruirCnjCDPs(cnj)
    END;
    
    WriteStrLn('FIN!')
END TestCnjCDP2.
