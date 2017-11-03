***************************************************************
* Program sluzi za prikaz kodirane verzije trazenog datuma
* da ne bih rucno to radio citajuci preslikavanja iz koda.
* Takodje, sluzi kao test program kodiranja i dekodiranja datuma 
***************************************************************
LOCAL dDatum := Date(), cEncDat

SET CENTURY ON
SET DATE GERMAN
SET CONFIRM ON

DO WHILE .T.
   CLEAR SCREEN
   @ 4,4 SAY "Datum za kodiranje: " GET dDatum
   READ
   
   IF LastKey() = 27
      EXIT
   ENDIF
   
   cEncDat = EncodeLicD(dDatum) 
   
   @  6,4 SAY "--------------------------------"
   @  8,4 SAY "Unet je datum:         " + DtoC(dDatum)
   @ 10,4 SAY "Enkodiran glasi:       " + cEncDat    
   @ 12,4 SAY "Dekodiran se vraca na: " + DtoC(DecodeLicD(cEncDat))
   WAIT "Dalje..."
ENDDO
***************************************************************


***************************************************************
* Kodira datum licence
***************************************************************
FUNCTION EncodeLicD(dLicDatum)
   LOCAL cMesec, cDan, cGod

   nMesec = Month(dLicDatum)
   nDan   = Day(dLicDatum)
   nGod   = Year(dLicDatum)  

   * ? nMesec, nDan, nGod 

RETURN EncDay(nDan) + EncMonth(nMesec) + EncYear(nGod)
***************************************************************


***************************************************************
* Kodira mesec iz datuma licence
* Kodove za 12 meseci sam proizvoljno smislio
***************************************************************
FUNCTION EncMonth(nMesec)
   LOCAL cMesec := Space(2)
    
	DO CASE
      CASE nMesec = 1 
		   cMesec = "RN"
      CASE nMesec = 2
         cMesec = "TX"
      CASE nMesec = 3
         cMesec = "WX"
      CASE nMesec = 4
         cMesec = "WC"
      CASE nMesec = 5
         cMesec = "UM"
      CASE nMesec = 6
         cMesec = "YC"
      CASE nMesec = 7
         cMesec = "OL"
      CASE nMesec = 8
         cMesec = "PT"
      CASE nMesec = 9
         cMesec = "TK"
      CASE nMesec = 10
         cMesec = "FS"
      CASE nMesec = 11
         cMesec = "AH"
      CASE nMesec = 12
         cMesec = "JE"
	ENDCASE
RETURN cMesec
***************************************************************


***************************************************************
* Kodira dan iz datuma licence
***************************************************************
FUNCTION EncDay(nDan)
   LOCAL nDan1, nDan2, cDan1 := Space(1), cDan2 := Space(1)
   STATIC nCounter := 0          // Initial value assigned once

	DO CASE
		CASE nDan >= 30 
			nDan1 = 3
		CASE nDan >= 20
			nDan1 = 2
		CASE nDan >= 10
			nDan1 = 1
		OTHERWISE
			nDan1 = 0
	ENDCASE
   nDan2 = nDan - nDan1 * 10

   IF nCounter = 0
      nCounter = nDan
   ELSE
      nCounter = nCounter + 1
   ENDIF
   
	DO CASE
		CASE nDan1 = 0
         cDan1 = IIF(ParNepar(nCounter), "K", "G")
		CASE nDan1 = 1
         cDan1 = IIF(ParNepar(nCounter), "A", "V")
      CASE nDan1 = 2
         cDan1 = IIF(ParNepar(nCounter), "N", "E")
      CASE nDan1 = 3
         cDan1 = IIF(ParNepar(nCounter), "C", "M")
	ENDCASE
   
	DO CASE
		CASE nDan2 = 0
         cDan2 = IIF(ParNepar(nCounter), "Q", "M")
      CASE nDan2 = 1
         cDan2 = IIF(ParNepar(nCounter), "E", "B")
      CASE nDan2 = 2
         cDan2 = IIF(ParNepar(nCounter), "T", "C")
      CASE nDan2 = 3
         cDan2 = IIF(ParNepar(nCounter), "U", "Z")
      CASE nDan2 = 4
         cDan2 = IIF(ParNepar(nCounter), "O", "F")
      CASE nDan2 = 5
         cDan2 = IIF(ParNepar(nCounter), "P", "H")
      CASE nDan2 = 6
         cDan2 = IIF(ParNepar(nCounter), "I", "S")
      CASE nDan2 = 7
         cDan2 = IIF(ParNepar(nCounter), "Y", "X")
         cDan2= "Y" .OR. cDan2= "X"
      CASE nDan2 = 8
         cDan2 = IIF(ParNepar(nCounter), "R", "V")
      CASE nDan2 = 9
         cDan2 = IIF(ParNepar(nCounter), "W", "N")
	ENDCASE
   
RETURN (cDan1 + cDan2)
***************************************************************


***************************************************************
* Pomocna funkcija koja vraca .T. ako je broj paran,
* .F. ako je neparan
***************************************************************
FUNCTION ParNepar(nNum)
   LOCAL lPar := .F.
   
   IF (nNum % 2) = 0
      lPar = .T.
   ENDIF
RETURN lPar 
***************************************************************

***************************************************************
* Kodira godinu iz datuma licence
* Kodove za godine sam proizvoljno smislio (generator sa interneta)
***************************************************************
FUNCTION EncYear(nGod)
   LOCAL cGod := "----"    && default

	DO CASE
		CASE nGod = 2015
         cGod = "VIZQ"
      CASE nGod = 2016
         cGod = "ICYG"
      CASE nGod = 2017
         cGod = "FBCP"
      CASE nGod = 2018
         cGod = "SPVC"
      CASE nGod = 2019
         cGod = "GMCT"
      CASE nGod = 2020
         cGod = "YPGD"
      CASE nGod = 2021
         cGod = "EZEH"
      CASE nGod = 2022
         cGod = "QRUW"
      CASE nGod = 2023
         cGod = "EWFG"
      CASE nGod = 2024
         cGod = "QWOH"
      CASE nGod = 2025
         cGod = "GTDL"
      CASE nGod = 2026
         cGod = "MNXQ"
      CASE nGod = 2027
         cGod = "OFVZ"
      CASE nGod = 2028
         cGod = "GKLI"
      CASE nGod = 2029
         cGod = "FKRG"
      CASE nGod = 2030
         cGod = "DGEI"
	ENDCASE
RETURN cGod
***************************************************************


************************************************************
* Naredne funkcije:
*    DecodeLicD(cLicDatum)
*    DecMonth(cMesec)
*    DecDay(cDan)
*    DecYear(cGod)
*  su iste kao u fajlu SETTINGS.PRG
*  Ovde ih koristim za testiranje kodiranja i dekodiranja
*  datuma licence.  
************************************************************

* Dekodira datum licence na osnovu kodiranog stringa iz baze
* Bitno je da li je pre poziva ove funkcije
* postavljeno SET DATE GERMAN, jer od toga zavisi da li je
* format datuma dd/mm/yyyy (ako je postavljeno)
* ili mm/dd/yyyy (ako nije postavljeno)
FUNCTION DecodeLicD(cLicDatum)
   LOCAL cLicMesec, cLicDan, cLicGod

   * proveriti duzinu cLicD i ako nije 8, vratiti default 01/01/2015
   IF Len(AllTrim(cLicDatum)) = 8
      cLicDan   = DecDay(SubStr(cLicDatum,1,2))
      cLicMesec = DecMonth(SubStr(cLicDatum,3,2))
      cLicGod   = DecYear(SubStr(cLicDatum,5,4))  

      * greska u kodu datuma
      IF cLicDan = "--" .OR. cLicMesec = "--" .OR. cLicGod = "----"
         RETURN CtoD("01/01/2015")
      ENDIF 

      RETURN CtoD(cLicDan + "/" + cLicMesec + "/" + cLicGod)
   ENDIF

RETURN CtoD("01/01/2015")      

* Dekodira mesec iz datuma licence na osnovu kodiranog stringa iz baze
* Kodove za 12 meseci sam proizvoljno smislio
FUNCTION DecMonth(cMesec)
   LOCAL cRetMes := "--"    && default
    
	DO CASE
		CASE cMesec = "RN"
			cRetMes = "01"
		CASE cMesec = "TX"
			cRetMes = "02"
		CASE cMesec = "WX"
			cRetMes = "03"
		CASE cMesec = "WC"
			cRetMes = "04"
		CASE cMesec = "UM"
			cRetMes = "05"
		CASE cMesec = "YC"
			cRetMes = "06"
		CASE cMesec = "OL"
			cRetMes = "07"
		CASE cMesec = "PT"
			cRetMes = "08"
		CASE cMesec = "TK"
			cRetMes = "09"
		CASE cMesec = "FS"
			cRetMes = "10"
		CASE cMesec = "AH"
			cRetMes = "11"
		CASE cMesec = "JE"
			cRetMes = "12"
	ENDCASE
RETURN cRetMes

* Dekodira dan iz datuma licence na osnovu kodiranog stringa iz baze
FUNCTION DecDay(cDan)
   LOCAL cDan1, cDan2, cRetDan1 := "-", cRetDan2 := "-"
   cDan1 = SubStr(cDan, 1, 1)
   cDan2 = SubStr(cDan, 2, 1) 
    
	DO CASE
		CASE cDan1= "K" .OR. cDan1= "G" 
			cRetDan1 = "0"
		CASE cDan1= "A" .OR. cDan1= "V"
			cRetDan1 = "1"
		CASE cDan1= "N" .OR. cDan1= "E"
			cRetDan1 = "2"
		CASE cDan1= "C" .OR. cDan1= "M"
			cRetDan1 = "3"
	ENDCASE

	DO CASE
		CASE cDan2= "Q" .OR. cDan2= "M" 
			cRetDan2 = "0"
		CASE cDan2= "E" .OR. cDan2= "B"
			cRetDan2 = "1"
		CASE cDan2= "T" .OR. cDan2= "C"
			cRetDan2 = "2"
		CASE cDan2= "U" .OR. cDan2= "Z"
			cRetDan2 = "3"
		CASE cDan2= "O" .OR. cDan2= "F" 
			cRetDan2 = "4"
		CASE cDan2= "P" .OR. cDan2= "H"
			cRetDan2 = "5"
		CASE cDan2= "I" .OR. cDan2= "S"
			cRetDan2 = "6"
		CASE cDan2= "Y" .OR. cDan2= "X"
			cRetDan2 = "7"
		CASE cDan2= "R" .OR. cDan2= "V" 
			cRetDan2 = "8"
		CASE cDan2= "W" .OR. cDan2= "N"
			cRetDan2 = "9"
	ENDCASE
   
   IF cRetDan1 = "-" .OR. cRetDan2 = "-"
      RETURN "--"
   ENDIF  
RETURN (cRetDan1 + cRetDan2)

* Dekodira godinu iz datuma licence na osnovu kodiranog stringa iz baze
* Kodove za godine sam proizvoljno smislio
FUNCTION DecYear(cGod)
   LOCAL cRetGod := "----"    && default

	DO CASE
		CASE cGod = "VIZQ"
			cRetGod = "2015"
		CASE cGod = "ICYG"
			cRetGod = "2016"
		CASE cGod = "FBCP"
			cRetGod = "2017"
		CASE cGod = "SPVC"
			cRetGod = "2018"
		CASE cGod = "GMCT"
			cRetGod = "2019"
		CASE cGod = "YPGD"
			cRetGod = "2020"
		CASE cGod = "EZEH"
			cRetGod = "2021"
		CASE cGod = "QRUW"
			cRetGod = "2022"
		CASE cGod = "EWFG"
			cRetGod = "2023"
		CASE cGod = "QWOH"
			cRetGod = "2024"
		CASE cGod = "GTDL"
			cRetGod = "2025"
		CASE cGod = "MNXQ"
			cRetGod = "2026"
		CASE cGod = "OFVZ"
			cRetGod = "2027"
		CASE cGod = "GKLI"
			cRetGod = "2028"
		CASE cGod = "FKRG"
			cRetGod = "2029"
		CASE cGod = "DGEI"
			cRetGod = "2030"
	ENDCASE
RETURN cRetGod
