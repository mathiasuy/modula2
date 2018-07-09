(* 47***** *)
IMPLEMENTATION MODULE ManejadorPersistencia;
(*******************************************************************************
Modulo de definicion de Manejdaor de Persistencia.

El TAD ManejdaorPersistencia ofrece operaciones que permiten persistir y recuperar
el estado del sistema. Para esto se utilizan archivos en texto plano que
deben tener el formato indicado en la operación GuardarEstado.

Laboratorio de Programación 2.
InCo-FI-UDELAR
*******************************************************************************)
FROM CDP IMPORT TCiudadPais, TIdCDP,  ImprimirCDP, CDP, CrearCDP;
FROM Paquete IMPORT Paquete, CrearPaquete, TIdPaquete, Texto, ImprimirPaquete;
FROM Ruta IMPORT Ruta, CrearRuta, InsertarCDPRuta, IrInicioRuta, IrSiguienteRuta;
FROM Tramo IMPORT Tramo, CrearTramo, ImprimirTramo;
FROM CnjCDPs IMPORT CnjCDPs, IdsCnjCDPs, ObtenerCnjCDPs;
FROM TramosHabilitados IMPORT TramosHabilitados, Destinos, CrearTramosHabilitados, InsertarTramo, Origenes, ObtenerTramo;
FROM LstIdsCDP IMPORT LstIdsCDP, EsVaciaLstIdsCDP, RestoLstIdsCDP, DestruirLstIdsCDP, PrimeroLstIdsCDP;
(*FROM CDP IMPORT IdCDP;     *)
FROM TextIO IMPORT WriteString, ReadString, SkipLine, WriteLn;
FROM WholeIO IMPORT WriteCard, ReadCard;
FROM ABBPaquetes IMPORT EsVacioABBPaquetes, CrearABBPaquetes, InsertarABBPaquetes, ABBPaquetes, IzqABBPaquetes, DerABBPaquetes, RaizABBPaquetes;
FROM IOChan IMPORT ChanId;
FROM ChanConsts IMPORT OpenResults;
FROM SeqFile IMPORT OpenWrite, OpenRead, Close, write, old, read;
FROM CnjCDPs IMPORT CrearCnjCDPs, InsertarCnjCDPs;
(*FROM StdChans IMPORT InChan;  *)


PROCEDURE GuardarEstadoPersistencia (nomArch: NombreArchivo; centros: CnjCDPs; tramos: TramosHabilitados; paquetes: ABBPaquetes);
	(* 
			Crea o sobreescribe el archivo de nombre 'nomArch' con la informacion de los
			parametros 'centros', 'tramos', y 'paquetes' utilizando el siguiente
			formato:

			CENTROS:
			[cantidad_elementos(centros)]
			<centros>
			TRAMOS:
			[cantidad_elementos(tramos)]
			<tramos>
			PAQUETES:
			[cantidad_elementos(paquetes)]
			<paquetes>
			FIN_DEL_ARCHIVO

		   Antes de imprimir la información de cada parámetro se imprime una palabra
		   que lo delimita seguido del caracter dos puntos ":".
		   Los paréntesis rectos ("[" y "]") y su contenido debe ser sustitudo por
		   la cantidad de elementos que contiene la colección que se indica.
		   Los caracteres de mayor y menor ("<" y ">") y su contenido debe ser
		   sustituido por la impresión de la colección correspondiente tal como
		   se describe a continuación:
		      * Los centros se deben imprimir ordenados por identificador en forma
		      creciente.
		      * Los tramos se deben imprimir ordenados por origen decreciente y los
		      orígenes iguales por destino decreciente.
		      * Los paquetes se deben imprimir en pre-orden. 
	*)
	     PROCEDURE Imprimir(l : LstIdsCDP; cid : ChanId);
		     BEGIN
				WHILE NOT EsVaciaLstIdsCDP(l) DO
					ImprimirCDP(ObtenerCnjCDPs(PrimeroLstIdsCDP(l),centros),cid);
					l := RestoLstIdsCDP(l);
				END;
	     END Imprimir;

	     PROCEDURE ImprimirPaquetes(a : ABBPaquetes; cid : ChanId);
		     BEGIN
				IF NOT EsVacioABBPaquetes(a) THEN
					ImprimirPaquete(RaizABBPaquetes(a),cid);
					ImprimirPaquetes(IzqABBPaquetes(a), cid);
					ImprimirPaquetes(DerABBPaquetes(a),cid);					
				END;
	     END ImprimirPaquetes;	     

	     PROCEDURE ContarPaquetes(a : ABBPaquetes):CARDINAL;
		     BEGIN
				IF EsVacioABBPaquetes(a) THEN
					RETURN 0;
				ELSE
					RETURN ContarPaquetes(DerABBPaquetes(a)) + ContarPaquetes(IzqABBPaquetes(a)) + 1;
				END; 
	     END ContarPaquetes;	    

	     PROCEDURE Reversa(l : LstIdsCDP; cid : ChanId);
		     	PROCEDURE ReversaDestinos(origen : TIdCDP; l : LstIdsCDP; cid : ChanId);
		     	VAR t : Tramo;
		     	BEGIN
		     		IF NOT EsVaciaLstIdsCDP(l) THEN
		     			ReversaDestinos(origen, RestoLstIdsCDP(l),cid);
		     			t := ObtenerTramo(origen, PrimeroLstIdsCDP(l), tramos);
		     			ImprimirTramo(t,cid);
		     		END;
		     	END ReversaDestinos;
		     VAR ldestinos : LstIdsCDP;
		     BEGIN
		     	IF NOT EsVaciaLstIdsCDP(l) THEN
					Reversa(RestoLstIdsCDP(l),cid);
					ldestinos := Destinos(PrimeroLstIdsCDP(l),tramos);
					ReversaDestinos(PrimeroLstIdsCDP(l),ldestinos,cid);
					DestruirLstIdsCDP(ldestinos);
	 			END;
	     END Reversa;

	     PROCEDURE Contar(l : LstIdsCDP):CARDINAL;
		     VAR cant : CARDINAL;
		     BEGIN
				cant := 0;
				WHILE NOT EsVaciaLstIdsCDP(l) DO
					cant := cant + 1;
					l := RestoLstIdsCDP (l);
				END;
				RETURN cant;
	     END Contar;

	     PROCEDURE ContarTramos(l : LstIdsCDP):CARDINAL;
		     VAR cant : CARDINAL;
		     	ldestinos, i : LstIdsCDP;
		     BEGIN
				cant := 0;
				WHILE NOT EsVaciaLstIdsCDP(l) DO
						ldestinos := Destinos(PrimeroLstIdsCDP(l),tramos);
						i := ldestinos;
						WHILE NOT EsVaciaLstIdsCDP(i) DO
							cant := cant + 1;
							i := RestoLstIdsCDP(i);
						END;
						DestruirLstIdsCDP(ldestinos);
					l := RestoLstIdsCDP (l);
				END;
				RETURN cant;
	     END ContarTramos;	     
	VAR	cid : ChanId;
	 	l : LstIdsCDP;
		res : OpenResults;
	BEGIN
		OpenWrite(cid,nomArch, old+write, res);

		IF res = opened THEN
			WriteString(cid,"CENTROS:");
			WriteLn(cid);
		(*Imprimir los centros ordenados por identificador en forma
	        creciente.  centros: CnjCDPs*)
			l := IdsCnjCDPs (centros);
			WriteCard(cid,Contar(l),1);
			WriteLn(cid);
			Imprimir(l,cid);
			DestruirLstIdsCDP(l);
			WriteString(cid,"TRAMOS:");
			
			WriteLn(cid);
		(*Los tramos se deben imprimir ordenados por origen decreciente y los
	      	orígenes iguales por destino decreciente. tramos: TramosHabilitados*)
			l := Origenes (tramos);
			WriteCard(cid,ContarTramos(l),1);	
			WriteLn(cid);
			Reversa(l,cid);
			DestruirLstIdsCDP(l);
			WriteString(cid,"PAQUETES:");
			WriteLn(cid);
		(*Los paquetes se deben imprimir en pre-orden. paquetes: ABBPaquetes*)
			WriteCard(cid,ContarPaquetes(paquetes),1);	
			WriteLn(cid);
			ImprimirPaquetes(paquetes,cid);
			Close(cid);
		END;				
END GuardarEstadoPersistencia;

PROCEDURE CargarEstadoPersistencia (nomArch: NombreArchivo;
                        VAR centros: CnjCDPs;
						VAR tramos: TramosHabilitados;
						VAR paquetes: ABBPaquetes);
(* Precondición: Los parámetros 'centros', 'tramos', y 'paquetes' no tienen
   memoria reservada.
   Inicializa los parametros con los datos contenidos en el archivo de nombre
   'nomArch'. Se asume que el archivo existe, que fue generado por el
   procedimiento GuardarEstado y que no fue modificado externamente.
   Luego de ejecutada la operacion, las colecciones deben quedar en un estado tal que
   si fueran los parámetros de GuardarEstadoPersistencia se obtendría un archivo igual
   a 'nomArch'. *)

	PROCEDURE ObtenerTramo(cid : ChanId):Tramo;
		(** LEER TRAMOS **)
		(*
		   Origen
		   Destino
		   Costo
		*)
		VAR 
			origen, destino : TIdCDP;
			costo : CARDINAL;
		BEGIN
			ReadString(cid,origen);
			SkipLine(cid);
			ReadString(cid,destino);
			SkipLine(cid);
			ReadCard(cid,costo);
			SkipLine(cid);
			RETURN CrearTramo (origen, destino, costo);
	END ObtenerTramo;
	PROCEDURE ObtenerPaquete(cid : ChanId):Paquete;
		(** LEER PAQUETES 
		
		   idPaquete
		   FPrio
		   MaxSaltos
		   Ruta
			obtengo la cantidad de paquetes y voy repitiendo el proceso hasta agotar cant*)	
		VAR
			idPaquete: TIdPaquete;
			id : TIdCDP;
			rutaPaquete: Ruta;
			fPrio: Texto;
			maxSaltos,cantRutas, posRuta, i : CARDINAL;
		BEGIN

			ReadString(cid,idPaquete);
			SkipLine(cid);
			ReadString(cid,fPrio);
			SkipLine(cid);
			ReadCard(cid,maxSaltos);
			SkipLine(cid);
			(** ID CDP de Ruta **)
			(*obtengo la cantidad de rutas y la guardo en cantRutas*)
					(*sacar la cantidad de rutas*)
					ReadCard(cid,cantRutas);
					SkipLine(cid);
					(*sacar la posicion actual*)
					ReadCard(cid,posRuta);
					SkipLine(cid);

					rutaPaquete := CrearRuta ();
					FOR i := 1 TO cantRutas  DO
						ReadString(cid,id);
						SkipLine(cid);
						InsertarCDPRuta (id, rutaPaquete);
					END;
					(*establecer la posicion actual*)
					IrInicioRuta(rutaPaquete);
					FOR i := 2 TO posRuta DO
						IrSiguienteRuta(rutaPaquete);
					END;
			(**)		
			RETURN CrearPaquete (idPaquete, rutaPaquete, maxSaltos, fPrio);
	END ObtenerPaquete;
	PROCEDURE ObtenerCentro(cid : ChanId):CDP;
		(****LEER CENTRO***
			Id
				Pais
				Ciudad
				CapacidadActual
		*)
		VAR
			id : TIdCDP;
			pais, ciudad: TCiudadPais;
			capActual : CARDINAL;
		BEGIN
			ReadString(cid,id);
			SkipLine(cid);
			ReadString(cid,pais);
			SkipLine(cid);
			ReadString(cid,ciudad);
			SkipLine(cid);
			ReadCard(cid,capActual);
			SkipLine(cid);
			RETURN CrearCDP (id, capActual, pais, ciudad);
	END ObtenerCentro;
VAR	
	cid : ChanId;
	res : OpenResults;
	i, cant : CARDINAL;
BEGIN
	OpenRead(cid,nomArch, read, res); 
	IF res = opened THEN
		SkipLine(cid); (*Salteo linea "CENTROS:"*)	
		centros := CrearCnjCDPs(); 
		ReadCard(cid,cant); (*leo la cantidad de centros*)
		SkipLine(cid); (*Salteo linea que indica cantdad de centros*)

		FOR i := 1 TO cant DO
			InsertarCnjCDPs(ObtenerCentro(cid),centros);
		END;
 		SkipLine(cid);(*Salteo linea "TRAMOS:"*)
		tramos := CrearTramosHabilitados();

		ReadCard(cid,cant); (*leo la cantidad de tramos*)
		SkipLine(cid); (*Salteo linea que indica cantdad de tramos*)			
		tramos := CrearTramosHabilitados();
		FOR i := 1 TO cant DO
			InsertarTramo(ObtenerTramo(cid),tramos);
		END;
 		SkipLine(cid); (*Salteo linea "PAQUETES:"*)
 		paquetes := CrearABBPaquetes();
		ReadCard(cid,cant); (*leo la cantidad de tramos*)
		SkipLine(cid); (*Salteo linea que indica cantdad de paquetes*)	
		FOR i := 1 TO cant DO
			InsertarABBPaquetes(ObtenerPaquete(cid),paquetes);
		END;
	END;		
	Close(cid);
END CargarEstadoPersistencia;
END ManejadorPersistencia.