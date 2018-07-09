(* 47***** *)
IMPLEMENTATION MODULE Rutas;
(******************************************************************************
Modulo de definicion de Rutas.

El TAD Rutas es un arbol finitario.
Sus nodos representan CDPs a los cuales se les asocia un costo.

Laboratorio de Programación 2.
InCo-FI-UDELAR
******************************************************************************)

FROM CDP IMPORT TIdCDP;
FROM LstIdsCDP IMPORT (*EsVaciaLstIdsCDP, ImprimirLstIdsCDP,*) LstIdsCDP, MergeLstIdsCDP, CrearLstIdsCDP, InsertarTIdCDP(*, DestruirLstIdsCDP *);
FROM Storage IMPORT ALLOCATE, DEALLOCATE;
FROM Strings IMPORT Compare,  CompareResults, Equal;
FROM STextIO IMPORT WriteString, WriteLn;
FROM SWholeIO IMPORT WriteCard;

TYPE
   Rutas = POINTER TO nodo;

	nodo = RECORD
			id : TIdCDP;
			costo : CARDINAL;
			sigHermano : Rutas;
			primerHijo : Rutas;
		END;


(************ Constructoras *************)

PROCEDURE CrearVaciaRutas (): Rutas;
(* Crea y devuelve el arbol vacio. *)
BEGIN
	RETURN NIL;
END CrearVaciaRutas;

PROCEDURE CrearHojaRutas (id: TIdCDP; costo: CARDINAL): Rutas;
(* Crea y devuelve un arbol formado por un solo nodo. *)
VAR ruta : Rutas;
BEGIN
	NEW (ruta);
	ruta^.id := id;
	ruta^.costo := costo;
	
	ruta^.sigHermano := NIL;
	ruta^.primerHijo := NIL;
	
	RETURN ruta;
END CrearHojaRutas;

PROCEDURE AgregarHijoRutas (hijo: Rutas; VAR r: Rutas);
(* Precondicion: NOT EsVaciaRutas(hijo) y NOT EsVaciaRutas(r)
   Precondicion: Ninguna de las raices de los subarboles de 'r' tiene el mismo
   identificador que la raiz de 'hijo'.
   Agrega 'hijo' a la coleccion de hijos de la raiz de 'r'. *)
VAR	
	actual, anterior : Rutas;
BEGIN
		actual := r^.primerHijo;
		IF actual <> NIL THEN
     		 (* 1.- se busca su posicion*)
			anterior := actual;
		     WHILE (actual <> NIL) AND (Compare(actual^.id, hijo^.id)=less) DO
		           anterior := actual;
		           actual := actual^.sigHermano
		     END;
                (*     WriteString(' entro ');*)
		     (* 3.- Se enlaza *)
		       (* inserta al principio *)
		     IF (anterior = NIL) OR (anterior = actual) THEN
			hijo^.sigHermano := anterior;
			r^.primerHijo := hijo;

		        (* importante: al insertar al principio actuliza la cabecera *)

		       (* inserta entre medias o al final *)
		     ELSE
		        hijo^.sigHermano := actual;
		        anterior^.sigHermano := hijo;
		     END
		ELSE
			r^.primerHijo := hijo;
		END;
END AgregarHijoRutas;

(************ Predicados ****************)

PROCEDURE EsVaciaRutas (r: Rutas): BOOLEAN;
(* Devuelve TRUE si 'r' es el arbol vacio, FALSE en otro caso. *)
BEGIN
	RETURN r = NIL;
END EsVaciaRutas;

PROCEDURE EsHojaRutas (r: Rutas): BOOLEAN;
(* Precondicion: NOT EsVaciaRutas(r)
   Devuelve TRUE si 'r' no tiene hijos, FALSE en otro caso. *)
BEGIN
	RETURN r^.primerHijo = NIL;
END EsHojaRutas;

PROCEDURE EsHijoRutas (id: TIdCDP; r: Rutas): BOOLEAN;
(* Precondicion: NOT EsVaciaRutas(r)
  Devuelve TRUE si 'id' es el identificador de la raiz de algun hijo de 'r',
  FALSE en otro caso. *)
BEGIN
	r := r^.primerHijo;
	
	WHILE (r <> NIL) AND NOT Equal(r^.id,id) DO
		r := r^.sigHermano;
	END;
	
	RETURN (r<> NIL) AND Equal(r^.id,id)
END EsHijoRutas;


(************ Selectoras ****************)

PROCEDURE RaizRutas (r: Rutas): TIdCDP;
(* Precondicion: NOT EsVaciaRutas(r)
  Devuelve el identificador de la raiz de 'r'. *)
BEGIN
	RETURN r^.id;
END RaizRutas;

PROCEDURE CostoRutas (r: Rutas): CARDINAL;
(* Precondicion: NOT EsVaciaRutas(r)
  Devuelve el costo asociado a la raiz de 'r'. *)
BEGIN
	RETURN r^.costo;
END CostoRutas;

PROCEDURE IdsHijosRutas (r: Rutas): LstIdsCDP;
(* Precondicion: NOT EsVaciaRutas(r)
 Devuelve una lista ordenada en forma creciente de los identificadores de las
 raices de los hijos de 'r'. *)
VAR l : LstIdsCDP;
BEGIN
	l := CrearLstIdsCDP();
	r := r^.primerHijo;
	WHILE r <> NIL DO
		InsertarTIdCDP (r^.id, l);
		r := r^.sigHermano
	END;
	
	RETURN l;
			
END IdsHijosRutas;

PROCEDURE HijoRutas (id: TIdCDP; r: Rutas): Rutas;
(* Precondicion: La raiz de 'r' tiene un hijo cuya raiz se identifica con id.
  Devuelve el hijo de la raiz de 'r' cuya raiz se identifica con 'id'. *)
BEGIN
	r := r^.primerHijo;
	
	WHILE (r <> NIL) AND NOT Equal(r^.id,id) DO
		r := r^.sigHermano;
	END;
	
	RETURN r;
END HijoRutas;

PROCEDURE MaxNivelRutas (r: Rutas) : CARDINAL;
(* Precondicion: NOT EsVaciaRutas(r)
   Devuelve la cantidad maxima de niveles que tiene el arbol r.
   La raiz de 'r' esta en el nivel 0.
 *)
	PROCEDURE PostOrden(r : Rutas; nivel : CARDINAL; VAR max : CARDINAL);
	BEGIN
		IF r <> NIL THEN
			PostOrden(r^.primerHijo, nivel+1, max);
			IF nivel > max THEN
			 	max := nivel;
			END;
			PostOrden(r^.sigHermano, nivel, max);
		END;
	END PostOrden;
VAR i : CARDINAL;
BEGIN
	i := 0;
	IF NOT EsHojaRutas(r) THEN
		PostOrden(r, 0,i);
	END;
	RETURN i;
END MaxNivelRutas;

PROCEDURE CentrosPorNivel (n: CARDINAL; r: Rutas): LstIdsCDP;
(* Precondicion: NOT EsVaciaRutas(r)  y n <= MaxNivelRutas(r)
  Devuelve una lista ordenada de forma creciente y sin repetidos con los
  identificadores que en 'r' están en el nivel 'n'.
  La raiz de 'r' esta en el nivel 0. *)
	PROCEDURE PostOrden(r : Rutas; n : CARDINAL; VAR l : LstIdsCDP);
	BEGIN
	        IF r <> NIL THEN
		
			IF n > 0 THEN

			PostOrden(r^.primerHijo, n-1 , l);
		
			ELSE
		    		InsertarTIdCDP(r^.id, l);
				MergeLstIdsCDP (l, l);
			END;
			PostOrden(r^.sigHermano, n, l);
		END;
	END PostOrden;
VAR l : LstIdsCDP;
BEGIN
        l := CrearLstIdsCDP();
	PostOrden(r, n, l);
	RETURN l;
END CentrosPorNivel;


(************ Salida ********************)

PROCEDURE ImprimirRutas (r: Rutas);
(* Imprime en post-orden los identificadores de cada nodo del arbol 'r'.
   Despues de cada nodo se imprime un retorno de carro.
   Antes de cada identificador se debe dejar una indentacion de largo h - 1,
   siendo 'h' la ALTURA del nodo (la altura de una hoja es 1).

"Entre los hijos de un nodo, el orden relativo en que se
    procesan es el lexicografico creciente."
*)
	PROCEDURE Impri(r : Rutas; n :CARDINAL);
	VAR i : CARDINAL;
		BEGIN
		IF r <> NIL THEN
			Impri (r^.primerHijo,n);

			IF NOT EsHojaRutas(r) THEN
				(*IF Equal(r^.id,"BCN") THEN
					WriteString(r^.id);
					WriteCard(MaxNivelRutas(r),1);
				END;*)
				FOR i := 0 TO MaxNivelRutas(r)-1 DO
					WriteString(' ');
				END;
			END;
			WriteString(r^.id);
			WriteLn;
			Impri (r^.sigHermano,n);
		END;
	END Impri;
VAR n,i : CARDINAL;
BEGIN
	IF r <> NIL THEN
		n := MaxNivelRutas(r);
		Impri(r^.primerHijo,n);
			FOR i := 1 TO MaxNivelRutas (r)  DO
				WriteString(' ');
			END;		
		WriteString(r^.id);
		WriteLn;
	END;
			
END ImprimirRutas;


(************ Destructoras **************)

PROCEDURE EliminarHijoRutas (id: TIdCDP; VAR r: Rutas);
(* Precondicion: La raiz de 'r' tiene un sub-arbol cuya raiz se identifica con
  id.
  Remueve de la coleccion de hijos de la raiz de 'r' el sub-arbol cuya raiz se
  identifica con 'id'.
  Destruye el sub-arbol removido. *)
	PROCEDURE Borrar(VAR r : Rutas; id : TIdCDP);
	VAR temp, actual, anterior : Rutas;
	BEGIN
		IF r <> NIL THEN
			IF EsHijoRutas(id,r) THEN
				IF Equal(r^.primerHijo^.id,id) THEN
					temp := r^.primerHijo;
					r^.primerHijo := r^.primerHijo^.sigHermano;
				ELSE
					actual := r^.primerHijo;
					anterior := actual;
					WHILE (actual <> NIL) AND NOT Equal(actual^.id,id) DO
						anterior := actual;
						actual := actual^.sigHermano;
					END;
					temp := actual;
					anterior^.sigHermano := actual^.sigHermano;			
				END;
				DestruirRutas(temp^.primerHijo);
				DISPOSE(temp);
			ELSE
				Borrar(r^.primerHijo,id);
				Borrar(r^.sigHermano,id);
			END;
		END;
	END Borrar;
(*VAR e : BOOLEAN;      *)
BEGIN
	(*                WriteCard(5,1);*)
	Borrar(r,id);	
END EliminarHijoRutas;

PROCEDURE DestruirRutas (VAR r: Rutas);
(* Libera la memoria reservada para la estructura 'r' y sus elementos. *)
BEGIN
	IF r <> NIL THEN
	     	DestruirRutas(r^.primerHijo);
		DestruirRutas(r^.sigHermano);
		DISPOSE(r);
		
	END;
END DestruirRutas;

END Rutas.