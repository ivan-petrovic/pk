LOCAL DN, zez, wBr, ind, pom, pom1
LOCAL wTar, wImaTar, SumaM, SumaD, SumaDT, Nivo, prTar

PRIVATE wText, wDat, Red, nStr

USE ARTPANE
INDEX ON ARTTAR + Str(ARTSIF,13,0) TO ARTINTAR
USE

SELECT 1
USE ARTPANE INDEX ARTINTAR

DO WHILE .T.

   wDat   = Date()
   wText  = Space(30)
   SumaM  = Val("0000000000.00")
   SumaD  = Val("0000000000000000.00")
   SumaDT = Val("0000000000000000.00")
   DN = " "
   Nivo = Val("0")
   zez  = Val("0")
   wTar = Space(8)
   wImaTar = 0

	MainMask("STAMPA LAGER PO TARIFAMA")
   @ 10,15 SAY "STAMPANJE LAGER LISTE (D/N)? " GET DN PICTURE "!" VALID(DN $ "DdNn")
   READ

	IF Lastkey() = 27 .or. DN = "N"
     CLOSE DATABASES
     RETURN
  	ENDIF

	@ 12,15 SAY "DATUM NA LAGER LISTI" GET wDat
	@ 14,15 SAY "TEKST (POPIS ILI LAGER LISTA)" GET wText
	READ

	IF Lastkey() = 27
		CLOSE DATABASES
		RETURN
	ENDIF

   @ 16,10 SAY "UNESITE TARIFU (ENTER sve tarife)" GET wTar
   READ

   IF Lastkey() = 27
      CLOSE DATABASES
      RETURN
   ENDIF

   IF ! Empty(wTar)
		SEEK wTar
		IF ! Found()
			MessageBox("NEMA ARTIKALA SA TAKVOM TARIFOM! ENTER ZA NASTAVAK...")
		  	LOOP
		ENDIF
		wImaTar = 1
   ENDIF
   
	@ 23,26 SAY ">>  Stampanje je u toku  <<"

	SET DEVICE TO PRINT
	SET PRINTER TO LPT1
	* SET PRINTER TO Lista
	SET PRINT ON

	Setprc(0,0)
	Red = 80
	nStr = 1

	IF Red > 62
		Glavkoja()
	ENDIF

	wBr = Val("0000")
	ind = 0

	DO WHILE .T.
		IF Eof()
			ind = 1
			EXIT
		ENDIF

		prTar = ARTTAR

		DO WHILE prTar = ARTTAR
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
				Glavkoja()
			ENDIF

			***********************************
			*  UBACEN DEO ZA RAZDVAJANJE TARIFA
			***********************************
			IF ARTKOL = 0
				SKIP
				LOOP
			ENDIF
			*********************************

			wBr = wBr + 1
			@ Red, 0 SAY wBr PICTURE "9999"
			@ Red, 5 SAY ARTSIF PICTURE "9999999999999"
			@ Red,19 SAY Substr(ARTNAZ,1,28)
			@ Red,48 SAY ARTKOL PICTURE "9999.99"
			@ Red,56 SAY ARTCEN PICTURE "99999.99"
			@ Red,65 SAY Round(ARTCEN * ARTKOL,2) PICTURE "999,999,999.99"
			Red = Red + 1

			SumaM  = SumaM + Round(ARTCEN * ARTKOL,2)
			SumaD  = SumaD + Round(ARTCEN * gnBod * ARTKOL,2)
			SumaDT = SumaDT + Round(ARTCEN * gnBod * ARTKOL,2)

			SKIP
		ENDDO

		@ Red,0 SAY Replicate("-",79)
		Red = Red + 1

		@ Red,30 SAY "ZBIR ZA TARIFU"
		@ Red,46 SAY prTar
		@ Red,57 SAY SumaDT PICTURE "999,999,999,999,999.99"
		Red = Red + 1

		@ Red,0 SAY Replicate("-",79)
		Red = Red + 1

		SumaDT = 0
		
		IF wImaTar = 1
			EXIT
		ENDIF
	ENDDO

	IF wImaTar = 1
		EXIT
	ENDIF

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
ERASE ARTINTAR.NTX

RETURN

******************************************
PROCEDURE Glavkoja

	Red = 1
	@ 1,1  SAY gcNazRad
	@ 1,24 SAY wText
	@ 1,55 SAY wDat
	@ 1,71 SAY "str" + Str(nStr,3)
	nStr = nStr + 1

	Red = Red + 2
	@ Red,1  SAY "RB"
	@ Red,9  SAY "SIFRA"
	@ Red,26 SAY "NAZIV ARTIKLA"
	@ Red,48 SAY "KOL"
	@ Red,53 SAY "  CENA"
	@ Red,63 SAY "IZNOS U DINARIMA"

	Red = Red + 1
	@ Red,0 SAY Replicate("-",79)
	Red = Red + 1

RETURN
******************************************
