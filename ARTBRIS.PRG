LOCAL DN, wArtSif

SELECT 1
USE ARTPANE INDEX APINSIF, APINART

DO WHILE .T.

	wArtSif = Val("0000000000000")
	DN = " "

	MainMask("BRISANJE ARTIKLA IZ EVIDENCIJE")
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

	IF ARTKOL > 0
		MessageBox("Ne moze se brisati ovaj artikal jer ga ima na kolicini.")
		LOOP
	ENDIF

	@ 6 , 9 SAY "NAZIV ARTIKLA"
	@ 7 , 1 SAY ARTNAZ
	@ 6 ,35 SAY "KOLICINA"
	@ 7 ,33 SAY ARTKOL PICTURE "999,999"
	@ 6 ,50 SAY "CENA"
	@ 7 ,47 SAY ARTCEN PICTURE "999,999.99"
	@ 6 ,67 SAY "DINARA"
	@ 7 ,61 SAY (ARTCEN * gnBod) PICTURE "999,999,999,999.99"
	@ 15,10 SAY "Brisanje ove sifre (D/N)? " GET DN PICTURE "!" VALID (DN $ "DN")
	READ

	IF Lastkey() = 27
		LOOP
	ENDIF

	IF DN = "D"
		DELETE
		PACK
	ENDIF

ENDDO

CLOSE DATABASES

RETURN
