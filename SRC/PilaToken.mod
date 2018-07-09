(* 47***** *)
IMPLEMENTATION MODULE PilaToken;
(*******************************************************************************
Módulo de definicion de Token.

El TAD PilaToken define una Pila cuyos elementos son del tipo abstracto
de datos Token.

Laboratorio de Programación 2.
InCo-FI-UDELAR
*******************************************************************************)

FROM Token IMPORT Token, DestruirToken;
FROM Storage IMPORT ALLOCATE, DEALLOCATE;
TYPE
        PilaToken = POINTER TO Pila; (* Opaco *)

        Pila = RECORD
        			t : Token;
        			sig : PilaToken;
        		END;

(************ Constructoras *************)

PROCEDURE CrearPilaToken(): PilaToken;
(* Devuelve la Pila vacia. *)
BEGIN
	RETURN NIL;
END CrearPilaToken;

PROCEDURE ApilarPilaToken (t: Token; VAR p: PilaToken);
(* Inserta el Token 't' al principio de la Pila 'p'. *)
VAR pr : PilaToken;
BEGIN
	IF EsVaciaPilaToken(p) THEN
		NEW(p);
		p^.t := t;
		p^.sig := NIL;
	ELSE
		NEW(pr);
		pr^.t := t;
		pr^.sig := p;
		p := pr;
	END;
END ApilarPilaToken;

(************ Predicados ****************)

PROCEDURE EsVaciaPilaToken (p: PilaToken): BOOLEAN;
(* Devuelve TRUE si la Pila 'p' es vacía, FALSE en otro caso. *)
BEGIN
	RETURN p = NIL;
END EsVaciaPilaToken;

(************ Selectoras ****************)

PROCEDURE CimaPilaToken (p: PilaToken): Token;
(* Precondicion: NOT EsVaciaPilaToken (p).
   Devuelve el primer elemento de la pila 'p'. *)
BEGIN
	RETURN p^.t;
END CimaPilaToken;

PROCEDURE DesapilarPilaToken (VAR p: PilaToken);
(* Precondicion: NOT EsVaciaPilaToken (p).
   Quita el primer elemento de la pila 'p'. *)
VAR temp : PilaToken;
BEGIN
	temp := p;
	p := p^.sig;
	(*DestruirToken(temp^.t);*)
	DISPOSE(temp);
END DesapilarPilaToken;

(************ Destructoras **************)

PROCEDURE DestruirPilaToken (VAR p: PilaToken);
(* Libera la memoria reservada por la Pila y sus elementos. *)
BEGIN
	WHILE p <> NIL DO
		DesapilarPilaToken (p);
	END;
END DestruirPilaToken;

END PilaToken.
