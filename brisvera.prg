* - nije pregledano - *
LOCAL ekran:=SAVESCREEN(0,0,24,79),kursor:=SETCURSOR(1)
@ 0,0 CLEAR
* ovde ubaciti punjenje datoteke gotovtem

SELECT 0
USE dmpdat INDEX dmpinbro,dmpinbs
SELECT 0
USE dmpdatt  &&      index nije potreban INDEXgotovsdT
ZAP
GO TOP
SELECT dmpdat
DO WHILE .T.
   @ 0,0 clear
   GO TOP
   ESCKEY()
   dat1 = ctod("01.01." + substr(str(year(date()),4,0),3,2))
   DAT2 = DATE()
   wsif = val("0000000000000")
   wuk1 = val("000000000000.00")
   store wuk1 to wuk2,wuk3,wuk4
   wUKUPNO = VAL("000000000000.00")
   mbrkal1 = Space(10)
   mbrkal2 = Space(10)
   @ 3,1 SAY "BROJ KOJI SE MENJA" GET MbRKAL1
   @ 5,1 SAY "BROJ U KOJI SE MENJA" GET MbRKAL2
   READ
   IF Lastkey() = 27
      EXIT
   ENDIF
  * kljuc = str(wsif) + dtos(ctod("  .  .  "))
  * set softseek on
   seek mBrkal1
   IF Eof() .or. ! mBrkal1 = dmpbro
      MSG("NISAM USPEO DA NADJEM TAJ BROJ KALKULACIJE  ! ",5)
      LOOP
   ENDIF
  * set softseek off
  *@ 3,32 SAY nazgov
  *@ 6,10 SAY "LISTANJE KARTICE OD DATUMA" GET DAT1
  *@ 6,47 SAY "DO DATUMA" GET DAT2
  *READ
*
  *IF Lastkey() = 27
  *   EXIT
  *ENDIF
*
   DO WHILE mBrkal1 = dmpbro
         SELECT dmpdatt
         APPEND BLANK
          replace dmpsif with DMPDAT->dmpsif
          replace dmpnaz with DMPDAT->dmpnaz
          replace dmpjm with DMPDAT->dmpjm
          replace dmpkol with DMPDAT->dmpkol            && wdmpkol
          replace dmpnc with DMPDAT->dmpnc             && wfcen
          replace dmpppd with DMPDAT->dmpppd            && wdmpppd
          replace dmpztr with DMPDAT->dmpztr
          replace dmpziz with DMPDAT->dmpziz
          replace dmpmar with DMPDAT->dmpmar
          replace dmpmiz with DMPDAT->dmpmiz
          replace dmpmbp with DMPDAT->dmpmbp
          replace dmpppk with DMPDAT->dmpppk            && wdmpppk
          replace dmpraz with DMPDAT->dmpraz                                 && wdmpraz
          replace dmppor with DMPDAT->dmppor
          replace dmptar with DMPDAT->dmptar
          replace dmpmsp with DMPDAT->dmpmsp            && wdmpmsp
          replace dmpvsp with DMPDAT->dmpvsp                            && wdmpvsp
          replace dmpbro with DMPDAT->dmpbro
          replace dmpdat with DMPDAT->dmpdat
          replace dmprab with DMPDAT->dmprab             && wdmprab
          replace dmpdob with DMPDAT->dmpdob
          replace dmpirab with DMPDAT->dmpirab            && wirab
          replace dmpfak with DMPDAT->dmpfak
          replace dmpdfak with DMPDAT->dmpdfak
          replace vrsta with DMPDAT->vrsta
          replace akciza with DMPDAT->akciza
          replace taksa with DMPDAT->taksa
          *
         SELECT dmpdat
         DELETE
      SKIP
   ENDDO
* kraj punjenja dmpdatt  , u njoj bromeniti broj kalkulacije
select dmpdatt
go top
DO WHILE ! Eof()
   replace dmpbro with mBrkal2
   SKIP
ENDDO
* sada ide prepis
SELECT dmpdatt
go top
DO WHILE ! Eof()
         SELECT dmpdat
         APPEND BLANK
          replace dmpsif with DMPDATT->dmpsif
          replace dmpnaz with DMPDATT->dmpnaz
          replace dmpjm with DMPDATT->dmpjm
          replace dmpkol with DMPDATT->dmpkol            && wdmpkol
          replace dmpnc with DMPDATT->dmpnc             && wfcen
          replace dmpppd with DMPDATT->dmpppd            && wdmpppd
          replace dmpztr with DMPDATT->dmpztr
          replace dmpziz with DMPDATT->dmpziz
          replace dmpmar with DMPDATT->dmpmar
          replace dmpmiz with DMPDATT->dmpmiz
          replace dmpmbp with DMPDATT->dmpmbp
          replace dmpppk with DMPDATT->dmpppk            && wdmpppk
          replace dmpraz with DMPDATT->dmpraz                                 && wdmpraz
          replace dmppor with DMPDATT->dmppor
          replace dmptar with DMPDATT->dmptar
          replace dmpmsp with DMPDATT->dmpmsp            && wdmpmsp
          replace dmpvsp with DMPDATT->dmpvsp                            && wdmpvsp
          replace dmpbro with DMPDATT->dmpbro
          replace dmpdat with DMPDATT->dmpdat
          replace dmprab with DMPDATT->dmprab             && wdmprab
          replace dmpdob with DMPDATT->dmpdob
          replace dmpirab with DMPDATT->dmpirab            && wirab
          replace dmpfak with DMPDATT->dmpfak
          replace dmpdfak with DMPDATT->dmpdfak
          replace vrsta with DMPDATT->vrsta
          replace akciza with DMPDATT->akciza
          replace taksa with DMPDATT->taksa
          *
         SELECT DMPDATT
         SKIP
ENDDO
commit
SELECT DMPDATT
ZAP
CLOSE DMPDATT
*
SELECT DMPDAT
CLOSE DMPDAT
* KRAJ PREPISA
SetColor(Normal)
*
RESTSCREEN(0,0,24,79,ekran)
SETCURSOR(kursor)
RETURN
*
ENDDO
SetColor(Normal)
SELECT DMPDAT
CLOSE DMPDAT
*
SELECT DMPDATT
ZAP
CLOSE DMPDATT
*
RESTSCREEN(0,0,24,79,ekran)
SETCURSOR(kursor)
RETURN


