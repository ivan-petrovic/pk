LOCAL indik, Izbor, wArtNaz, Red, Broj

SELECT 1
USE ARTPANE INDEX APINSIF

indik = 0

DO WHILE .T.

	wArtNaz = Space(13)
	MainMask("LISTANJE ARTIKALA")
	@ 5,10 SAY "Unesite deo naziva artikla"      
	@ 6,15 GET wArtNaz PICTURE "@!" VALID ! Empty(wArtNaz)
	READ

	IF Lastkey() = 27
		EXIT
	ENDIF

	SET FILTER TO ! At(Alltrim(wArtNaz), ARTNAZ) = 0
	GO TOP

	Red = 5
	DO WHILE .T.     
		
		IF ! Eof()
			IF Red = 5 
				CLEAR SCREEN
				ESCK()
				@ 2,35 SAY "LISTANJE ARTIKALA"
				@ 3,1  SAY Replicate("*",78)
				@ 4,4  SAY "SIFRA"  
				@ 4,22 SAY "NAZIV ARTIKLA"
				@ 4,44 SAY "JM "
				@ 4,49 SAY "KOLICINA"
				@ 4,62 SAY "CENA"
				@ 4,72 SAY "DINARA"
				@ 5,1  SAY Replicate("*",78)
			ENDIF

			Red = Red + 1
			@ Red,0 SAY ARTSIF
			@ Red,14 SAY ARTNAZ
			@ Red,44 SAY ARTJM
			@ Red,48 SAY ARTKOL PICTURE "99999.999"
			@ Red,58 SAY ARTCEN PICTURE "99999.99"
			@ Red,67 SAY (ARTCEN * gnBod) PICTURE "99999999.99"

			IF Red > 15
				Red = 5

				Izbor = 1
				@ 22,1  PROMPT "DALJE"
				@ 22,30 PROMPT "PRETHODNI EKRAN"
				@ 22,55 PROMPT "OD POCETKA"

				MENU TO Izbor

				DO CASE
					CASE Lastkey() = 27
						indik = 1
						EXIT
					CASE Izbor = 2
						IF Recno() > 22
							SKIP -22
						ELSE 
							GO TOP
						ENDIF
						LOOP
					CASE Izbor = 3
						GO TOP
						LOOP
					CASE Izbor = 1
				ENDCASE
			ENDIF
			
			SKIP
			LOOP
		ENDIF	&& ! Eof()

		@ 19,1 SAY "Zavrseno listanje!!"

		Izbor = 1
		@ 22,1 PROMPT "PRETHODNI EKRAN"
		@ 22,30 PROMPT "OD POCETKA"

		MENU TO Izbor

		DO CASE
			CASE Lastkey() = 27
				indik = 1
				EXIT
			CASE Izbor = 1
				IF Recno() > 22
					Broj = (Red - 5) + 11
					SKIP -Broj
					Red = 5
					LOOP
				ELSE
					GO TOP
					Red = 5
					LOOP
				ENDIF
			CASE Izbor = 2
				GO TOP
				Red = 5
				LOOP
			OTHERWISE
				indik = 1
				EXIT
		ENDCASE

		EXIT
	ENDDO

	IF indik = 1
		indik = 0
		LOOP
	ENDIF

ENDDO

SET FILTER TO

RETURN
