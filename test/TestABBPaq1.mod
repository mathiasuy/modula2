MODULE TestABBPaq1;
(******************************************************************************
Modulo de prueba unitaria del TAD ABBPaquetes.

Prueba las funcionalidades basicas del TAD.

Laboratorio de Programacion 2.
InCo-FI-UDELAR
******************************************************************************)

FROM ABBPaquetes IMPORT ABBPaquetes, CrearABBPaquetes, InsertarABBPaquetes,
                         RaizABBPaquetes, IzqABBPaquetes, DerABBPaquetes,
                         PaqueteABBPaquetes, EsVacioABBPaquetes,
                         PerteneceABBPaquetes, CDPsActualABBPaquetes, 
                         ImprimirABBPaquetes, EliminarABBPaquetes, 
                         DestruirABBPaquetes;
FROM LstIdsCDP   IMPORT ImprimirLstIdsCDP;    						
FROM Paquete     IMPORT Paquete, CrearPaquete, ImprimirPaquete;
FROM Ruta        IMPORT Ruta, CrearRuta, InsertarCDPRuta, IrInicioRuta, 
						IrSiguienteRuta;
FROM STextIO IMPORT WriteString, WriteLn;
FROM StdChans IMPORT StdOutChan;


PROCEDURE ImprimirMensaje (condicion: BOOLEAN; strOK, strError: ARRAY OF CHAR);
BEGIN
    IF condicion THEN
        WriteString ('OK, ');
        WriteString (strOK)
    ELSE    
        WriteString ('Error, ');
        WriteString (strError)
    END;
	
    WriteLn
END ImprimirMensaje;

    
VAR
    abb, hijo: ABBPaquetes;
    p: Paquete;
    r: Ruta;
BEGIN
    abb := CrearABBPaquetes();
	
	(* vacio *)
    ImprimirMensaje (EsVacioABBPaquetes (abb), 'es vacio', 'no es vacio');
    ImprimirMensaje (NOT PerteneceABBPaquetes ('Paquete', abb), 'no pertenece', 'pertenece');
	WriteString ('Arbol vacio:');
	WriteLn;
    ImprimirABBPaquetes (abb);
	WriteLn;	
	
	(* un elemento *)	
    r := CrearRuta ();
    InsertarCDPRuta ('A', r);
    InsertarCDPRuta ('B', r);
    p := CrearPaquete ('Paquete', r, 5,"[ a ]"); 
    InsertarABBPaquetes (p, abb);	
    ImprimirMensaje (NOT EsVacioABBPaquetes (abb), 'no es vacio', 'es vacio');
    ImprimirMensaje (PerteneceABBPaquetes ('Paquete', abb), 'pertenece', 'no pertenece');
    ImprimirABBPaquetes (abb);
    EliminarABBPaquetes ('Paquete', abb);
	
	(* vacio *)
    ImprimirMensaje (EsVacioABBPaquetes (abb), 'es vacio', 'no es vacio');
    ImprimirMensaje (NOT PerteneceABBPaquetes ('Paquete', abb), 'no pertenece', 'pertenece');
	WriteString ('Listado vacio con identificadores de CDPs actuales');
	WriteLn;
    ImprimirLstIdsCDP (CDPsActualABBPaquetes (abb));

    r := CrearRuta ();
    InsertarCDPRuta ('P', r);
    InsertarCDPRuta ('Q', r);
    p := CrearPaquete ('paq50', r, 5,"[ a ]"); 
    InsertarABBPaquetes (p, abb);
	WriteString ('Listado con unico identificador de CDPs actuales');
	WriteLn;
    ImprimirLstIdsCDP (CDPsActualABBPaquetes (abb));
    
    r := CrearRuta ();
    InsertarCDPRuta ('A', r);
    InsertarCDPRuta ('B', r);
    p := CrearPaquete ('paq40', r, 4,"[ a ]"); 
    InsertarABBPaquetes (p, abb);

	(* arbol con hijo izquierdo *)	
    ImprimirMensaje (PerteneceABBPaquetes ('paq50', abb), 'pertenece', 'no pertenece');
    ImprimirMensaje (PerteneceABBPaquetes ('paq40', abb), 'pertenece', 'no pertenece');

	(* se elimino el hijo izquierdo *)	
    EliminarABBPaquetes ('paq40', abb);	
    ImprimirMensaje (PerteneceABBPaquetes ('paq50', abb), 'pertenece', 'no pertenece');
    ImprimirMensaje (NOT PerteneceABBPaquetes ('paq40', abb), 'no pertenece', 'pertenece');
    
    r := CrearRuta ();
    InsertarCDPRuta ('A', r);
    InsertarCDPRuta ('B', r);
    p := CrearPaquete ('paq40', r, 4,"[ a ]"); 
    InsertarABBPaquetes (p, abb);
    ImprimirMensaje (PerteneceABBPaquetes ('paq40', abb), 'pertenece', 'no pertenece');

	(* se elimino la raiz *)	
    EliminarABBPaquetes ('paq50', abb);
    ImprimirMensaje (NOT PerteneceABBPaquetes ('paq50', abb), 'no pertenece', 'pertenece');
    ImprimirMensaje (PerteneceABBPaquetes ('paq40', abb), 'pertenece', 'no pertenece');
	ImprimirABBPaquetes (abb);
	
    r := CrearRuta ();
    InsertarCDPRuta ('P', r);
    InsertarCDPRuta ('Q', r);
	IrInicioRuta (r);
    p := CrearPaquete ('paq50', r, 5,"[ a ]"); 
    InsertarABBPaquetes (p, abb);
	
	(* arbol con hijo derecho *)	
    ImprimirMensaje (PerteneceABBPaquetes ('paq50', abb), 'pertenece', 'no pertenece');
	ImprimirABBPaquetes (abb);
    
	hijo := IzqABBPaquetes (abb);
    ImprimirMensaje (EsVacioABBPaquetes (hijo), 'es vacio', 'no es vacio');
	hijo := DerABBPaquetes (abb);
    ImprimirMensaje (NOT EsVacioABBPaquetes (hijo), 'no es vacio', 'es vacio');

    r := CrearRuta ();
    InsertarCDPRuta ('Z', r);
    InsertarCDPRuta ('Y', r);
    InsertarCDPRuta ('X', r);
    InsertarCDPRuta ('W', r);
	IrInicioRuta (r);
	IrSiguienteRuta (r);
    p := CrearPaquete ('paq30', r, 3,"[ a ]"); 
    InsertarABBPaquetes (p, abb);
	
	(* arbol con hijo izquierdo y derecho *)	
    ImprimirMensaje (PerteneceABBPaquetes ('paq30', abb), 'pertenece', 'no pertenece');
	ImprimirABBPaquetes (abb);	
	
	ImprimirPaquete (RaizABBPaquetes (abb),StdOutChan());
	hijo := IzqABBPaquetes (abb);
	
	IF (NOT EsVacioABBPaquetes (hijo)) THEN
		ImprimirPaquete (RaizABBPaquetes (hijo),StdOutChan())
	END;
	
	hijo := DerABBPaquetes (abb);
	
	IF (NOT EsVacioABBPaquetes (hijo)) THEN
		ImprimirPaquete (RaizABBPaquetes (hijo),StdOutChan())
	END;
	
	IF PerteneceABBPaquetes ('paq50', abb) THEN
		p := PaqueteABBPaquetes ('paq50', abb);
		ImprimirPaquete (p,StdOutChan());
	END;

    ImprimirLstIdsCDP (CDPsActualABBPaquetes (abb));
    DestruirABBPaquetes(abb)
END TestABBPaq1.
