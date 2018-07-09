(* 47***** *)
IMPLEMENTATION MODULE ABBPaquetes;
(******************************************************************************
Modulo de definicion de ABBPaquetes.

El TAD ABBPaquetes define un arbol binario de busqueda cuyos elementos son
del tipo abstracto de datos Paquete.
El arbol esta ordenado por el identificador del Paquete.
La coleccion de paquetes del sistema se mantiene en una estructura de este
tipo.

Laboratorio de Programacion 2.
InCo-FI-UDELAR
******************************************************************************)

FROM Paquete IMPORT Paquete, RutaPaquete, TIdPaquete, IdPaquete, DestruirPaquete;
FROM Ruta IMPORT ActualCDPRuta;
FROM LstIdsCDP IMPORT LstIdsCDP, MergeLstIdsCDP, DestruirLstIdsCDP, CrearLstIdsCDP, InsertarTIdCDP;
FROM Storage IMPORT ALLOCATE, DEALLOCATE;
FROM Strings IMPORT Compare,  CompareResults, Equal;
FROM STextIO IMPORT WriteString, WriteLn;
TYPE
    ABBPaquetes = POINTER TO nodo;
    nodo = RECORD
				p : Paquete;
				d : ABBPaquetes;
				i : ABBPaquetes
			END;


(************ Constructoras *************)

PROCEDURE CrearABBPaquetes (): ABBPaquetes;
BEGIN
	RETURN NIL;
END CrearABBPaquetes;
(* Devuelve el arbol vacio. *)

PROCEDURE InsertarABBPaquetes (p: Paquete; VAR abb: ABBPaquetes);
(* Precondicion: NOT PerteneceABBPaquetes (IdPaquete(p), abb).
   Inserta el Paquete 'p' en el arbol 'abb'. *)
BEGIN
	IF abb=NIL THEN
		NEW(abb);
		abb^.p := p;
		abb^.d := NIL;
		abb^.i := NIL;
	ELSE
		IF (Compare(IdPaquete(p),IdPaquete(abb^.p))=greater) THEN
			InsertarABBPaquetes(p,abb^.d);
		ELSE
			InsertarABBPaquetes(p,abb^.i);
		END;
	END;
END InsertarABBPaquetes;


(************ Predicados ****************)

PROCEDURE EsVacioABBPaquetes (abb: ABBPaquetes): BOOLEAN;
(* Devuelve TRUE si el arbol 'abb' es vacio, FALSE en otro caso. *)
BEGIN
	RETURN abb = NIL
END EsVacioABBPaquetes;

PROCEDURE PerteneceABBPaquetes (id: TIdPaquete;
                                abb: ABBPaquetes): BOOLEAN;
(* Devuelve TRUE si en el arbol 'abb' existe un Paquete cuyo identificador es
 'id', FALSE en otro caso. *)
BEGIN
	WHILE abb <> NIL DO
		IF Equal(IdPaquete(abb^.p),id) THEN
			RETURN TRUE;
		ELSIF Compare(id, IdPaquete(abb^.p))=greater THEN
			abb := abb^.d;
		ELSE
			abb := abb^.i;
		END;
	END;
	RETURN FALSE;
END PerteneceABBPaquetes;


(************ Selectoras ****************)

PROCEDURE RaizABBPaquetes (abb: ABBPaquetes): Paquete;
(* Precondicion: NOT EsVacioABBPaquetes (abb).
   Devuelve el elemento raiz del arbol 'abb'. *)
BEGIN
	RETURN abb^.p;
END RaizABBPaquetes;

PROCEDURE IzqABBPaquetes (abb: ABBPaquetes): ABBPaquetes;
(* Precondicion: NOT EsVacioABBPaquetes (abb).
   Devuelve el sub-arbol izquierdo de 'abb'. *)
BEGIN
	RETURN abb^.i;
END IzqABBPaquetes;

PROCEDURE DerABBPaquetes (abb: ABBPaquetes): ABBPaquetes;
(* Precondicion: NOT EsVacioABBPaquetes (abb).
   Devuelve el sub-arbol derecho de 'abb'. *)
BEGIN
	RETURN abb^.d;
END DerABBPaquetes;

PROCEDURE PaqueteABBPaquetes (id: TIdPaquete;
                              abb: ABBPaquetes): Paquete;
(* Precondicion: PerteneceABBPaquetes (id, abb).
   Devuelve el Paquete en 'abb' cuyo identificador es 'id'. *)
BEGIN
	IF Compare(IdPaquete(abb^.p),id)=equal THEN
		RETURN abb^.p;
	ELSIF Compare(id, IdPaquete(abb^.p))=greater THEN
		RETURN PaqueteABBPaquetes(id,abb^.d);
	ELSE
		RETURN PaqueteABBPaquetes(id,abb^.i);
	END;
END PaqueteABBPaquetes;

PROCEDURE CDPsActualABBPaquetes (abb: ABBPaquetes): LstIdsCDP;
(* Devuelve una lista ordenada de manera creciente y sin elementos repetidos
  con los identificadores de los CDPs que son posicion actual de la ruta de
  algun paquete de 'abb'. *)

	PROCEDURE InOrden(abb : ABBPaquetes; VAR l : LstIdsCDP);
	VAR ltemp : LstIdsCDP;
	BEGIN
		IF abb <> NIL THEN
			InOrden(abb^.i, l);
			ltemp := CrearLstIdsCDP();
			InsertarTIdCDP (ActualCDPRuta (RutaPaquete (abb^.p)),ltemp);
			MergeLstIdsCDP(l,ltemp);
			DestruirLstIdsCDP(ltemp);
			InOrden(abb^.d, l);
		END;
	END InOrden;
VAR l : LstIdsCDP;
BEGIN
	l := CrearLstIdsCDP();
	InOrden(abb,l);
	RETURN l;		
END CDPsActualABBPaquetes;


(************ Salida ********************)

PROCEDURE ImprimirABBPaquetes (abb: ABBPaquetes);
(* Imprime los identificadores de cada Paquete del arbol 'abb' en orden creciente
   Se incluye una nueva linea luego de la impresion de cada elemento.
   La impresion se debe indentar segun el nivel de profundidad (la raíz
   sin espacios y luego se suma un espacio por cada nivel de profundidad).
   Si el arbol es vacio no se imprime nada. *)

	PROCEDURE Imprimir (abb: ABBPaquetes; i:CARDINAL);
	VAR n : CARDINAL;
	BEGIN
		IF NOT (abb = NIL) THEN
			Imprimir(abb^.i, i+1);
			FOR n := 1 TO i DO
				WriteString(" ");
			END;
			WriteString( IdPaquete(abb^.p) );
			WriteLn;
			Imprimir(abb^.d,i+1);
		END;	
	END Imprimir;
BEGIN
	Imprimir(abb,0);		
END ImprimirABBPaquetes;


(************ Destructoras **************)

PROCEDURE EliminarABBPaquetes (id: TIdPaquete; VAR abb: ABBPaquetes);
(* Precondicion: PerteneceABBPaquetes (id, abb).
   Remueve de 'abb' el paquete cuyo identificador es 'id'.
   Libera la memoria asociada al paquete removido.
   En su lugar se coloca el menor paquete del subarbol derecho, si este existe.
   Si no existe se coloca el mayor paquete del subarbol izquierdo, si el mismo existe.
   En otro caso, ese lugar queda vacío.   *)

  PROCEDURE Max (VAR abb : ABBPaquetes):Paquete;
   VAR p : Paquete; aux:ABBPaquetes;
   BEGIN
		IF abb <> NIL THEN
			IF abb^.i = NIL THEN
				p:=abb^.p;
				aux:=abb;
				abb := abb^.d;
				DISPOSE (aux);
				RETURN p;
			ELSE
				RETURN Max (abb^.i);
			END;
		END;
   END Max;

VAR aux:ABBPaquetes;	
BEGIN
	IF abb <> NIL THEN
		IF (Compare(IdPaquete(abb^.p), id) = equal) THEN
			IF abb^.i = NIL THEN
				aux := abb;
				abb := abb^.d;
				DestruirPaquete(aux^.p);
				DISPOSE (aux);
			ELSIF abb^.d = NIL THEN
				aux:=abb;
				abb:=abb^.i;
				DestruirPaquete(aux^.p);
				DISPOSE(aux);
			ELSE
				DestruirPaquete(abb^.p);
				abb^.p:=Max(abb^.d);
			END;
		ELSE
			EliminarABBPaquetes(id,abb^.d);
			EliminarABBPaquetes(id,abb^.i);
		END;	
	END;
END EliminarABBPaquetes;


PROCEDURE DestruirABBPaquetes (VAR abb: ABBPaquetes);
(* Libera la memoria reservada para el arbol 'abb' y sus elementos. *)
BEGIN
	IF abb <>NIL THEN
		DestruirABBPaquetes(abb^.d);
		DestruirABBPaquetes(abb^.i);
		DestruirPaquete(abb^.p);
		DISPOSE(abb);
	END;
END DestruirABBPaquetes;

END ABBPaquetes.
