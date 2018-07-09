(* 47***** *)
IMPLEMENTATION MODULE PilaExpresion;
(*******************************************************************************
Módulo de definicion de PilaExpresion.

El TAD PilaExpresion define una Pila cuyos elementos son del tipo abstracto
de datos Expresion.

Laboratorio de Programación 2.
InCo-FI-UDELAR
*******************************************************************************)

FROM Expresion IMPORT Expresion, DestruirExpresion;
FROM Storage IMPORT ALLOCATE, DEALLOCATE;

TYPE
        PilaExpresion = POINTER TO Pila; (* Opaco *)

        Pila = RECORD
        			ex : Expresion;
        			sig : PilaExpresion;
        		END;

(************ Constructoras *************)

PROCEDURE CrearPilaExpresion(): PilaExpresion;
(* Devuelve la Pila vacia. *)
BEGIN
	RETURN NIL;
END CrearPilaExpresion;

PROCEDURE ApilarPilaExpresion (e: Expresion;
                                        VAR p: PilaExpresion);
(* Inserta la Expresion 'e' al principio de la Pila 'p'. *)
VAR pi : PilaExpresion;
BEGIN
	IF EsVaciaPilaExpresion(p) THEN
		NEW (p);
		p^.ex := e;
		p^.sig := NIL;
	ELSE
		NEW (pi);
		pi^.ex := e;
		pi^.sig := p;
		p := pi;
	END;
END ApilarPilaExpresion;

(************ Predicados ****************)

PROCEDURE EsVaciaPilaExpresion (p: PilaExpresion): BOOLEAN;
(* Devuelve TRUE si la Pila 'p' es vacia, FALSE en otro caso. *)
BEGIN
	RETURN p = NIL;
END EsVaciaPilaExpresion;

(************ Selectoras ****************)

PROCEDURE CimaPilaExpresion (p: PilaExpresion): Expresion;
(* Precondicion: NOT EsVaciaPilaExpresion (p).
   Devuelve el primer elemento de la pila 'p'. *)
BEGIN
	RETURN p^.ex;
END CimaPilaExpresion;

PROCEDURE DesapilarPilaExpresion (VAR p: PilaExpresion);
(* Precondicion: NOT EsVaciaPilaExpresion (p).
   Quita el primer elemento de la pila 'p'. *)
VAR temp : PilaExpresion;
BEGIN
	temp := p;
	p := p^.sig;
	DISPOSE(temp);
END DesapilarPilaExpresion;

(************ Destructoras **************)

PROCEDURE DestruirPilaExpresion (VAR p: PilaExpresion);
(* Libera la memoria reservada por la Pila 'p' y sus elementos. *)
BEGIN
	WHILE NOT EsVaciaPilaExpresion(p) DO
		DestruirExpresion(p^.ex);
		DesapilarPilaExpresion(p)
	END;
END DestruirPilaExpresion;

END PilaExpresion.
