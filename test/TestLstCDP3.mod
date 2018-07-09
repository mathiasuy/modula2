MODULE TestLstCDP3;
(******************************************************************************
Módulo de prueba unitaria del TAD LstIdsCDP.

Prueba las funcionalidades básicas del TAD.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM LstIdsCDP IMPORT LstIdsCDP, CrearLstIdsCDP, InsertarTIdCDP,
                       EsVaciaLstIdsCDP, PerteneceLstIdsCDP, PrimeroLstIdsCDP, 
					   RestoLstIdsCDP, ImprimirLstIdsCDP, EliminarLstIdsCDP, 
					   DestruirLstIdsCDP;
FROM STextIO   IMPORT WriteString, WriteLn;



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
BEGIN
	l := CrearLstIdsCDP();	
		
	EvaluarCond (EsVaciaLstIdsCDP(l), 'OK-Es vacia', 'ERROR-Lista vacia');	
	EvaluarCond (PerteneceLstIdsCDP('cuatro', l), 'ERROR-Lista vacia', 'OK-No pertenece');
	InsertarTIdCDP ('uno', l);
	InsertarTIdCDP ('dos', l);
	InsertarTIdCDP ('tres', l);	
	EvaluarCond (EsVaciaLstIdsCDP(l), 'ERROR-Lista con 3 elementos', 'OK-Lista no vacia');
	EvaluarCond (PerteneceLstIdsCDP('cuatro', l), 'ERROR-Elemento no agregado', 'OK-No pertenece');
	EvaluarCond (PerteneceLstIdsCDP('tres', l), 'OK-Pertenece', 'ERROR-Elemento agregado');
	
	WriteStringLn (PrimeroLstIdsCDP (l));
	WriteStringLn (PrimeroLstIdsCDP (RestoLstIdsCDP (l)));
	
	ImprimirLstIdsCDP (l);
	EliminarLstIdsCDP ('dos', l);
	ImprimirLstIdsCDP (l);
	EliminarLstIdsCDP ('tres', l);
	ImprimirLstIdsCDP (l);
	EliminarLstIdsCDP ('uno', l);
	ImprimirLstIdsCDP (l);			
	
	DestruirLstIdsCDP (l)
END TestLstCDP3.
