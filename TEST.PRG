/*
? KonBr("601" + "1803957715590")

***************************************************************
* Pomocna funkcija koja racuna kontrolni broj po modulu 97
* cBroj - string koji sadrzi broj za koji se racuna kontrolni broj
*
* Trebalo bi ovako:
* 98 - [(cBroj * 100) mod 97]
*
* Posto je broj za koji se racuna kontrolni broj preveliki
* (cBroj ima 16 cifara, puta 100, 18 cifara)
* koristi se identitet:
* a x b mod n = [(a mod n) x (b mod n)] mod n
FUNCTION KonBr(cBroj)
   LOCAL a:=0, b:=100, rez:=0

   a = Val(cBroj)
   rez = 98 - ((a % 97) * (b % 97)) % 97
RETURN Str(rez,2,0)
***************************************************************
*/

/*
* Stampa virmana na 'beskonacnom' papiru sa 3 naloga za prenos po listu
LOCAL i, cLine

SET DEVICE TO PRINT
SET PRINTER TO LPT1
SET PRINT ON

* cLine = "|   5    |    5    |    5    |    5    |    5    |    5    |    5    |    5"
* FOR i := 0 TO 3

*    FOR j := 1 TO 65
*       ? IIF(j % 2 == 0, j, cLine)
*    NEXT j
   
*    IF i < 3; EJECT; ENDIF

* NEXT i

FOR i := 1 TO 3
   printVirman(1)
   printVirman(8)
   printVirman(8)
   EJECT
NEXT i

SET PRINTER OFF
SET PRINT TO
SET DEVICE TO SCREEN

RETURN

* nSkip = 1 za prvi virman na strani
* nSkip = 8 za drugi virman na strani
* nSkip = 8 za treci virman na strani
PROCEDURE printVirman(nSkip)
   cDuznik1 = "JP za izgradnju"
   cDuznik2 = "V. Karadzica 99D, Obrenovac"
   cSvrha1 = "Uplata zarada"
   cSvrha2 = "za mesec 03/2014"
   cPoverilac1 = "Ivan Petrovic"
   cPoverilac2 = "A. A. Simovica 48A, Obrenovac"
   cMestoDatum = "Obrenovac, 05.04.2014."
   
   cSifra = "240"
   cValuta = "RSD"
   cIznos = "= 56.258,12"
   cRacunDuznika = "Racun JP za izgradnju"
   cModel1 = "12"
   cPoziv1 = "123-456-789"
   cRacunPoverioca = "Racun Ivana Petrovica"
   cModel2 = "97"
   cPoziv2 = "987-654-321"

   FOR j := 1 TO nSkip
      ?
   NEXT j

   * red 2
   ? Space(5) + substr(PadR(cDuznik1,40),1,30) + Space(9)
   ?? substr(PadR(cSifra,10),1,5) + Space(2)
   ?? substr(PadR(cValuta,10),1,5) + Space(5)
   ?? cIznos

   * red 3
   ? Space(5) + substr(PadR(cDuznik2,40),1,30)

   ?     && red 4

   * red 5
   ? Space(50) + substr(PadR(cRacunDuznika,40),1,25)

   ?     && red 6

   * red 7
   ? Space(5) + substr(PadR(cSvrha1,40),1,30)

   * red 8
   ? Space(5) + substr(PadR(cSvrha2,40),1,30) + Space(9)
   ?? substr(PadR(cModel1,10),1,5) + Space(5)
   ?? substr(PadR(cPoziv1,30),1,20)

   ?     && red 9
   ?     && red 10

   * red 11
   ? Space(50) + substr(PadR(cRacunPoverioca,40),1,25)

   * red 12
   ? Space(5) + substr(PadR(cPoverilac1,40),1,30)
   * red 13
   ? Space(5) + substr(PadR(cPoverilac2,40),1,30)

   * red 14
   ? Space(44) + substr(PadR(cModel2,10),1,5) + Space(5)
   ?? substr(PadR(cPoziv2,30),1,20)

   ?     && red 15
   ?     && red 16

   * red 17
   ? Space(15) + substr(PadR(cMestoDatum,30),1,25)

RETURN
*/
/*
SET ALTERNATE TO lista.htm
SET ALTERNATE ON

? "<!DOCTYPE html>"
? "<html>"
? "	<head>"
? "		<title>Stampa virmana</title>"
? '      <meta http-equiv="Content-Type" content="text/html; charset=utf-8">'
? "	</head>"
? "	<body>"
? "		<div id='nalog1'>"
? "            <h2>Uplatilac</h2>"
? "            <p>Иван Ivan Petrovic</p>"
? "      </div>"
? "	</body>"
? "</html>"

SET ALTERNATE TO
SET ALTERNATE OFF
CLEAR SCREEN
RETURN
*/
/*
IF logUsage("PROBA")
   ? "Uspesan upis."
ELSE
   ? "Neuspesan upis."
ENDIF


FUNCTION logUsage(fname)
   LOCAL lSuccess := .F.

   IF File("C:\PK\USAGELOG.DBF")
      SELECT 0
      USE C:\PK\USAGELOG.DBF
      
      LOCATE FOR FILENAME = fname
      IF Found()
         REPLACE CNT WITH CNT + 1
      ELSE
         APPEND BLANK
         REPLACE FILENAME WITH fname
         REPLACE CNT WITH 1
      ENDIF
      
      USE
      lSuccess = .T.
   ENDIF

RETURN lSuccess
*/