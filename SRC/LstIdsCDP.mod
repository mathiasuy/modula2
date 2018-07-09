(* 47***** *)
IMPLEMENTATION MODULE LstIdsCDP;
(******************************************************************************
Modulo de definicion de LstIdsCDP.

El TAD LstIdsCDP representa las listas de elementos de tipo TIdCDP.

Laboratorio de Programacion 2.
InCo-FI-UDELAR
******************************************************************************)
FROM CDP IMPORT TIdCDP;
FROM Strings IMPORT Equal, CompareResults, Compare;
FROM STextIO IMPORT WriteString, WriteLn;
FROM Storage IMPORT ALLOCATE, DEALLOCATE;

TYPE
   LstIdsCDP =  POINTER TO nodo;
	nodo =  RECORD
 			id : TIdCDP;
			s  : LstIdsCDP;
		END;

(************ Constructoras *************)

PROCEDURE CrearLstIdsCDP (): LstIdsCDP;
(* Devuelve la lista vacia. *)
BEGIN
	RETURN NIL	
END CrearLstIdsCDP;

PROCEDURE InsertarTIdCDP (t: TIdCDP; VAR lt: LstIdsCDP);
(* Inserta el elemento 't' al final de 'lt'. *)
VAR 	copy, temp : LstIdsCDP;
BEGIN
	IF lt = NIL THEN
		NEW (lt);
		lt^.id := t;
		lt^.s := NIL;
	ELSE
		copy := lt;
		WHILE (copy^.s <> NIL) DO
			copy := copy^.s;
		END;
		
		NEW (temp);
		temp^.id := t;
		temp^.s := NIL;
		copy^.s := temp;
	END;
END InsertarTIdCDP;

PROCEDURE MergeLstIdsCDP (VAR l1, l2: LstIdsCDP);
(* Precondicion: 'l1' y 'l2' son listas ordenadas de manera creciente sin elementos
 repetidos.
 Devuelve en 'l1' una lista ordenada sin elementos repetidos con todos los
 TIdCDP que inicialmente estaban en 'l1' o 'l2'.
 Devuelve en 'l2' una lista ordenada sin elementos repetidos con todos los
 TIdCDP que estaban en 'l1' y 'l2'.
 En esta operacion no se obtiene ni libera memoria. *)

	PROCEDURE Insertar(VAR L : LstIdsCDP; elem : LstIdsCDP);
	VAR actual, anterior : LstIdsCDP;
	BEGIN
	(*     { 1.- se busca su posicion }*)
		actual := L;
		anterior := L;
		WHILE (actual <> NIL) AND (Compare(actual^.id, elem^.id) = less) DO
			anterior := actual;
			actual := actual^.s
		END;
	
	(*     { 3.- Se enlaza }*)
	(*        inserta al principio }*)
		IF (anterior = NIL) OR (anterior = actual) THEN
			elem^.s := anterior;
			L := elem;  (* importante: al insertar al principio actuliza la cabecera }*)
	(*	      inserta entre medias o al final }                                                    *)
		ELSE
			elem^.s := actual;
			anterior^.s := elem;
		END;
	END Insertar;

	PROCEDURE Desenganchar(t : TIdCDP;VAR l : LstIdsCDP; l1 : LstIdsCDP): BOOLEAN;
	VAR anterior, actual : LstIdsCDP;
	BEGIN
		IF NOT PerteneceLstIdsCDP (t,l1) THEN
			IF Equal(l^.id, t) THEN
				l := l^.s;
			ELSE
				anterior := l;
				actual := l;
				WHILE (actual <> NIL) AND  NOT Equal(actual^.id,t) DO
					anterior := actual;
					actual := actual^.s;
				END;
				anterior^.s := actual^.s;
			END;
			RETURN TRUE;
		ELSE
			RETURN FALSE;
		END;
	END Desenganchar;
	
 VAR t2, temp: LstIdsCDP;
BEGIN
	t2 := l2; (*sera la victima a desarmar, aunque quedaran lo sque pertenecen a las 2 listas*)
	WHILE t2 <> NIL DO
			temp := t2;  (*elemento que se desenganchara*)
			(*Desengancho de l2 (porque si lo hago de t2
			 dara problemas con el primer elemento
			 todos los elementos que no estan en l1 *)
			IF Desenganchar(t2^.id,l2,l1) THEN
			(*desengancho de l2 si verifico que no esta en l1*)
			(* Los inserto en l1*)
				Insertar(l1, temp);
				t2 := l2;
			ELSE
				t2 := t2^.s;  (*avanzo t2*)
			END;
	END;
(*Canelones, Cerro Largo, MAldonado, Trinidad*)	
(*Canelones, Maldonado, Montevideo*)
END MergeLstIdsCDP;


(************ Predicados ****************)

PROCEDURE EsVaciaLstIdsCDP (lt: LstIdsCDP): BOOLEAN;
(* Devuelve TRUE si 'lt' es vacía, FALSE en otro caso. *)
BEGIN
	RETURN lt = NIL;
END EsVaciaLstIdsCDP;

PROCEDURE PerteneceLstIdsCDP (id: TIdCDP; lt: LstIdsCDP): BOOLEAN;
(* Devuelve TRUE si 'id' pertenece a 'lt', FALSE en otro caso. *)
VAR parar : BOOLEAN;
BEGIN
        parar := FALSE;
	IF lt <> NIL THEN
		WHILE (lt <> NIL) AND NOT parar DO
			IF Equal(lt^.id, id) THEN
				parar := TRUE;
			END;			
			lt := lt^.s;
		END;
	END;
	RETURN parar;
END PerteneceLstIdsCDP;

(************ Selectoras  ****************)

PROCEDURE PrimeroLstIdsCDP (lt: LstIdsCDP): TIdCDP;
(* Precondicion: NOT EsVaciaLstIdsCDP (lt).
 Devuelve el primer elemento de 'lt'. *)
BEGIN
	RETURN lt^.id;
END PrimeroLstIdsCDP;

PROCEDURE RestoLstIdsCDP (lt: LstIdsCDP): LstIdsCDP;
(* Precondicion: NOT EsVaciaLstIdsCDP (lt).
 Devuelve 'lt' sin el primer elemento. *)
BEGIN
	RETURN lt^.s;
END RestoLstIdsCDP;

(************ Salida  **************)
PROCEDURE ImprimirLstIdsCDP (lt: LstIdsCDP);
(* Imprime todos los identificadores que pertenecen a 'lt'con un espacio en
 blanco despues de cada elemento.
 Imprime un nueva linea al final. *)
BEGIN
	WHILE lt <> NIL DO
	WriteString(lt^.id);
	WriteString(" ");
	lt := lt^.s;
	END;
	WriteLn;
END ImprimirLstIdsCDP;


(************ Destructoras **************)

PROCEDURE EliminarLstIdsCDP (id: TIdCDP; VAR lt: LstIdsCDP);
(* Precondicion: PerteneceLstIdsCDP (id, lt).
  Remueve de 'lt' el identificador 'id'. Libera la memoria asignada al
  elemento removido. *)
VAR anterior, actual, temp : LstIdsCDP;
BEGIN
  	IF Equal(lt^.id,id) THEN
		temp := lt;
		lt := lt^.s;
	ELSE
		anterior := lt;
		actual := lt;
		WHILE NOT Equal(actual^.id,id) DO
		anterior := actual;
		actual := actual^.s;
		END;
		temp := anterior^.s;
		anterior^.s := actual^.s;
	END;
	DISPOSE(temp);

END EliminarLstIdsCDP;

PROCEDURE DestruirLstIdsCDP (VAR lt: LstIdsCDP);
(* Libera la memoria asignada a'lt' y sus elementos. *)
VAR s : LstIdsCDP;
BEGIN
	WHILE lt <> NIL DO
		s := lt;
		(*DISPOSE(lt^.id);*)
		lt := lt^.s;
		DISPOSE (s);
	END;
END DestruirLstIdsCDP;

END LstIdsCDP.
