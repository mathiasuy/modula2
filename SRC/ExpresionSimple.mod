(* 47***** *)
IMPLEMENTATION MODULE ExpresionSimple;
(*******************************************************************************
Modulo de definicion de ExpresionSimple.

El TAD ExpresionSimple representa expresiones que pueden ser 
valores enteros o variables. 


Una ExpresionSimple puede ser reducida a una ExpresionSimple con
un valor entero si:
- la expresion ya es un valor entero
- la expresion es una variable y se conoce su valor

Ejemplos de ExpresionSimple:
20
costo

Laboratorio de Programación 2.
InCo-FI-UDELAR
*******************************************************************************)
FROM STextIO IMPORT WriteString;
FROM SWholeIO IMPORT WriteInt;
FROM Storage IMPORT ALLOCATE, DEALLOCATE;
FROM Strings IMPORT Equal;

TYPE
        ExpresionSimple = POINTER TO Expresion;

        Expresion = RECORD
                       CASE variable : BOOLEAN OF
                          TRUE  : 
                              var : TValorVariable |
                          FALSE :
                              n   : INTEGER |
                    END;
                  END;
        
        
(************ Constructoras *************)

PROCEDURE CrearExpresionSimpleValor (val : INTEGER): ExpresionSimple;
(* Devuelve una ExpresionSimple con valor 'val'. *)
VAR x : ExpresionSimple;
BEGIN
  NEW (x);
  x^.variable := FALSE;
  x^.n := val;
  RETURN x;
END CrearExpresionSimpleValor;

PROCEDURE CrearExpresionSimpleVariable (var : TVariable): ExpresionSimple;
(* Devuelve una ExpresionSimple variable, con nombre 'var'. *)
VAR x : ExpresionSimple;
BEGIN
  NEW (x);
  x^.variable := TRUE;
  x^.var.variable := var;
  RETURN x;
END CrearExpresionSimpleVariable;

PROCEDURE CopiarExpresionSimple (e : ExpresionSimple): ExpresionSimple;
(* Devuelve una copia limpia de la ExpresionSimple 'e'. *)
VAR copy : ExpresionSimple;
BEGIN
  NEW (copy);
  copy^.variable := e^.variable;
  IF e^.variable THEN
    (*copy^.variable := TRUE;
    NEW (copy^.var);*)
    copy^.var.variable := e^.var.variable;
    copy^.var.valor := e^.var.valor;
  ELSE
    (*copy^.variable := FALSE;*)
    copy^.n := e^.n;
  END;
  RETURN copy;
END CopiarExpresionSimple;
   
(************ Predicados ********************)
PROCEDURE EsValorExpresionSimple(e: ExpresionSimple): BOOLEAN;
(* Devuelve TRUE unicamente si la ExpresionSimple es un valor y FALSE en caso
   contrario. *)
BEGIN
  (*WriteString("llego");*)
  RETURN NOT e^.variable;
END EsValorExpresionSimple;

PROCEDURE EsVariableExpresionSimple(e: ExpresionSimple): BOOLEAN;
(* Devuelve TRUE unicamente si la ExpresionSimple es una variable y FALSE en caso
   contrario. *)
BEGIN
  RETURN e^.variable;
END EsVariableExpresionSimple;

(************ Selectoras ****************)


PROCEDURE ValorExpresionSimple (e: ExpresionSimple): INTEGER;
(* Precondicion: EsValorExpresionSimple(e).
   Devuelve el valor de la ExpresionSimple. *)
BEGIN
  RETURN e^.n;
END ValorExpresionSimple;

(************ Operaciones ****************)

PROCEDURE ReducirExpresionSimple(val: TValorVariable; 
                                 e: ExpresionSimple): ExpresionSimple;
(* Reduce la ExpresionSimple 'e' segun el valor de la variable 
   que contiene 'val'. 
   La ExpresionSimple retornada no comparte memoria con 'e'.

   Por lo tanto:
   - Si EsValorExpresionSimple(e) entonces devuelve una copia de 'e'.
   - Si EsVariableExpresionSimple(e) y 'val.variable' coincide con la variable
     entonces devuelve una expresion con valor 'val.valor'.
   - Si EsVariableExpresionSimple(e) y 'val.variable' no coincide con la variable
     entonces devuelve una copia de 'e'.
*)
BEGIN
  IF EsValorExpresionSimple(e) THEN
    RETURN  CopiarExpresionSimple (e);
  ELSIF EsVariableExpresionSimple(e) AND Equal(val.variable, e^.var.variable) THEN
    RETURN CrearExpresionSimpleValor (val.valor);
  ELSIF EsVariableExpresionSimple(e) AND (val.valor <> e^.var.valor) THEN
    RETURN  CopiarExpresionSimple (e);
  END;
END ReducirExpresionSimple;

(************ Salida ********************)

PROCEDURE ImprimirExpresionSimple (e: ExpresionSimple);
(* Imprime en pantalla los datos de la ExpresionSimple pasada como parametro.
   Si EsValorExpresionSimple(e) se imprime el valor
   Si EsVariableExpresionSimple(e) se imprime el nombre de la variable.
*)
BEGIN
    (*IF EsValorExpresionSimple (e) THEN WriteString("es vacia"); END;
    WriteString("llegoooooooooooooooooooooo");*)
    (*WriteString(e^.var.variable);*)
  IF EsValorExpresionSimple(e) THEN

    WriteInt(e^.n,1); 
  ELSE
    WriteString(e^.var.variable);
  END;
END ImprimirExpresionSimple;

(************ Destructoras **************)

PROCEDURE DestruirExpresionSimple (VAR e : ExpresionSimple);
(* Libera la memoria reservada. *)
BEGIN
  DISPOSE (e);
END DestruirExpresionSimple;

END ExpresionSimple.
