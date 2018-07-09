(* 47***** *)
IMPLEMENTATION MODULE ColaToken;
(*******************************************************************************
Módulo de definicion de ColaToken.

El TAD ColaToken define una Cola cuyos elementos son del tipo abstracto
de datos Token.

Laboratorio de Programación 2.
InCo-FI-UDELAR
*******************************************************************************)

FROM Token IMPORT Token, DestruirToken, ImprimirToken, CopiarToken;
FROM Storage IMPORT DEALLOCATE, ALLOCATE;
FROM STextIO IMPORT WriteString;
TYPE
        
		Cola = POINTER TO 	nodo;
        nodo = RECORD 
        			t : Token;
        			sig : Cola;
				END;

        ColaToken = POINTER TO Selector;  (* Opaco *)
        Selector = 	RECORD
        				primero : Cola;
        				ultimo : Cola;
        			END;

(************ Constructoras *************)

PROCEDURE CrearColaToken(): ColaToken;
(* Devuelve la Cola vacía. *)
VAR c : ColaToken;
BEGIN
	NEW (c);
	c^.primero := NIL;
	c^.ultimo := NIL;
	RETURN c;
END CrearColaToken;


PROCEDURE EncolarColaToken (t: Token; VAR c: ColaToken);
(* Inserta el Token 't' al final de la cola 'c'. *)
BEGIN
	IF c^.primero = NIL THEN
		NEW (c^.primero);
		c^.primero^.t := t;
		c^.primero^.sig := NIL;
		c^.ultimo := c^.primero;
	ELSE
		NEW(c^.ultimo^.sig);
		c^.ultimo := c^.ultimo^.sig;
		c^.ultimo^.t := t;
		c^.ultimo^.sig := NIL;
	END;
END EncolarColaToken;
(************ Predicados ****************)

PROCEDURE EsVaciaColaToken (c: ColaToken): BOOLEAN;
(* Devuelve TRUE si la Cola 'c' es vacía, FALSE en otro caso. *)
BEGIN
	IF c = NIL THEN
		RETURN c = NIL;
	ELSE
		RETURN c^.primero = NIL;
	END;
END EsVaciaColaToken;

(************ Selectoras ****************)

PROCEDURE PrimeroColaToken (c: ColaToken): Token;
(* Precondicion: NOT EsVaciaColaToken (c).
   Devuelve el primer elemento de la Cola 'c'. *)
BEGIN
	RETURN c^.primero^.t;
END PrimeroColaToken;

PROCEDURE DesencolarColaToken (VAR c: ColaToken);
(* Precondicion: NOT EsVaciaColaToken (c).
   Quita el primer elemento de la Cola 'c'. *)
 VAR temp : Cola;
 BEGIN
 	temp := c^.primero;
 	(*DestruirToken(temp^.t);*)
	c^.primero := c^.primero^.sig;
	DISPOSE(temp);
 END DesencolarColaToken;
   
(********** Salida **********************)
PROCEDURE ImprimirColaToken(c : ColaToken);
(* Imprime en la salida estandar la Cola Token c. 
 Se imprime un espacio entre cada Token*)
VAR  t : Cola;
BEGIN
	t := c^.primero;
	WHILE t <> NIL DO
		ImprimirToken(t^.t);
		IF t^.sig <> NIL THEN WriteString(' '); END;
		t := t^.sig;
	END;
END ImprimirColaToken;

(************ Destructoras **************)

PROCEDURE DestruirColaToken (VAR c: ColaToken);
(* Libera la memoria reservada por la Cola y sus elementos. *)
VAR x, temp : Cola;
BEGIN
	(*WHILE c^.primero <> NIL DO
		DesencolarColaToken(c);
	END;*)
	x := c^.primero;
	WHILE x <> NIL DO
		temp := x;
		x := x^.sig;
		DestruirToken(temp^.t);
		DISPOSE(temp);
	END;
	DISPOSE(c);
	c := NIL;
END DestruirColaToken;

END ColaToken.
