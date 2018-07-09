MODULE TestABBPaq4;
(******************************************************************************
Modulo de prueba unitaria del TAD ABBPaquetes.

Prueba el uso de memoria dinamica del TAD.

Laboratorio de Programacion 2.
InCo-FI-UDELAR
******************************************************************************)

FROM ABBPaquetes IMPORT ABBPaquetes, CrearABBPaquetes, InsertarABBPaquetes,
                         CDPsActualABBPaquetes, EliminarABBPaquetes,
                         DestruirABBPaquetes, PerteneceABBPaquetes;
FROM CDP		 IMPORT TIdCDP;						
FROM LstIdsCDP	 IMPORT LstIdsCDP, DestruirLstIdsCDP;
FROM Paquete     IMPORT Paquete, CrearPaquete, TIdPaquete;
FROM Ruta        IMPORT Ruta, CrearRuta, InsertarCDPRuta, IrInicioRuta, 
						IrSiguienteRuta;
FROM STextIO	 IMPORT WriteString, WriteLn;
FROM Strings     IMPORT Concat;
FROM WholeStr    IMPORT CardToStr;


CONST
	MAX_ITER = 4000;
	
VAR
    abb: ABBPaquetes;
    p: Paquete;
    r: Ruta;
	i, j, k, cantRutas, cantAvanza: CARDINAL;
	sufijo: ARRAY [0..4] OF CHAR;
	id: TIdPaquete;
	idCentro: TIdCDP;
	l: LstIdsCDP;
	
BEGIN
	WriteString ("Prueba DestruirABBPaquetes"); WriteLn;
	
	FOR i := 1 TO MAX_ITER DO
    	abb := CrearABBPaquetes();
		
		FOR j := 10 TO 60 DO
			CardToStr ((j * j + 1) MOD 101, sufijo);
			Concat ('id', sufijo, id);
			
			IF (NOT PerteneceABBPaquetes (id, abb)) THEN
				r := CrearRuta ();
			
				FOR k := 1 TO j DO
					CardToStr (k, sufijo);
					Concat ('centro', sufijo, idCentro);
					InsertarCDPRuta (idCentro, r)
				END;
			
				p := CrearPaquete (id, r, j,"[ a ]");
				InsertarABBPaquetes (p, abb)
			END
		END;
		
		DestruirABBPaquetes(abb)
	END;
	
	WriteString ("Prueba EliminarABBPaquetes"); WriteLn;
	
	FOR i := 1 TO MAX_ITER DO
    	abb := CrearABBPaquetes();
		
		FOR j := 10 TO 60 DO
			CardToStr ((j * j + 1) MOD 101, sufijo);
			Concat ('id', sufijo, id);
			
			IF (NOT PerteneceABBPaquetes (id, abb)) THEN
				r := CrearRuta ();
			
				FOR k := 1 TO j DO
					CardToStr (k, sufijo);
					Concat ('centro', sufijo, idCentro);
					InsertarCDPRuta (idCentro, r)
				END;
			
				p := CrearPaquete (id, r, j,"[ a ]");
				InsertarABBPaquetes (p, abb)
			END
		END;
		
		FOR j := ((i * i + 1) MOD 61) TO ((i * i + 1) MOD 11)  BY -1 DO
			CardToStr ((j * j + 1) MOD 101, sufijo);
			Concat ('id', sufijo, id);
			
			IF (PerteneceABBPaquetes (id, abb)) THEN
				EliminarABBPaquetes (id, abb)
			END
		END;
		
		FOR j := 10 TO 60 DO
			CardToStr ((j * j + 1) MOD 101, sufijo);
			Concat ('id', sufijo, id);
			
			IF (PerteneceABBPaquetes (id, abb)) THEN
				EliminarABBPaquetes (id, abb)
			END
		END;
		
		DestruirABBPaquetes(abb)
	END;
	
	WriteString ("Prueba CDPsActualABBPaquetes"); WriteLn;
	
	FOR i := 1 TO 2 * MAX_ITER DO
    	abb := CrearABBPaquetes();
		
		FOR j := 10 TO 60 DO
			CardToStr ((j * j + 1) MOD 101, sufijo);
			Concat ('id', sufijo, id);
			
			IF (NOT PerteneceABBPaquetes (id, abb)) THEN
				r := CrearRuta ();
				cantRutas := 1 + ((i * j) MOD 21);
			
				FOR k := 1 TO cantRutas DO
					CardToStr (k, sufijo);
					Concat ('centro', sufijo, idCentro);
					InsertarCDPRuta (idCentro, r)
				END;
				
				cantAvanza := ((i * j) MOD (cantRutas + 1));
			    IrInicioRuta(r);
				
				FOR k := 1 TO cantAvanza DO
					IrSiguienteRuta(r)
				END;
				
				p := CrearPaquete (id, r, j,"[ a ]");
				InsertarABBPaquetes (p, abb)
			END
		END;
		
		l := CDPsActualABBPaquetes(abb);
		DestruirLstIdsCDP(l);
		DestruirABBPaquetes(abb)
	END;
	
	WriteString ("OK-Fin prueba")	
END TestABBPaq4.
