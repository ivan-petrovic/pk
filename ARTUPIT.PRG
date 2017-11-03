LOCAL indik, Izbor, wArtSif

SELECT 1
USE ARTPANE INDEX APINSIF

DO WHILE .T.

	indik = 0
	wArtSif = val("0000000000000")
	DN = " "

	MainMask("UPIT O ARTIKLU")
	@ 3,9 TO 5,67
	
	Izbor = 1
	@ 4,10 PROMPT " UPIT PO NAZIVU "
	@ 4,50 PROMPT " UPIT PO SIFRI  "

	MENU TO Izbor

	@ 3,1 SAY Space(78)
	@ 4,1 SAY Space(78)
	@ 5,1 SAY Space(78)

	DO CASE
		CASE Lastkey() = 27
			EXIT
		CASE Izbor = 1
			DO ARTUNAZ
		CASE Izbor = 2
			DO WHILE .T.
				@ 4,1 SAY Space(78)
				@ 5,1 SAY Space(78)
				@ 6,1 SAY Space(78)
				@ 7,1 SAY Space(78)
				@ 23,1 SAY Space(78)
				@ 4,4 SAY "SIFRA"
				@ 5,2 GET wArtSif PICTURE "9999999999999" VALID ! Empty(wArtSif)
				READ

				IF Lastkey() = 27
					EXIT
				ENDIF

				SEEK wArtSif
				IF ! Found()
					MessageBox("Ne postoji artikal sa tom sifrom!")
					LOOP
				ENDIF

				@ 6, 9 SAY "NAZIV ARTIKLA"
				@ 7, 1 SAY ARTNAZ
				@ 6,35 SAY "KOLICINA"
				@ 7,33 SAY ARTKOL PICTURE "999,999"
				@ 6,50 SAY "CENA"
				@ 7,47 SAY ARTCEN PICTURE "99,999,999.99"
				@ 6,67 SAY "DINARA"
				@ 7,61 SAY (ARTCEN * gnBod) PICTURE "999,999,999,999.99"

				@ 23,30 SAY "Jos upita (D/N)? " GET DN PICTURE "!" VALID (DN $ "DN")
				READ

				IF Lastkey() = 27
					indik = 1
					EXIT
				ENDIF

				IF DN = "N"
					indik = 1
					EXIT
				ENDIF

				IF DN = "D"
					wArtSif = val("0000000000000")
					@ 6,1 SAY Space(78)
					@ 7,1 SAY Space(78)
					LOOP
				ENDIF
			ENDDO

			IF indik = 1
				indik = 0
			ENDIF
		ENDCASE

ENDDO

CLOSE DATABASES

RETURN
