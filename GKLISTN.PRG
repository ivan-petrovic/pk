* - nije pregledano - *
*********************************************
* GKLDD  program za listanje knjige prihoda
*********************************************
SET WRAP ON
SET MESSAGE TO 24 CENTER
SET PROCEDURE TO FUNKCIJE
set date german
DO WHILE .T.
   CLEAR SCREEN
   WOD = DATE()
   WDO = DATE()
   @ 10,10 SAY "OD DATUMA" GET WOD
   @ 10,32 SAY "DO DATUMA" GET WDO
   READ
   IF Lastkey() = 27
      CLEAR SCREEN
      RETURN
   ENDIF
 *  USE GKPRI INDEX GKPINDK
   use rashodn index rashindn
   SET FILTER TO ((rpbez06 + rpbez2 + rpbez4 + RPV + RPN + RPN1 + RPBEZ+RUSP+RUSBEZP) > 0 .AND. RSK = 0)
   GO TOP
   DO WHILE .T.
      CLEAR SCREEN
      CRTA = REPLI("-",80)
      @ 23,0 TO 24,79 DOUBLE
      ESCKEY()
      WBROJ = 1
      WRED = 4
      @ 1,0 SAY CRTA
      *SET COLO TO /W
     *@ 2,0 SAY " RED BROJ "
      @ 2,0 SAY " DAT.KNJI "
      @ 2,11 SAY "PAZ.SA P/P"
      @ 2,22 SAY "PAZ.BE P/P"
      @ 2,33 SAY "PAZ.US P/P"
      @ 2,44 SAY "PAZ.UB P/P"
      @ 2,55 SAY "UKUP.USLUG"
      @ 2,66 SAY "UKUP.PAZAR"
      *SET COLO TO
      @ 3,0 SAY CRTA
      DO WHILE WBROJ < 16
         IF Eof()
            EXIT
         ENDIF
         IF rdk < wod
            SKIP
            LOOP
         ENDIF
         IF rdk > wdo
            SKIP
            LOOP
         ENDIF
         @ wred,1 SAY rdk
         @ wred,11 SAY rpn1 PICTURE "999,999.99"
         @ wred,22 SAY rpbez PICTURE "999,999.99"
         @ wred,33 SAY rusp PICTURE "999,999.99"
         @ wred,44 SAY rusbezp PICTURE "999,999.99"
         @ wred,55 SAY round(rusp + rusbezp,2) PICTURE "999,999.99"
         @ wred,66 SAY rsvep PICTURE "999,999.99"
        * DISP OFF NEXT 15 RDK,RPV,RPN,RPBEZ,RSVEP
        wred = wred + 1
        wbroj = wbroj + 1
         SKIP
      ENDDO
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
            SET FILTER TO
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
ENDDO


