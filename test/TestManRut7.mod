MODULE TestManRut7;
(******************************************************************************
Modulo de prueba unitaria del TAD ManejadorRutas.

Prueba las funcionalidades basicas del TAD.

Laboratorio de Programacion 2.
InCo-FI-UDELAR
******************************************************************************)

FROM ManejadorRutas IMPORT DistanciaMinima;
FROM Rutas          IMPORT Rutas, CrearHojaRutas, AgregarHijoRutas,
                           HijoRutas, ImprimirRutas, DestruirRutas;
FROM STextIO        IMPORT WriteLn;
FROM SWholeIO       IMPORT WriteCard;



PROCEDURE WriteCardLn (c: CARDINAL);
(* Despliega una cardinal y posiciona el cursor en la siguiente línea. *)
BEGIN
	WriteCard(c, 1);
	WriteLn
END WriteCardLn;


VAR
    rs, hijo: Rutas;
	
BEGIN
	rs := CrearHojaRutas ("A", 0);
	AgregarHijoRutas (CrearHojaRutas ("C", 4), rs);
	AgregarHijoRutas (CrearHojaRutas ("J", 2), rs);
	AgregarHijoRutas (CrearHojaRutas ("M", 1), rs);

	hijo := HijoRutas ("M", rs);
	AgregarHijoRutas (CrearHojaRutas ("J", 2), hijo);
	AgregarHijoRutas (CrearHojaRutas ("B", 10), hijo);
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
	
	WriteCardLn (DistanciaMinima ("A", rs));
	WriteCardLn (DistanciaMinima ("B", rs));
	WriteCardLn (DistanciaMinima ("C", rs));
	WriteCardLn (DistanciaMinima ("L", rs));
	WriteCardLn (DistanciaMinima ("J", rs));
	
	DestruirRutas (rs)
END TestManRut7.
