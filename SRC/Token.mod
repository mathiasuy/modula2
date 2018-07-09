(* 47***** *)
IMPLEMENTATION MODULE Token;
(*******************************************************************************
Modulo de definicion del TAD Token.

Cada token representa a los posibles elementos sintacticos de una expresion.
Un token puede ser: una ExpresionSimple, un operador aritmetico o un parentesis.
Laboratorio de Programacion 2.
InCo-FING-UDELAR

*******************************************************************************)
FROM ExpresionSimple IMPORT ImprimirExpresionSimple, ExpresionSimple, CopiarExpresionSimple, DestruirExpresionSimple;
FROM Storage IMPORT ALLOCATE, DEALLOCATE;
FROM STextIO IMPORT WriteString;
FROM SWholeIO IMPORT WriteCard;

TYPE
   TipoToken = (expresion, operador, parentesis);
   Token = POINTER TO token;  (* Opaco *)
   token = RECORD 
                  CASE t : TipoToken OF
                     expresion : 
                           ex : ExpresionSimple |
                     operador : 
                           op : TOper|
                     parentesis :
                           pa : Parentesis|
                  END;
               END;

(************ Constructoras *************)

PROCEDURE CrearTokenExpresionSimple(e : ExpresionSimple): Token;
(* Devuelve el token formado por la ExpresionSimple 'e'. *)
VAR t : Token;
BEGIN
   NEW (t);
   t^.t := expresion;
   t^.ex := e;
   RETURN t;   
END CrearTokenExpresionSimple;

PROCEDURE CrearTokenOper(o : TOper) : Token;
(* Devuelve el token formado por el operador 'o'. *)
VAR t : Token;
BEGIN
   NEW (t);
   t^.t := operador;
   t^.op := o;
   RETURN t;
END CrearTokenOper;

PROCEDURE CrearTokenParentesis(s : Parentesis) : Token;
(* Devuelve el token formado por el parentesis 's'. *)
VAR t : Token;
BEGIN
   NEW (t);
   t^.t := parentesis;
   t^.pa := s;
   RETURN t;
END CrearTokenParentesis;

PROCEDURE CopiarToken (t : Token) : Token;
(* Devuelve una copia limpia del token 't'. *)
VAR n : Token;
BEGIN
   NEW (n);
  (*) n^.t := t^.t;*)
   CASE t^.t OF
      expresion   : n^.ex := CopiarExpresionSimple (t^.ex);
                     n^.t := expresion|
      operador    : n^.op := t^.op;
                     n^.t := operador |
      parentesis  : n^.pa := t^.pa;
                     n^.t := parentesis |
   END;
  RETURN n;
END CopiarToken;

(************ Predicados ********************)

PROCEDURE EsExpresionSimpleToken(t : Token) : BOOLEAN;
(* Devuelve TRUE si el token 't' esta formado por una ExpresionSimple 
   y FALSE en otro caso. *)
BEGIN
   RETURN t^.t = expresion;
END EsExpresionSimpleToken;

PROCEDURE EsOperadorToken(t : Token) : BOOLEAN;
(* Devuelve TRUE si el token 't' esta formado por un operador aritmetico 
   y FALSE en otro caso. *)
BEGIN

   RETURN t^.t = operador;
END EsOperadorToken;

PROCEDURE EsParentesisToken(t : Token) : BOOLEAN;
(* Devuelve TRUE si el token 't' esta formado por un parentesis 
   y FALSE en otro caso. *)
BEGIN
   RETURN t^.t = parentesis;
END EsParentesisToken;


(************ Selectoras ****************)

PROCEDURE ExpresionSimpleToken(t : Token) : ExpresionSimple;
(* Precondicion: EsExpresionSimpleToken(t). 
   Devuelve la ExpresionSimple del token 't' *)
BEGIN
(*WriteString('llego');*)
   RETURN t^.ex;
END ExpresionSimpleToken;

PROCEDURE OperadorToken(t:Token) : TOper;
(* Precondicion: EsOperadorToken(t). 
   Devuelve el operador del token 't' *)
BEGIN
   RETURN t^.op;
END OperadorToken;

PROCEDURE ParentesisToken(t : Token) : Parentesis;
(* Precondicion: EsParentesisToken(t). 
   Devuelve el parentesis del token 't' *)
BEGIN
   RETURN t^.pa;
END ParentesisToken;

(*************  Salida *****************)
PROCEDURE ImprimirToken(t : Token);
(* Imprime en la salida estandar el Token t 
   TOper       = (OP_MAS, OP_MENOS, OP_POR, OP_DIV);
   Parentesis  = (PARINI, PARFIN );
   *)
BEGIN
   CASE t^.t OF
         expresion   :  ImprimirExpresionSimple(t^.ex)|
         operador    :  CASE t^.op OF
                           OP_MAS: WriteString("+")|
                           OP_MENOS: WriteString("-")|
                           OP_POR: WriteString("*")|
                           OP_DIV: WriteString("/")|
                        END|
         parentesis  :  CASE t^.pa OF
                           PARINI: WriteString("(")|
                           PARFIN: WriteString(")")|
                        END|
   END;
END ImprimirToken;

(************ Destructoras **************)

PROCEDURE DestruirToken(VAR t : Token);
(* Libera la memoria reservada por el token 't' y sus elementos. *)
BEGIN
   IF t^.t = expresion THEN
      DestruirExpresionSimple(t^.ex);
   END;
   DISPOSE(t);
END DestruirToken;

END Token.
