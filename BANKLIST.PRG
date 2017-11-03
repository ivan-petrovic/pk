* - nije pregledano - *
****************************************************************
*BANKLIST
*program za listanje banaka                                   
****************************************************************
*
SET MESSAGE TO 24 CENTER
SET DATE GERMAN
CLEAR SCREEN
SET PROCEDURE TO FUNKCIJE
SELECT 0
USE BANKDAT INDEX BINSIF
GO TOP
PRAZNO = REPLI("-",80)
S = 1
DO WHILE S = 1
   ESCKEY()
   @ 1,0 SAY PRAZNO
   *SET COLOR TO /W
   @ 2,0 SAY " SIF.BANK "
   @ 2,12 SAY "         NAZIV BANKE          "
   @ 2,45 SAY "       ZIRORACUN BANKE        "
   *SET COLOR TO
   @ 3,0 SAY PRAZNO
   DISP OFF NEXT 15 SIBANK,Space(6),NAZBANK,Space(1),ZIRBANK
   IF Eof()
      IZBOR = 3
   ELSE
      IZBOR = 1
   ENDIF
   @ 22,25 PROMPT " Dalje " MESSAGE "Sledeca stranica"
   @ 22,32 PROMPT " Nazad " MESSAGE "Prethodna stranica"
   @ 22,39 PROMPT " Pocetak " MESSAGE "Lista od pocetka"
   @ 24,0
   @ 23,0 TO 24,79 DOUBLE
   CLEAR TYPEAHEAD
   MENU TO IZBOR
   DO CASE
      CASE Lastkey() = 27
           *RELEASE ALL
           CLOSE DATABASES
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
*RELEASE ALL
CLEAR SCREEN
CLOSE BANKDAT
RETURN
