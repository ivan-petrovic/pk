LOCAL Odl, DN, SumaM, SumaD, Nivo, zez, wBr, ind, pom, pom1
PRIVATE wText, wDat, Red

MainMask("STAMPA LAGER JEDNE PRODAVNICE SORTIRAN PO SIFRAMA ROBE")

Odl = " "
@ 10,10 SAY "LAGER PO SIFRAMA/NAZIVI (S/N) " GET Odl PICTURE "!" VALID(Odl $ "SsNn")
READ

IF Lastkey() = 27
	RETURN
ENDIF

IF Odl = "S"
   SELECT 1
   USE ARTPANE INDEX APINSIF
ELSE
   SELECT 1
   USE ARTPANE INDEX APINART
ENDIF

DO WHILE .T.

	wDat = date()
	wText = Space(30)
	SumaM = val("0000000000.00")
	SumaD = val("0000000000000000.00")
	DN = " "
	Nivo = val("0")
	zez = val("0")

	MainMask("STAMPA LAGER JEDNE PRODAVNICE SORTIRAN PO SIFRAMA ROBE")
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

	@ 12,10 SAY "UNESITE NIVO LAGERA (BROJ PRODAVNICE)" GET Nivo PICTURE "9"
	@ 14,15 SAY "DATUM NA LAGER LISTI " GET wDat
	@ 16,15 SAY "TEKST (POPIS ILI LAGER LISTA)" GET wText
	READ

	IF Lastkey() = 27
   	CLOSE DATABASES
   	RETURN
	ENDIF

	@ 23,26 SAY ">>  Stampanje je u toku  <<"

	SET DEVICE TO PRINT
	SET PRINTER TO LPT1
	SET PRINT ON

	Red = 80
	IF Red > 62
		Glavic1()
	ENDIF

	wBr = val("0000")
	ind = 0

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
			Glavic1()
		ENDIF
		
		IF artkol = 0
			SKIP
			LOOP
		ENDIF
		
		wBr = wBr + 1
		@ Red,0 SAY wBr PICTURE "9999"
		@ Red,5 SAY ARTSIF PICTURE "9999999999999"
		@ Red,19 SAY Substr(ARTNAZ,1,28)
		@ Red,48 SAY ARTKOL PICTURE "9999.99"
		@ Red,56 SAY ARTCEN PICTURE "99999.99"
		@ Red,65 SAY Round(ARTCEN * ARTKOL,2) PICTURE "999,999,999.99"
		SumaM = SumaM + Round(ARTCEN * ARTKOL,2)
		SumaD = SumaD + Round(ARTCEN * gnBod * ARTKOL,2)
		Red = Red + 1

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

SET DEVICE TO SCREEN
SET PRINT OFF
SET PRINT TO

CLOSE DATABASES

RETURN

******************************************
PROCEDURE Glavic1

Red = 1
@ 1,1 SAY gcNazRad
@ 1,24 SAY wText
@ 1,56 SAY wDat
@ 1,67 SAY "BOD"
@ 1,71 SAY gnBod PICTURE "9,999.99"

Red = Red + 2
@ Red,1 SAY "RB"
@ Red,9 SAY "SIFRA"
@ Red,26 SAY "NAZIV ARTIKLA"
@ Red,48 SAY "KOL"
@ Red,53 SAY "  CENA"
@ Red,63 SAY "IZNOS U DINARIMA"

Red = Red + 1
@ Red,0 SAY repli("-",79)
Red = Red + 1

RETURN

******************************************
