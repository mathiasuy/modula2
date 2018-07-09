MODULE TestRuta2;
(******************************************************************************
Módulo de prueba unitaria del TAD Ruta.

Prueba el uso de memoria dinámica del TAD.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM CDP        IMPORT TIdCDP;
FROM Ruta        IMPORT Ruta, CrearRuta, InsertarCDPRuta, DestruirRuta,
                        IrInicioRuta, IrSiguienteRuta, EsUltimoRuta,
                        RemoverActualRuta, ConcatenarRuta;
FROM STextIO    IMPORT WriteString, WriteLn;                        
FROM Strings    IMPORT Concat;
FROM WholeStr   IMPORT CardToStr;



CONST
    MAX_IDS = 1200;
VAR
    r, r2: Ruta;
    i, j, h: CARDINAL;
    subFijo: ARRAY [0..4] OF CHAR;
    id: TIdCDP;
    ids: ARRAY [1..MAX_IDS] OF TIdCDP;
    
BEGIN
    FOR i := 1 TO MAX_IDS DO
        CardToStr(i, subFijo);
        Concat('id', subFijo, id);
        ids[i] := id
    END;
    
    WriteString ("Prueba DestruirRuta"); WriteLn;
    
    FOR i := 1 TO 6000 DO
        r := CrearRuta();
        
        FOR j := 1 TO MAX_IDS DO
            IF ((j MOD 10) = 0) THEN
                IrInicioRuta(r)
            END;
            
            IF (((j MOD 5) = 0) AND (NOT EsUltimoRuta(r))) THEN
                IrSiguienteRuta(r)
            END;
            
            InsertarCDPRuta (ids[j], r)
        END;
        
        DestruirRuta(r)    
    END;
   
    WriteString ("Prueba RemoverActualRuta"); WriteLn;
   
    FOR i := 1 TO 6000 DO    
        r := CrearRuta();        
    
        FOR j := 1 TO MAX_IDS DO
            InsertarCDPRuta (ids[j], r)
        END;
        
        FOR j := 1 TO MAX_IDS DO
            IF ((j MOD 10) = 0) THEN
                IrInicioRuta(r)
            END;
            
            IF (((j MOD 5) = 0) AND (NOT EsUltimoRuta(r))) THEN
                IrSiguienteRuta(r)
            END;
        
            RemoverActualRuta(r)
        END;
        
        DestruirRuta(r)
    END;

    WriteString ("Prueba ConcatenarRuta"); WriteLn;
    
    FOR i := 1 TO 4000 DO    
        r := CrearRuta();        
        r2 := CrearRuta();
    
        FOR j := 1 TO MAX_IDS DO
            InsertarCDPRuta (ids[j], r);
            
            IF ((j MOD 3) = 0) THEN
                InsertarCDPRuta (ids[j], r2)
            END
        END;        
        
        IF ((i MOD 10) = 0) THEN
            IrInicioRuta(r)
        ELSIF ((i MOD 7) = 0) THEN
            IrInicioRuta(r);
            
            FOR h := 1 TO 150 DO
                IrSiguienteRuta(r)
            END
        END;
        
        ConcatenarRuta(r, r2);        
        DestruirRuta(r2);
        DestruirRuta(r)
    END;

    WriteString ("OK-Fin de la prueba")
END TestRuta2.