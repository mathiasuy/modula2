MODULE TestTraHab3;
(******************************************************************************
Módulo de prueba unitaria del TAD TramosHabilitados.

Prueba las funcionalidades básicas del TAD.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM Tramo             IMPORT CrearTramo, ImprimirTramo;
FROM TramosHabilitados IMPORT TramosHabilitados, CrearTramosHabilitados, 
                                EsVaciaTramosHabilitados, Destinos, Origenes,
                                InsertarTramo, ObtenerTramo, PerteneceTramo, 
                                EliminarTramo, DestruirTramosHabilitados;
FROM LstIdsCDP         IMPORT LstIdsCDP, DestruirLstIdsCDP, ImprimirLstIdsCDP;
FROM STextIO           IMPORT WriteString, WriteLn;
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
	l: LstIdsCDP;
    ts: TramosHabilitados;
BEGIN
	ts := CrearTramosHabilitados();
	EvaluarCond (EsVaciaTramosHabilitados(ts), "OK-Es vacio", "ERROR-Es vacio");
	EvaluarCond (PerteneceTramo ("A", "B", ts), "ERROR-Es vacio", "OK-No pertenece");
	
	InsertarTramo (CrearTramo ("E", "B", 1), ts);
	InsertarTramo (CrearTramo ("A", "B", 1), ts);	
	InsertarTramo (CrearTramo ("B", "A", 1), ts);
	InsertarTramo (CrearTramo ("D", "E", 1), ts);
	InsertarTramo (CrearTramo ("B", "D", 1), ts);
	InsertarTramo (CrearTramo ("D", "C", 1), ts);	
	InsertarTramo (CrearTramo ("D", "A", 1), ts);
	InsertarTramo (CrearTramo ("A", "C", 1), ts);
	
	EvaluarCond (EsVaciaTramosHabilitados(ts), "ERROR-No es vacio", "OK-No es vacio");
	EvaluarCond (PerteneceTramo ("B", "C", ts), "ERROR-No pertenece", "OK-No pertenece");
	EvaluarCond (PerteneceTramo ("D", "A", ts), "OK-Pertenece", "ERROR-Pertenece");
	ImprimirTramo (ObtenerTramo ("B", "D", ts),StdOutChan());
	
	l := Destinos ("D", ts);
	ImprimirLstIdsCDP (l);
	DestruirLstIdsCDP (l);
	l := Destinos ("B", ts);
	ImprimirLstIdsCDP (l);
	DestruirLstIdsCDP (l);
	
	l := Origenes (ts);
	ImprimirLstIdsCDP (l);
	DestruirLstIdsCDP (l);
	
	EliminarTramo ("B", "A", ts);
	EliminarTramo ("D", "C", ts);		
	l := Destinos ("D", ts);
	ImprimirLstIdsCDP (l);
	DestruirLstIdsCDP (l);	
	l := Destinos ("B", ts);
	ImprimirLstIdsCDP (l);
	DestruirLstIdsCDP (l);
	
	EliminarTramo ("B", "D", ts);
	l := Origenes (ts);
	ImprimirLstIdsCDP (l);
	DestruirLstIdsCDP (l);
	
	DestruirTramosHabilitados (ts)
END TestTraHab3.
