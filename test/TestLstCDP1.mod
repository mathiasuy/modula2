MODULE TestLstCDP1;
(******************************************************************************
Módulo de prueba unitaria del TAD LstIdsCDP.

Prueba las funcionalidades básicas del TAD.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM CDP       IMPORT TIdCDP;
FROM LstIdsCDP IMPORT LstIdsCDP, CrearLstIdsCDP, InsertarTIdCDP, 
                       EsVaciaLstIdsCDP, PerteneceLstIdsCDP, PrimeroLstIdsCDP, 
					   RestoLstIdsCDP, ImprimirLstIdsCDP, EliminarLstIdsCDP, 
					   DestruirLstIdsCDP, MergeLstIdsCDP;
FROM Strings   IMPORT Equal, Assign;
FROM STextIO   IMPORT WriteString, WriteLn;



PROCEDURE WriteStrLn(msg : ARRAY OF CHAR);
BEGIN
    WriteString(msg);
    WriteLn;
END WriteStrLn;



VAR
	idCA, idMO, idMA, idCL, idTR, idPrim : TIdCDP;
    lst01, lst02 : LstIdsCDP;
BEGIN
    Assign('Canelones', idCA);
    Assign('Montevideo', idMO);
    Assign('Maldonado', idMA);
    Assign('CerroLargo', idCL);
    Assign('Trinidad', idTR);

    WriteStrLn('Lista vacia');
    lst01 := CrearLstIdsCDP();
	
    IF EsVaciaLstIdsCDP(lst01) THEN
        WriteStrLn('OK, es vacia')
    ELSE
        WriteStrLn('ERROR, no es vacia')
    END;
	
    IF PerteneceLstIdsCDP(idCA, lst01) THEN
        WriteStrLn('ERROR, pertence')
    ELSE
        WriteStrLn('OK, no pertence')
    END;
	
    WriteStrLn('Imprimiendo Lista: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    WriteLn;
    
    
    WriteStrLn('Lista con un solo elemento');
    lst01 := CrearLstIdsCDP();
    InsertarTIdCDP(idCA, lst01);
	
    IF EsVaciaLstIdsCDP(lst01) THEN
        WriteStrLn('ERROR, es vacia')
    ELSE
        WriteStrLn('OK, no es vacia')
    END;
	
    IF PerteneceLstIdsCDP(idCA, lst01) THEN
        WriteStrLn('OK, CA pertence')
    ELSE
        WriteStrLn('ERROR, CA no pertence')
    END;
	
    IF PerteneceLstIdsCDP(idMO, lst01) THEN
        WriteStrLn('ERROR, MO pertence')
    ELSE
        WriteStrLn('OK, MO no pertence')
    END;
	
    IF PerteneceLstIdsCDP(idMA, lst01) THEN
        WriteStrLn('ERROR, MA pertence')
    ELSE
        WriteStrLn('OK, MA no pertence')
    END;
	
    idPrim := PrimeroLstIdsCDP(lst01);
	
    IF Equal(idPrim, idCA) THEN
        WriteStrLn('OK, primer elemento es CA')
    ELSE
        WriteStrLn('ERROR, primer elemento no es CA')
    END;
	
    IF EsVaciaLstIdsCDP(RestoLstIdsCDP(lst01)) THEN
        WriteStrLn('OK, es vacia')
    ELSE
        WriteStrLn('ERROR, no es vacia')
    END;
	
    WriteStrLn('Imprimiendo Lista: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    EliminarLstIdsCDP(idCA, lst01);
	
    IF EsVaciaLstIdsCDP(lst01) THEN
        WriteStrLn('OK, es vacia')
    ELSE
        WriteStrLn('ERROR, no es vacia')
    END;
	
    DestruirLstIdsCDP(lst01);
    WriteLn;
    
    WriteStrLn('Lista con varios elementos');
    lst01 := CrearLstIdsCDP();
    InsertarTIdCDP(idCA, lst01);
    InsertarTIdCDP(idMA, lst01);
    InsertarTIdCDP(idCL, lst01);
    InsertarTIdCDP(idTR, lst01);
	
    IF EsVaciaLstIdsCDP(lst01) THEN
        WriteStrLn('ERROR, es vacia')
    ELSE
        WriteStrLn('OK, no es vacia')
    END;
	
    IF PerteneceLstIdsCDP(idTR, lst01) THEN
        WriteStrLn('OK, TR pertence')
    ELSE
        WriteStrLn('ERROR, TR no pertence')
    END;
	
    IF PerteneceLstIdsCDP(idMA, lst01) THEN
        WriteStrLn('OK, MA pertence')
    ELSE
        WriteStrLn('ERROR, MA no pertence')
    END;
	
    IF PerteneceLstIdsCDP(idMO, lst01) THEN
        WriteStrLn('ERROR, MO pertence')
    ELSE
        WriteStrLn('OK, MO no pertence')
    END;
	
    idPrim := PrimeroLstIdsCDP(lst01);
	
    IF Equal(idPrim, idCA) THEN
        WriteStrLn('OK, primer elemento es CA')
    ELSE
        WriteStrLn('ERROR, primer elemento no es CA')
    END;
	
    lst02 := RestoLstIdsCDP(lst01);
    idPrim := PrimeroLstIdsCDP(lst02);
	
    IF Equal(idPrim, idMA) THEN
        WriteStrLn('OK, primer elemento es MA')
    ELSE
        WriteStrLn('ERROR, primer elemento no es MA')
    END;
	
    IF EsVaciaLstIdsCDP(RestoLstIdsCDP(lst02)) THEN
        WriteStrLn('ERROR, es vacia')
    ELSE
        WriteStrLn('OK, no es vacia')
    END;
	
    WriteStrLn('Imprimiendo Lista 1: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    WriteStrLn('Imprimiendo Lista 2: [');
    ImprimirLstIdsCDP(lst02);
    WriteStrLn(']');
    EliminarLstIdsCDP(idMA, lst01);
    EliminarLstIdsCDP(idTR, lst01);
    WriteStrLn('Imprimiendo Lista 1: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
	
    
    WriteStrLn('Merge');
    
    WriteStrLn('Ambas vacias');
    lst01 := CrearLstIdsCDP();
    lst02 := CrearLstIdsCDP();
    MergeLstIdsCDP(lst01, lst02);
	
    IF EsVaciaLstIdsCDP(lst01) AND EsVaciaLstIdsCDP(lst01) THEN
        WriteStrLn('OK, ambas vacias')
    ELSE
        WriteStrLn('ERROR, no ambas vacias')
    END;
	
    DestruirLstIdsCDP(lst01);
    DestruirLstIdsCDP(lst02);
    
    WriteStrLn('Primera vacia y segunda no');
    lst01 := CrearLstIdsCDP();
    lst02 := CrearLstIdsCDP();
    InsertarTIdCDP(idCA, lst02);
    InsertarTIdCDP(idCL, lst02);
    InsertarTIdCDP(idMA, lst02);
    InsertarTIdCDP(idTR, lst02);
    MergeLstIdsCDP(lst01, lst02);
	
    IF NOT EsVaciaLstIdsCDP(lst01) AND EsVaciaLstIdsCDP(lst02) THEN
        WriteStrLn('OK, primera no vacia y segunda vacia')
    ELSE
        WriteStrLn('ERROR, primera vacia o segunda no vacia')
    END;
	
    WriteStrLn('Imprimiendo Lista 1: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    WriteStrLn('Imprimiendo Lista 2: [');
    ImprimirLstIdsCDP(lst02);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    DestruirLstIdsCDP(lst02);
    
    WriteStrLn('Primera no vacia y segunda vacia');
    lst01 := CrearLstIdsCDP();
    lst02 := CrearLstIdsCDP();
    InsertarTIdCDP(idCA, lst01);
    InsertarTIdCDP(idCL, lst01);
    InsertarTIdCDP(idMA, lst01);
    InsertarTIdCDP(idTR, lst01);
    MergeLstIdsCDP(lst01, lst02);
	
    IF NOT EsVaciaLstIdsCDP(lst01) AND EsVaciaLstIdsCDP(lst02) THEN
        WriteStrLn('OK, primera no vacia y segunda vacia')
    ELSE
        WriteStrLn('ERROR, primera vacia o segunda no vacia')
    END;
	
    WriteStrLn('Imprimiendo Lista 1: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    WriteStrLn('Imprimiendo Lista 2: [');
    ImprimirLstIdsCDP(lst02);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    DestruirLstIdsCDP(lst02);
    
    WriteStrLn('Ambas no vacias, sin interseccion');
    lst01 := CrearLstIdsCDP();
    lst02 := CrearLstIdsCDP();
    InsertarTIdCDP(idCL, lst01);
    InsertarTIdCDP(idMA, lst01);
    InsertarTIdCDP(idTR, lst01);
    InsertarTIdCDP(idCA, lst02);
    InsertarTIdCDP(idMO, lst02);
    MergeLstIdsCDP(lst01, lst02);
	
    IF NOT EsVaciaLstIdsCDP(lst01) AND EsVaciaLstIdsCDP(lst02) THEN
        WriteStrLn('OK, primera no vacia y segunda vacia')
    ELSE
        WriteStrLn('ERROR, primera vacia o segunda no vacia')
    END;
	
    WriteStrLn('Imprimiendo Lista 1: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    WriteStrLn('Imprimiendo Lista 2: [');
    ImprimirLstIdsCDP(lst02);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    DestruirLstIdsCDP(lst02);
    
    WriteStrLn('Ambas no vacias, con interseccion');
    lst01 := CrearLstIdsCDP();
    lst02 := CrearLstIdsCDP();
    InsertarTIdCDP(idCA, lst01);
    InsertarTIdCDP(idCL, lst01);
    InsertarTIdCDP(idMA, lst01);
    InsertarTIdCDP(idTR, lst01);
    InsertarTIdCDP(idCA, lst02);
    InsertarTIdCDP(idMA, lst02);
    InsertarTIdCDP(idMO, lst02);
    MergeLstIdsCDP(lst01, lst02);
	
    IF NOT EsVaciaLstIdsCDP(lst01) AND NOT EsVaciaLstIdsCDP(lst02) THEN
        WriteStrLn('OK, ambas no vacias')
    ELSE
        WriteStrLn('ERROR, alguna vacia')
    END;
	
    WriteStrLn('Imprimiendo Lista 1: [');
    ImprimirLstIdsCDP(lst01);
    WriteStrLn(']');
    WriteStrLn('Imprimiendo Lista 2: [');
    ImprimirLstIdsCDP(lst02);
    WriteStrLn(']');
    DestruirLstIdsCDP(lst01);
    DestruirLstIdsCDP(lst02);
    
    WriteStrLn('FIN!')
END TestLstCDP1.
