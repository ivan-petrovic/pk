SELECT 0
USE TRG
INDEX ON DK TO TRGDK
CLOSE TRG

SELECT 0
USE TRG INDEX TRGDK

DO WHILE .T.

   wzad = val("000000000000000.00")
   wraz = val("000000000000000.00")
   wizndin = val("000000000000000.00")
   worgj = Space(4)          
   wrb = val("0000")
   red = 0
   wstr = 1
   wod = ctod("  .  .  ")
   wdo = ctod("  .  .  ")

   MainMask("STAMPANJE TRGOVACKE KNJIGE")

   @ 8,10 SAY "OD DATUMA: " GET wod VALID ! Empty(wod)
   @ 9,10 SAY "DO DATUMA: " GET wdo VALID(wdo >= wod)
   READ

   IF Lastkey() = 27
      EXIT
   ENDIF

   SET DEVICE TO PRINT
   * SET PRINT TO LISTA
   SET PRINT ON
   IF lLaser
      ? Chr(27) + '(s17.5H'      && kondenz On za laserski
   ELSE
      ? Chr(15)                  && kondenz On za matricni
   ENDIF

   DO TRGZAG
   DO WHILE ! Eof()
      IF ! (wod <= DK .AND. DK <= wdo)
         SKIP
         LOOP
      ENDIF

      red = red + 1
      @ red,  1 SAY rb PICTURE "9999"
      @ red,  6 SAY brkal
      @ red, 17 SAY dk
      @ red, 28 SAY Substr(opk,1,40)
      @ red, 70 SAY zad PICTURE "999,999,999.99"
      @ red, 85 SAY raz PICTURE "999,999,999.99"
      @ red,103 SAY datupl
      @ red,117 SAY izndin PICTURE "999,999,999,999.99"

      IF red > 62
         wstr = wstr + 1
         DO TRGZAG
      ENDIF

      wzad = wzad + Round(ZAD,2)
      wraz = wraz + Round(RAZ,2)
      wizndin = wizndin + Round(IZNDIN,2)
      SKIP
   ENDDO

   SET SOFTSEEK OFF
   red = red + 1
   @ red,0 SAY Replicate("-",136)
   red = red + 1
   @ red, 70 SAY wzad PICTURE "999,999,999.99"
   @ red, 85 SAY wraz PICTURE "999,999,999.99"
   @ red,117 SAY wizndin PICTURE "999,999,999,999.99"
   red = red + 1
   @ red,0 SAY " "

   IF lLaser
      ? Chr(27) + '&k0S' + Chr(27) + '(s10.5H'  && kondenz Off za laserski
   ELSE
      ? Chr(18)                                 && kondenz Off za matricni
   ENDIF
   SET DEVICE TO SCREEN
   SET PRINT OFF
ENDDO

CLOSE DATABASES
RETURN

***************************************************************
PROCEDURE trgzag

@ 1,  1 SAY gcNazRad
@ 2, 30 SAY "     T  R  G  O  V  A  C  K  A               K   NJ   I   G   A"
@ 3,127 SAY "STR."
@ 3,132 SAY wstr PICTURE "9999"
@ 4, 40 SAY "OD DATUMA"
@ 4, 50 SAY wod
@ 4, 77 SAY "DO DATUMA"
@ 4, 87 SAY wdo
@ 6,  0 SAY "REDNI"
@ 6,  6 SAY "DATUM KNJIZENJA"
@ 6, 23 SAY "O  P  I  S   K  NJ  I  Z  E  NJ  A"
@ 6, 61 SAY "I  Z  N  O  S   D  I  N  A  R  A"
@ 6,103 SAY "UPLACENO NA TEKUCI RACUN"
@ 7,  0 SAY "BROJ"
@ 7, 70 SAY "ZADUZENJE"
@ 7, 85 SAY "RAZDUZENJE"
@ 7,100 SAY "DATUM KNJIZENJA"
@ 7,119 SAY "IZNOS DINARA"
@ 8,  0 SAY Replicate("-",136)
red = 8

RETURN
***************************************************************
