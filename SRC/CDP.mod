(* 47***** *)
IMPLEMENTATION MODULE CDP;

(*FROM SWholeIO IMPORT WriteCard;
FROM STextIO IMPORT WriteString, WriteLn;*)
IMPORT TextIO;
IMPORT WholeIO;
FROM Storage IMPORT ALLOCATE, DEALLOCATE;
FROM IOChan IMPORT ChanId;

(******************************************************************************
Modulo de definicion de CDP.

El TAD CDP define el Centro de Distribucion de Paquetes.
Los mismos contiene la siguiente informacion:
  - Identificador del Centro (IdCDP)
  - Capacidad actual
  - Pais
  - Ciudad


Laboratorio de Programacion 2.
InCo-FI-UDELAR
******************************************************************************)

TYPE
    CDP = POINTER TO RECORD
    		Id  : TIdCDP;
    		Ciudad : TCiudadPais;
		Pais	: TCiudadPais;
		CapPaquetes : CARDINAL;
		END;

(************ Constructoras *************)

PROCEDURE CrearCDP (id: TIdCDP;
		   capActual: CARDINAL;
		   pais, ciudad: TCiudadPais): CDP;
(* Devuelve un nuevo centro de distribucion de paquetes. *)
VAR
	cdp : CDP;
BEGIN
	NEW (cdp);
	cdp^.Id := id;
	cdp^.Ciudad := ciudad;
	cdp^.Pais := pais;
	cdp^.CapPaquetes := capActual;
	
	RETURN cdp	
END CrearCDP;


(************ Selectoras ****************)

PROCEDURE IdCDP (c: CDP): TIdCDP;
(* Devuelve el identificador de 'c'. *)
BEGIN
	RETURN c^.Id;
END IdCDP;


PROCEDURE CapacidadActualCDP (c: CDP): CARDINAL;
(* Devuelve la capacidad actual de 'c'. *)
BEGIN
	RETURN c^.CapPaquetes;
END CapacidadActualCDP;

PROCEDURE PaisCDP (c: CDP): TCiudadPais;
(* Devuelve el pais de 'c'. *)
BEGIN
	RETURN c^.Pais;
END PaisCDP;

PROCEDURE CiudadCDP (c: CDP): TCiudadPais;
(* Devuelve la ciudad de 'c'. *)
BEGIN
	RETURN c^.Ciudad;
END CiudadCDP;

(************ Operaciones ****************)

PROCEDURE AumentarCapacidadActualCDP (VAR c: CDP);
(* Aumenta en 1 la capacidad actual de 'c'. *)
BEGIN
	c^.CapPaquetes := c^.CapPaquetes + 1;
END AumentarCapacidadActualCDP;

PROCEDURE DisminuirCapacidadActualCDP (VAR c: CDP);
(* Disminuye en 1 la capacidad actual de 'c'. *)
BEGIN
	c^.CapPaquetes := c^.CapPaquetes - 1;
END DisminuirCapacidadActualCDP;


(************ Salida ********************)

(* MODIFICADO *)
PROCEDURE ImprimirCDP (c: CDP; cid : ChanId);
(* Imprime los datos de 'c' en el canal 'cid':
   Id
   Pais
   Ciudad
   CapacidadActual

   Se incluye un nueva linea luego de la impresión de cada campo. *)
BEGIN
	TextIO.WriteString(cid,c^.Id);
	TextIO.WriteLn(cid);
	TextIO.WriteString(cid,c^.Pais);
	TextIO.WriteLn(cid);
	TextIO.WriteString(cid,c^.Ciudad);
	TextIO.WriteLn(cid);
	WholeIO.WriteCard(cid,c^.CapPaquetes,1);
	TextIO.WriteLn(cid);
END ImprimirCDP;


(************ Destructoras **************)
PROCEDURE DestruirCDP (VAR c: CDP);
(* Libera la memoria asignada a  'c'. *)
BEGIN
	DISPOSE(c);
END DestruirCDP;


END CDP.