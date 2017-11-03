LOCAL ukUpl, ukIspl, ukSaldo
PRIVATE Dat1, Dat2, Strana, Red

Dat1 = Date()
Dat2 = Date()

MainMask("KNJIGA ZIRO RACUNA OD DATUMA DO DATUMA")
@ 10,10 SAY "OD DATUMA: " GET Dat1 VALID !Empty(Dat1)
@ 11,10 SAY "DO DATUMA: " GET Dat2 VALID !Empty(Dat2) .AND. Dat1 <= Dat2
READ

IF Lastkey() = 27
   RETURN
ENDIF

SELECT 0
USE GKZIRO INDEX GKZINBB
GO TOP

SET DEVICE TO PRINT
SET PRINT TO LPT1
* SET PRINT TO Lista
SET PRINT ON
SET CONSOLE OFF

Strana  = 0
Red     = 0
ukUpl   = 0
ukIspl  = 0
ukSaldo = 0

DO GLAVA1

DO WHILE ! Eof()

   IF DTOS(BDIZ) >= DTOS(Dat1) .AND. DTOS(BDIZ) <= DTOS(Dat2)
      @ Red, 0 SAY RB PICTURE "999"
      @ Red, 4 SAY BDIZ
      @ Red,13 SAY OPIS
      @ Red,44 SAY UPL   PICTURE "9999999.99"
      @ Red,55 SAY ISPL  PICTURE "9999999.99"
      @ Red,66 SAY SALDO PICTURE "9999999.99"
      Red = Red + 1

      ukUpl   = ukUpl + UPL
      ukIspl  = ukIspl + ISPL
      ukSaldo = ukSaldo + SALDO

      IF Red > 62
         Red = 0
         DO GLAVA1
      ENDIF
   ENDIF

   SKIP
ENDDO

Red = Red + 1
@ Red,0 SAY Replicate("*",80)
Red = Red + 1
@ Red,44 SAY ukUpl   PICTURE "9999999.99"
@ Red,55 SAY ukispl  PICTURE "9999999.99"
@ Red,66 SAY ukSaldo PICTURE "9999999.99"

SET PRINT OFF
SET CONSOLE ON
SET DEVICE TO SCREEN

CLOSE GKZIRO
RETURN

*************************************************
PROCEDURE GLAVA1

   Strana = Strana + 1
   Red = Red + 2

   @ Red, 1 SAY gcNazRad
   @ Red,25 SAY "STAMPANJE KNJIGE ZIRO RACUNA"
   @ Red,70 SAY "STR:"
   @ Red,76 SAY Strana PICTURE "9999"
   Red = Red + 1

   @ Red, 5 SAY "OD:"
   @ Red, 9 SAY Dat1
   @ Red,66 SAY "DO:"
   @ Red,70 SAY Dat2
   Red = Red + 1

   @ Red,0 SAY Replicate("*",80)
   Red = Red + 1

   @ Red, 0 SAY " RB"
   @ Red, 4 SAY "DAT IZV."
   @ Red,13 SAY "           OPIS               "
   @ Red,44 SAY " UPLATA NA"
   @ Red,55 SAY "ISPLATA SA"
   @ Red,66 SAY "    STANJE"
   @ Red,77 SAY "I"
   Red = Red + 1

RETURN
*************************************************
