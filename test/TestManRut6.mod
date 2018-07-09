MODULE TestManRut6;
(******************************************************************************
Modulo de prueba unitaria del TAD ManejadorRutas.

Prueba las funcionalidades basicas del TAD.

Laboratorio de Programacion 2.
InCo-FI-UDELAR
******************************************************************************)

FROM CDP               IMPORT CrearCDP;
FROM CnjCDPs           IMPORT CnjCDPs, CrearCnjCDPs, InsertarCnjCDPs,
                              DestruirCnjCDPs;
FROM ManejadorRutas    IMPORT RutaOptima;
FROM Ruta              IMPORT Ruta, ImprimirRuta, DestruirRuta;
FROM Rutas             IMPORT Rutas, CrearHojaRutas, AgregarHijoRutas,
                              HijoRutas, ImprimirRutas, DestruirRutas;
FROM StdChans IMPORT StdOutChan;

VAR
	cnj     : CnjCDPs;
    rs, hijo: Rutas;
    r       : Ruta;
	
BEGIN
	cnj := CrearCnjCDPs();
	InsertarCnjCDPs (CrearCDP ("A", 100, "PaisA", "CiudadA"), cnj);
	InsertarCnjCDPs (CrearCDP ("C", 100, "PaisC", "CiudadC"), cnj);
	InsertarCnjCDPs (CrearCDP ("J", 100, "PaisC", "CiudadC"), cnj);
	InsertarCnjCDPs (CrearCDP ("M", 100, "PaisC", "CiudadC"), cnj);
	
	rs := CrearHojaRutas ("A", 0);
	AgregarHijoRutas (CrearHojaRutas ("C", 4), rs);
	AgregarHijoRutas (CrearHojaRutas ("J", 2), rs);
	AgregarHijoRutas (CrearHojaRutas ("M", 1), rs);

	hijo := HijoRutas ("M", rs);
	AgregarHijoRutas (CrearHojaRutas ("J", 2), hijo);
	hijo := HijoRutas ("J", hijo);
	AgregarHijoRutas (CrearHojaRutas ("A", 3), hijo);
	AgregarHijoRutas (CrearHojaRutas ("C", 3), hijo);
	hijo := HijoRutas ("A", hijo);
	AgregarHijoRutas (CrearHojaRutas ("C", 7), hijo);

	hijo := HijoRutas ("J", rs);
	AgregarHijoRutas (CrearHojaRutas ("C", 3), hijo);
	AgregarHijoRutas (CrearHojaRutas ("A", 3), hijo);
	hijo := HijoRutas ("A", hijo);
	AgregarHijoRutas (CrearHojaRutas ("C", 7), hijo);
	AgregarHijoRutas (CrearHojaRutas ("J", 5), hijo);
	hijo := HijoRutas ("J", hijo);	
	AgregarHijoRutas (CrearHojaRutas ("C", 6), hijo);
	ImprimirRutas (rs);		
	
	r := RutaOptima (rs, cnj);
	ImprimirRuta (r,StdOutChan());

	DestruirRuta (r);
	DestruirRutas (rs);
	DestruirCnjCDPs (cnj)
END TestManRut6.
