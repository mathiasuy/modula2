(* 47***** *)
IMPLEMENTATION MODULE Paquete;
(******************************************************************************
Modulo de definicion de Paquete.

El TAD Paquete representa la informacion de un Paquete: su
identificador, ruta y maxima cantidad de saltos.

Laboratorio de Programacion 2.
InCo-FI-UDELAR
******************************************************************************)

FROM Ruta IMPORT Ruta, DestruirRuta, PrimerCDPRuta, UltimoCDPRuta, IrSiguienteRuta,ImprimirRuta;
(*
	FROM STextIO IMPORT WriteLn, WriteString;
	FROM SWholeIO IMPORT WriteCard;*)
FROM IOChan IMPORT ChanId;
FROM Storage IMPORT ALLOCATE, DEALLOCATE;
FROM CDP IMPORT TIdCDP;
IMPORT TextIO;
IMPORT WholeIO;
TYPE
    Paquete = POINTER TO RECORD
    				id : TIdPaquete;
					ruta : Ruta;
					maxS : CARDINAL;
					FPrio : Texto;
			END;
			

(************ Constructoras *************)

PROCEDURE CrearPaquete (id: TIdPaquete; rutaPaquete: Ruta; maxSaltos:CARDINAL; fPrio: Texto): Paquete;
(* Devuelve un Paquete con los datos pasados como parámetro.
   El parametro 'fPrio' contiene la formula de prioridad 
   asignada al paquete. *)
VAR p : Paquete;
BEGIN
	NEW (p);
	p^.id := id;
	p^.ruta := rutaPaquete;
	p^.maxS := maxSaltos;
	p^.FPrio := fPrio;
	RETURN p;
END CrearPaquete;

PROCEDURE AsignarRutaPaquete (ruta: Ruta; VAR p: Paquete);
(* Libera la memoria asignada a la ruta actual y asigna la nueva ruta al paquete. *)
BEGIN
	DestruirRuta(p^.ruta);
	p^.ruta := ruta;
		
END AsignarRutaPaquete;

(************ Selectoras ****************)

PROCEDURE IdPaquete (p: Paquete): TIdPaquete;
(* Devuelve el identificador de 'p'. *)
BEGIN
        RETURN p^.id;
END IdPaquete;

PROCEDURE RutaPaquete (p: Paquete): Ruta;
(* Devuelve la ruta de 'p'. *)
BEGIN
	RETURN p^.ruta;
END RutaPaquete;

PROCEDURE InicioCDPPaquete (p: Paquete): TIdCDP;
(* Devuelve el TIdCDP inicio de 'p'. *)
BEGIN
	RETURN PrimerCDPRuta(p^.ruta);
END InicioCDPPaquete;

PROCEDURE FinCDPPaquete (p: Paquete): TIdCDP;
(* Devuelve el TIdCDP destino de 'p'. *)
BEGIN
	RETURN UltimoCDPRuta(p^.ruta);
END FinCDPPaquete;

PROCEDURE MaxSaltosPaquete (p: Paquete): CARDINAL;
(* Devuelve la cantidad maxima de saltos para 'p'.*)
BEGIN
	RETURN p^.maxS;
END MaxSaltosPaquete;

(* NUEVO *)
PROCEDURE FPrioPaquete (p: Paquete): Texto;
(* Devuelve el texto de la formula de prioridad de 'p'.*)
BEGIN
	RETURN p^.FPrio;
END FPrioPaquete;

(************ Predicados ****************)

PROCEDURE AvanzarPaquete (p: Paquete);
(* Avanza 'p' al siguiente CDP de la ruta. *)
BEGIN
	IrSiguienteRuta (p^.ruta);	
END AvanzarPaquete;

(************ Salida ********************)

(* MODIFICADO *)
PROCEDURE ImprimirPaquete (p: Paquete; cid : ChanId);
(* Imprime los datos de 'p' en la el canal 'cid' con el siguiente formato:
   idPaquete
   FPrio
   MaxSaltos
   Ruta
   
   Se incluye un nueva linea luego de la impresión de cada campo. *)
BEGIN
	TextIO.WriteString(cid,p^.id);
	TextIO.WriteLn(cid);
	TextIO.WriteString(cid,p^.FPrio);
	TextIO.WriteLn(cid);
	WholeIO.WriteCard(cid,p^.maxS,1);
	TextIO.WriteLn(cid);
	ImprimirRuta (p^.ruta,cid);
END ImprimirPaquete;

(************ Destructoras **************)
PROCEDURE DestruirPaquete (VAR p: Paquete);
(* Libera la memoria asignada a 'p'. *)
BEGIN
	DestruirRuta(p^.ruta);
	DISPOSE(p);
END DestruirPaquete;

END Paquete.
