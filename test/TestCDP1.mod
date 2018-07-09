MODULE TestCDP1;
(******************************************************************************
Módulo de prueba unitaria del TAD CDP.

Prueba las funcionalidades básicas del TAD.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM STextIO  IMPORT WriteLn, WriteString;                        
FROM SWholeIO IMPORT WriteCard;

FROM CDP IMPORT TCiudadPais,TIdCDP, CDP, CrearCDP, IdCDP, CapacidadActualCDP,
                  PaisCDP, CiudadCDP, AumentarCapacidadActualCDP, 
				  DisminuirCapacidadActualCDP, ImprimirCDP, DestruirCDP;
FROM StdChans IMPORT StdOutChan;

VAR
    c1, c2, c3: CDP;
    idCDP: TIdCDP;
    capActual: CARDINAL;
    ciudad, pais: TCiudadPais;
BEGIN
    c1 := CrearCDP ("Centro 1", 100, "Uruguay", "Montevideo");
    c2 := CrearCDP ("Centro 2", 50, "Argentina", "Buenos Aires");
    c3 := CrearCDP ("Centro 3", 200, "Brasil", "San Pablo");
    
    idCDP := IdCDP (c1);
    WriteString("Id CDP 1: ");
    WriteString(idCDP);WriteLn();
    
    capActual := CapacidadActualCDP (c2);
    WriteString("Capacidad CDP 2: ");
    WriteCard(capActual,1);WriteLn();
    
    DisminuirCapacidadActualCDP (c2);
    DisminuirCapacidadActualCDP (c2);
    DisminuirCapacidadActualCDP (c2);
    AumentarCapacidadActualCDP (c2);
    
    capActual := CapacidadActualCDP (c2);
    WriteString("Capacidad CDP 2: ");
    WriteCard(capActual,1);WriteLn();
    
    pais := PaisCDP(c3);
    WriteString("Pais CDP 3: ");
    WriteString(pais);WriteLn();
    
    ciudad := CiudadCDP(c3);
    WriteString("Ciudad CDP 3: ");
    WriteString(ciudad);WriteLn();
    
    WriteString("CDP 1: ");WriteLn();
    ImprimirCDP(c1,StdOutChan());
    
    WriteString("CDP 2: ");WriteLn();
    ImprimirCDP(c2,StdOutChan());
    
    WriteString("Destruyendo CDPs... ");
    DestruirCDP(c1);
    DestruirCDP(c2);
    DestruirCDP(c3);
    WriteString("OK!");WriteLn()
END TestCDP1.