LOCAL DN, zez, wBr, ind, pom, pom1
LOCAL wTar, wImaTar, SumaM, SumaD, SumaDT, Nivo, prTar

PRIVATE wText, wDat

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
   * @ 10,15 SAY "STAMPANJE LAGER LISTE (D/N)? " GET DN PICTURE "!" VALID(DN $ "DdNn")
   * READ

	* IF Lastkey() = 27 .or. DN = "N"
   *  CLOSE DATABASES
   *  RETURN
  	* ENDIF

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
   
   SET CONSOLE OFF
   SET ALTERNATE TO c:\PK\lagtar.html
   SET ALTERNATE ON
   header("Stampa lagera po tarifama","lagtar.css")
   makeHeader(Alltrim(gcNazRad) + " - Lager po tarifama")

	Glavkoja()

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

			***********************************
			*  UBACEN DEO ZA RAZDVAJANJE TARIFA
			***********************************
			IF ARTKOL = 0
				SKIP
				LOOP
			ENDIF
			*********************************

			wBr = wBr + 1

         ? TR_EL_open("", 12)
         ? TD_EL_Num(wBr, 0, 12)
         ? TD_EL_Num(ARTSIF, 0, 12)
         ? TD_EL_Str(ARTNAZ, 12)
         ? TD_EL_Num(ARTKOL, 2, 12)
         ? TD_EL_Num(ARTCEN, 2, 12)
         ? TD_EL_Num(ARTCEN * ARTKOL, 2, 12)
         ? TR_EL_close("", 12)

			* @ Red, 0 SAY wBr PICTURE "9999"
			* @ Red, 5 SAY ARTSIF PICTURE "9999999999999"
			* @ Red,19 SAY Substr(ARTNAZ,1,28)
			* @ Red,48 SAY ARTKOL PICTURE "9999.99"
			* @ Red,56 SAY ARTCEN PICTURE "99999.99"
			* @ Red,65 SAY Round(ARTCEN * ARTKOL,2) PICTURE "999,999,999.99"
			* Red = Red + 1

			SumaM  = SumaM + Round(ARTCEN * ARTKOL,2)
			SumaD  = SumaD + Round(ARTCEN * gnBod * ARTKOL,2)
			SumaDT = SumaDT + Round(ARTCEN * gnBod * ARTKOL,2)

			SKIP
		ENDDO

      ? TR_El_open("zbir", 12)
      ? General_El('<td colspan="5" class="centriraj">ZBIR ZA TARIFU ' + prTar +'</td>',12)
      ? TD_EL_Num(SumaDT, 2, 12)
      ? TR_El_close("zbir", 12)

		* @ Red,30 SAY "ZBIR ZA TARIFU"
		* @ Red,46 SAY prTar
		* @ Red,57 SAY SumaDT PICTURE "999,999,999,999,999.99"
		* Red = Red + 1

		SumaDT = 0
		
		IF wImaTar = 1
			EXIT
		ENDIF
	ENDDO

	IF wImaTar = 1
		EXIT
	ENDIF

	IF ind = 1
      ? TR_El_open("zbir", 12)
      ? General_El('<td colspan="5" class="centriraj">UKUPNO:</td>',12)
      ? TD_EL_Num(SumaD, 2, 12)
      ? TR_El_close("zbir", 12)

		* @ Red,0 SAY Replicate("-",79)
		* Red = Red + 1
		* @ Red,57 SAY SumaD PICTURE "999,999,999,999,999.99"
		EXIT
	ENDIF

ENDDO

? TBL_El_close("lagtar-table", 6)
? General_El("</div> <!-- lagtar -->",6)

DO futer

SET ALTERNATE TO
SET ALTERNATE OFF
SET CONSOLE ON

CLOSE DATABASES
ERASE ARTINTAR.NTX

RETURN

******************************************
PROCEDURE Glavkoja

? General_El('<div class="lagtar">',6)
? TBL_El_open("lagtar-zaglavlje", 9)

? TR_El_open("", 12)
? TD_El_Str(gcNazRad, 12)
? TD_El_Str(wText, 12)
? TD_El_Str(DtoC(wDat), 12)
? TR_El_close("", 12)

? TBL_El_close("lagtar-zaglavlje", 9)

? TBL_El_open("lagtar-table", 9)
? General_El("<thead>",9)

? TR_El_open("", 12)
? TH_El_Str("RB", 12)
? TH_El_Str("Sifra", 12)
? TH_El_Str("Naziv artikla", 12)
? TH_El_Str("Kolicina", 12)
? TH_El_Str("Cena", 12)
? TH_El_Str("Iznos u dinarima", 12)
? TR_El_close("", 12)

? General_El("</thead>",9)

RETURN
******************************************
