SELECT 0
USE PLACPNAS

SELECT 0
USE PLACP INDEX PLACP

* mcPPKPC03(9), mcPORNDO22(10), mcDOPVL43(11), mcFINTRA50(12), mcPORIM82(13), mcPORSRE66(14), mcPORPAU36(15), mcGGZEM(16)
SELECT PLACPNAS
mcPPKPC03  = CPPKPC03
mcPORNDO22 = CPORNDO22
mcDOPVL43  = CDOPVL43
mcFINTRA50 = CFINTRA50
mcPORIM82  = CPORIM82
mcPORSRE66 = CPORSRE66
mcPORPAU36 = CPORPAU36
mcGGZEM    = CGGZEM

SELECT PLACP

WOD  = Date()
WDO  = Date()
wz1  = Val("00000000.00")
wz2  = Val("00000000.00")
wz3  = Val("00000000.00")
wz4  = Val("00000000.00")
wz5  = Val("00000000.00")
wz6  = Val("00000000.00")
wz7  = Val("00000000.00")
wz8  = Val("00000000.00")
wz9  = Val("00000000.00")
wz10 = Val("00000000.00")
wz11 = Val("00000000.00")
wz12 = Val("00000000.00")
wz13 = Val("00000000.00")
wz14 = Val("00000000.00")
wz15 = Val("00000000.00")
wz16 = Val("00000000.00")
wz17 = Val("00000000.00")
wz18 = Val("00000000.00")
ZEZ  = 0
wRed = 80

MainMask("STAMPANJE STAVKI PLACENOG POREZA OD DATUMA DO DATUMA")
@ 12,10 SAY "OD DATUMA" GET WOD
@ 12,32 SAY "DO DATUMA" GET WDO
READ

IF Lastkey() = 27
   CLOSE PLACP
   CLOSE PLACPNAS
   RETURN
ENDIF

* ovde obezbediti sta ima u rezervama po nazivu
mREZ11 = Space(18)
mREZ22 = Space(18)
mREZ33 = Space(18)
DO WHILE ! Eof()
   IF rez11 = " "
      zez = zez + 0
   ELSE
      mREZ11 = REZ11
   ENDIF
   IF rez22 = " "
      zez = zez + 0
   ELSE
      mREZ22 = REZ22
   ENDIF
   IF rez33 = " "
      zez = zez + 0
   ELSE
      mREZ33 = REZ33
   ENDIF
   SKIP
ENDDO

* SELECT PLACP
GO TOP
* kraj obezbedjivanja po rezervama

SET DEVICE TO PRINT
SET PRINT TO LPT1
* SET PRINT TO LISTA
SET PRINT ON

IF lLaser
   @ 1, 0 SAY Chr(27) + '(s17.5H'   && kondenz On za laserski
ELSE
   @ 1, 0 SAY Chr(15)               && kondenz On za matricni
ENDIF

DO WHILE ! Eof()
   IF wRed > 62
      @ 1,27 SAY "STAMPANJE STAVKI UPLACENOG POREZA OD "
      @ 1,65 SAY WOD
      @ 1,77 SAY "DO "
      @ 1,81 SAY WDO
      @ 3, 0 SAY "DAT."
      @ 3, 7 SAY "BRI"
      @ 3,11 SAY " POREZ "
      @ 3,19 SAY "  PIO  "
      @ 3,27 SAY "  ZDR  "
      @ 3,35 SAY " NEZAP "
      @ 3,43 SAY Substr(mcPPKPC03,1,7)     && "PPKPC03"
      @ 3,51 SAY Substr(mcPORNDO22,1,7)    && "PORND22"
      @ 3,59 SAY Substr(mcDOPVL43,1,7)     && "DOPVL43"
      @ 3,67 SAY Substr(mcFINTRA50,1,7)    && "FINTR50"
      @ 3,75 SAY Substr(mcPORIM82,1,7)     && "PORIM82"
      @ 3,83 SAY Substr(mcPORSRE66,1,7)    && "PORSR66"
      @ 3,91 SAY Substr(mcPORPAU36,1,7)    && "PORPA36"
      @ 3,99 SAY Substr(mcGGZEM,1,7)       && "GGZEMLJ"

      IF mREZ11 = " "
         zez = zez + 0
      ELSE
         @ 3,107 SAY Substr(mREZ11,1,7)
      ENDIF
      IF mREZ22 = " "
         zez = zez + 0
      ELSE
         @ 3,115 SAY Substr(mREZ22,1,7)
      ENDIF
      IF mREZ33 = " "
         zez = zez + 0
      ELSE
         @ 3,123 SAY Substr(mREZ33,1,7)
      ENDIF
      @ 4,0 SAY Replicate("-",130)
      wRed = 5
   ENDIF

   IF dplacpor < wod .OR. dplacpor > wdo
      SKIP
      LOOP
   ENDIF

   IF Day(dplacpor) < 10
      @ wRed,0 SAY "0"
      @ wRed,1 SAY Day(dplacpor) PICTURE "9"
   ELSE
      @ wRed,0 SAY Day(dplacpor) PICTURE "99"
   ENDIF
   @ wRed,2 SAY "."

   IF Month(dplacpor) < 10
      @ wRed,3 SAY "0"
      @ wRed,4 SAY Month(dplacpor) PICTURE "9"
   ELSE
      @ wRed,3 SAY Month(dplacpor) PICTURE "99"
   ENDIF
   @ wRed,  5 SAY "."

   @ wRed,  7 SAY brnal    PICTURE "999"
   @ wRed, 11 SAY ppop73   PICTURE "9999999"
   @ wRed, 19 SAY ppus05   PICTURE "9999999"
   @ wRed, 27 SAY ppnv46   PICTURE "9999999"
   @ wRed, 35 SAY ppsrec81 PICTURE "9999999"
   @ wRed, 43 SAY ppkpc03  PICTURE "9999999"
   @ wRed, 51 SAY porndo22 PICTURE "9999999"
   @ wRed, 59 SAY dopvl43  PICTURE "9999999"
   @ wRed, 67 SAY fintra50 PICTURE "9999999"
   @ wRed, 75 SAY porim82  PICTURE "9999999"
   @ wRed, 83 SAY porsre66 PICTURE "9999999"
   @ wRed, 91 SAY porpau36 PICTURE "9999999"
   @ wRed, 99 SAY ggzem    PICTURE "9999999"
   @ wRed,107 SAY rez1     PICTURE "9999999"
   @ wRed,115 SAY rez2     PICTURE "9999999"
   @ wRed,123 SAY rez3     PICTURE "9999999"

   wz1  = Round(wz1 + ppop73,2)
   wz2  = Round(wz2 + ppus05,2)
   wz3  = Round(wz3 + ppnv46,2)
   wz4  = Round(wz4 + ppsrec81,2)
   wz5  = Round(wz5 + ppkpc03,2)
   wz6  = Round(wz6 + porndo22,2)
   wz7  = Round(wz7 + dopvl43,2)
   wz8  = Round(wz8 + fintra50,2)
   wz9  = Round(wz9 + porim82,2)
   wz10 = Round(wz10 + porsre66,2)
   wz11 = Round(wz11 + porpau36,2)
   wz12 = Round(wz12 + ggzem,2)
   wz13 = Round(wz13 +  rez1,2)
   wz14 = Round(wz14 +  rez2,2)
   wz15 = Round(wz15 +  rez3,2)

   wRed = wRed + 1
   SKIP
ENDDO

CLOSE PLACP
CLOSE PLACPNAS

@ wRed,0 SAY Replicate("-",130)
wRed = wRed + 1
@ wRed, 11 SAY WZ1  PICTURE "9999999"
@ wRed, 19 SAY WZ2  PICTURE "9999999"
@ wRed, 27 SAY WZ3  PICTURE "9999999"
@ wRed, 35 SAY WZ4  PICTURE "9999999"
@ wRed, 43 SAY WZ5  PICTURE "9999999"
@ wRed, 51 SAY WZ6  PICTURE "9999999"
@ wRed, 59 SAY WZ7  PICTURE "9999999"
@ wRed, 67 SAY WZ8  PICTURE "9999999"
@ wRed, 75 SAY WZ9  PICTURE "9999999"
@ wRed, 83 SAY WZ10 PICTURE "9999999"
@ wRed, 91 SAY WZ11 PICTURE "9999999"
@ wRed, 99 SAY WZ12 PICTURE "9999999"
@ wRed,107 SAY WZ13 PICTURE "9999999"
@ wRed,115 SAY WZ14 PICTURE "9999999"
@ wRed,123 SAY WZ15 PICTURE "9999999"

wRed = wRed + 1
@ wRed,10 SAY "UKUPNO UPLACENOG POREZA "
@ wRed,35 SAY Round(WZ1+WZ2+WZ3+WZ4+WZ5+WZ6+WZ7+WZ8+WZ9+WZ10+WZ11+WZ12+WZ13+WZ14+WZ15,2) PICTURE "999,999,999.99"
wRed = wRed + 1
IF lLaser
   @ wRed,0 SAY Chr(27) + '&k0S' + chr(27) + '(s10.5H'  && kondenz Off za laserski
ELSE
   @ wRed,0 SAY Chr(18)                                 && kondenz Off za matricni
ENDIF

EJECT
SET DEVICE TO SCREEN
SET PRINT OFF
SET PRINT TO

RETURN
