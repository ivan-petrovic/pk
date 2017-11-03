LOCAL DN, wBr, ind, SumaM, SumaD, Odl, Nivo, zez, pom, pom1
LOCAL	wStop, wPrer, SumBez, SumPor, sSumBez,	sSumPor

PRIVATE Dat, Red

SELECT 3
USE TARDAT INDEX TARINSIF

MainMask("LAGER SA CENAMA BEZ P/P, P/P I CENE SA P/P")

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

SELECT 1
DO WHILE .T.

	MainMask("LAGER SA CENAMA BEZ P/P, P/P I CENE SA P/P")

	Dat = Date()
	wStop = Val("000.00")
	wPrer = Val("000.00")
	SumBez = Val("000000000000.00")
	SumPor = Val("000000000000.00")
	SumaM = Val("000000000000.00")
	SumaD = Val("0000000000000000.00")
	sSumBez = Val("000000000000.00")
	sSumPor = Val("000000000000.00")
	DN = " "
	Nivo = Val("0")
	zez = Val("0")

	@ 10,15 SAY "STAMPANJE LAGER LISTE (D/N)? " GET DN PICTURE "!" VALID(DN $ "DdNn")
	READ
	
	IF Lastkey() = 27 .OR. DN = "N"
   	CLOSE DATABASES
		RETURN
	ENDIF

	@ 12,10 SAY "UNESITE NIVO LAGERA (BROJ PRODAVNICE)" GET Nivo PICTURE "9"
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
   IF lLaser
      ? Chr(27) + '(s17.5H'      && kondenz On za laserski
   ELSE
      ? Chr(15)                  && kondenz On za matricni
   ENDIF

	IF Red > 62
		Glavic1c()
	ENDIF

	wBr = Val("0000")
	ind = 0
	
	DO WHILE .T.
   	wPrer = 0
		SumPor = 0
		SumBez = 0
		wStop = 0

		IF Eof()
      	ind = 1
			EXIT
		ENDIF
     
		pom  = Str(ARTSIF,13,0)
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
			Glavic1c()
		ENDIF
		
		IF ARTKOL = 0
			SKIP
			LOOP
		ENDIF
		
		* trazenje stope i racunanje poreza
		SELECT 3
		SEEK A->ARTTAR
		IF Found()
			wStop = TARZBIR
		ELSE
			wStop = 0
		ENDIF
		
		SELECT 1
		wPrer   = Round((wStop * 100) / (wStop + 100),2)
		SumPor  = Round(ARTCEN * wPrer / 100,2)
		SumBez  = Round(ARTCEN - SumPor,2)
		sSumPor = Round(sSumPor + SumPor * ARTKOL,2)
		sSumBez = Round(sSumBez + SumBez * ARTKOL,2)
		* kraj svega toga
				
		wBr = wBr + 1 
		@ Red,0   SAY wBr PICTURE "9999"
		@ Red,5   SAY ARTSIF PICTURE "9999999999999"
		@ Red,19  SAY Substr(ARTNAZ,1,28)
		@ Red,48  SAY wStop PICTURE "999.99"
		@ Red,55  SAY ARTKOL PICTURE "99999.99"
		@ Red,64  SAY SumBez PICTURE "9999,999,999.99"
		@ Red,80  SAY SumPor PICTURE "9999,999,999.99"
		@ Red,96  SAY ARTCEN PICTURE "9999,999,999.99"
		@ Red,112 SAY Round(ARTCEN * ARTKOL,2) PICTURE "9,999,999,999.99"
		Red = Red + 1
		
		SumaM = SumaM + Round(ARTCEN * ARTKOL,2)
		SumaD = SumaD + Round(ARTCEN * gnBod * ARTKOL,2)
		
		SKIP
   ENDDO
	
	IF ind = 1
   	@ Red,0 SAY Replicate("-",129)
		Red = Red + 1
		@ Red,64  SAY sSumBez PICTURE "9999,999,999.99"
		@ Red,80  SAY sSumPor PICTURE "9999,999,999.99"
		@ Red,112 SAY SumaD   PICTURE "9,999,999,999.99"
		EXIT
	ENDIF

ENDDO

Red = Red + 1
@ Red,0 SAY " "
IF lLaser
   @ Red,0 SAY Chr(27) + '&k0S' + chr(27) + '(s10.5H'  && kondenz Off za laserski
ELSE
   @ Red,0 SAY Chr(18)                                 && kondenz Off za matricni
ENDIF

SET DEVICE TO SCREEN
SET PRINT OFF
SET PRINT TO

CLOSE DATABASES

RETURN

******************************************
PROCEDURE Glavic1c

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
	@ Red,48 SAY " STOPA"
	@ Red,55 SAY "KOLICINA"
	@ Red,64 SAY "CENA BEZ POREZA"
	@ Red,80 SAY "   IZNOS POREZA"
	@ Red,96 SAY "CENA SA POREZOM"
	@ Red,112 SAY "IZNOS U DINARIMA"
	Red = Red + 1
	
	@ Red,0 SAY Replicate("-",129)
	Red = Red + 1

RETURN
******************************************
