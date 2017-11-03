LOCAL nRedBrNaloga, cDuznik1, cDuznik2, cSifPl, cValuta, nIznos
LOCAL cZiro1, cSvrha1, cSvrha2, cBrMod1, cPoziv1, cPover1
LOCAL cZiro2, cPover2, cBrMod2, cPoziv2, cMesto, dDatum
LOCAL cRazmak := '2'

cDuznik1 = Space(36)
cDuznik2 = Space(36)
cSvrha1  = Space(36)
cSvrha2  = Space(36)
cPover1  = Space(36)
cPover2  = Space(36)
cMesto   = "Obrenovac "
dDatum   = Date()

cSifPl  = "253"
cValuta = "din."
nIznos  = Val("0000000000000.00")
cZiro1  = Space(26)
cBrMod1 = Space(3)
cPoziv1 = Space(26)
cZiro2  = Space(26)
cBrMod2 = " 97"
cPoziv2 = Space(26)
dDatumVal = Date()

SELECT 1
USE ZIRPLAC INDEX ZIRPLAC1   && po tarifi i podtarifi

* MessageBox(Str(nPos1,4) + Str(nPos2,4) + Str(nPos3,4)) 
* RETURN

DO WHILE .T.

   wod = Date()
   wdo = Date()
   wd  = Date()
   wmes    = "Obrenovac"
   wsifpl  = 253

   SET DEVICE TO SCREEN
   SET PRINTER OFF

   MainMask("STAMPA VIRMANA ZA OBRACUNAT POREZ")

   @  5,10 SAY "Datum stampe (vidljivo na virmanu) :  " GET dDatum
   @  7,10 SAY "Mesto (vidljivo na virmanu)        :  " GET cMesto
   @  9,10 SAY "Sifra placanja                     :  " GET cSifPl
   @ 14,10 SAY "Od datuma: " GET wod
   @ 14,50 SAY "Do datuma: " GET wdo VALID(wod <= wdo)
   READ

   IF Lastkey() = 27
      EXIT
   ENDIF

   SET CONSOLE OFF
   SET DEVICE TO PRINTER
   * SET PRINT TO LISTA
   SET PRINT TO LPT1
   SET PRINTER ON

   * ? Chr(27) + '(s13H'
   @ 0,0 SAY Chr(27) + '(s12H' + Chr(27) + '&l' + cRazmak + 'C'
   SetPrc(0,0)

   nRedBrNaloga = 0
   DO WHILE ! Eof()
	   IF IZNOS = 0 .OR. PODTAR # "D"
	   	SKIP
	      LOOP
	   ENDIF

      nRedBrNaloga = nRedBrNaloga + 1
      cDuznik1 = Substr(Alltrim(gcPrez) + " " + Alltrim(gcIme) + Space(36), 1, 36)
      cDuznik2 = Substr(Alltrim(gcNazRad) + ", " + Alltrim(gcMesto) + Space(36), 1, 36)
      cSvrha1  = Substr(Alltrim(SVRHA) + Space(36), 1, 36)
      nIznos   = IZNOS
      cSvrha2  = Substr("od " +  DtoC(wod) + " do " + DtoC(wdo) + Space(36), 1, 36)
      cZiro1   = Substr(Alltrim(gcZiro) + Space(26), 1, 26)
      cPover1  = Substr("Poreska uprava Obrenovac" + Space(36), 1, 36)
      cZiro2   = Substr(Centriraj(ZR,26) + Space(26),1,26)
      cPoziv2  = Substr(Str(gnKontrol,2) + "-014-" + gcJMBG + Space(26),1, 26)

      * nPos1, nPos2, nPos3 su PRIVATE promenljive definisane u KOMSTR.PRG
      DO CASE
      CASE (nRedBrNaloga % 3) == 1
         @ nPos1 + 02,08 SAY cDuznik1
         @ nPos1 + 06,08 SAY cDuznik2
         @ nPos1 + 07,08 SAY Space(44) + cSifPl + Space(4) + cValuta + Space(6) + Formatiraj(nIznos, 16, 2)

         @ nPos1 + 17,65 SAY cZiro1
         @ nPos1 + 20,08 SAY cSvrha1
         @ nPos1 + 24,08 SAY cSvrha2

         @ nPos1 + 28,57 SAY cBrMod1 + Space(5) + cPoziv1

         @ nPos1 + 39,08 SAY cPover1 + Space(21) + cZiro2
         @ nPos1 + 43,08 SAY cPover2

         @ nPos1 + 50,51 SAY cBrMod2 + Space(11) + cPoziv2

         * @ nPos1 + 58,22 SAY Alltrim(cMesto) + "," + DtoC(dDatum)
         @ nPos1 + 60,22 SAY Alltrim(cMesto)
      CASE (nRedBrNaloga % 3) == 2
         @ nPos2 + 02,08 SAY cDuznik1
         @ nPos2 + 06,08 SAY cDuznik2
         @ nPos2 + 07,08 SAY Space(44) + cSifPl + Space(4) + cValuta + Space(6) + Formatiraj(nIznos, 16, 2)

         @ nPos2 + 17,65 SAY cZiro1
         @ nPos2 + 20,08 SAY cSvrha1
         @ nPos2 + 24,08 SAY cSvrha2

         @ nPos2 + 28,57 SAY cBrMod1 + Space(5) + cPoziv1

         @ nPos2 + 39,08 SAY cPover1 + Space(21) + cZiro2
         @ nPos2 + 43,08 SAY cPover2

         @ nPos2 + 50,51 SAY cBrMod2 + Space(11) + cPoziv2

         * @ nPos2 + 58,22 SAY Alltrim(cMesto) + "," + DtoC(dDatum)
         @ nPos2 + 60,22 SAY Alltrim(cMesto)
      CASE (nRedBrNaloga % 3) == 0
         @ nPos3 + 02,08 SAY cDuznik1
         @ nPos3 + 06,08 SAY cDuznik2
         @ nPos3 + 07,08 SAY Space(44) + cSifPl + Space(4) + cValuta + Space(6) + Formatiraj(nIznos, 16, 2)

         @ nPos3 + 17,65 SAY cZiro1
         @ nPos3 + 20,08 SAY cSvrha1
         @ nPos3 + 24,08 SAY cSvrha2

         @ nPos3 + 28,57 SAY cBrMod1 + Space(5) + cPoziv1

         @ nPos3 + 39,08 SAY cPover1 + Space(21) + cZiro2
         @ nPos3 + 43,08 SAY cPover2

         @ nPos3 + 49,51 SAY cBrMod2 + Space(11) + cPoziv2

         * @ nPos3 + 57,22 SAY Alltrim(cMesto) + "," + DtoC(dDatum)
         @ nPos3 + 59,22 SAY Alltrim(cMesto)
         * EJECT
      ENDCASE

		SKIP
	ENDDO

   ? Chr(27)+ Chr(69) && Reset printer
   EJECT

   SET CONSOLE ON
   SET PRINTER OFF
ENDDO

CLOSE DATABASES
RETURN
