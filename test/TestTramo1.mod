MODULE TestTramo1;
(******************************************************************************
Módulo de prueba unitaria del TAD Tramo.

Prueba las funcionalidades básicas del TAD.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM STextIO  IMPORT WriteLn, WriteString;                        
FROM SWholeIO IMPORT WriteCard;

FROM CDP   IMPORT TIdCDP;
FROM Tramo IMPORT Tramo,CrearTramo, CDPOrigenTramo, CDPDestinoTramo, 
                    CostoTramo, ImprimirTramo, DestruirTramo;
FROM StdChans IMPORT StdOutChan;

VAR
    t1, t2, t3: Tramo;
    origen, destino: TIdCDP;
    costo: CARDINAL;
BEGIN
    t1 := CrearTramo ("CDP Montevideo","CDP Buenos Aires", 500);
    t2 := CrearTramo ("CDP San Pablo","CDP Buenos Aires", 1000);
    t3 := CrearTramo ("CDP Montevideo","CDP San Pablo", 300);
    
    origen := CDPOrigenTramo (t1);
    WriteString("Origen tramo 1: ");
    WriteString(origen);WriteLn();
    
    destino := CDPDestinoTramo (t1);
    WriteString("Destino tramo 1: ");
    WriteString(destino);WriteLn();
    
    origen := CDPOrigenTramo (t2);
    WriteString("Origen tramo 2: ");
    WriteString(origen);WriteLn();
    
    destino := CDPDestinoTramo (t2);
    WriteString("Destino tramo 2: ");
    WriteString(destino);WriteLn();
    
    origen := CDPOrigenTramo (t3);
    WriteString("Origen tramo 3: ");
    WriteString(origen);WriteLn();
    
    destino := CDPDestinoTramo (t3);
    WriteString("Destino tramo 3: ");
    WriteString(destino);WriteLn();
    
    costo := CostoTramo (t1);
    WriteString("Costo tramo 1: ");
    WriteCard(costo,1);WriteLn();
    
    costo := CostoTramo (t2);
    WriteString("Costo tramo 2: ");
    WriteCard(costo,1);WriteLn();
    
    costo := CostoTramo (t3);
    WriteString("Costo tramo 3: ");
    WriteCard(costo,1);WriteLn();
    
    WriteString("Tramo 1:");
    ImprimirTramo(t1,StdOutChan());
    
    WriteString("Tramo 2:");
    ImprimirTramo(t2,StdOutChan());
    
    WriteString("Tramo 3:");
    ImprimirTramo(t3,StdOutChan());
    
    WriteString ("Destruyendo tramos...");
    DestruirTramo(t3);
    DestruirTramo(t1);
    DestruirTramo(t2);
    WriteString ("OK!")    
END TestTramo1.