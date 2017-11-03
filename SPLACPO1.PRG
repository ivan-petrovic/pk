SELECT 0
USE PLACP INDEX PLACP

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

MainMask("STAMPANJE STAVKI PLACENOG POREZA ZA POSELEDNJIH 7 STAVKI")
@ 12,10 SAY "OD DATUMA" GET WOD
@ 12,32 SAY "DO DATUMA" GET WDO
READ

IF Lastkey() = 27
   CLOSE PLACP
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

DO WHILE ! Eof()
   IF wRed > 66
      @ 1,10 SAY "STAMPANJE STAVKI UPLACENOG POREZA OD "
      @ 1,47 SAY WOD
      @ 1,58 SAY "DO "
      @ 1,61 SAY WDO
      @ 3, 0 SAY "DAT."
      @ 3, 7 SAY "BRI"
      @ 3,11 SAY "PPLEL80"
      @ 3,19 SAY "PPLEO87"
      @ 3,27 SAY "PPKOMU53"
      @ 3,36 SAY "PPFINU60"
      @ 3,45 SAY "PPUUT67"
      @ 3,53 SAY "PPUEST74"
      @ 3,62 SAY "PPUAUT88"
      @ 4, 0 SAY Replicate("-",79)
      wRed = 5
   ENDIF

   IF dplacpor  < wod .OR. dplacpor > wdo
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
   @ wRed,5 SAY "."

   @ wRed, 7 SAY brnal    PICTURE "999"
   @ wRed,11 SAY pplel80  PICTURE "9999999"
   @ wRed,19 SAY ppleo87  PICTURE "9999999"
   @ wRed,27 SAY ppkomu53 PICTURE "9999999"
   @ wRed,36 SAY ppfinu60 PICTURE "9999999"
   @ wRed,45 SAY ppuut67  PICTURE "9999999"
   @ wRed,53 SAY ppuest74 PICTURE "9999999"
   @ wRed,62 SAY ppuaut88 PICTURE "9999999"

   wz1 = Round(wz1 + pplel80,2)
   wz2 = Round(wz2 + ppleo87,2)
   wz3 = Round(wz3 + ppkomu53,2)
   wz4 = Round(wz4 + ppfinu60,2)
   wz5 = Round(wz5 + ppuut67,2)
   wz6 = Round(wz6 + ppuest74,2)
   wz7 = Round(wz7 + ppuaut88,2)

   wRed = wRed + 1
   SKIP
ENDDO

CLOSE PLACP

@ wRed,0 SAY Replicate("-",79)
wRed = wRed + 1

@ wRed,11 SAY WZ1 PICTURE "9999999"
@ wRed,19 SAY WZ2 PICTURE "9999999"
@ wRed,27 SAY WZ3 PICTURE "9999999"
@ wRed,36 SAY WZ4 PICTURE "9999999"
@ wRed,45 SAY WZ5 PICTURE "9999999"
@ wRed,53 SAY WZ6 PICTURE "9999999"
@ wRed,62 SAY WZ7 PICTURE "9999999"
wRed = wRed + 1

@ wRed,10 SAY "UKUPNO UPLACENOG POREZA "
@ wRed,35 SAY Round(WZ1+WZ2+WZ3+WZ4+WZ5+WZ6+WZ7,2) PICTURE "999,999,999.99"
wRed = wRed + 1

EJECT
SET DEVICE TO SCREEN
SET PRINT OFF
SET PRINT TO

RETURN
