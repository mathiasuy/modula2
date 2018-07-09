MODULE TestManRut5;
(******************************************************************************
Modulo de prueba unitaria del TAD ManejadorRutas.

Prueba las funcionalidades basicas del TAD.

Laboratorio de Programacion 2.
InCo-FI-UDELAR
******************************************************************************)

FROM ManejadorRutas    IMPORT ConstruirRutas;
FROM Rutas             IMPORT Rutas, ImprimirRutas, DestruirRutas;
FROM Tramo             IMPORT CrearTramo;
FROM TramosHabilitados IMPORT TramosHabilitados, CrearTramosHabilitados,
                              DestruirTramosHabilitados, InsertarTramo;


VAR
    r  : Rutas;
    th : TramosHabilitados;

BEGIN
	th := CrearTramosHabilitados();
	InsertarTramo (CrearTramo ("A", "C", 4), th);
	InsertarTramo (CrearTramo ("A", "J", 2), th);
	InsertarTramo (CrearTramo ("A", "M", 1), th);
	InsertarTramo (CrearTramo ("J", "A", 1), th);
	InsertarTramo (CrearTramo ("J", "C", 1), th);
	InsertarTramo (CrearTramo ("J", "D", 1), th);
	InsertarTramo (CrearTramo ("D", "E", 1), th);
	InsertarTramo (CrearTramo ("E", "F", 1), th);
	InsertarTramo (CrearTramo ("F", "C", 1), th);
	InsertarTramo (CrearTramo ("M", "J", 1), th);
	InsertarTramo (CrearTramo ("L", "K", 1), th);
	
	r := ConstruirRutas ("A", "C", 4, th);
	ImprimirRutas (r);
	DestruirRutas (r);
	DestruirTramosHabilitados (th)
END TestManRut5.
