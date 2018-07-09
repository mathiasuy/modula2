MODULE TestCPrio1;
(******************************************************************************
Módulo de prueba unitaria del TAD CPrioPaquetes.

Prueba las funcionalidades básicas del TAD.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM Ruta    IMPORT CrearRuta;
FROM Paquete IMPORT Paquete, CrearPaquete, DestruirPaquete, IdPaquete;
FROM CPrioPaquetes IMPORT CPrioPaquetes, CrearCPrioPaquetesVacia, InsertarCPrioPaquetes, ImprimirCPrioPaquetes, DestruirCPrioPaquetes,
                          ObtenerMinCPrioPaquetes, RemoverMinCPrioPaquetes, EsVaciaCPrioPaquetes;
FROM STextIO         IMPORT WriteString, WriteLn;

FROM Strings IMPORT Equal;


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



(* Principal *)
VAR
    c: CPrioPaquetes;
    p: Paquete;
BEGIN
   c := CrearCPrioPaquetesVacia(4);
   EvaluarCond (EsVaciaCPrioPaquetes(c), "OK-es vacia", "ERROR-no es vacia");


   InsertarCPrioPaquetes(5,CrearPaquete ("p5", CrearRuta(), 1, "[ 5 ]"),c);
   InsertarCPrioPaquetes(1,CrearPaquete ("p1", CrearRuta(), 1, "[ 1 ]"),c);
   InsertarCPrioPaquetes(3,CrearPaquete ("p3", CrearRuta(), 1, "[ 3 ]"),c);

   ImprimirCPrioPaquetes(c);
  
   EvaluarCond (EsVaciaCPrioPaquetes(c), "ERROR-es vacia", "OK-no es vacia");   
   
   p := ObtenerMinCPrioPaquetes(c);
   EvaluarCond (Equal(IdPaquete(p),"p1"), "OK-paquete correcto", "ERROR-paquete incorrecto");   
   RemoverMinCPrioPaquetes(c);
   DestruirPaquete(p);

   p := ObtenerMinCPrioPaquetes(c);
   EvaluarCond (Equal(IdPaquete(p),"p3"), "OK-paquete correcto", "ERROR-paquete incorrecto");   
   RemoverMinCPrioPaquetes(c);
   DestruirPaquete(p);

   p := ObtenerMinCPrioPaquetes(c);
   EvaluarCond (Equal(IdPaquete(p),"p5"), "OK-paquete correcto", "ERROR-paquete incorrecto");   

   EvaluarCond (EsVaciaCPrioPaquetes(c), "ERROR-es vacia", "OK-no es vacia");   

   RemoverMinCPrioPaquetes(c);
   DestruirPaquete(p);
   EvaluarCond (EsVaciaCPrioPaquetes(c), "OK-es vacia", "ERROR-no es vacia");


   DestruirCPrioPaquetes(c);
   WriteStringLn("OK-fin")
   
END TestCPrio1.
