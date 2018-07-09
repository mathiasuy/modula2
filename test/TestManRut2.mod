MODULE TestManRut2;
(******************************************************************************
Modulo de prueba unitaria del TAD ManejadorRutas.

Prueba las funcionalidades basicas del TAD. 
En la prueba se construye 'rutas' con las operaciones del TAD Rutas, 
dado que el objetivo de este caso de prueba es solamente probar RutaOptima 
sin introducir posibles errores derivados de la operación ConstruirRutas.
En la Tarea 'rutas' se debe construir a partir de la operación ConstruirRutas.

Laboratorio de Programacion 2.
InCo-FI-UDELAR
******************************************************************************)

FROM Rutas IMPORT Rutas, DestruirRutas, ImprimirRutas, AgregarHijoRutas,
CrearHojaRutas, HijoRutas;
FROM STextIO IMPORT WriteString, WriteLn;
FROM ManejadorRutas IMPORT RutaOptima;
FROM CnjCDPs IMPORT CnjCDPs, CrearCnjCDPs, InsertarCnjCDPs, DestruirCnjCDPs, ObtenerCnjCDPs;
FROM CDP IMPORT CDP, CrearCDP, DisminuirCapacidadActualCDP, 
AumentarCapacidadActualCDP;
FROM Ruta IMPORT Ruta, ImprimirRuta, DestruirRuta, EsVaciaRuta;
FROM StdChans IMPORT StdOutChan;

VAR
    rutas, hijo             : Rutas;
    r                       : Ruta;
    cnj                     : CnjCDPs;
    cdpUSA, cdpZAZ, cdpBCN  : CDP;
BEGIN

       (************ RutaOptima *************)

       rutas := CrearHojaRutas('MVD',0);
       AgregarHijoRutas(CrearHojaRutas('USA',20),rutas);
      
       cnj :=  CrearCnjCDPs();
       InsertarCnjCDPs(CrearCDP('MVD',25,'Uruguay','Montevideo'),cnj);
       cdpUSA := CrearCDP('USA',1,'USA','Chicago');
       InsertarCnjCDPs(cdpUSA,cnj);

       WriteString('1-Rutas es '); WriteLn;
       ImprimirRutas(rutas);     
       WriteLn;

       (* espero: MVD-USA *)
       r := RutaOptima(rutas,cnj);

       WriteString('1-Ruta Optima es '); WriteLn;
       ImprimirRuta(r,StdOutChan());
       WriteLn;

       DestruirRuta(r);

       AgregarHijoRutas(CrearHojaRutas('ZAZ',15),rutas);
       hijo := HijoRutas('ZAZ',rutas);
       AgregarHijoRutas(CrearHojaRutas('USA',19),hijo);

       InsertarCnjCDPs(CrearCDP('ZAZ',1,'Espania','Zaragoza'),cnj);

       WriteString('2-Rutas es '); WriteLn;
       ImprimirRutas(rutas);     
       WriteLn;

       (*espero MVD-ZAZ-USA *)
       r := RutaOptima(rutas,cnj);
 
       WriteString('2a-Ruta Optima es '); WriteLn;
       ImprimirRuta(r,StdOutChan());
       WriteLn;

       DestruirRuta(r);

       cdpZAZ := ObtenerCnjCDPs('ZAZ',cnj);
       DisminuirCapacidadActualCDP(cdpZAZ); 

       (* espero MVD-USA porque ZAZ no tiene capacidad *)
       r := RutaOptima(rutas,cnj);
 
       WriteString('2b-Ruta Optima es '); WriteLn;
       ImprimirRuta(r,StdOutChan());
       WriteLn;

       DestruirRuta(r);

       cdpBCN := CrearCDP('BCN',1,'Espania','Barcelona');
       InsertarCnjCDPs(cdpBCN,cnj);

       AgregarHijoRutas(CrearHojaRutas('BCN',16),hijo);
       hijo := HijoRutas('BCN',hijo);
       AgregarHijoRutas(CrearHojaRutas('USA',17),hijo);

       AgregarHijoRutas(CrearHojaRutas('BCN',11),rutas);
       hijo := HijoRutas('BCN',rutas);
       AgregarHijoRutas(CrearHojaRutas('USA',20),hijo);

       AumentarCapacidadActualCDP(cdpZAZ); 

       WriteString('3-Rutas es '); WriteLn;
       ImprimirRutas(rutas);     
       WriteLn;

       (*espero MVD-ZAZ-BCN-USA *)
       r := RutaOptima(rutas,cnj);
 
       WriteString('3a-Ruta Optima es '); WriteLn;
       ImprimirRuta(r,StdOutChan());
       WriteLn;

       DisminuirCapacidadActualCDP(cdpZAZ); 

       (*espero MVD-BCN-USA porque ZAZ no tiene capacidad y 
                es la de menor orden lexicografico *)
       r := RutaOptima(rutas,cnj);
 
       WriteString('3b-Ruta Optima es '); WriteLn;
       ImprimirRuta(r,StdOutChan());
       WriteLn;


       DisminuirCapacidadActualCDP(cdpBCN); 

       (*espero MVD-USA porque ZAZ y BNC no tienen capacidad *)
       r := RutaOptima(rutas,cnj);
 
       WriteString('3c-Ruta Optima es '); WriteLn;
       ImprimirRuta(r,StdOutChan());
       WriteLn;

       DestruirRuta(r);

       DisminuirCapacidadActualCDP(cdpUSA);

       (*espero vacio porque USA no tiene capacidad *)
       r := RutaOptima(rutas,cnj);

       IF EsVaciaRuta(r) THEN
           WriteString('OK - La ruta es vacia');
       ELSE
           WriteString('ERROR - La ruta No es vacia');
       END;
       WriteLn;

       DestruirRuta(r);
       DestruirRutas(rutas);
       DestruirCnjCDPs(cnj);

END TestManRut2.
