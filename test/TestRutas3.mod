MODULE TestRutas3;
(******************************************************************************
Modulo de prueba unitaria del TAD Rutas.

Prueba las funcionalidades basicas del TAD.

Laboratorio de Programacion 2.
InCo-FI-UDELAR
******************************************************************************)

FROM Rutas     IMPORT Rutas, CrearVaciaRutas, EsVaciaRutas, EsHojaRutas,
                      EsHijoRutas, CrearHojaRutas, DestruirRutas,
					  AgregarHijoRutas, RaizRutas, CostoRutas, IdsHijosRutas,
					  HijoRutas, ImprimirRutas, EliminarHijoRutas;
FROM LstIdsCDP IMPORT LstIdsCDP, ImprimirLstIdsCDP, DestruirLstIdsCDP;
FROM STextIO   IMPORT WriteString, WriteLn;					
FROM SWholeIO  IMPORT WriteCard;



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
    r, hijo: Rutas;
	l: LstIdsCDP;
BEGIN
	r := CrearVaciaRutas();
	EvaluarCond (EsVaciaRutas(r), "OK-Es vacia", "ERROR-Es vacia");
	DestruirRutas (r);
	
	r := CrearHojaRutas ("padre", 0);
	AgregarHijoRutas (CrearHojaRutas("hijo2", 4), r);
	AgregarHijoRutas (CrearHojaRutas("hijo1", 3), r);
	AgregarHijoRutas (CrearHojaRutas("hijo3", 5), r);
	hijo := HijoRutas ("hijo2", r);
	EvaluarCond (EsHojaRutas(hijo), "OK-Es hoja", "ERROR-Es hoja");
	AgregarHijoRutas (CrearHojaRutas("nieto1", 2), hijo);
	AgregarHijoRutas (CrearHojaRutas("nieto2", 1), hijo);
	
	EvaluarCond (EsVaciaRutas(r), "ERROR-No es vacia", "OK-No es vacia");
	EvaluarCond (EsHojaRutas(r), "ERROR-No es hoja", "OK-No es hoja");
	EvaluarCond (EsHijoRutas ("hijo4", r), "ERROR-No es hijo", "OK-No es hijo");
	EvaluarCond (EsHijoRutas ("hijo1", r), "OK-Es hijo", "ERROR-Es hijo");
	
	WriteStringLn (RaizRutas(hijo));
	WriteCardLn (CostoRutas(hijo));
	l := IdsHijosRutas(r);
	ImprimirLstIdsCDP (l);
	DestruirLstIdsCDP (l);
	
	ImprimirRutas(r);
	EliminarHijoRutas ("hijo3", r);
	ImprimirRutas(r);
	EliminarHijoRutas ("hijo1", r);
	ImprimirRutas(r);
	EliminarHijoRutas ("hijo2", r);
	ImprimirRutas(r);

	DestruirRutas (r)	
END TestRutas3.
