(* 47***** *)
IMPLEMENTATION MODULE TramosHabilitados;
(******************************************************************************
Modulo de definicion de TramosHabilitados.

E777777777777
No hay dos tramos que tengan a la vez los mismos origen y destino.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)
FROM Storage IMPORT ALLOCATE, DEALLOCATE;
FROM LstIdsCDP IMPORT CrearLstIdsCDP, PerteneceLstIdsCDP;

FROM Strings IMPORT Compare, Equal, CompareResults;

FROM CDP IMPORT TIdCDP;
FROM Tramo IMPORT CDPDestinoTramo, CDPOrigenTramo, Tramo, DestruirTramo;
FROM LstIdsCDP IMPORT LstIdsCDP, InsertarTIdCDP;
(*FROM STextIO IMPORT WriteString;   *)
(*FROM SWholeIO IMPORT WriteCard;    *)


TYPE
   TramosHabilitados =	POINTER TO nodo;
   nodo  = 		RECORD
   				tramo	: Tramo;
				sig	: TramosHabilitados;
			END;

(************ Constructoras *************)

PROCEDURE CrearTramosHabilitados (): TramosHabilitados;
(* Devuelve la estructura vacía. *)
BEGIN
	RETURN NIL;
END CrearTramosHabilitados;


PROCEDURE InsertarTramo (nuevo: Tramo; VAR t: TramosHabilitados);
(* Precondicion: NOT PerteneceTramo (CDPOrigen (nuevo), CDPDestino (nuevo), t)
   Inserta el tramo 'nuevo' en la estructura 't'. *)
   VAR bnuevo, anterior, actual : TramosHabilitados;
BEGIN
     (* 1.- se busca su posicion *)
     actual := t;
     anterior := t;
     WHILE (actual <> NIL) AND (Compare(CDPDestinoTramo(actual^.tramo), CDPDestinoTramo(nuevo))=less) DO
           anterior := actual;
           actual := actual^.sig
     END;

     (* 2.- se crea el nodo *)
     NEW(bnuevo);
     bnuevo^.tramo := nuevo;

     (* 3.- Se enlaza *)
       (* inserta al principio *)
     IF (anterior = NIL) OR (anterior = actual) THEN
        bnuevo^.sig := anterior;
        t := bnuevo  (* importante: al insertar al principio actuliza la cabecera *)

       (* inserta entre medias o al final *)
     ELSE
        bnuevo^.sig := actual;
        anterior^.sig := bnuevo;
     END
END InsertarTramo;

(************ Selectoras ****************)

PROCEDURE ObtenerTramo (origen, destino: TIdCDP; t:TramosHabilitados): Tramo;
(* Precondicion: PerteneceTramo (origen, destino, t) = TRUE.
   Devuelve el tramo entre 'origen' y 'destino'.  *)
BEGIN
	WHILE (t <> NIL) AND NOT
		(
		Equal(origen,CDPOrigenTramo(t^.tramo)) AND Equal(destino, CDPDestinoTramo(t^.tramo))
		)
	DO
		t := t^.sig;
	END;
	
	RETURN t^.tramo;
END ObtenerTramo;


PROCEDURE Destinos (origen: TIdCDP; t: TramosHabilitados): LstIdsCDP;
(* Devuelve la lista con los TIdCDP de destinos de tramos en 't' cuyo TIdCDP
   origen es igual a 'origen'.
   La lista devuelta debe estar en ordenada de manera creeciente. *)
VAR 	destinos : LstIdsCDP;
	tdestino, torigen : TIdCDP;
BEGIN
	destinos := CrearLstIdsCDP ();
	(* inserto en la lista*)
	IF t <> NIL THEN
		WHILE ( t <> NIL ) DO
			torigen := CDPOrigenTramo(t^.tramo);
			tdestino := CDPDestinoTramo(t^.tramo);
			IF Equal(torigen, origen) AND NOT PerteneceLstIdsCDP(tdestino,destinos) THEN
				InsertarTIdCDP (tdestino, destinos);
			END;
			t := t^.sig;
		END;
	END;
	RETURN destinos;
END Destinos;

PROCEDURE Origenes (t:TramosHabilitados): LstIdsCDP;
(* Devuelve una lista con los TIdCDP que son origen de algun tramo en 't'.
   La lista devuelta debe estar ordenada de manera creciente. *)
VAR 	lista : LstIdsCDP;
	temp : TIdCDP;
	l : TramosHabilitados;
BEGIN
	lista := CrearLstIdsCDP ();
	WHILE t <> NIL DO
		l := t;
		temp := CDPOrigenTramo(l^.tramo);
		IF NOT PerteneceLstIdsCDP(temp, lista) THEN
			WHILE (l <> NIL) DO
				IF (Compare(CDPOrigenTramo(l^.tramo),temp)= less)
				AND (NOT PerteneceLstIdsCDP(CDPOrigenTramo(l^.tramo),lista) )
				THEN
					temp := CDPOrigenTramo(l^.tramo);
				END;
				l := l^.sig;
			END;
		(*	IF Equal(CDPDestinoTramo(l^.tramo),destino) THEN*)
				InsertarTIdCDP (temp, lista);
(*			END;                                              *)
		ELSE
			t := t^.sig;
		END;
	END;
	RETURN lista;
END Origenes;

(************ Predicados ****************)

PROCEDURE EsVaciaTramosHabilitados (lt: TramosHabilitados): BOOLEAN;
(* Devuelve TRUE si 'lt' es vacía, FALSE en otro caso. *)
BEGIN
	RETURN lt = NIL;
END EsVaciaTramosHabilitados;

PROCEDURE PerteneceTramo (origen, destino: TIdCDP; t:TramosHabilitados): BOOLEAN;
(* Devuelve TRUE si en 't' hay un tramo entre 'origen' y 'destino',  FALSE en
 otro caso. *)
BEGIN
	WHILE (t <> NIL)
		AND NOT
		( Equal(CDPDestinoTramo(t^.tramo),destino) AND Equal(CDPOrigenTramo(t^.tramo),origen)	)	
	DO
		t := t^.sig;
	END;
	RETURN t <> NIL;
END PerteneceTramo;

(************ Destructoras **************)
PROCEDURE EliminarTramo (origen, destino: TIdCDP; VAR t:TramosHabilitados);
(* Remueve de 't' el tramo determinado por los TIdCDP 'origen' y 'destino'.
 Libera la memoria asignada al tramo removido. *)
 VAR temp, anterior, actual : TramosHabilitados;
BEGIN
IF PerteneceTramo(origen,destino,t) THEN
	IF t^.sig = NIL
	THEN
		temp := t;
		t := NIL;
		DestruirTramo(temp^.tramo);
		DISPOSE(temp);
	ELSE
	  anterior := t;
	  actual := t;
	  WHILE (actual <> NIL) AND NOT
	  (
	  Equal(CDPDestinoTramo(actual^.tramo),destino) AND Equal(CDPOrigenTramo(actual^.tramo),origen)
	  )
	  DO
		anterior := actual;
		actual := actual^.sig;
	  END;
	  	temp := actual;
	  	anterior^.sig := actual^.sig;
		DestruirTramo(temp^.tramo);		
		DISPOSE(temp);
	END;
END;

END EliminarTramo;

PROCEDURE DestruirTramosHabilitados (VAR t: TramosHabilitados);
(* Libera la memoria asignada a 't' y sus elementos. *)
VAR temp : TramosHabilitados;
BEGIN
	WHILE t <> NIL DO
	        temp := t;
		DestruirTramo(t^.tramo);
		t := t^.sig;
		DISPOSE(temp);
	END;		

END DestruirTramosHabilitados;

END TramosHabilitados.
