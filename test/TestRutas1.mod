MODULE TestRutas1;
(******************************************************************************
Modulo de prueba unitaria del TAD Rutas.

Prueba las funcionalidades basicas del TAD.

Laboratorio de Programacion 2.
InCo-FI-UDELAR
******************************************************************************)

FROM Rutas IMPORT Rutas, CrearVaciaRutas, EsVaciaRutas, 
EsHojaRutas, EsHijoRutas, CrearHojaRutas, DestruirRutas, AgregarHijoRutas,
RaizRutas, CostoRutas, IdsHijosRutas, HijoRutas, ImprimirRutas,
 EliminarHijoRutas, MaxNivelRutas, CentrosPorNivel;
FROM CDP IMPORT TIdCDP;
FROM STextIO IMPORT WriteString, WriteLn;
FROM LstIdsCDP IMPORT LstIdsCDP, ImprimirLstIdsCDP, DestruirLstIdsCDP,
EsVaciaLstIdsCDP;


VAR
    r, r1, r2, r3, r4, r5, r6   : Rutas;
    id1, id2                    : TIdCDP;
    costo                       : CARDINAL;
    lis                         : LstIdsCDP;
BEGIN

       (************ Constructoras y Predicados *************)

        r1 := CrearVaciaRutas();

        IF EsVaciaRutas(r1) THEN
            WriteString("OK - r1 es vacia");
        ELSE
            WriteString("ERROR - r1 NO es vacia");
        END;
        WriteLn;

        DestruirRutas(r1);

        r1 := CrearHojaRutas("DEP001", 100);

        IF EsVaciaRutas(r1) THEN
            WriteString("ERROR - r1 es vacia");
        ELSE
            WriteString("OK - r1 NO es vacia");
        END;
        WriteLn;

        IF EsHojaRutas(r1) THEN
            WriteString("OK - r1 es hoja");
        ELSE
            WriteString("ERROR - r1 NO es hoja");
        END;
        WriteLn;

        IF EsHijoRutas("DEP001",r1) THEN
            WriteString("ERROR - DEP001 es hijo");
        ELSE
            WriteString("OK - DEP001 NO es hijo");
        END;
        WriteLn;

        IF EsHijoRutas("DEP002",r1) THEN
            WriteString("ERROR - DEP002 es hijo");
        ELSE
            WriteString("OK - DEP002 NO es hijo");
        END;
        WriteLn;
      
        DestruirRutas(r1);
       
        r1 := CrearHojaRutas("DEP001", 100);
        r2 := CrearHojaRutas("DEP002", 200);

        AgregarHijoRutas(r2,r1);

        IF EsHijoRutas("DEP001",r1) THEN
            WriteString("ERROR - DEP001 es hijo");
        ELSE
            WriteString("OK - DEP001 NO es hijo");
        END;
        WriteLn;

        IF EsHijoRutas("DEP002",r1) THEN
            WriteString("OK - DEP002 es hijo");
        ELSE
            WriteString("ERROR - DEP002 NO es hijo");
        END;
        WriteLn;

        IF EsHijoRutas("DEP001",r2) THEN
            WriteString("ERROR - DEP001 es hijo");
        ELSE
            WriteString("OK - DEP001 NO es hijo");
        END;
        WriteLn;

        
        (************ Selectoras ****************)

        id1 := RaizRutas(r1);
        WriteString("El identificador de la raiz es ");
        WriteString(id1);
        WriteLn;

        id2 := RaizRutas(r2);
        WriteString("El identificador de la raiz es ");
        WriteString(id2);
        WriteLn;

        costo := CostoRutas(r1);
        IF costo = 100 THEN
            WriteString("OK - El costo de la raiz es 100");
        ELSE
            WriteString("ERROR - El costo de la raiz es 100");
        END;
        WriteLn;
       
        costo := CostoRutas(r2);
        IF costo = 200 THEN
            WriteString("OK - El costo de la raiz es 200");
        ELSE
            WriteString("ERROR - El costo de la raiz NO es 200");
        END;
        WriteLn;
       
        r3 := CrearHojaRutas("DEP003", 300);
        r4 := CrearHojaRutas("DEP004", 400);
        
        AgregarHijoRutas(r3,r2);
        AgregarHijoRutas(r4,r1);
        
        costo := CostoRutas(r3);
        IF costo = 300 THEN
            WriteString("OK - El costo de la raiz es 300");
        ELSE
            WriteString("ERROR - El costo de la raiz NO es 300");
        END;
        WriteLn;

        costo := CostoRutas(r4);
        IF costo = 400 THEN
            WriteString("OK - El costo de la raiz es 400");
        ELSE
            WriteString("ERROR - El costo de la raiz NO es 400");
        END;
        WriteLn;

        (* se espera DEP002 y DEP004 *)
        lis := IdsHijosRutas(r1);
        WriteString("La lista de los hijos de r1 es: ");
        ImprimirLstIdsCDP (lis);
        DestruirLstIdsCDP(lis);

        (* se espera DEP003 *)
        lis := IdsHijosRutas(r2);
        WriteString("La lista de los hijos de r2 es: ");
        ImprimirLstIdsCDP (lis);
        DestruirLstIdsCDP(lis);

        (* se espera la lista vacia *)
        lis := IdsHijosRutas(r3);
        IF EsVaciaLstIdsCDP(lis) THEN
             WriteString("OK - La lista de hijos de r3 es vacia");
        ELSE
             WriteString("ERROR - La lista de hijos de NO r3 es vacia");
        END;
        WriteLn;
        DestruirLstIdsCDP(lis);

        r5 := CrearHojaRutas("DEP005", 500);
        AgregarHijoRutas(r5,r1);

        r6 := CrearHojaRutas("DEP002b", 600);
        AgregarHijoRutas(r6,r1);

        (* se espera DEP002 DEP002b DEP004 DEP005*)
        lis := IdsHijosRutas(r1);
        WriteString("La lista de los hijos de r1 es: ");
        ImprimirLstIdsCDP (lis);
        DestruirLstIdsCDP(lis);

        IF r2 = HijoRutas("DEP002",r1) THEN
            WriteString("OK - r2 es hijo de r1");
        ELSE
            WriteString("ERROR - r2 NO es hijo de r1");
        END;
        WriteLn;

       IF r4 = HijoRutas("DEP004",r1) THEN
            WriteString("OK - r4 es hijo de r1");
        ELSE
            WriteString("ERROR - r4 NO es hijo de r1");
        END;
        WriteLn;
        
        IF r3 = HijoRutas("DEP003",r2) THEN
            WriteString("OK - r3 es hijo de r2");
        ELSE
            WriteString("ERROR - r3 NO es hijo de r2");
        END;
        WriteLn;

        (************ Salida y Niveles ********************)

        WriteString("Impresion de Rutas r1");WriteLn;
        ImprimirRutas(r1);

        IF 2 = MaxNivelRutas(r1) THEN
           WriteString("OK - El maximo nivel de r1 es 2");
        ELSE
           WriteString("ERROR - El maximo nivel de r1 NO es 2");
        END;
        WriteLn;

        WriteString("Impresion de Rutas r2");WriteLn;
        ImprimirRutas(r2);

        IF 1 = MaxNivelRutas(r2) THEN
           WriteString("OK - El maximo nivel de r2 es 1");
        ELSE
           WriteString("ERROR - El maximo nivel de r2 NO es 1");
        END;
        WriteLn;
        
        WriteString("Impresion de Rutas r5");WriteLn;
        ImprimirRutas(r5);

        IF 0 = MaxNivelRutas(r5) THEN
           WriteString("OK - El maximo nivel de r5 es 0");
        ELSE
           WriteString("ERROR - El maximo nivel de r5 NO es 0");
        END;
        WriteLn;

        WriteString("Impresion de Rutas vacio");WriteLn;
        r := CrearVaciaRutas();
        ImprimirRutas(r);

        lis := CentrosPorNivel(0,r1);
        WriteString("Los centros del nivel 0 de r1 son: ");
        ImprimirLstIdsCDP (lis);
        DestruirLstIdsCDP(lis);

        lis := CentrosPorNivel(1,r1);
        WriteString("Los centros del nivel 1 de r1 son: ");
        ImprimirLstIdsCDP (lis);
        DestruirLstIdsCDP(lis);

        lis := CentrosPorNivel(2,r1);
        WriteString("Los centros del nivel 2 de r1 son: ");
        ImprimirLstIdsCDP (lis);
        DestruirLstIdsCDP(lis);

        (************ Destructoras **************)

        EliminarHijoRutas("DEP005", r1);
        WriteString("Se elimina DEP005 de r1"); WriteLn;
        WriteString("Impresion de Rutas r1");WriteLn;
        ImprimirRutas(r1);

        EliminarHijoRutas("DEP002b", r1);
        WriteString("Se elimina DEP002b de r1"); WriteLn;
        WriteString("Impresion de Rutas r1");WriteLn;
        ImprimirRutas(r1);
 
        EliminarHijoRutas("DEP002", r1);
        WriteString("Se elimina DEP002 de r1"); WriteLn;
        WriteString("Impresion de Rutas r1");WriteLn;
        ImprimirRutas(r1);
        
        r5 := CrearHojaRutas("DEP005", 500);
        AgregarHijoRutas(r5,r1);

        r6 := CrearHojaRutas("DEP02b", 500);
        AgregarHijoRutas(r6,r5);

        r2 := CrearHojaRutas("DEP002", 500);
        AgregarHijoRutas(r2,r4);
 
        WriteString("Impresion de Rutas r1");WriteLn;
        ImprimirRutas(r1);

        (* Destruyo *)
        DestruirRutas(r1);
        


END TestRutas1.
