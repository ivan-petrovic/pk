LOCAL wArtSif, indik, Red, Izbor, Broj

SELECT 1
USE ARTPANE INDEX APINSIF,APINART

indik = 0

DO WHILE .T.

	wArtSif = val("0000000000000")

	MainMask("LISTANJE ARTIKALA")
	@ 5,10 SAY "Artikal od kojeg zelite pregled"
	@ 6,33 SAY "(ENTER - od pocetka do kraja)"
	@ 6,15 GET wArtSif PICTURE "9999999999999"
	READ

	IF Lastkey() = 27
		EXIT
	ENDIF

	IF Empty(wArtSif)
		GO TOP
	ELSE
		SEEK wArtSif
		IF ! Found()
			MessageBox("Ne postoji takav artikal!")
			LOOP
		ENDIF
	ENDIF

	Red = 5
	DO WHILE .T.

		IF ! Eof()
			IF Red = 5
				CLEAR SCREEN
				ESCK()

				@ 2,35 SAY "LISTANJE ARTIKALA"
				@ 3,1 SAY Replicate("*",78)
				@ 4,4 SAY "SIFRA"
				@ 4,22 SAY "NAZIV ARTIKLA"
				@ 4,44 SAY "KOLICINA"
				@ 4,56 SAY "CENA"
				@ 4,70 SAY "DINARA"
				@ 5,1 SAY Replicate("*",78)
			ENDIF

			Red = Red + 1
			@ Red,0 SAY ARTSIF
			@ Red,14 SAY ARTNAZ
			@ Red,44 SAY ARTKOL PICTURE "999,999"
			@ Red,52 SAY ARTCEN PICTURE "999,999.99"
			@ Red,63 SAY Round(ARTCEN * ARTKOL, 2) PICTURE "9999,999,999.99"

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
		ENDIF && ! Eof()

		@ 19,1 SAY "Zavrseno listanje!!"

		Izbor = 1
		@ 22,1  PROMPT "PRETHODNI EKRAN"
		@ 22,30 PROMPT "OD POCETKA"

		MENU TO Izbor

		DO CASE
			CASE Lastkey() = 27
				indik = 1
				EXIT
			CASE Izbor = 1
				Red = 5
				IF Recno() > 22
					Broj = (Red - 5) + 11
					SKIP -Broj
					LOOP
				ELSE
					GO TOP
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

CLOSE DATABASES

RETURN
