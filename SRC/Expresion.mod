(* 47***** *)
IMPLEMENTATION MODULE Expresion;
(*******************************************************************************
Modulo de definicion del TAD Expresion.

Una Expresion es un arbol binario cuyos nodos son operadores aritmeticos 
(vinculando sub-expresiones) y sus hojas valores enteros o variables.

Los elementos de tipo Expresion representan las expresiones aritmeticas usuales 
bien formadas. Estas pueden ser: 
- valor entero
- nombre de variable
- expresion operador expresion
- ( expresion )

Laboratorio de Programacion 2.
InCo-FIng-UDELAR
*******************************************************************************)
FROM PilaToken IMPORT PilaToken, CrearPilaToken, DesapilarPilaToken, CimaPilaToken, EsVaciaPilaToken,
                      ApilarPilaToken;
FROM Token IMPORT Token, OperadorToken, CopiarToken, TOper, EsOperadorToken,
                  CrearTokenOper, CrearTokenExpresionSimple;
FROM ColaToken IMPORT EncolarColaToken, CrearColaToken, EsVaciaColaToken, ColaToken,
                      PrimeroColaToken, DesencolarColaToken, DestruirColaToken;
FROM ExpresionSimple IMPORT CopiarExpresionSimple, ReducirExpresionSimple, ExpresionSimple, TValorVariable;
FROM Storage IMPORT ALLOCATE, DEALLOCATE;
FROM PilaExpresion IMPORT DesapilarPilaExpresion, CimaPilaExpresion, ApilarPilaExpresion, PilaExpresion, CrearPilaExpresion;
FROM ExpresionSimple IMPORT CrearExpresionSimpleValor, ValorExpresionSimple, EsValorExpresionSimple;
FROM Token IMPORT Parentesis,EsExpresionSimpleToken, ExpresionSimpleToken, EsParentesisToken, DestruirToken, ParentesisToken;

TYPE
      Expresion = POINTER TO arbol; (* opaco *)

      arbol = RECORD 
                e : Token;
                i : Expresion;
                d : Expresion;
              END;

(************ Constructoras *************)

PROCEDURE CrearExpresionVacia (): Expresion;
  (* Devuelve una Expresion vacia. *)
  BEGIN
    RETURN NIL;
END CrearExpresionVacia;

PROCEDURE CrearExpresionSimple (e: ExpresionSimple): Expresion;
  (* Devuelve una expresion simple que contiene 'e'. *)
  VAR n : Expresion;
  BEGIN
      NEW (n);
      n^.e := CrearTokenExpresionSimple(e);
      n^.i := NIL;
      n^.d := NIL;
      RETURN n;
END CrearExpresionSimple; 
PROCEDURE CrearExpresionOper (op: TOper; izq, der: Expresion): Expresion;
  (* Devuelve una nueva Expresion que vincula las subexpresiones 'izq' y 
     'der' mediante el operador 'op'. *)
  VAR n : Expresion;
  BEGIN
      NEW (n);
      n^.e := CrearTokenOper(op);
      n^.i := izq;
      n^.d := der;
      RETURN n;
END CrearExpresionOper; 
PROCEDURE ColaTokenAExpresion (VAR c : ColaToken) : Expresion;
  (* Precondicion: NOT EsVaciaColaToken(c).
     Precondicion: 'c' corresponde a una expresion aritmetica bien formada. 
     Los tokens de 'c' estan ordenados de acuerdo a la notacion infija
     de la expresion.
     Devuelve la Expresion que representa la cola de tokens en 'c'.
     Al terminar se debe cumplir EsVaciaColaToken (c).	
     Se debe respetar los parentesis y el 
     orden de precedencia usual de los operadores.  *)
  VAR pos : ColaToken;
      t : Token;
      p : PilaExpresion;
      izq, der : Expresion;
  BEGIN
    pos := InfijaAPosfija(c);
    p := CrearPilaExpresion();

    WHILE NOT EsVaciaColaToken(pos) DO
        t := PrimeroColaToken(pos);
        IF EsExpresionSimpleToken(t) THEN
          ApilarPilaExpresion(CrearExpresionSimple(CopiarExpresionSimple(ExpresionSimpleToken(t))),p); (*creo nodo numero a agregar a la pila de expresion*)
          DestruirToken(t);
        ELSE(*IF EsOperadorToken(t) THEN*)
              der := CimaPilaExpresion(p);
              DesapilarPilaExpresion(p);
              izq := CimaPilaExpresion(p);
              DesapilarPilaExpresion(p);
              ApilarPilaExpresion(CrearExpresionOper(OperadorToken(t), izq, der), p);
              DestruirToken(t);
        END;
        DesencolarColaToken(pos);
    END; (*recorro la cola de entrada hasta agotarla*)
    (*Devuelvo el resto de la pila*)
    DestruirColaToken(pos);
    (*DestruirPilaExpresion(p);*)
    RETURN CimaPilaExpresion(p);
END ColaTokenAExpresion; 

PROCEDURE InfijaAPosfija (VAR c : ColaToken) : ColaToken;
  (* Precondicion: 'c' corresponde a una expresion aritmetica bien formada. 
     Los tokens de 'c' estan ordenados de acuerdo a la notacion infija.
     Devuelve una cola de tokens con los mismos elementos que 'c', pero
     cambia el orden del dado por la notacion infija al dado por la notacion 
     posfija. La cola devuelta no comparte memoria con 'c'.
     Por ejemplo si 'c' es: 1 -> OP_MAS -> 2
     devuelve 1 -> 2 -> OP_MAS. 
     Al terminar se debe cumplir EsVaciaColaToken (c).	
     
     Esta operacion es auxiliar a ColaTokenAExpresion.
     Se debe respetar los parentesis y el 
     orden de precedencia usual de los operadores.
   *)
  PROCEDURE Es(t : Token): CHAR;
  BEGIN
    IF EsExpresionSimpleToken(t) THEN  
        RETURN "e"
    ELSIF EsOperadorToken(t)   THEN 
        CASE OperadorToken(t) OF
          OP_POR  : RETURN "*"|
          OP_DIV  : RETURN "/"|
          OP_MAS  : RETURN "+"|
          OP_MENOS: RETURN "-"|
        END;
    ELSE
        IF ParentesisToken(t) = PARINI 
        THEN  RETURN "(";
        ELSE  RETURN ")"
        END;
    END;
  END Es;

  PROCEDURE Procedencia(c1 : CHAR):CARDINAL;
  (*de izquierda a derecha*)
  BEGIN
    CASE c1 OF
      "/","*": RETURN 1|
      "+","-": RETURN 2|
    END;
  END Procedencia;

  PROCEDURE DevolverParentesis(VAR p : PilaToken; VAR n : ColaToken);
  (* PRECONDICION: NOT EsVaciaPilaToken(p) y el primero no es parentesis 
    (siempre se va a cumplir para una ec bien fomrada)*)
  VAR cima : Token;
  BEGIN  
      cima := CimaPilaToken(p);
      WHILE (NOT EsVaciaPilaToken(p)) AND 
      NOT (EsParentesisToken(cima) AND (ParentesisToken(cima) = PARINI)) DO
          EncolarColaToken(cima,n);
          DesapilarPilaToken(p);
          cima := CimaPilaToken(p);
      END; 
      DesapilarPilaToken(p);(*elimino el parentesis de la pila*)
  END DevolverParentesis;

  VAR t, cima : Token;
      p : PilaToken;
      c1, c2 : CHAR;
      n : ColaToken;
  BEGIN
    n := CrearColaToken();
    p := CrearPilaToken();
    WHILE NOT EsVaciaColaToken(c) DO
        t := PrimeroColaToken(c);
        c1 := Es(t);
        CASE c1 OF
            "e" :  EncolarColaToken(t,n)|
            "(" :  ApilarPilaToken(t,p)|                      
            ")" :  DevolverParentesis(p,n)|
            "*","/","+","-":  IF NOT EsVaciaPilaToken(p) THEN
                                cima := CimaPilaToken(p);
                                c2 := Es(cima);
                                IF (c2<>"(") AND (Procedencia(c1) >= Procedencia(c2)) THEN
                                  EncolarColaToken(cima,n);
                                  DesapilarPilaToken(p);
                                END;
                              END;
                              ApilarPilaToken(t,p);|    
        END;          
        DesencolarColaToken(c);
  END; (*recorro la cola de entrada hasta agotarla*)
      (*Devuelvo el resto de la pila*) 
      WHILE NOT EsVaciaPilaToken(p) DO 
        EncolarColaToken(CimaPilaToken(p),n); 
        DesapilarPilaToken(p);
      END;    
      RETURN n;
END InfijaAPosfija; 
PROCEDURE CopiarExpresion (e : Expresion) : Expresion;
  (* Devuelve una copia de la Expresion 'e' sin compartir memoria. *)
  VAR n : Expresion;
  BEGIN
      IF EsVaciaExpresion(e) THEN
        RETURN NIL;
      ELSE
        NEW(n);
        n^.e := CopiarToken(e^.e);
        n^.i := CopiarExpresion(e^.i);
        n^.d := CopiarExpresion(e^.d);
        RETURN n;
      END;
END CopiarExpresion; 

(************ Predicados *************)
PROCEDURE EsVaciaExpresion (e: Expresion): BOOLEAN;
  (* Devuelve TRUE unicamente si la Expresion 'e' es vacia y FALSE en caso
     contrario. *)
  BEGIN
    RETURN e = NIL;
END EsVaciaExpresion; 
PROCEDURE EsExpresionSimple (e: Expresion): BOOLEAN;
  (* Precondicion: NOT EsVaciaExpresion (e).
     Devuelve TRUE si la Expresion 'e' esta formada por una ExpresionSimple y 
     FALSE en otro caso. *)
  BEGIN
    RETURN EsExpresionSimpleToken(e^.e)
END EsExpresionSimple; 
PROCEDURE EsOperExpresion (e: Expresion): BOOLEAN;
    (* Precondicion: NOT EsVaciaExpresion (e).
       Devuelve TRUE si la expresion 'e' esta formada por un operador que
       une
       a dos subexpresiones y FALSE en otro caso. *)
    BEGIN
      RETURN EsOperadorToken(e^.e);
END EsOperExpresion; 

(************ Selectoras ****************)

PROCEDURE ObtenerOperExpresion (e: Expresion): TOper;
  (* Precondicion: NOT EsVaciaExpresion(e) AND EsOperExpresion(e).
     Devuelve el operador de la expresion 'e'. *)
  BEGIN
    RETURN OperadorToken(e^.e);
END ObtenerOperExpresion; 
PROCEDURE ObtenerExpresionSimple (e: Expresion): ExpresionSimple;
  (* Precondicion: NOT EsVaciaExpresion(e) AND EsExpresionSimple(e).
     Devuelve la ExpresionSimple de la Expresion 'e'. *)
  BEGIN
    RETURN ExpresionSimpleToken(e^.e)
END ObtenerExpresionSimple; 
PROCEDURE ObtenerIzqExpresion (e : Expresion): Expresion;
  (* Precondicion: NOT EsVaciaExpresion(e) AND EsOperExpresion(e).
     Devuelve la subexpresion izquierda de la Expresion 'e'. *)
  BEGIN
    RETURN e^.i;
END ObtenerIzqExpresion; 
PROCEDURE ObtenerDerExpresion (e : Expresion): Expresion;
  (* Precondicion: NOT EsVaciaExpresion(e) AND EsOperExpresion(e).
     Devuelve la subexpresion derecha de la Expresion 'e'. *)
  BEGIN
    RETURN e^.d
END ObtenerDerExpresion; 

(************ Operaciones *************)

PROCEDURE EvaluacionParcial (val : TValorVariable; e : Expresion) : Expresion;
  (* Crea y devuelve una Expresion que resulta de evaluar parcialmente la 
     Expresion 'e' con el valor 'val.valor' para la variable 'val.variable'. 
     La Expresion devuelta no comparte memoria con 'e'.

     Esta operacion reduce la Expresion todo lo que se pueda.
     - Para cada expresion simple, la misma se reduce usando 'val'
       para intentar llegar a un valor.
     - Para cada operador se procede a evaluar las subexpresiones y se
       reduce realizando la operacion correspondiente si es posible;
       esto es: si las subexpresiones reducen a expresiones simples de tipo valor.
       Las operaciones a aplicar son:
       - OP_MAS   : suma
       - OP_MENOS : resta
       - OP_POR   : multiplicacion
       - OP_DIV   : division entera
   
     Por ejemplo, si tenemos:
     val.variable = costo y val.valor = 250

     Si 'e' es: ( 10 - costo / 100 ) + saltos
     La Expresion devuelta seria: 8 + saltos.

  *)
  VAR r : INTEGER;
    izq, der : Expresion;
  BEGIN
    IF EsVaciaExpresion(e) THEN
      RETURN NIL;
    ELSIF EsVaciaExpresion(ObtenerDerExpresion(e)) AND EsVaciaExpresion(ObtenerIzqExpresion(e)) THEN
        RETURN CrearExpresionSimple (ReducirExpresionSimple(val, ObtenerExpresionSimple(e)));
    ELSE
          izq := EvaluacionParcial (val,ObtenerIzqExpresion(e));
          der := EvaluacionParcial (val,ObtenerDerExpresion(e));
          IF
          EsExpresionSimpleToken(izq^.e) AND EsExpresionSimpleToken(der^.e) AND 
          EsValorExpresionSimple(ObtenerExpresionSimple(izq)) AND EsValorExpresionSimple(ObtenerExpresionSimple(der))
          THEN
                    CASE ObtenerOperExpresion(e) OF
  OP_MAS   : r := ValorExpresionSimple(ObtenerExpresionSimple(izq)) + ValorExpresionSimple(ObtenerExpresionSimple(der))|
  OP_MENOS : r := ValorExpresionSimple(ObtenerExpresionSimple(izq)) - ValorExpresionSimple(ObtenerExpresionSimple(der))|
  OP_POR   : r := ValorExpresionSimple(ObtenerExpresionSimple(izq)) * ValorExpresionSimple(ObtenerExpresionSimple(der))|
  OP_DIV   : r := ValorExpresionSimple(ObtenerExpresionSimple(izq)) DIV ValorExpresionSimple(ObtenerExpresionSimple(der))|
                    END;
                    DestruirExpresion(der);
                    DestruirExpresion(izq);
                    RETURN CrearExpresionSimple(CrearExpresionSimpleValor(r));
          ELSE
                    RETURN CrearExpresionOper(ObtenerOperExpresion(e),izq,der);
          END;
    END;
END EvaluacionParcial; 

(************ Destructoras *************)
PROCEDURE DestruirExpresion (VAR e: Expresion);
  (* Libera la memoria reservada por la Expresion 'e' y todos sus elementos. *)
  BEGIN
    IF NOT EsVaciaExpresion(e) THEN
      DestruirExpresion(e^.i);
      DestruirExpresion(e^.d);
      DestruirToken(e^.e);
      DISPOSE(e);
    END;
END DestruirExpresion; 
END Expresion.
