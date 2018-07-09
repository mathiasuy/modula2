MODULE TestCPrio3;
(******************************************************************************
Módulo de prueba unitaria del TAD CPrioPaquetes.

Prueba el uso de distintos valores de 'd' del TAD.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM Ruta    IMPORT CrearRuta;
FROM Paquete IMPORT TIdPaquete,Paquete, CrearPaquete, DestruirPaquete;
FROM CPrioPaquetes IMPORT CPrioPaquetes, CrearCPrioPaquetesVacia, InsertarCPrioPaquetes, ImprimirCPrioPaquetes, DestruirCPrioPaquetes,
                          ObtenerMinCPrioPaquetes, RemoverMinCPrioPaquetes, EsLlenaCPrioPaquetes, EsVaciaCPrioPaquetes;
FROM STextIO         IMPORT WriteString, WriteLn;
FROM WholeStr IMPORT IntToStr;



PROCEDURE WriteStringLn (str: ARRAY OF CHAR);
(* Despliega una cadena de caracteres y posiciona el cursor en la siguiente línea. *)
BEGIN
   WriteString(str);
   WriteLn
END WriteStringLn;



PROCEDURE EvaluarCond (cond: BOOLEAN; msgTrue, msgFalse: ARRAY OF CHAR);
(* Evalua la condición 'cond', si es verdadera despliega 'msgTrue' sino despliega 'msgFalse' *)
BEGIN
   IF (cond) THEN
      WriteStringLn (msgTrue)
   ELSE
      WriteStringLn (msgFalse)
   END
END EvaluarCond;


PROCEDURE Prio(i:INTEGER) : INTEGER;
(* Dado un entero de 1 a 100, retorna un valor de prioridad asociado*)
BEGIN
  RETURN ((i * 4896) MOD (114) + (i * 1256) MOD (94) + 1)
END Prio;

(* Principal *)
VAR
    c: CPrioPaquetes;
    p: Paquete;
    i, j, prio: INTEGER;
    pid : TIdPaquete;
BEGIN
   FOR i := 1 TO 5 DO

      c := CrearCPrioPaquetesVacia(i);
 
      FOR j := 1 TO 100 DO
         (* la formula de prioridad del paquete no importa en este caso, 
            se usa la prioridad "prio" *)
         prio := Prio(j);
         IntToStr(prio,pid);
         InsertarCPrioPaquetes(prio,CrearPaquete (pid, CrearRuta(), 1, "[ costo ]"),c)
      END;
   
      EvaluarCond (EsLlenaCPrioPaquetes(c), "OK-es llena", "ERROR-no es llena");
     
      ImprimirCPrioPaquetes(c);

      FOR j := 1 TO 100 DO
         p := ObtenerMinCPrioPaquetes(c);
         RemoverMinCPrioPaquetes(c);
         DestruirPaquete(p)
      END;

   EvaluarCond (EsVaciaCPrioPaquetes(c), "OK-es vacia", "ERROR-no es vacia");

   DestruirCPrioPaquetes(c);
   WriteStringLn("OK-destruir")
 
   END;

   WriteStringLn("OK-fin")
   
END TestCPrio3.
