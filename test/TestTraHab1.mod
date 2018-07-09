MODULE TestTraHab1;
(******************************************************************************
Módulo de prueba unitaria del TAD TramosHabilitados.

Prueba las funcionalidades básicas del TAD.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM Tramo             IMPORT Tramo, CrearTramo, CDPOrigenTramo, 
                                CDPDestinoTramo, CostoTramo;
FROM TramosHabilitados IMPORT TramosHabilitados, CrearTramosHabilitados, 
                                EsVaciaTramosHabilitados, Destinos, Origenes,
                                InsertarTramo, ObtenerTramo, PerteneceTramo, 
                                EliminarTramo, DestruirTramosHabilitados;
FROM LstIdsCDP         IMPORT LstIdsCDP, EsVaciaLstIdsCDP, DestruirLstIdsCDP,
                                ImprimirLstIdsCDP;
FROM STextIO           IMPORT WriteString, WriteLn;



PROCEDURE WriteStrLn(msg : ARRAY OF CHAR);
BEGIN
    WriteString(msg);
    WriteLn;
END WriteStrLn;


VAR
	lst01 : LstIdsCDP;
    tramos : TramosHabilitados;
    tr01, trCnj : Tramo;
BEGIN
    WriteStrLn('Conjunto vacio');
    tramos := CrearTramosHabilitados();
	
    IF EsVaciaTramosHabilitados(tramos) THEN
        WriteStrLn('OK, es vacio')
    ELSE
        WriteStrLn('ERROR, no es vacio')
    END;
	
    IF PerteneceTramo('MA', 'MO', tramos) THEN
        WriteStrLn('ERROR, pertence')
    ELSE
        WriteStrLn('OK, no pertence')
    END;
	
    lst01 := Destinos('MA', tramos);
    WriteStrLn('Imprimiendo Destinos MA: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    lst01 := Origenes(tramos);
	
    IF EsVaciaLstIdsCDP(lst01) THEN
        WriteStrLn('OK, Origenes es vacia')
    ELSE
        WriteStrLn('ERROR, Origenes no es vacia')
    END;
	
    DestruirLstIdsCDP(lst01);
    DestruirTramosHabilitados(tramos);
    WriteLn;
    
    WriteStrLn('Conjunto con un solo elemento');
    tr01 := CrearTramo('MA', 'CA', 0);
    tramos := CrearTramosHabilitados();
    InsertarTramo(tr01, tramos);
	
    IF EsVaciaTramosHabilitados(tramos) THEN
        WriteStrLn('ERROR, es vacio')
    ELSE
        WriteStrLn('OK, no es vacio')
    END;
	
    IF PerteneceTramo('MA', 'MO', tramos) THEN
        WriteStrLn('ERROR, MA -> MO pertence')
    ELSE
        WriteStrLn('OK, MA -> MO no pertence')
    END;
	
    IF PerteneceTramo('MA', 'CA', tramos) THEN
        WriteStrLn('OK, MA -> CA pertence')
    ELSE
        WriteStrLn('ERROR, MA -> CA no pertence')
    END;
	
    IF PerteneceTramo('TR', 'CA', tramos) THEN
        WriteStrLn('ERROR, TR -> CA pertence')
    ELSE
        WriteStrLn('OK, TR -> CA no pertence')
    END;
	
    IF PerteneceTramo('CA', 'MA', tramos) THEN
        WriteStrLn('ERROR, CA -> MA pertence')
    ELSE
        WriteStrLn('OK, CA -> MA no pertence')
    END;
	
    lst01 := Destinos('MO', tramos);
	
    IF EsVaciaLstIdsCDP(lst01) THEN
        WriteStrLn('OK, Destinos MO es vacia')
    ELSE
        WriteStrLn('ERROR, Destinos MO no es vacia')
    END;
	
    DestruirLstIdsCDP(lst01);
    lst01 := Destinos('MA', tramos);
    WriteStrLn('Imprimiendo Destinos MA: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    lst01 := Origenes(tramos);
    WriteStrLn('Imprimiendo Origenes: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    trCnj := ObtenerTramo(CDPOrigenTramo(tr01), CDPDestinoTramo(tr01), tramos);
	
    IF trCnj = tr01 THEN
        WriteStrLn('OK, trCnj es tr01')
    ELSE
        WriteStrLn('ERROR, trCnj no es tr01')
    END;
	
    EliminarTramo(CDPOrigenTramo(tr01), CDPDestinoTramo(tr01), tramos);
	
    IF EsVaciaTramosHabilitados(tramos) THEN
        WriteStrLn('OK, es vacio')
    ELSE
        WriteStrLn('ERROR, no es vacio')
    END;
	
    IF PerteneceTramo('MA', 'CA', tramos) THEN
        WriteStrLn('ERROR, MA -> CA pertence')
    ELSE
        WriteStrLn('OK, MA -> CA no pertence')
    END;
	
    lst01 := Origenes(tramos);
    WriteStrLn('Imprimiendo Origenes: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    DestruirTramosHabilitados(tramos);
    WriteLn;
    
    WriteStrLn('Conjunto con varios elementos');
    tramos := CrearTramosHabilitados();
    InsertarTramo(CrearTramo('CA', 'MA', 11), tramos);
    InsertarTramo(CrearTramo('MA', 'CL', 21), tramos);
    InsertarTramo(CrearTramo('CA', 'MO', 12), tramos);
    InsertarTramo(CrearTramo('TR', 'CL', 31), tramos);
    InsertarTramo(CrearTramo('CA', 'TR', 13), tramos);
    InsertarTramo(CrearTramo('TR', 'MO', 33), tramos);
    InsertarTramo(CrearTramo('MA', 'TR', 23), tramos);
    InsertarTramo(CrearTramo('TR', 'MA', 32), tramos);
    InsertarTramo(CrearTramo('CA', 'CL', 14), tramos);
    InsertarTramo(CrearTramo('MA', 'MO', 22), tramos);
	
    IF EsVaciaTramosHabilitados(tramos) THEN
        WriteStrLn('ERROR, es vacio')
    ELSE
        WriteStrLn('OK, no es vacio')
    END;
	
    IF PerteneceTramo('MO', 'MA', tramos) THEN
        WriteStrLn('ERROR, MO -> MA pertence')
    ELSE
        WriteStrLn('OK, MA -> CA no pertence')
    END;
	
    IF PerteneceTramo('MA', 'MO', tramos) THEN
        WriteStrLn('OK, MA -> MO pertence')
    ELSE
        WriteStrLn('ERROR, MA -> MO no pertence')
    END;
	
    lst01 := Origenes(tramos);
    WriteStrLn('Imprimiendo Origenes: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    lst01 := Destinos('MA', tramos);
    WriteStrLn('Imprimiendo Destinos MA: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    lst01 := Destinos('TR', tramos);
    WriteStrLn('Imprimiendo Destinos TR: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    lst01 := Destinos('MO', tramos);
    WriteStrLn('Imprimiendo Destinos MO: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    lst01 := Destinos('CA', tramos);
    WriteStrLn('Imprimiendo Destinos CA: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    lst01 := Destinos('CL', tramos);
    WriteStrLn('Imprimiendo Destinos CL: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    trCnj := ObtenerTramo('CA', 'TR', tramos);
	
    IF CostoTramo(trCnj) = 13 THEN
        WriteStrLn('OK, costo de tramo CA -> TR es 13')
    ELSE
        WriteStrLn('ERROR, costo de tramo CA -> TR no es 13')
    END;
	
    trCnj := ObtenerTramo('TR', 'CL', tramos);
	
    IF CostoTramo(trCnj) = 31 THEN
        WriteStrLn('OK, costo de tramo TR -> CL es 31')
    ELSE
        WriteStrLn('ERROR, costo de tramo TR -> CL no es 31')
    END;
	
    EliminarTramo('CA', 'TR', tramos);
    EliminarTramo('MA', 'CL', tramos);
    EliminarTramo('TR', 'MO', tramos);
    lst01 := Destinos('TR', tramos);
    WriteStrLn('Imprimiendo Destinos TR: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    lst01 := Destinos('MA', tramos);
    WriteStrLn('Imprimiendo Destinos MA: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    lst01 := Destinos('CA', tramos);
    WriteStrLn('Imprimiendo Destinos CA: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    DestruirTramosHabilitados(tramos);
    WriteLn;
    WriteStrLn('FIN!')
END TestTraHab1.
