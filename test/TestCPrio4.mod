MODULE TestCPrio4;
(******************************************************************************
Módulo de prueba unitaria del TAD CPrioPaquetes.

Prueba de empates en las prioridades.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM Ruta    IMPORT CrearRuta;
FROM Paquete IMPORT TIdPaquete, Paquete, CrearPaquete, DestruirPaquete, IdPaquete;
FROM CPrioPaquetes IMPORT CPrioPaquetes, CrearCPrioPaquetesVacia, InsertarCPrioPaquetes, ImprimirCPrioPaquetes, DestruirCPrioPaquetes,
                          ObtenerMinCPrioPaquetes, RemoverMinCPrioPaquetes;
FROM STextIO         IMPORT WriteString, WriteLn;

FROM WholeStr IMPORT IntToStr;

(*cantidad de paquetes a insertar, tiene que ser par*)
CONST CANT_PAQUETES = 20;

PROCEDURE WriteStringLn (str: ARRAY OF CHAR);
(* Despliega una cadena de caracteres y posiciona el cursor en la siguiente línea. *)
BEGIN
   WriteString(str);
   WriteLn
END WriteStringLn;



(* Principal *)
VAR
    c: CPrioPaquetes;
    p: Paquete;
    pid: TIdPaquete;
    i : INTEGER;
BEGIN
   c := CrearCPrioPaquetesVacia(3);


   FOR i := 1 TO (CANT_PAQUETES DIV 2) DO
      (* la formula de prioridad del paquete no importa en este caso, 
         se usa la prioridad "prio" *)
      IntToStr(i,pid);
      InsertarCPrioPaquetes(5,CrearPaquete (pid, CrearRuta(), 1, "[ costo ]"),c)
   END;

   FOR i := 1 TO (CANT_PAQUETES DIV 2) DO
      (* la formula de prioridad del paquete no importa en este caso, 
         se usa la prioridad "prio" *)
      IntToStr(i+CANT_PAQUETES DIV 2,pid);
      InsertarCPrioPaquetes(10,CrearPaquete (pid, CrearRuta(), 1, "[ costo ]"),c)
   END;

   ImprimirCPrioPaquetes(c);  

   p := ObtenerMinCPrioPaquetes(c);
   RemoverMinCPrioPaquetes(c);

   ImprimirCPrioPaquetes(c);  

   WriteStringLn(IdPaquete(p));
   DestruirPaquete(p);

   FOR i := 1 TO (CANT_PAQUETES-1) DO
      p := ObtenerMinCPrioPaquetes(c);
      RemoverMinCPrioPaquetes(c);
      WriteStringLn(IdPaquete(p));
      DestruirPaquete(p)
   END;


   DestruirCPrioPaquetes(c);
   WriteStringLn("OK-fin")
   
END TestCPrio4.
