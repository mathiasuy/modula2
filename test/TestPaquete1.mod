MODULE TestPaquete1;
(******************************************************************************
Módulo de prueba unitaria del TAD Paquete.

Prueba las funcionalidades básicas del TAD.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM Paquete    IMPORT Paquete, CrearPaquete, IdPaquete,
                        RutaPaquete, InicioCDPPaquete, FinCDPPaquete,
                        MaxSaltosPaquete, AvanzarPaquete, ImprimirPaquete,
                        DestruirPaquete;
FROM Ruta       IMPORT Ruta, CrearRuta, InsertarCDPRuta, ImprimirRuta,
                        IrInicioRuta, ActualCDPRuta;                        
FROM STextIO    IMPORT WriteString, WriteLn;
FROM SWholeIO   IMPORT WriteCard;
FROM StdChans IMPORT StdOutChan;


VAR
    r: Ruta;
    p: Paquete;
BEGIN
    r := CrearRuta();
    InsertarCDPRuta ("MVD", r);    (* Montevideo *)
    InsertarCDPRuta ("PDU", r);    (* Paysandu *)    
    InsertarCDPRuta ("STY", r);    (* Salto *)
    InsertarCDPRuta ("ATI", r);    (* Artigas *)
    IrInicioRuta (r);
    p := CrearPaquete ("paq1", r, 6,"[ a ]");
    
    WriteString ("Datos del paquete (identificador, inicio, fin, maxSaltos y ruta):"); WriteLn;    
    WriteString (IdPaquete(p)); WriteLn;
    WriteString (InicioCDPPaquete(p)); WriteLn;
    WriteString (FinCDPPaquete(p)); WriteLn;
    WriteCard (MaxSaltosPaquete(p), 1); WriteLn;
    ImprimirRuta (RutaPaquete(p),StdOutChan());
    
    WriteString ("Antes de avanzar en la ruta el centro actual es: ");
    WriteString (ActualCDPRuta (RutaPaquete(p)));
    WriteLn;
    
    WriteString ("Avanza en la ruta y despliega el centro actual"); WriteLn;
    AvanzarPaquete (p);
    WriteString (ActualCDPRuta (RutaPaquete(p)));    
    WriteLn;
    WriteString ("Datos del paquete"); WriteLn;
    ImprimirPaquete(p,StdOutChan());
    DestruirPaquete(p)     
END TestPaquete1.