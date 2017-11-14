*******************************************
* Pomocne procedure i funkcije
*******************************************

*******************************************
PROCEDURE Naslov
	CLEAR SCREEN
	
	@  1, 1 TO 23,79
	@ 23 ,1 TO 24,79 DOUBLE
	@  3, 3 TO 5,77
	@  4, 6 SAY gcNazRad
	@  4,40 SAY RTRIM(gcPrez) + " " + RTRIM(gcIme)
	@  4,65 SAY DATE()

RETURN
*******************************************

*******************************************
PROCEDURE ESCKEY

	@ 0,1 SAY " Izlaz = ESC "

RETURN
*******************************************

*******************************************
PROCEDURE MessageBox
	PARAMETERS cPoruka
	LOCAL cScreen
	
	cScreen = SaveScreen( 13,13,15,66 )

	@ 13,13 CLEAR TO 15,66
	@ 13,13 TO 15,66
	@ 14,14 SAY Centriraj(cPoruka, 65-13)
	Inkey(0)
	
	RestScreen( 13,13,15,66, cScreen)

RETURN
*******************************************

*******************************************
FUNCTION Centriraj(cPoruka, nDuzina)
	LOCAL nLen := Len(cPoruka)

	IF nLen > nDuzina
		cPoruka = SubStr(cPoruka, 1, nDuzina)
		RETURN cPoruka
	ENDIF

	* koliko da se pomeri da bi bilo centrirano
	nLen = (nDuzina - nLen) / 2

RETURN Replicate(" ", nLen) + cPoruka
*******************************************

*******************************************
PROCEDURE MainWnd(cNaslov)
	CLEAR SCREEN

	@ 0,0 TO 23,79 DOUBLE
	@ 23,0  SAY Chr(204)
	@ 23,79 SAY Chr(185)
	@ 24,0  SAY Chr(186)
	@ 24,79 SAY Chr(186)

	@ 1,1 SAY Centriraj(cNaslov, 78)

	@ 2,2 TO 4,77
	@ 3,4  SAY gcNazRad
	@ 3,40 SAY RTRIM(gcPrez) + " " + RTRIM(gcIme)
	@ 3,65 SAY DATE()

RETURN
*******************************************

*******************************************
PROCEDURE MainMask(cNaslov)
	CLEAR SCREEN
	@ 0,0 TO 24,79 DOUBLE
	@ 1,1 SAY Centriraj(cNaslov, 78)
RETURN
*******************************************

*******************************************
PROCEDURE Esck
	@ 1, 0 SAY "ESC - IZLAZ"
	@ 1,60 SAY "DATUM:"
	@ 1,67 SAY DATE()
RETURN
*******************************************

*******************************************
PROCEDURE ZAGPAN

	CLEAR SCREEN
	@ 1,1 TO 23,79
	@ 23,1 TO 24,79 DOUBLE
	@ 3,3 TO 5,77

	@ 4,5  SAY "  P A N E   P R O M     "
	@ 4,35 SAY "  O B R E N O V A C  "
	@ 4,66 SAY " "
	@ 4,67 SAY DATUM
	@ 4,75 SAY " "

	@ 6,3 SAY " Strelicama dovedite svetleci prozor na zeljeni posao i pritisnite ENTER"
	
RETURN
*******************************************

*******************************************
PROCEDURE ZAGAN

	CLEAR SCREEN
	@ 1,1 TO 23,79
	@ 23,1 TO 24,79 DOUBLE
	@ 3,3 TO 5,77

	@ 4,5  SAY "  KNJIGOVODSTVENE USLUGE "
	@ 4,35 SAY " O B R E N O V A C "
	@ 4,66 SAY " "
	DATUM = DATE()
	@ 4,67 SAY DATUM
	@ 4,75 SAY " "

	@ 6,3 SAY " Strelicama dovedite svetleci prozor na zeljeni posao i pritisnite ENTER"
	
RETURN
*******************************************

*******************************************
PROCEDURE ZAGPP

	CLEAR SCREEN
	@ 1,1 TO 23,79
	@ 23,1 TO 24,79 DOUBLE
	@ 3,3 TO 5,77

	@ 4,5 SAY "  KNJIGOVODSTVENE USLUGE "
	@ 4,35 SAY " O B R E N O V A C "
	@ 4,66 SAY " "
	DATUM = DATE()
	@ 4,67 SAY DATUM
	@ 4,75 SAY " "

	@ 6,3 SAY " Strelicama dovedite svetleci prozor na zeljeni posao i pritisnite ENTER"

RETURN
*******************************************

*******************************************
FUNCTION ZAGVP

	CLEAR SCREEN
	@ 1,1 TO 23,79
	@ 23,1 TO 24,79 DOUBLE
	@ 3,3 TO 5,77

	@ 4,5 SAY "  KNJIGOVODSTVENE USLUGE "
	@ 4,35 SAY " O B R E N O V A C "
	@ 4,66 SAY " "
	DATUM = DATE()
	@ 4,67 SAY DATUM
	@ 4,75 SAY " "

	@ 6,3 SAY " Strelicama dovedite svetleci prozor na zeljeni posao i pritisnite ENTER"

RETURN
*******************************************

*******************************************
PROCEDURE PAUZA

	Q = " "
	@ 23,22 SAY "PRITISNITE BILO STA ZA NASTAVAK..."
	WAIT " " TO Q
	@ 23,22

RETURN
*******************************************

*******************************************
PROCEDURE NEMADAN

	Q = " "
	@ 23,22 SAY "POD TIM DATUMOM NISTE NISTA RADILI!"
	WAIT " " TO Q
	@ 23,22

RETURN
*******************************************

*******************************************
PROCEDURE NEMACEK

	Q = " "
	@ 23,22 SAY "NEMA TOG BROJA CEKA! ENTER ZA NASTAVAK..."
	WAIT " " TO Q
	@ 23,22

RETURN
*******************************************

*******************************************
PROCEDURE NEMABANK

	Q = " "
	@ 23,22 SAY "NEMA TAKVE KOMBINACIJE DATUMA I BANKE!"
	WAIT " " TO Q
	@ 23,22
	
RETURN
*******************************************

*******************************************
PROCEDURE NEMAB

	Q = " "
	@ 23,27 SAY "NEMA TAKVE SIFRE BANKE!"
	WAIT " " TO Q
	@ 23,27
	
RETURN
*******************************************

*******************************************
PROCEDURE POR

	Q = " "
	@ 21,5 SAY "ZBIR RAZLICIT OD 100 %! ENTER ZA NASTAVAK..."
	WAIT " " TO Q
	@ 21,0

RETURN
*******************************************

*******************************************
PROCEDURE PORUKA

	Q = " "
	@ 23,16 SAY "MORA SE UNETI! PRITISNITE BILO STA ZA NASTAVAK ..."
	WAIT " " TO Q
	@ 23,16
	
RETURN
*******************************************

*******************************************
PROCEDURE POSTOJI

	Q= " "
	@ 23,12 SAY "TAKVA SIFRA VEC POSTOJI! PRITISNITE BILO STA ZA NASTAVAK..."
	WAIT " " TO Q
	@ 23,12

RETURN
*******************************************

*******************************************
PROCEDURE PORUKA1

	Q = " "
	@ 23,14 SAY "NEMA TAKVOG INDEKSA! PRITISNITE BILO STA ZA NASTAVAK..."
	WAIT " " TO Q
	@ 23,14

RETURN
*******************************************

*******************************************
PROCEDURE NEPOSTOJI

	Q = " "
	@ 23,10 SAY "TAKVA SIFRA BANKE NE POSTOJI! PRITISNITE BILO STA ZA NASTAVAK..."
	WAIT " " TO Q
	@ 23,10

RETURN
*******************************************

*******************************************
PROCEDURE ZAG1

	CLEAR SCREEN
	@ 1,1 TO 23,79
	@ 23,1 TO 24,79 DOUBLE
	@ 3,3 TO 5,77

	@ 4,5 SAY " ELEKTRODISTRIBUCIJA "
	@ 4,35 SAY "  O B R E N O V A C  "
	@ 4,66 SAY " "
	@ 4,67 SAY DATUM
	@ 4,75 SAY " "

	@ 6,3 SAY "Strelicama dovedite svetleci prozor na zeljeni posao i pritisnite ENTER"

RETURN
*******************************************

*******************************************
PROCEDURE ZAG2

	CLEAR SCREEN
	@ 1,1 TO 23,79
	@ 23,1 TO 24,79 DOUBLE
	@ 21,4 SAY "Strelicama dovedite svetleci prozor na zeljeni posao i pritisnite ENTER"

RETURN
*******************************************

*******************************************
* ne radi dobro za negativne brojeve,
* npr napisace: -.126.656,25 	
FUNCTION Formatiraj(nIzn, nUkPos, nDecPos)
LOCAL cRez, cTmp, cPosleDec, cCeoBroj

cRez = ""
cTmp = Alltrim(Str(nIzn,nUkPos,nDecPos))

cPosleDec = Right(cTmp,nDecPos)
cCeoBroj  = Left(cTmp,Len(cTmp) - nDecPos - 1)

DO WHILE Len(cCeoBroj) > 3
   cTmp = '.' + Right(cCeoBroj,3)
   cRez = cTmp + cRez
   cCeoBroj = Left(cCeoBroj, Len(cCeoBroj) - 3)
ENDDO

cRez = cCeoBroj + cRez + "," + cPosleDec
cRez = Replicate(" ", nUkPos - Len(cRez)) + cRez
RETURN cRez
*******************************************

*******************************************
FUNCTION PDVKoeficijent(stopa_pdv)

RETURN Round((1 - 1 / (1 + stopa_pdv / 100)), 6)
*******************************************

*******************************************
* Promena PDV stope u 2012. godini
* pa se PDV koeficijent za izracunavanje
* PDV-a ako je data cena sa PDV-om
* dobija po ovoj logici
* Primer upotrebe f-je:
* nPDV = nCenaSaPDV * KoefPDV(datum_stavke)
* nCenaBezPDV = nCenaSaPDV - nPDV   
*******************************************
FUNCTION KoefPDV(dDatum)
   LOCAL nKoef := 0.0
   
   IF Year(dDatum) == 2012                && u 2012,
      IF Month(dDatum) < 10               && do 1. oktobra
         nKoef = PDVKoeficijent(18)       && PDV je bio 18%
      ELSE                                && a od 1. oktobra
         nKoef = PDVKoeficijent(20)       && PDV je 20%   
      ENDIF
   ELSE
      IF Year(dDatum) < 2012              && pre 2012.
         nKoef = PDVKoeficijent(18)       && PDV je 18%
      ELSE                                && a posle 2012.
         nKoef = PDVKoeficijent(20)       && PDV je 20% (ako se ne promeni)
      ENDIF
   ENDIF
   
RETURN nKoef
*******************************************

*******************************************
* Promena Nize PDV stope u 2014. godini
* sa 8% na 10%
* pa se PDV koeficijent za izracunavanje
* PDV-a ako je data cena sa PDV-om
* dobija po ovoj logici
* Primer upotrebe f-je:
* nPDV = nCenaSaPDV * KoefPDVNiza(datum_stavke)
* nCenaBezPDV = nCenaSaPDV - nPDV
*******************************************
FUNCTION KoefPDVNiza(dDatum)
   LOCAL nKoef := 0.0

   IF Year(dDatum) < 2014              && pre 2014.
      nKoef = PDVKoeficijent(8)        && PDV je 8%
   ELSE                                && a posle 2014.
      nKoef = PDVKoeficijent(10)       && PDV je 10%
   ENDIF

RETURN nKoef
*******************************************
