* - nije pregledano - *
*********************************************
* GKZIRO  program za listanje knjige prihoda
*********************************************
SET WRAP ON
SET MESSAGE TO 24 CENTER
SELECT 0
USE GKZIRO index gkzinbB,gkzinpB     && gkzinbr,gkzindp
GO TOP
DO WHILE .T.
   CLEAR SCREEN
   CRTA = REPLI("-",80)
   @ 23,0 TO 24,79 DOUBLE
   ESCKEY()
   @ 1,0 SAY CRTA
   *SET COLO TO /W
   @ 2,0 SAY " RB"
   @ 2,4 SAY "DAT   IZV."
 * @ 2,18 SAY "DAT.PROM"
   @ 2,15 SAY "   OPIS        "
   @ 2,31 SAY "      UPLATA"
   @ 2,44 SAY "     ISPLATA"
   @ 2,57 SAY "      STANJE"
   *@ 2,70 SAY "INDIKATOR"
   *SET COLO TO
   @ 3,0 SAY CRTA
   DISP OFF NEXT 15 RB,BDIZ,OPIS,UPL,ISPL,SALDO,Space(3)   && ,INDIK
   SKIP
   IF Eof()
      IZBOR = 3
   ELSE
      IZBOR = 1
   ENDIF
   @ 22,25 PROMPT " Dalje " MESSAGE "Sledeca stranica"
   @ 22,32 PROMPT " Nazad " MESSAGE "Predhodna stranica"
   @ 22,39 PROMPT " Pocetak " MESSAGE "Lista od pocetka"
   *@ 24,0
  CLEAR TYPEAHEAD
  MENU TO IZBOR
  DO CASE
   CASE Lastkey() = 27
        RELEASE ALL
        USE
        CLEAR SCREEN
        RETURN
   CASE IZBOR = 1
        LOOP
   CASE IZBOR = 2
        SKIP -29
   CASE IZBOR = 3
        GO TOP
        LOOP
  ENDCASE
ENDDO

