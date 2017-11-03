LOCAL wBr, SumaM, SumaD, wPrer, SumBez, SumPor
LOCAL sSumBez, sSumPor, wDmpBro

PRIVATE Dat, Red

SELECT 1
USE DMPDAT INDEX DMPINBRO,DMPINBS

DO WHILE .T.
   
	MainMask("STAMPA P/P, BEZ P/P, SA P/P PO KALKULACIJI")
	wDmpBro = Space(10)
	@ 3,1 SAY "Kalkulacija:" GET wDmpBro PICTURE "@!" VALID ! Empty(wDmpBro)
	READ
	
	IF Lastkey() = 27
     CLOSE DATABASES
     RETURN
	ENDIF
	
	SEEK wDmpBro
	IF ! Found()
		MessageBox("Ne postoji takva kalkulacija!")
		LOOP
	ENDIF
	
	Dat      = Date()
	wPrer    = Val("000.00")
	SumBez   = Val("000000000000.00")
	SumPor   = Val("000000000000.00")
	SumaM    = Val("000000000000.00")
	SumaD    = Val("0000000000000000.00")
	wBr      = Val("0000")
	sSumBez  = Val("000000000000.00")
	sSumPor  = Val("000000000000.00")

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
		Glawic1c()
	ENDIF
	
	DO WHILE (DMPBRO = wDmpBro)
		wPrer   = Round((DMPPOR * 100) / (DMPPOR + 100),2)
		SumPor  = Round(DMPMSP * wPrer / 100,2)
		SumBez  = Round(DMPMSP - SumPor,2)
		sSumPor = Round(sSumPor + SumPor * DMPKOL,2)
		sSumBez = Round(sSumBez + SumBez * DMPKOL,2)

		wBr = wBr + 1
		@ Red,0   SAY wBr PICTURE "9999"
		@ Red,5   SAY DMPSIF PICTURE "9999999999999"
		@ Red,19  SAY Substr(DMPNAZ,1,28)
		@ Red,48  SAY DMPPOR PICTURE "999.99"
		@ Red,55  SAY DMPKOL PICTURE "99999.99"
		@ Red,64  SAY SumBez PICTURE "9999,999,999.99"
		@ Red,80  SAY SumPor PICTURE "9999,999,999.99"
		@ Red,96  SAY DMPMSP PICTURE "9999,999,999.99"
		@ Red,112 SAY Round(DMPMSP * DMPKOL,2) PICTURE "9,999,999,999.99"
		Red = Red + 1
		
		SumaM = SumaM + Round(DMPMSP * DMPKOL,2)
		SumaD = SumaD + Round(DMPMSP * DMPKOL,2)
	
		IF Red > 62
			Glawic1c()
		ENDIF

		SKIP
   ENDDO

	@ Red,0 SAY Replicate("-",129)
	Red = Red + 1

	@ Red,64  SAY sSumBez PICTURE "9999,999,999.99"
	@ Red,80  SAY sSumPor PICTURE "9999,999,999.99"
	@ Red,112 SAY SumaD   PICTURE "9,999,999,999.99"

	EXIT

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
PROCEDURE Glawic1c

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
