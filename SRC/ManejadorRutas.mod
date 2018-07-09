(* 47***** *)
IMPLEMENTATION MODULE ManejadorRutas;
(******************************************************************************
Modulo de definicion de ManejadorRutas.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM LstIdsCDP  IMPORT	LstIdsCDP, EsVaciaLstIdsCDP, PerteneceLstIdsCDP, PrimeroLstIdsCDP,
			RestoLstIdsCDP, DestruirLstIdsCDP;(*, EliminarLstIdsCDP;*)
FROM TramosHabilitados IMPORT	TramosHabilitados, ObtenerTramo, EsVaciaTramosHabilitados, Destinos;
FROM Tramo   IMPORT Tramo, CostoTramo;
FROM Strings IMPORT Equal;
(*FROM STextIO IMPORT WriteString, WriteLn;*)
(*FROM STextIO IMPORT WriteString, WriteLn; *)
(*FROM LstIdsCDP IMPORT ImprimirLstIdsCDP;  *)
FROM CDP     IMPORT CDP, TIdCDP, CapacidadActualCDP;
FROM CnjCDPs IMPORT CnjCDPs, PerteneceCnjCDPs, ObtenerCnjCDPs;
FROM Ruta    IMPORT Ruta, CrearRuta, InsertarCDPRuta;(*,SiguienteCDPRuta, IndiceRuta, IrInicioRuta,EsUltimoRuta;*)
FROM Rutas   IMPORT Rutas, CrearVaciaRutas, CrearHojaRutas, AgregarHijoRutas,
EliminarHijoRutas, EsVaciaRutas, EsHojaRutas, DestruirRutas,
		RaizRutas, CostoRutas, IdsHijosRutas, HijoRutas, MaxNivelRutas, CentrosPorNivel;
(*FROM SWholeIO IMPORT WriteCard;   *)

PROCEDURE ConstruirRutas (origen, destino: TIdCDP; maxSaltos: CARDINAL;
							th: TramosHabilitados): Rutas;
(* Preconcicion: 'origen' <> 'destino.
   Devuelve un arbol 'r' de tipo Rutas en el cual la raiz es 'origen' y
   todas las hojas son 'destino'.
   Los caminos desde la raiz hasta las hojas en el arbol devuelto
   representan a todas las rutas posibles entre 'origen' y 'destino' en 'th'
   que tiene hasta 'maxSaltos' y en la que 'destino' no es CDP intermedio.
   Si no existe ninguna ruta, se devuelve el arbol vacio.
   Para cualquier arbol 't' que sea raiz de un nodo de 'r', CostoRutas (t)
   debe devolver la suma de los costos de los tramos que llevan desde la raiz
   de 'r' hasta la raiz de 't'.
*)
	PROCEDURE AgregarHijo(id : TIdCDP;VAR r :Rutas): Rutas;
	VAR t : Tramo;
		hijo : Rutas;
	BEGIN
		t := ObtenerTramo(RaizRutas(r),id,th);
		hijo := CrearHojaRutas(id,CostoRutas(r) + CostoTramo(t));
		AgregarHijoRutas(hijo, r);
		RETURN hijo;
	END AgregarHijo;

PROCEDURE CrearRama(origen,destino : TIdCDP; max : CARDINAL;VAR r : Rutas;VAR retorno : BOOLEAN);
VAR lstDestinos, iter : LstIdsCDP;
	id : TIdCDP;
	hijo : Rutas;
	BEGIN
		IF (max > 0) THEN
			lstDestinos := Destinos(origen,th);
			iter := lstDestinos;
				WHILE NOT EsVaciaLstIdsCDP(iter) DO
					id := PrimeroLstIdsCDP(iter);
					hijo := AgregarHijo(id,r);
					retorno := TRUE;
					CrearRama(id, destino, max-1, hijo, retorno);
					iter := RestoLstIdsCDP(iter);
					IF (NOT retorno) AND EsHojaRutas(hijo) THEN
						EliminarHijoRutas(id,r); 
					END;
				END;
			DestruirLstIdsCDP(lstDestinos);
		END;
		IF NOT Equal(origen, destino) THEN
			retorno := FALSE;
		END;
END CrearRama;
VAR r, hijo : Rutas;
	nodo : TIdCDP;
	lstDestinos, iter : LstIdsCDP;
	t : Tramo;
	llego : BOOLEAN;
BEGIN
	r := CrearVaciaRutas();
	IF NOT EsVaciaTramosHabilitados(th) AND (maxSaltos > 0) THEN
			r := CrearHojaRutas(origen,0);
			lstDestinos := Destinos(origen,th);
			iter := lstDestinos;
			WHILE NOT EsVaciaLstIdsCDP(iter) DO
				nodo := PrimeroLstIdsCDP(iter);
				t := ObtenerTramo(origen,nodo,th);
				hijo := CrearHojaRutas(nodo,CostoTramo(t));
				IF maxSaltos > 1 THEN
					CrearRama(nodo, destino, maxSaltos-1, hijo, llego);
					AgregarHijoRutas(hijo, r);
				ELSE 
					IF Equal(destino,nodo) THEN 
						AgregarHijoRutas(hijo, r);
					ELSE
						DestruirRutas(hijo);
					END;
				END;
				iter := RestoLstIdsCDP(iter);
			END;
		DestruirLstIdsCDP(lstDestinos);
	END;
	RETURN r;
END ConstruirRutas;

PROCEDURE CostoDestino(r : Rutas; VAR menor : CARDINAL);
VAR hijo : Rutas;
	lstDestinos, iter : LstIdsCDP;
BEGIN
	IF NOT EsVaciaRutas(r) THEN
		IF NOT EsHojaRutas(r) THEN
			lstDestinos := IdsHijosRutas(r);
			iter := lstDestinos;
			hijo := HijoRutas(PrimeroLstIdsCDP(iter),r);
			menor := CostoRutas(hijo);
			WHILE NOT EsVaciaLstIdsCDP(iter) DO
				hijo := HijoRutas(PrimeroLstIdsCDP(iter),r);
				IF CostoRutas(hijo) < menor THEN
					menor := CostoRutas(hijo);
				END;
				CostoDestino(hijo, menor);
				iter := RestoLstIdsCDP(iter);
			END;
			DestruirLstIdsCDP(lstDestinos);

		ELSE
			menor := CostoRutas(r);
		END;
	END;
END CostoDestino;



PROCEDURE RutaOptima (r: Rutas; cnj: CnjCDPs): Ruta;
(* Precondicion: NOT EsHojaRutas (r) AND NOT EsVaciaRutas (r).
   Precondicion: 'r' es el resultado de ConstruirRutas (o,d,th), donde 'th' es
   una colección de tramos entre los CDPs de 'cnj'.
   Devuelve la ruta formada por los nodos desde la raiz de 'r' hasta la hoja
   que tiene asociado menor costo, con la restricción de que el segundo
   elemento de la ruta devuelta corresponde a un CDP en 'cnj' con capacidad
   actual > 0.
   Si no existe ninguna ruta que cumpla las condiciones, se devuelve la ruta
   vacia.
   En caso que haya mas de una ruta con menor costo se devuelve la menor de
   ellas en orden lexicografico. *)
	(*PROCEDURE Recorrer(VAR r : Ruta;VAR costo : CARDINAL; r)
VAR capacidad : CARDINAL;*)


		PROCEDURE CostoMenorDestino(r : Rutas):CARDINAL;
		VAR menor : CARDINAL;
		BEGIN
			CostoDestino(r,menor);
			RETURN menor;
		END CostoMenorDestino;

		PROCEDURE Condicion ( r : Rutas; cnj : CnjCDPs) : BOOLEAN;
		VAR c : CDP;
		BEGIN
			 IF PerteneceCnjCDPs (RaizRutas(r), cnj) THEN
			 	c := ObtenerCnjCDPs(RaizRutas(r),cnj);
				IF CapacidadActualCDP (c) > 0 THEN 
					RETURN TRUE;
						
				END; 
			END;
			RETURN FALSE;
		END Condicion;

		PROCEDURE Minimo(r : Rutas; ruta : Ruta);
		VAR lstHijos, iter : LstIdsCDP;
			hijoMinimo, hijo : Rutas;
		BEGIN
			IF NOT EsHojaRutas(r) THEN (*true si no tiene hijos*)
				lstHijos := IdsHijosRutas(r);
				iter := lstHijos;
				hijo := HijoRutas(PrimeroLstIdsCDP(iter),r);
				hijoMinimo := hijo;
				WHILE NOT EsVaciaLstIdsCDP(iter) DO
					hijo := HijoRutas(PrimeroLstIdsCDP(iter),r);
					IF CostoMenorDestino(hijo) < CostoMenorDestino(hijoMinimo) THEN
						hijoMinimo := hijo;
					END;
					iter := RestoLstIdsCDP(iter);
				END;
				DestruirLstIdsCDP(lstHijos);
				InsertarCDPRuta(RaizRutas(hijoMinimo),ruta);
				Minimo(hijoMinimo, ruta);
			END;
		END Minimo;
VAR ruta : Ruta;
	lstHijos, iter : LstIdsCDP;
	hijo, hijoMinimo : Rutas;
BEGIN

	ruta := CrearRuta();
	
	(*inserto el segundo elemento tal que tenga  un CDP con capacidad actual > 0*)
	lstHijos := IdsHijosRutas(r);
	iter := lstHijos;
	
	hijo := HijoRutas(PrimeroLstIdsCDP(iter),r);
	WHILE (NOT EsVaciaLstIdsCDP(iter)) AND (NOT Condicion(hijo, cnj)) DO
		hijo := HijoRutas(PrimeroLstIdsCDP(iter),r); 
		iter := RestoLstIdsCDP(iter);	
	END;

	IF Condicion(hijo,cnj)  THEN
			hijoMinimo := hijo;
			WHILE NOT EsVaciaLstIdsCDP(iter) DO 
				hijo := HijoRutas(PrimeroLstIdsCDP(iter),r); 

			IF (CostoMenorDestino(hijo) < CostoMenorDestino(hijoMinimo)) AND Condicion(hijo,cnj) THEN
					hijoMinimo := hijo;
				END;
				iter := RestoLstIdsCDP(iter);
			END;
			DestruirLstIdsCDP(lstHijos);
			IF NOT EsVaciaRutas(hijoMinimo) THEN
				InsertarCDPRuta(RaizRutas(r), ruta);
				InsertarCDPRuta(RaizRutas(hijoMinimo),ruta);
				Minimo(hijoMinimo, ruta);
			END;
	ELSE
			DestruirLstIdsCDP(lstHijos);
	END;
	
	RETURN ruta;

END RutaOptima;


PROCEDURE DistanciaMinima (c: TIdCDP; r: Rutas): CARDINAL;
(* Precondicion: NOT EsVaciaRutas (r).
   Devuelve la minima cantidad de saltos con que se puede para llegar desde el
   centro representado por la raiz de 'r' hasta 'c' si eso se puede hacer en no
   mas de MaxNivelRutas (r) saltos; en otro caso devuelve 1 + MaxNivelRutas .*)
VAR
	maxNivel, i : CARDINAL;
	nivel : LstIdsCDP;
BEGIN
	maxNivel := MaxNivelRutas (r);
	
	i := 0;
	WHILE (i <= maxNivel) DO
		nivel := CentrosPorNivel (i, r);
		IF PerteneceLstIdsCDP (c, nivel) THEN
			DestruirLstIdsCDP(nivel);
			RETURN i;
		END;
		DestruirLstIdsCDP(nivel);			
		i := i + 1;
	END;
	
	RETURN i;
END DistanciaMinima;	
END ManejadorRutas.
