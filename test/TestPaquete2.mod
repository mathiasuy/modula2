MODULE TestPaquete2;
(******************************************************************************
Módulo de prueba unitaria del TAD Paquete.

Prueba el uso de memoria dinámica del TAD.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM Paquete    IMPORT Paquete, CrearPaquete, DestruirPaquete;
FROM Ruta        IMPORT Ruta, CrearRuta, InsertarCDPRuta, IrInicioRuta;                        
FROM STextIO    IMPORT WriteString, WriteLn;


VAR
    i: CARDINAL;
    r: Ruta;
    p: Paquete;
BEGIN
    WriteString ("Inicio de prueba");
    WriteLn;
    
    FOR i := 1 TO 500000 DO
        r := CrearRuta();
        InsertarCDPRuta ("MVD", r);    (* Montevideo *)
        InsertarCDPRuta ("PDU", r);    (* Paysandu *)    
        InsertarCDPRuta ("STY", r);    (* Salto *)
        InsertarCDPRuta ("ATI", r);    (* Artigas *)
        IrInicioRuta (r);
        p := CrearPaquete ("paq", r, i,"[ a ]");
        DestruirPaquete(p)
    END;
    
    WriteString ("OK-Fin de la prueba")
END TestPaquete2.