(* 47***** *)
IMPLEMENTATION MODULE CnjCDPs;
(******************************************************************************
Modulo de definicion de CnjCDPs.

El TAD CnjCDPs representa la coleccion de los CDPs del sistema.
No hay dos CDPs con el mismo identificador.

Laboratorio de Programacion 2.
InCo-FI-UDELAR
******************************************************************************)
FROM CDP IMPORT TIdCDP, IdCDP, CDP, DestruirCDP;
FROM Strings IMPORT Compare, Equal, CompareResults;
FROM Storage IMPORT ALLOCATE, DEALLOCATE;
FROM LstIdsCDP IMPORT LstIdsCDP, CrearLstIdsCDP, InsertarTIdCDP;
(*FROM STextIO IMPORT WriteString;       *)

TYPE

   CnjCDPs = POINTER TO cdp;

	cdp = 	RECORD
			c : CDP;
			s : CnjCDPs;
		END;
	
(************ Constructoras *************)

PROCEDURE CrearCnjCDPs (): CnjCDPs;
BEGIN
	RETURN NIL;
END CrearCnjCDPs;
(* Devuelve la estructura vacia. *)

PROCEDURE InsertarCnjCDPs (centro: CDP; VAR c: CnjCDPs);
(* Inserta en 'c' el CDP 'centro'. *)
VAR nuevo, actual, anterior : CnjCDPs;
BEGIN
	IF NOT PerteneceCnjCDPs(IdCDP(centro),c) THEN
		NEW (nuevo);
		nuevo^.c := centro;
		IF (c = NIL) THEN
			nuevo^.s := NIL;
			c := nuevo;
		ELSIF (Compare(IdCDP(centro), IdCDP(c^.c)) = less) THEN
			nuevo^.s := c;
			c := nuevo;
		ELSE
			anterior := c;
			actual := c;
			WHILE (actual <> NIL) AND (Compare(IdCDP(centro), IdCDP(actual^.c)) = greater) DO
				anterior := actual;
				actual := actual^.s;
			END;
			nuevo^.s := actual;
			anterior^.s := nuevo;
		END;		
	END;
END InsertarCnjCDPs;


(************ Predicados ****************)

PROCEDURE EsVacioCnjCDPs (c: CnjCDPs): BOOLEAN;
(* Devuelve TRUE si 'c' es vacío, FALSE en otro caso. *)
BEGIN
	RETURN c = NIL;
END EsVacioCnjCDPs;

PROCEDURE PerteneceCnjCDPs (id: TIdCDP; c: CnjCDPs): BOOLEAN;
(* Devuelve TRUE si en 'c' hay un CDP con identificador 'id', FALSE en otro
 caso. *)
BEGIN
	
	WHILE (c <> NIL) AND NOT Equal(IdCDP(c^.c), id) DO
		c := c^.s;
	END;

	RETURN c <> NIL
END PerteneceCnjCDPs;


(************ Selectoras  ****************)

PROCEDURE ObtenerCnjCDPs (id: TIdCDP; c: CnjCDPs): CDP;
(* Precondicion: en 'c' hay un CDP con identificador 'id'.
 Devuelve el CDP con identificador 'id'. *)
BEGIN
	WHILE (c <> NIL) AND NOT Equal(IdCDP(c^.c), id) DO
		c := c^.s;
	END;

	RETURN c^.c;
END ObtenerCnjCDPs;

PROCEDURE IdsCnjCDPs (c: CnjCDPs): LstIdsCDP;
(* Devuelve una lista con los TIdCDP que son identificadores de los centros
 en 'c'.
  La lista devuelta debe estar en orden creciente. *)
VAR lt : LstIdsCDP;
BEGIN
	lt := CrearLstIdsCDP();
	WHILE (c <> NIL) DO
		InsertarTIdCDP(IdCDP(c^.c),lt);
		c := c^.s;
	END;
	RETURN lt;
END IdsCnjCDPs;


(************ Destructoras **************)

PROCEDURE EliminarCnjCDPs (id: TIdCDP; VAR c: CnjCDPs);
(* Precondicion: en 'c' hay un CDP con identificador 'id'.
  Remueve de 'c' el CDP con identificador 'id'.
  Libera la memoria asignada al CDP removido. *)
VAR temp : CnjCDPs;
BEGIN
	IF Equal(IdCDP(c^.c), id) THEN
		temp := c;
		c := c^.s;
		DestruirCDP(temp^.c);		
	ELSE
		WHILE (c^.s <> NIL) AND Equal(IdCDP(c^.s^.c), id) DO
			c := c^.s;
		END;
		temp := c^.s;
		c^.s := c^.s^.s;
		DestruirCDP(temp^.c);		
	END;
	DISPOSE(temp);
END EliminarCnjCDPs;

PROCEDURE DestruirCnjCDPs (VAR c: CnjCDPs);
(* Libera la memoria asignada por el conjunto 'c' y sus elementos. *)
VAR temp : CnjCDPs;
BEGIN
	WHILE (c <> NIL) DO
		temp := c;
		c := c^.s;
		DestruirCDP(temp^.c);		
		DISPOSE(temp);
	END;
END DestruirCnjCDPs;
	
END CnjCDPs.