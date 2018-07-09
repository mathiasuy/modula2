MODULE TestRuta3;
(******************************************************************************
Módulo de prueba unitaria del TAD Ruta.

Prueba las funcionalidades básicas del TAD.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM Ruta IMPORT Ruta, CrearRuta, InsertarCDPRuta, PrimerCDPRuta, UltimoCDPRuta,
                 ActualCDPRuta, SiguienteCDPRuta, IrInicioRuta, IrSiguienteRuta,
                 EsVaciaRuta, EsUltimoRuta, IndiceRuta, ImprimirRuta,
                 RemoverActualRuta, DestruirRuta;
FROM STextIO IMPORT WriteString, WriteLn;
FROM SWholeIO IMPORT WriteCard;
FROM StdChans IMPORT StdOutChan;



PROCEDURE WriteStringLn (str: ARRAY OF CHAR);
(* Despliega una cadena de caracteres y posiciona el cursor en la siguiente línea. *)
BEGIN
	WriteString(str);
	WriteLn
END WriteStringLn;


PROCEDURE WriteCardLn (c: CARDINAL);
(* Despliega una cardinal y posiciona el cursor en la siguiente línea. *)
BEGIN
	WriteCard(c, 1);
	WriteLn
END WriteCardLn;


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
    r: Ruta;
BEGIN
    r := CrearRuta();
	EvaluarCond (EsVaciaRuta (r), "OK-Es vacia", "ERROR-Es vacia");
	WriteCardLn (IndiceRuta(r));
	
	InsertarCDPRuta ("A", r);
	InsertarCDPRuta ("B", r);
	InsertarCDPRuta ("C", r);
	InsertarCDPRuta ("D", r);
	InsertarCDPRuta ("E", r);
	EvaluarCond (EsVaciaRuta (r), "ERROR-No es vacia", "OK-No es vacia");
	EvaluarCond (EsUltimoRuta (r), "OK-Es el ultimo", "ERROR-Es el ultimo");
	WriteCardLn (IndiceRuta(r));
	
	IrInicioRuta (r);
	IrSiguienteRuta (r);
	WriteStringLn (PrimerCDPRuta (r));	
	WriteStringLn (ActualCDPRuta (r));
	WriteStringLn (SiguienteCDPRuta (r));
	WriteStringLn (UltimoCDPRuta (r));
	EvaluarCond (EsUltimoRuta (r), "ERROR-No es el ultimo", "OK-No es el ultimo");	
	
	IrInicioRuta (r);
	IrSiguienteRuta (r);
	IrSiguienteRuta (r);
	RemoverActualRuta (r);
	IrInicioRuta (r);
	RemoverActualRuta (r);
	ImprimirRuta (r,StdOutChan());
    
    DestruirRuta(r)
END TestRuta3.