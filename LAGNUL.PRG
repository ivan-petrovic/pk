LOCAL wBr, ind, SumaM, SumaD

SELECT 1
USE ARTPANE INDEX APINSIF

DO WHILE .T.

	SumaM = val("0000000000.00")
	SumaD = val("0000000000000000.00")

	* MainMask("STAMPA LAGER ARTIKALA CIJE JE STANJE KOLICINA NULA")

   SET CONSOLE OFF
   SET ALTERNATE TO c:\PK\lagnul.html
   SET ALTERNATE ON
   header("Stampa lagera sa kolicinom nula","lagnul.css")
   makeHeader(Alltrim(gcNazRad) + " - Lager sa kolicinom nula")

	Glavicw()

	wBr = val("0000")
	ind = 0

	DO WHILE .T.
		IF Eof()
			ind = 1
			EXIT
		ENDIF

		IF ARTKOL # 0
			SKIP
			LOOP
		ENDIF

		wBr = wBr + 1
		
      ? TR_EL_open("", 12)
      ? TD_EL_Num(wBr, 0, 12)
      ? TD_EL_Num(ARTSIF, 0, 12)
      ? TD_EL_Str(ARTNAZ, 12)
      ? TD_EL_Num(ARTKOL, 2, 12)
      ? TD_EL_Num(ARTCEN, 2, 12)
      ? TD_EL_Num(ARTCEN * gnBod, 2, 12)
      ? TR_EL_close("", 12)

		* @ Red,0  SAY wBr PICTURE "9999"
		* @ Red,5  SAY ARTSIF PICTURE "9999999999999"
		* @ Red,19 SAY substr(ARTNAZ,1,28)
		* @ Red,48 SAY ARTKOL PICTURE "9999"
		* @ Red,52 SAY ARTCEN PICTURE "99999.99"
		* @ Red,61 SAY (ARTCEN * gnBod) PICTURE "999,999,999,999.99"

		SumaM = SumaM + (ARTCEN * ARTKOL)
		SumaD = SumaD + (ARTCEN * gnBod * ARTKOL)

		SKIP
	ENDDO

	IF ind = 1
      ? TR_El_open("zbir", 12)
      ? General_El('<td colspan="4" class="centriraj">UKUPNO</td>',12)
      ? TD_EL_Num(SumaM, 2, 12)
      ? TD_EL_Num(SumaD, 2, 12)
      ? TR_El_close("zbir", 12)

   	* @ Red,40 SAY SumaM PICTURE "9,999,999,999.99"
   	* @ Red,57 SAY SumaD PICTURE "999,999,999,999,999.99"
   	EXIT
	ENDIF

ENDDO

? TBL_El_close("lagnul-table", 6)
? General_El("</div> <!-- lagnul -->",6)

DO futer

SET ALTERNATE TO
SET ALTERNATE OFF
SET CONSOLE ON

USE

RETURN

******************************************
PROCEDURE Glavicw

   ? General_El('<div class="lagnul">',6)
   ? TBL_El_open("lagnul-zaglavlje", 9)

   ? TR_El_open("", 12)
   ? TD_El_Str(gcNazRad, 12)
   ? TD_El_Str("LAGER SA KOLICINOM NULA", 12)
   ? TD_El_Str(DtoC(Date()), 12)
   ? TD_El_Str("BOD: " + Str(gnBod,16,2), 12)
   ? TR_El_close("", 12)

   ? TBL_El_close("lagnul-zaglavlje", 9)

   ? TBL_El_open("lagnul-table", 9)
   ? General_El("<thead>",9)

   ? TR_El_open("", 12)
   ? TH_El_Str("RB", 12)
   ? TH_El_Str("Sifra", 12)
   ? TH_El_Str("Naziv artikla", 12)
   ? TH_El_Str("Kolicina", 12)
   ? TH_El_Str("Bodovi", 12)
   ? TH_El_Str("Cena u dinarima", 12)
   ? TR_El_close("", 12)

   ? General_El("</thead>",9)

RETURN
******************************************
