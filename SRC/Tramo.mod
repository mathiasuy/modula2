(* 47***** *)
IMPLEMENTATION MODULE Tramo;
(******************************************************************************
Modulo de definicion de Tramo.

Este TAD representa una conexion directa entre dos centros, el origen y el
 destino. Tiene asociado un costo.
NOTA: la existencia de un tramo entre A y B no implica la existencia de un
tramo entre B y A, y en caso que existiese el costo no tiene por que ser
el mismo.

Laboratorio de Programacion 2.
InCo-FI-UDELAR
******************************************************************************)
FROM CDP IMPORT TIdCDP;
(*FROM STextIO IMPORT WriteString, WriteLn;
FROM SWholeIO IMPORT  WriteCard;*)
(*FROM*)
FROM Storage IMPORT ALLOCATE, DEALLOCATE;
IMPORT WholeIO;
IMPORT TextIO;
FROM IOChan IMPORT ChanId;

TYPE
    Tramo = POINTER TO RECORD
    			origen : TIdCDP;
			destino: TIdCDP;
			costo  : CARDINAL;
		END;

(************ Constructoras *************)
	
PROCEDURE CrearTramo (origen, destino: TIdCDP; costo: CARDINAL): Tramo;
(* Devuelve un nuevo Tramo. *)
VAR tramo : Tramo;
BEGIN
	NEW (tramo);
	tramo^.origen := origen;
	tramo^.destino := destino;
	tramo^.costo := costo;
	RETURN tramo;
END CrearTramo;

(************ Selectoras *************)
PROCEDURE CDPOrigenTramo (t: Tramo): TIdCDP;
(* Devuelve el CDP origen de 't'. *)
BEGIN
	RETURN t^.origen;
END CDPOrigenTramo;

PROCEDURE CDPDestinoTramo (t: Tramo): TIdCDP;
(* Devuelve el CDP destino de 't'. *)
BEGIN
	RETURN t^.destino;
END CDPDestinoTramo;

PROCEDURE CostoTramo (t: Tramo): CARDINAL;
(* Devuelve el costo de 't'. *)
BEGIN
	RETURN t^.costo;
END CostoTramo;

(************ Salida ********************)

(* MODIFICADO *)
PROCEDURE ImprimirTramo (t: Tramo; cid : ChanId);
(* Imprime 't' en el canal 'cid' de acuerdo al siguiente formato:
   Origen
   Destino
   Costo

   Se incluye un nueva linea luego de la impresión de cada campo. *)
BEGIN
	TextIO.WriteString(cid,t^.origen);
	TextIO.WriteLn(cid);
	TextIO.WriteString(cid,t^.destino);
	TextIO.WriteLn(cid);

	WholeIO.WriteCard(cid,t^.costo,1);
	TextIO.WriteLn(cid);
END ImprimirTramo;

(************ Destructoras **************)
PROCEDURE DestruirTramo (VAR t: Tramo);
(* Libera la memoria asignada a 't'. *)
BEGIN
	DISPOSE (t);
END DestruirTramo;

END Tramo.
