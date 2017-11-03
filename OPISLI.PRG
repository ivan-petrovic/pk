LOCAL wSifop, wAutoop, DN, Izbor

USE OPIS
GO TOP

DO WHILE .T.

	CLEAR SCREEN
	@ 23,0 TO 24,79 DOUBLE
	ESCKEY()
	@ 1,0 SAY Replicate("-",80)

	@ 2,0 SAY " SIF. OPIS "
	@ 2,30 SAY " GRUPA ROBE "

	@ 3,0 SAY Replicate("-",80)

	DISPLAY OFF NEXT 15 Space(3), SIFOP, Space(5), AUTOOP
	SKIP

	IF Eof()
		Izbor = 3
	ELSE
		Izbor = 1
	ENDIF

	@ 22,25 PROMPT " Dalje " MESSAGE "Sledeca stranica"
	@ 22,32 PROMPT " Nazad " MESSAGE "Predhodna stranica"
	@ 22,39 PROMPT " Pocetak " MESSAGE "Lista od pocetka"
           
	CLEAR TYPEAHEAD
	MENU TO Izbor

	DO CASE
	   CASE Lastkey() = 27
			EXIT
		CASE Izbor = 1
   		LOOP
   	CASE Izbor = 2
   		SKIP -29
   	CASE Izbor = 3
   		GO TOP
   		LOOP
	ENDCASE

ENDDO

USE

RETURN