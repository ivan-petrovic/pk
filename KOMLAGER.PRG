LOCAL SumaM, SumaD, Nivo, zez, DN, ind
LOCAL pom, pom1, wBr, indja, pomSiOp, Limuz
PRIVATE Dat, Red

USE ARTPANE
INDEX ON Str(SIOP) + ARTNAZ TO TAKOIN
USE

SELECT 3
USE OPIS INDEX OPIN

SELECT 1
USE ARTPANE INDEX TAKOIN

SELECT 1
DO WHILE .T.

	Dat = date()
	SumaM = val("0000000000.00")
	SumaD = val("0000000000000000.00")
	Nivo = val("0")
	zez = val("0")
	DN = " "

	MainMask("STAMPA LAGERA JEDNE PRODAVNICE SORTIRAN PO GRUPAMA ROBE")
	@ 10,15 SAY "STAMPANJE LAGER LISTE (D/N)? " GET DN PICTURE "!" VALID(DN $ "DdNn")
	READ

	IF Lastkey() = 27
		CLOSE DATABASES
		RETURN
	ENDIF

	IF DN = "N"
		CLOSE DATABASES
		RETURN
	ENDIF

	@ 12,15 SAY "UNESITE NIVO LAGERA (BROJ PRODAVNICE)" GET Nivo PICTURE "9"
	READ

	IF Lastkey() = 27
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
		Glavic()
	ENDIF

	wBr = val("0000")
	ind = 0
	pomSiOp = val("00000")
	indja = 0
	Limuz = Space(30)

	DO WHILE .T.
		IF Eof()
			ind = 1
			EXIT
		ENDIF
     
		pom = Str(ARTSIF,13,0)
		pom1 = Ltrim(pom)
		pom1 = Substr(pom1,1,1)
		IF Nivo = 0
			zez = zez + 0
		ELSE
			IF ! Val(pom1) = Nivo
				SKIP
				LOOP
			ENDIF
		ENDIF

		IF Red > 60
			Glavic()
		ENDIF

		wBr = wBr + 1
		IF indja = 0
			indja = 1
			pomSiOp = A->SIOP

			SELECT 3
			SEEK pomSiOp
			Limuz = AUTOOP

			@ Red,25 SAY Limuz
			Red = Red + 1

			@ Red,0 SAY Replicate("-",78)
			Red = Red + 1

			SELECT 1
		ENDIF

		IF pomSiOp = SIOP
			zez = zez + 0
		ELSE
			pomSiOp = SIOP

			SELECT 3
			SEEK pomSiOp
			Limuz = AUTOOP

			@ Red,25 SAY Limuz
			Red = Red + 1

			@ Red,0 SAY Replicate("-",78)
			Red = Red + 1

			SELECT 1
		ENDIF

		IF artkol = 0
			SKIP
			LOOP
		ENDIF

		@ Red,0 SAY wBr PICTURE "9999"
		@ Red,5 SAY ARTSIF PICTURE "9999999999999"
		@ Red,19 SAY Substr(ARTNAZ,1,28)
		@ Red,48 SAY ARTKOL PICTURE "9999.99"
		@ Red,56 SAY ARTCEN PICTURE "99999.99"
		@ Red,65 SAY Round(ARTCEN * ARTKOL,2) PICTURE "999,999,999.99"
		Red = Red + 1
		
		SumaM = SumaM + Round(ARTCEN * ARTKOL,2)
		SumaD = SumaD + Round(ARTCEN * gnBod * ARTKOL,2)

		SKIP
   ENDDO

	IF ind = 1
   	@ Red,0 SAY Replicate("-",79)
   	Red = Red + 1
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

CLOSE DATABASES

RETURN

*********************************************
PROCEDURE Glavic

	Red = 1
	@ 1,1 SAY gcNazRad
	@ 1,24 SAY "LAGER LISTA NA DAN"
	@ 1,45 SAY Dat
	@ 1,56 SAY "BOD"
	@ 1,60 SAY gnBod PICTURE "9,999,999,999.99"

	Red = Red + 2
	@ Red,1 SAY "RB"
	@ Red,9 SAY "SIFRA"
	@ Red,26 SAY "NAZIV ARTIKLA"
	@ Red,48 SAY "KOL"
	@ Red,53 SAY "  CENA"
	@ Red,63 SAY "IZNOS U DINARIMA"

	Red = Red + 1
	@ Red,0 SAY Replicate("-",79)
	Red = Red + 1

RETURN

*********************************************
