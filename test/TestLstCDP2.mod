MODULE TestLstCDP2;
(******************************************************************************
Módulo de prueba unitaria del TAD LstIdsCDP.

Prueba el uso de memoria dinámica del TAD.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM CDP IMPORT TIdCDP;
FROM LstIdsCDP IMPORT LstIdsCDP, CrearLstIdsCDP, InsertarTIdCDP, 
                        EliminarLstIdsCDP, DestruirLstIdsCDP;
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
	lst   : LstIdsCDP;
    i,j   : CARDINAL;
    idCdp : TIdCDP;
    str   : ARRAY [1..20] OF CHAR;
BEGIN
    lst := CrearLstIdsCDP();
	
    FOR i := 1 TO MAX_EXT DO
        FOR j := 1 TO MAX_INT DO
            CardToStr(j, str);
            Assign('cdp_', idCdp);
            Concat(idCdp, str, idCdp);
            InsertarTIdCDP(idCdp, lst)
        END;
        
        FOR j := MAX_INT DIV 2 TO MAX_INT DO
            CardToStr(j, str);
            Assign('cdp_', idCdp);
            Concat(idCdp, str, idCdp);
            EliminarLstIdsCDP(idCdp, lst)
        END;
        
        FOR j := MAX_INT DIV 2 -1 TO 1 BY -1 DO
            CardToStr(j, str);
            Assign('cdp_', idCdp);
            Concat(idCdp, str, idCdp);
            EliminarLstIdsCDP(idCdp, lst)
        END
    END;
	
    DestruirLstIdsCDP(lst);
    
    FOR i := 1 TO MAX_EXT DO
        lst := CrearLstIdsCDP();
		
        FOR j := 1 TO MAX_INT DO
            CardToStr(j, str);
            Assign('cdp_', idCdp);
            Concat(idCdp, str, idCdp);
            InsertarTIdCDP(idCdp, lst)
        END;
		
        DestruirLstIdsCDP(lst)
    END;
    
    WriteStrLn('FIN!')
END TestLstCDP2.
