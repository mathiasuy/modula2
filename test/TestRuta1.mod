MODULE TestRuta1;
(******************************************************************************
Módulo de prueba unitaria del TAD Ruta.

Prueba las funcionalidades básicas del TAD.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM Ruta IMPORT Ruta, CrearRuta, InsertarCDPRuta, PrimerCDPRuta, UltimoCDPRuta,
                 ActualCDPRuta, SiguienteCDPRuta, IrInicioRuta, IrSiguienteRuta,
                    EsVaciaRuta, EsUltimoRuta, ConcatenarRuta, ImprimirRuta,
                    RemoverActualRuta, DestruirRuta, IndiceRuta;
FROM STextIO IMPORT WriteString, WriteLn;
FROM StdChans IMPORT StdOutChan;


VAR
    r1, r2: Ruta;
BEGIN
    r1 := CrearRuta();
    r2 := CrearRuta();
    
    IF (EsVaciaRuta (r1)) THEN
        WriteString("OK-La ruta es vacia")
    ELSE
        WriteString("ERROR-La ruta deberia ser vacia")
    END;
    
    WriteLn;
    
    IF (IndiceRuta(r1) = 0) THEN
        WriteString("OK-El indice es cero")
    ELSE
        WriteString("ERROR-El indice deberia ser cero")
    END;
    
    WriteLn;
    InsertarCDPRuta ("MVD", r1);    (* Montevideo *)
    
    IF (EsVaciaRuta (r1)) THEN
        WriteString("ERROR-La ruta no deberia ser vacia")
    ELSE
        WriteString("OK-La ruta no es vacia")
    END;
    
    WriteLn;
    InsertarCDPRuta ("PDU", r1);    (* Paysandu *)    
    InsertarCDPRuta ("STY", r1);    (* Salto *)
    InsertarCDPRuta ("ATI", r1);    (* Artigas *)
    WriteString("Imprime la ruta en su orden"); WriteLn;
    ImprimirRuta(r1,StdOutChan());
    IrInicioRuta (r1);
    IrSiguienteRuta (r1);
    WriteString("Imprime primero, ultimo, actual y siguiente"); WriteLn;
    WriteString (PrimerCDPRuta(r1)); WriteLn;
    WriteString (UltimoCDPRuta(r1)); WriteLn;
    WriteString (ActualCDPRuta(r1)); WriteLn;
    WriteString (SiguienteCDPRuta(r1)); WriteLn;
    
    IF (IndiceRuta(r1) = 2) THEN
        WriteString("OK-El indice es 2")
    ELSE
        WriteString("ERROR-El indice deberia ser 2")
    END;
    
    WriteLn;
    
    IF (EsUltimoRuta(r1)) THEN
        WriteString("ERROR-La ruta no deberia estar en su ultimo elemento")
    ELSE
        WriteString("OK-La ruta no esta en su ultimo elemento")
    END;    
    
    WriteLn;
    InsertarCDPRuta ("TAB", r2);    (* Tacuarembo *)
    InsertarCDPRuta ("MLZ", r2);    (* Cerro Largo *)
    WriteString("Imprime la segunda ruta"); WriteLn;
    ImprimirRuta(r2,StdOutChan());
    
    IF (EsUltimoRuta(r2)) THEN
        WriteString("OK-La ruta esta en su ultimo elemento")
    ELSE
        WriteString("ERROR-La ruta deberia estar en su ultimo elemento")
    END;
    
    WriteLn;
    ConcatenarRuta (r1, r2);
    WriteString("Imprime la nueva ruta luego de concatenar con la segunda"); WriteLn;
    ImprimirRuta(r1,StdOutChan());
    IrInicioRuta (r1);
    IrSiguienteRuta (r1);    
    RemoverActualRuta(r1);
    WriteString("Imprime la ruta luego de remover Paysandu (PDU)"); WriteLn;
    ImprimirRuta(r1,StdOutChan());
    
    DestruirRuta(r1);
    DestruirRuta(r2)
END TestRuta1.