MODULE TestABBPaq3;
(******************************************************************************
Modulo de prueba unitaria del TAD ABBPaquetes.

Prueba las funcionalidades basicas del TAD.

Laboratorio de Programacion 2.
InCo-FI-UDELAR
******************************************************************************)

FROM ABBPaquetes IMPORT ABBPaquetes, CrearABBPaquetes, InsertarABBPaquetes,
                         RaizABBPaquetes, IzqABBPaquetes, DerABBPaquetes,
                         PaqueteABBPaquetes, EsVacioABBPaquetes,
                         PerteneceABBPaquetes, ImprimirABBPaquetes,
						 EliminarABBPaquetes, DestruirABBPaquetes;
FROM Paquete     IMPORT CrearPaquete, ImprimirPaquete;
FROM Ruta        IMPORT Ruta, CrearRuta, InsertarCDPRuta, IrInicioRuta, 
						IrSiguienteRuta;
FROM STextIO IMPORT WriteString, WriteLn;
FROM StdChans IMPORT StdOutChan;


PROCEDURE WriteStringLn (str: ARRAY OF CHAR);
(* Despliega una cadena de caracteres y posiciona el cursor en la siguiente línea. *)
BEGIN
	WriteString(str);
	WriteLn
END WriteStringLn;


PROCEDURE EvaluarCond (cond: BOOLEAN; msgTrue, msgFalse: ARRAY OF CHAR);
(* Evalua la condición 'cond', si es verdadera despliega 'msgTrue' sino despliega 'msgFalse' *)
BEGIN
	IF (cond) THEN
		WriteStringLn (msgTrue)
	ELSE
		WriteStringLn (msgFalse)
	END
END EvaluarCond;



(* Principal *)
VAR
    abb: ABBPaquetes;
    r1, r2, r3: Ruta;
BEGIN
    abb := CrearABBPaquetes();
	EvaluarCond (EsVacioABBPaquetes(abb), 'OK-Es vacio', 'ERROR-Es vacio');
	EvaluarCond (PerteneceABBPaquetes('cuatro', abb), 'ERROR-Es vacio', 'OK-No pertenece');

	r1 := CrearRuta();
	r2 := CrearRuta();
	r3 := CrearRuta();
	InsertarCDPRuta ('A', r1);
	InsertarCDPRuta ('B', r2);
	InsertarCDPRuta ('C', r2);
	InsertarCDPRuta ('D', r3);
	InsertarCDPRuta ('E', r3);
	InsertarCDPRuta ('F', r3);
	IrInicioRuta (r1);
	IrInicioRuta (r2);	
	IrInicioRuta (r3);
	IrSiguienteRuta (r3);
	InsertarABBPaquetes (CrearPaquete ('Tres', r3, 3, "[ a ]"), abb);
	InsertarABBPaquetes (CrearPaquete ('Dos', r2, 2, "[ a ]"), abb);
	InsertarABBPaquetes (CrearPaquete ('Uno', r1, 1,"[ a ]"), abb);
	EvaluarCond (EsVacioABBPaquetes(abb), 'ERROR-No es vacio', 'OK-No es vacio');
	EvaluarCond (PerteneceABBPaquetes('cuatro', abb), 'ERROR-No pertenece', 'OK-No pertenece');
	EvaluarCond (PerteneceABBPaquetes('Dos', abb), 'OK-Pertenece', 'ERROR-Pertenece');
	
	ImprimirPaquete (RaizABBPaquetes(abb),StdOutChan());
	ImprimirPaquete (RaizABBPaquetes(IzqABBPaquetes(abb)),StdOutChan());
	ImprimirPaquete (RaizABBPaquetes(DerABBPaquetes(abb)),StdOutChan());
	ImprimirPaquete (PaqueteABBPaquetes ('Uno', abb),StdOutChan());
	
	ImprimirABBPaquetes (abb);
	EliminarABBPaquetes ('Tres', abb);
	ImprimirABBPaquetes (abb);
	EliminarABBPaquetes ('Uno', abb);
	ImprimirABBPaquetes (abb);
	EliminarABBPaquetes ('Dos', abb);
	ImprimirABBPaquetes (abb);

	DestruirABBPaquetes (abb)	
END TestABBPaq3.
