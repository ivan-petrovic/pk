LOCAL DN, wBr, ind, SumaM, SumaD

PRIVATE Dat, Red

SELECT 1
USE ARTPANE INDEX APINSIF

DO WHILE .T.

	Dat = date()
	SumaM = val("0000000000.00")
	SumaD = val("0000000000000000.00")
	DN = " "

	MainMask("STAMPA LAGER ARTIKALA CIJE JE STANJE KOLICINA NULA")
	@ 10,10 SAY "STAMPANJE LAGER LISTE ARTIKALA SA STANJEM NULA (D/N)? " ;
	        GET DN PICTURE "!" VALID(DN $ "DdNn")
	READ

	IF Lastkey() = 27
		CLOSE DATABASES
		RETURN
	ENDIF

	IF DN = "N"
		CLOSE DATABASES
		RETURN
	ENDIF

	@ 23,26 SAY ">>  Stampanje je u toku  <<"

	SET DEVICE TO PRINT
	SET PRINTER TO LPT1
	SET PRINT ON

	Setprc(0,0)
	Red = 80

	IF Red > 62
		Glavicw()
	ENDIF

	wBr = val("0000")
	ind = 0

	DO WHILE .T.
		IF Eof()
			ind = 1
			EXIT
		ENDIF

		IF Red > 60
			Glavicw()
		ENDIF

		IF ARTKOL # 0
			SKIP
			LOOP
		ENDIF

		wBr = wBr + 1
		@ Red,0  SAY wBr PICTURE "9999"
		@ Red,5  SAY ARTSIF PICTURE "9999999999999"
		@ Red,19 SAY substr(ARTNAZ,1,28)
		@ Red,48 SAY ARTKOL PICTURE "9999"
		@ Red,52 SAY ARTCEN PICTURE "99999.99"
		@ Red,61 SAY (ARTCEN * gnBod) PICTURE "999,999,999,999.99"
		Red = Red + 1

		SumaM = SumaM + (ARTCEN * ARTKOL)
		SumaD = SumaD + (ARTCEN * gnBod * ARTKOL)

		SKIP
	ENDDO

	IF ind = 1
   	@ Red,0 SAY Replicate("-",79)
   	Red = Red + 1
   	@ Red,40 SAY SumaM PICTURE "9,999,999,999.99"
   	@ Red,57 SAY SumaD PICTURE "999,999,999,999,999.99"
   	EXIT
	ENDIF

ENDDO

Red = Red + 1
@ Red,0 SAY " "

EJECT
SET DEVICE TO SCREEN
SET PRINT OFF
SET PRINT TO

USE

RETURN

******************************************
PROCEDURE Glavicw

	Red = 1
	@ 1,1 SAY gcNazRad
	@ 1,24 SAY "LAGER SA KOLIC. NULA"
	@ 1,45 SAY Dat
	@ 1,56 SAY "BOD"
	@ 1,60 SAY gnBod PICTURE "9,999,999,999.99"
	Red = Red + 2

	@ Red,1 SAY "RB"
	@ Red,9 SAY "SIFRA"
	@ Red,26 SAY "NAZIV ARTIKLA"
	@ Red,48 SAY "KOL"
	@ Red,53 SAY "BODOVI"
	@ Red,65 SAY "CENA U DINARIMA"
	Red = Red + 1

	@ Red,0 SAY Replicate("-",79)
	Red = Red + 1

RETURN
******************************************
