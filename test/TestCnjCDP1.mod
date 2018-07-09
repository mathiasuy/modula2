MODULE TestCnjCDP1;
(******************************************************************************
Módulo de prueba unitaria del TAD CnjCDPs.

Prueba las funcionalidades básicas del TAD.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM CDP       IMPORT CDP, CrearCDP, IdCDP;
FROM CnjCDPs   IMPORT CnjCDPs, CrearCnjCDPs, InsertarCnjCDPs, EsVacioCnjCDPs, 
                       PerteneceCnjCDPs, ObtenerCnjCDPs, IdsCnjCDPs, 
					   EliminarCnjCDPs, DestruirCnjCDPs;
FROM LstIdsCDP IMPORT LstIdsCDP, ImprimirLstIdsCDP, DestruirLstIdsCDP;
FROM STextIO   IMPORT WriteString, WriteLn;


PROCEDURE WriteStrLn(msg : ARRAY OF CHAR);
BEGIN
    WriteString(msg);
    WriteLn;
END WriteStrLn;


VAR
	cdp01, cdp02, cdp03, cdp04, cdp05, cdpCnj : CDP;
    cnj01 : CnjCDPs;
    lst01 : LstIdsCDP;
    
BEGIN
    WriteStrLn('Conjunto vacio');
    cdp01 := CrearCDP('cdpMO', 10, 'Uruguay', 'Montevideo');
    cnj01 := CrearCnjCDPs();
	
    IF EsVacioCnjCDPs(cnj01) THEN
        WriteStrLn('OK, es vacio')
    ELSE
        WriteStrLn('ERROR, no vacio')
    END;
	
    IF PerteneceCnjCDPs(IdCDP(cdp01), cnj01) THEN
        WriteStrLn('ERROR, MO pertence')
    ELSE
        WriteStrLn('OK, MO no pertence')
    END;
	
    lst01 := IdsCnjCDPs(cnj01);
    WriteStrLn('Imprimiendo Lista: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    DestruirCnjCDPs(cnj01);
    WriteLn;
    
    WriteStrLn('Conjunto con un solo elemento');
    cdp01 := CrearCDP('cdpMO', 10, 'Uruguay', 'Montevideo');
    cdp02 := CrearCDP('cdpCA', 20, 'Uruguay', 'Canelones');
    cdp03 := CrearCDP('cdpMA', 30, 'Uruguay', 'Maldonado');
    cnj01 := CrearCnjCDPs();
    InsertarCnjCDPs(cdp01, cnj01);
	
    IF EsVacioCnjCDPs(cnj01) THEN
        WriteStrLn('ERROR, es vacio')
    ELSE
        WriteStrLn('OK, no vacio')
    END;
	
    IF PerteneceCnjCDPs(IdCDP(cdp01), cnj01) THEN
        WriteStrLn('OK, MO pertence')
    ELSE
        WriteStrLn('ERROR, MO no pertence')
    END;
	
    IF PerteneceCnjCDPs(IdCDP(cdp03), cnj01) THEN
        WriteStrLn('ERROR, MA pertence')
    ELSE
        WriteStrLn('OK, MA no pertence')
    END;
	
    cdpCnj := ObtenerCnjCDPs(IdCDP(cdp01), cnj01);
	
    IF cdpCnj = cdp01 THEN
        WriteStrLn('OK, MO es el CDP esperado')
    ELSE
        WriteStrLn('ERROR, MO era el CDP esperado')
    END;
	
    lst01 := IdsCnjCDPs(cnj01);
    WriteStrLn('Imprimiendo Lista: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    EliminarCnjCDPs(IdCDP(cdp01), cnj01);
	
    IF EsVacioCnjCDPs(cnj01) THEN
        WriteStrLn('OK, es vacio')
    ELSE
        WriteStrLn('ERROR, no vacio')
    END;
	
    lst01 := IdsCnjCDPs(cnj01);
    WriteStrLn('Imprimiendo Lista: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    DestruirCnjCDPs(cnj01);
    WriteLn;
    
    WriteStrLn('Conjunto con varios elementos');
    cdp01 := CrearCDP('cdpMO', 10, 'Uruguay', 'Montevideo');
    cdp02 := CrearCDP('cdpCA', 20, 'Uruguay', 'Canelones');
    cdp03 := CrearCDP('cdpMA', 30, 'Uruguay', 'Maldonado');
    cdp04 := CrearCDP('cdpTR', 40, 'Uruguay', 'Trinidad');
    cdp05 := CrearCDP('cdpCL', 50, 'Uruguay', 'CerroLargo');
    cnj01 := CrearCnjCDPs();
    InsertarCnjCDPs(cdp01, cnj01);
    InsertarCnjCDPs(cdp02, cnj01);
    InsertarCnjCDPs(cdp03, cnj01);
    InsertarCnjCDPs(cdp04, cnj01);
	
    IF PerteneceCnjCDPs(IdCDP(cdp01), cnj01) THEN
        WriteStrLn('OK, MO pertence')
    ELSE
        WriteStrLn('ERROR, MO no pertence')
    END;
	
    IF PerteneceCnjCDPs(IdCDP(cdp05), cnj01) THEN
        WriteStrLn('ERROR, CL pertence')
    ELSE
        WriteStrLn('OK, CL no pertence')
    END;
	
    IF PerteneceCnjCDPs(IdCDP(cdp03), cnj01) THEN
        WriteStrLn('OK, MA pertence')
    ELSE
        WriteStrLn('ERROR, MA no pertence')
    END;
	
    IF PerteneceCnjCDPs(IdCDP(cdp05), cnj01) THEN
        WriteStrLn('ERROR, CL pertence')
    ELSE
        WriteStrLn('OK, CL no pertence')
    END;
	
    IF PerteneceCnjCDPs(IdCDP(cdp04), cnj01) THEN
        WriteStrLn('OK, TR pertence')
    ELSE
        WriteStrLn('ERROR, TR no pertence')
    END;
	
    lst01 := IdsCnjCDPs(cnj01);
    WriteStrLn('Imprimiendo Lista: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    cdpCnj := ObtenerCnjCDPs(IdCDP(cdp01), cnj01);
	
    IF cdpCnj = cdp01 THEN
        WriteStrLn('OK, MO es el CDP esperado')
    ELSE
        WriteStrLn('ERROR, MO era el CDP esperado')
    END;
	
    cdpCnj := ObtenerCnjCDPs(IdCDP(cdp03), cnj01);
	
    IF cdpCnj = cdp03 THEN
        WriteStrLn('OK, MA es el CDP esperado')
    ELSE
        WriteStrLn('ERROR, MA era el CDP esperado')
    END;
	
    EliminarCnjCDPs(IdCDP(cdp02), cnj01);
    EliminarCnjCDPs(IdCDP(cdp03), cnj01);
	
    IF PerteneceCnjCDPs(IdCDP(cdp02), cnj01) THEN
        WriteStrLn('ERROR, CA pertence')
    ELSE
        WriteStrLn('OK, CA no pertence')
    END;
	
    IF PerteneceCnjCDPs(IdCDP(cdp03), cnj01) THEN
        WriteStrLn('ERROR, MA pertence')
    ELSE
        WriteStrLn('OK, MA no pertence')
    END;
	
    lst01 := IdsCnjCDPs(cnj01);
    WriteStrLn('Imprimiendo Lista: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    cdpCnj := ObtenerCnjCDPs(IdCDP(cdp04), cnj01);
	
    IF cdpCnj = cdp04 THEN
        WriteStrLn('OK, MO es el CDP esperado')
    ELSE
        WriteStrLn('ERROR, MO era el CDP esperado')
    END;
	
    DestruirCnjCDPs(cnj01);
    WriteLn;
    WriteStrLn('FIN!')
END TestCnjCDP1.
