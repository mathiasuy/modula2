MODULE TestTraHab2;
(******************************************************************************
Módulo de prueba unitaria del TAD TramosHabilitados.

Prueba el uso de memoria dinámica del TAD.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM CDP               IMPORT TIdCDP;
FROM Tramo             IMPORT Tramo, CrearTramo;
FROM TramosHabilitados IMPORT TramosHabilitados, CrearTramosHabilitados, 
                                InsertarTramo, EliminarTramo, 
                                DestruirTramosHabilitados;
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
	orig, dest : TIdCDP;
    str        : ARRAY [1..20] OF CHAR;
    tramosHab  : TramosHabilitados;
    tramo      : Tramo;
    i,j        : CARDINAL;
BEGIN
    tramosHab := CrearTramosHabilitados();
	
    FOR i := 1 TO MAX_EXT DO
        FOR j := 1 TO MAX_INT DO
            CardToStr(j, str);
            Assign('orig_', orig);
            Assign('dest_', dest);
            Concat(orig, str, orig);
            Concat(dest, str, dest);
            tramo := CrearTramo(orig, dest, j);
            InsertarTramo(tramo, tramosHab)
        END;
        
        FOR j := MAX_INT DIV 2 TO MAX_INT DO
            CardToStr(j, str);
            Assign('orig_', orig);
            Assign('dest_', dest);
            Concat(orig, str, orig);
            Concat(dest, str, dest);
            EliminarTramo(orig, dest, tramosHab)
        END;
        
        FOR j := MAX_INT DIV 2 -1 TO 1 BY -1 DO
            CardToStr(j, str);
            Assign('orig_', orig);
            Assign('dest_', dest);
            Concat(orig, str, orig);
            Concat(dest, str, dest);
            EliminarTramo(orig, dest, tramosHab)
        END
    END;
	
    DestruirTramosHabilitados(tramosHab);
    
    FOR i := 1 TO MAX_EXT DO
        tramosHab := CrearTramosHabilitados();
		
        FOR j := 1 TO MAX_INT DO
            CardToStr(j, str);
            Assign('orig_', orig);
            Assign('dest_', dest);
            Concat(orig, str, orig);
            Concat(dest, str, dest);
            tramo := CrearTramo(orig, dest, j);
            InsertarTramo(tramo, tramosHab)
        END;
		
        DestruirTramosHabilitados(tramosHab)
    END;
    
    WriteStrLn('FIN!');
END TestTraHab2.
