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
   SET FILTER TO ((rpbez06 + rpbez2 + rpbez4 + RPV + RPN + RPN1 + RPBEZ) > 0 .AND. RSK = 1)
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
      @ 2,0 SAY "DAT.KNJI"
      @ 2,9 SAY "PAZ.VISA"
      @ 2,18 SAY "PAZ.NIZA"
      @ 2,27 SAY "PAZ.NI12"
      @ 2,36 SAY "PAZ.OSLO"
      @ 2,45 SAY "USLU. SA P/P"
      @ 2,63 SAY "UKUPAN PAZAR"
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
         @ wred,0 SAY rdk
         @ wred,9 SAY rpv PICTURE "99999.99"
         @ wred,18 SAY rpn PICTURE "99999.99"
         @ wred,27 SAY rpn1 PICTURE "99999.99"
         @ wred,36 SAY rpbez PICTURE "9999999.99"
         @ wred,45 SAY rusp PICTURE "999999999.99"
         @ wred,63 SAY rsvep PICTURE "999999999.99"
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
