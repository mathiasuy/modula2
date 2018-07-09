MODULE TestCPrio2;
(******************************************************************************
Módulo de prueba unitaria del TAD CPrioPaquetes.

Prueba de casos de borde.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM Ruta    IMPORT CrearRuta;
FROM Paquete IMPORT TIdPaquete,Paquete, CrearPaquete, DestruirPaquete, IdPaquete;
FROM CPrioPaquetes IMPORT CPrioPaquetes, CrearCPrioPaquetesVacia, InsertarCPrioPaquetes, ImprimirCPrioPaquetes, DestruirCPrioPaquetes,
                          ObtenerMinCPrioPaquetes, RemoverMinCPrioPaquetes, EsLlenaCPrioPaquetes;
FROM STextIO         IMPORT WriteString, WriteLn;
FROM WholeStr IMPORT IntToStr,StrToInt,ConvResults;



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


PROCEDURE EvaluarCond2 (cond: BOOLEAN; msgTrue, msgFalse: ARRAY OF CHAR);
(* Evalua la condición 'cond', si es verdadera despliega 'msgTrue' sino despliega 'msgFalse'
   No despliega salto de línea. *)
BEGIN
   IF (cond) THEN
      WriteString (msgTrue)
   ELSE
      WriteString (msgFalse)
   END
END EvaluarCond2;


PROCEDURE Prio(i:INTEGER) : INTEGER;
(* Dado un entero de 1 a 100, retorna un valor de prioridad asociado*)
BEGIN
  RETURN ((i * 4896) MOD (114) + (i * 1256) MOD (94) + 1)
END Prio;

(* Principal *)
VAR
    c: CPrioPaquetes;
    p: Paquete;
    i, j, prio, prio2: INTEGER;
    pid : TIdPaquete;
    res : ConvResults;
BEGIN
   c := CrearCPrioPaquetesVacia(4);

   FOR i := 1 TO 100 DO
      (* la formula de prioridad del paquete no importa en este caso, 
         se usa la prioridad "prio" *)
      prio := Prio(i);
      IntToStr(prio,pid);
      InsertarCPrioPaquetes(prio,CrearPaquete (pid, CrearRuta(), 1, "[ costo ]"),c)
   END;

   ImprimirCPrioPaquetes(c);

   EvaluarCond (EsLlenaCPrioPaquetes(c), "OK-es llena", "ERROR-no es llena");

   prio := 0;

   FOR i := 1 TO 4 DO
      FOR j := 1 TO 25 DO
         p := ObtenerMinCPrioPaquetes(c);
         RemoverMinCPrioPaquetes(c);
	 StrToInt(IdPaquete(p),prio2,res);
         EvaluarCond2(prio <= prio2, "-OK","-ERROR");
         prio := prio2;
         DestruirPaquete(p)
      END;
      WriteLn;
      ImprimirCPrioPaquetes(c)
   END;

   DestruirCPrioPaquetes(c);
   WriteStringLn("OK-fin")
   
END TestCPrio2.
