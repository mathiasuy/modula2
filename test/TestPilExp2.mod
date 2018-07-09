MODULE TestPilExp2;
(******************************************************************************
Módulo de prueba unitaria del TAD PilaExpresion.

Prueba el uso de memoria dinamica del TAD.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM Expresion       IMPORT Expresion, CrearExpresionSimple, CrearExpresionOper,
                            DestruirExpresion;
FROM ExpresionSimple IMPORT CrearExpresionSimpleVariable,
                            CrearExpresionSimpleValor;               
FROM PilaExpresion   IMPORT PilaExpresion, CrearPilaExpresion, CimaPilaExpresion,
                            ApilarPilaExpresion, DesapilarPilaExpresion,
                            DestruirPilaExpresion;
FROM Token           IMPORT TOper;               
FROM STextIO         IMPORT WriteString, WriteLn;


CONST
   MAX_ITER = 5000;
   MAX_ELEMS = 400;



PROCEDURE WriteStringLn (str: ARRAY OF CHAR);
(* Despliega una cadena de caracteres y posiciona el cursor en la siguiente línea. *)
BEGIN
   WriteString(str);
   WriteLn
END WriteStringLn;



(* Principal *)
VAR
   p: PilaExpresion;
   e: Expresion;
   i,j: CARDINAL;
BEGIN
   WriteStringLn ("Prueba DestruirPilaExpresion");
   
   FOR i := 1 TO MAX_ITER DO
      p := CrearPilaExpresion();
      
      FOR j := 1 TO MAX_ELEMS DO
         ApilarPilaExpresion (CrearExpresionSimple (CrearExpresionSimpleValor (1)), p);
         ApilarPilaExpresion (CrearExpresionOper (OP_MAS,
         CrearExpresionSimple (CrearExpresionSimpleValor (2)),
         CrearExpresionSimple (CrearExpresionSimpleValor (4))), p);
         ApilarPilaExpresion (CrearExpresionSimple (CrearExpresionSimpleVariable ("capacidad")), p);
      END;
      
      DestruirPilaExpresion(p)
   END;
   
   WriteStringLn ("Prueba DesapilarPilaExpresion");
   
   FOR i := 1 TO MAX_ITER DO
      p := CrearPilaExpresion();
      
      FOR j := 1 TO MAX_ELEMS DO
         ApilarPilaExpresion (CrearExpresionSimple (CrearExpresionSimpleValor (1)), p);
         ApilarPilaExpresion (CrearExpresionOper (OP_MAS,
         CrearExpresionSimple (CrearExpresionSimpleValor (2)),
         CrearExpresionSimple (CrearExpresionSimpleValor (4))), p);
         ApilarPilaExpresion (CrearExpresionSimple (CrearExpresionSimpleVariable ("capacidad")), p);
      END;
      
      FOR j := 1 TO MAX_ELEMS*3 DO
         e := CimaPilaExpresion (p);
         DesapilarPilaExpresion (p);
		 DestruirExpresion (e)
      END;
      
      DestruirPilaExpresion(p)
   END;
   
   WriteString ("OK-Fin prueba")
END TestPilExp2.
