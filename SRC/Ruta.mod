(* 47***** *)
IMPLEMENTATION MODULE Ruta;

(*FROM SWholeIO IMPORT WriteCard;  
FROM STextIO IMPORT WriteLn, WriteString;*)
FROM Storage IMPORT ALLOCATE, DEALLOCATE;
FROM Strings IMPORT Equal;
FROM CDP IMPORT TIdCDP;(*, IdCDP, ImprimirCDP, DestruirCDP;*)
FROM IOChan IMPORT ChanId;
IMPORT TextIO;
IMPORT WholeIO;

(******************************************************************************
Modulo de definicion de Ruta.

El TAD Ruta define la lista de indentificadores de CDPs que debe atravesar un
paquete.

Laboratorio de Programacion 2.
InCo-FI-UDELAR
******************************************************************************)

TYPE

    ruta = POINTER TO nodo;
    nodo	 = RECORD	
    			id  : TIdCDP;
				sig : ruta;
			END;    			
			
    Ruta = POINTER TO RECORD
    		primero : ruta;
		actual  : ruta;
		END;

(************ Constructoras *************)

PROCEDURE CrearRuta (): Ruta;
(* Devuelve una ruta vacia. *)
VAR r : Ruta;
BEGIN
	NEW(r);
	r^.primero := NIL;
	r^.actual := NIL;
	RETURN r;
END CrearRuta;

PROCEDURE InsertarCDPRuta (c: TIdCDP; VAR r: Ruta);
(* Inserta el id de CDP 'c' despues de la posicion actual de 'r'. *)
VAR temp : ruta;
BEGIN
	NEW (temp);
	temp^.id := c;
	IF EsVaciaRuta (r) THEN
		temp^.sig := NIL;
		r^.primero := temp;		
		r^.actual := temp;
	ELSE
		temp^.sig := r^.actual^.sig;
		r^.actual^.sig := temp;
		(*asigno a actual el que se inserto*)
		r^.actual := r^.actual^.sig;
	END;

END InsertarCDPRuta;

(* NUEVO *)
PROCEDURE RestoRuta (r: Ruta): Ruta;
(* Devuelve una copia sin compartir memoria de la Ruta 'r' a partir de 
   su posicion actual. 
   La posicion actual de la copia devuelta queda en su primer elemento.

   Si 'r' es vacia, se retorna una ruta vacia. *)
VAR t : Ruta;
	l : ruta;
BEGIN
	t := CrearRuta();
	l := r^.actual;
	WHILE l <> NIL DO
		InsertarCDPRuta(l^.id,t);
		l := l^.sig;
	END;
	IrInicioRuta(t);
	RETURN t;
END RestoRuta;

(************ Selectoras ****************)

PROCEDURE PrimerCDPRuta (r: Ruta): TIdCDP;
(* Precondicion: NOT EsVaciaRuta (r).
   Devuelve el primer elemento de 'r'. *)
BEGIN
	RETURN r^.primero^.id;
END PrimerCDPRuta;

PROCEDURE UltimoCDPRuta (r: Ruta): TIdCDP;
(* Precondicion: NOT EsVaciaRuta (r).
   Devuelve el último elemento de 'r'. *)
VAR j : ruta;
BEGIN
	j := r^.primero;
	
	WHILE j^.sig <> NIL DO
	  j := j^.sig;
	END;
	
	RETURN j^.id;
END UltimoCDPRuta;

PROCEDURE ActualCDPRuta (r: Ruta): TIdCDP;
(* Precondicion: NOT EsVaciaRuta (r).
   Devuelve el id de CDP de la posicion actual de 'r'. *)
BEGIN
	RETURN r^.actual^.id;
END ActualCDPRuta;

PROCEDURE SiguienteCDPRuta (r: Ruta): TIdCDP;
(* Precondicion: NOT EsVaciaRuta (r) AND NOT EsDestinoRuta(r).
   Devuelve el id de CDP de la posicion siguiente a la actual de 'r'. *)
BEGIN
	IF  EsUltimoRuta (r) THEN
		RETURN r^.primero^.id;
	ELSE
		RETURN  r^.actual^.sig^.id;
	END;
END SiguienteCDPRuta;

PROCEDURE IndiceRuta (r: Ruta): CARDINAL;
(* Devuelve el numero de elementos que hay hasta la posicion actual, incluida.
  Si EsVaciaRuta (r) devuelve 0. *)
VAR	 i : CARDINAL;
	 temp, actual : ruta;
BEGIN
	i := 0;
	IF NOT EsVaciaRuta(r) THEN
		temp := r^.primero;	
		actual := r^.actual;
		WHILE NOT Equal(temp^.id, actual^.id) DO
			i := i + 1;
			temp := temp^.sig;
		END;
		i := i + 1;
	
	END;
	RETURN i;
	
END IndiceRuta;

PROCEDURE Contar (r: Ruta): CARDINAL;
(* Devuelve el numero de elementos que hay hasta la posicion actual, incluida.
  Si EsVaciaRuta (r) devuelve 0. *)
VAR	 i : CARDINAL;
	 temp : ruta;
BEGIN
	i := 0;
	IF NOT EsVaciaRuta(r) THEN
		temp := r^.primero;	
		WHILE temp <> NIL DO
			i := i + 1;
			temp := temp^.sig;
		END;
	END;
	RETURN i;
	
END Contar;

(************ Operaciones ****************)

PROCEDURE IrInicioRuta (VAR r: Ruta);
(* Precondicion: NOT EsVaciaRuta (r).
  La posición actual se mueve al inicio de 'r'. *)
BEGIN
	r^.actual := r^.primero;	
END IrInicioRuta;

PROCEDURE IrSiguienteRuta (VAR r: Ruta);
(* Precondicion: NOT EsVaciaRuta (r).
   La posición actual se mueve al siguiente de 'r'.
   Si la posicion actual estaba en el ultimo elemento pasa al primero. *)
BEGIN
	IF EsUltimoRuta (r)
	THEN
		IrInicioRuta (r);
	ELSE
		r^.actual := r^.actual^.sig;
	END;
END IrSiguienteRuta;

(************ Predicados ****************)

PROCEDURE EsVaciaRuta (r: Ruta): BOOLEAN;
(* Devuelve TRUE si 'r' es vacía, FALSE en otro caso. *)
BEGIN
	RETURN r^.primero = NIL;
END EsVaciaRuta;

PROCEDURE EsUltimoRuta (r: Ruta): BOOLEAN;
(* Devuelve TRUE si 'r' está posicionada en su ultimo elemento *)
BEGIN
	IF r^.primero = NIL THEN
		RETURN FALSE;
	ELSE
		RETURN r^.actual^.sig = NIL;
	END
END EsUltimoRuta;

PROCEDURE ConcatenarRuta (VAR r1: Ruta; r2:Ruta);
(* Concatena r2 inmediatamente despues de la posicion actual.
  La posicion actual se mantiene en el mismo elemento.
  Se libera la memoria asignada a los restantes elementos de r1.
  La ruta modificada 'r1' y 'r2' no comparten memoria. *)
	PROCEDURE Insertar(id : TIdCDP; VAR r : ruta);
	VAR s: ruta;
	BEGIN
	        IF r = NIL THEN
			NEW (r);
			r^.id := id;
			r^.sig := NIL;			
		ELSE
			s := r;
			WHILE  s^.sig <> NIL DO
				s := s^.sig;
			END;
			NEW(s^.sig);
			s := s^.sig;
			s^.id := id;
			s^.sig := NIL;
		END;
	END Insertar;

VAR	t1, t2 : ruta;
	resto, temp : ruta;
BEGIN
	IF r1 <> NIL THEN
		t1 := r1^.primero;
		WHILE NOT Equal(t1^.id, r1^.actual^.id) DO
			t1 := t1^.sig
		END;
		resto := t1^.sig;

		WHILE resto <> NIL DO
			temp := resto;
			resto := resto^.sig;
			DISPOSE(temp);
		END;
		t1^.sig := NIL;
		
	END;

	IF r2 <> NIL THEN
		t2 := r2^.primero;
		IF t2 <> NIL THEN
			WHILE t2^.sig <> NIL DO
				Insertar(t2^.id,r1^.primero);
				t2 := t2^.sig;
			END;
			Insertar(t2^.id,r1^.primero);
		END;
	END;
END ConcatenarRuta;

(************ Salida ********************)

(* MODIFICADO *)
PROCEDURE ImprimirRuta (r: Ruta; cid : ChanId);
(* Imprime la cantidad de CDPs y luego
   los id de los CDPs de 'r' en el canal 'cid'.
   Se incluye un nueva linea luego de la impresión de cada elemento.
   Si la ruta es vacia se imprime un 0 y una nueva linea. *)
VAR j : ruta;
BEGIN
	j := r^.primero;
	WholeIO.WriteCard(cid,Contar(r),1);
	TextIO.WriteLn(cid);
	WholeIO.WriteCard(cid,IndiceRuta(r),1);
	TextIO.WriteLn(cid);
	IF j <> NIL  THEN
		TextIO.WriteString(cid,j^.id);
		WHILE j^.sig <> NIL DO
			TextIO.WriteLn(cid);
			TextIO.WriteString(cid,j^.sig^.id);			
			j := j^.sig;
		END;
		TextIO.WriteLn(cid);
	END;
	
END ImprimirRuta;


(************ Destructoras **************)

PROCEDURE RemoverActualRuta (VAR r: Ruta);
(* Precondicion: NOT EsVaciaRuta (r).
  Remueve el elemento de 'r' que esta en la posicion actual y libera la
  memoria asignada a el.
  La posicion actual pasa a ser la siguiente a la actual original.
  Si la posicion actual estaba en el ultimo elemento pasa al primero.
  Si en 'r' habia un unico elemento la posicion actual queda indefinida. *)
VAR temp, anterior, actual : ruta;
BEGIN
IF r <> NIL THEN
		temp := r^.actual;
		IF Equal(r^.primero^.id, temp^.id) THEN
			IF r^.actual^.sig <> NIL THEN
				r^.actual := temp^.sig;
			END;
			r^.primero := temp^.sig;
		ELSE	
			anterior := r^.primero;	
			actual := r^.primero;
			WHILE (NOT Equal(temp^.id, actual^.id)) DO
				anterior := actual;
				actual := actual^.sig;
			END;
			anterior^.sig := actual^.sig;
			IF actual^.sig = NIL THEN
				r^.actual := r^.primero;
			ELSE
				r^.actual := actual^.sig;
			END;
		END;
	    	DISPOSE(temp);		
END;
END RemoverActualRuta;

PROCEDURE DestruirRuta (VAR r: Ruta);
(* Libera la memoria asignada a 'r'. *)
VAR	j, temp : ruta;
	
BEGIN
	j := r^.primero;
	WHILE j <> NIL DO
		temp := j;
		j := j^.sig;
		DISPOSE(temp);
	END;
	DISPOSE(r);
END DestruirRuta;

END Ruta.
