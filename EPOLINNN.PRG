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
   SELECT 0
   USE EPODAT INDEX EPOIND
   WDO = DATE()
   @ 12,10 SAY "OD DATUMA" GET WOD
   @ 12,32 SAY "DO DATUMA" GET WDO
   READ
   IF Lastkey() = 27
      CLEAR SCREEN
      RETURN
   ENDIF
   DO WHILE .T.
      CLEAR SCREEN
      CRTA = REPLI("-",80)
      @ 23,0 TO 24,79 DOUBLE
      ESCKEY()
      WBROJ = 1
      WRED = 4
      @ 1,0 SAY CRTA
      *SET COLO TO /W
      @ 2,0 SAY "R.BR"
      @ 2,5 SAY " DAT.KNJI "
      @ 2,16 SAY "    OPIS KNJI"
      @ 2,30 SAY "OD PRODROB"
      @ 2,41 SAY "OD  USLUGA"
      @ 2,52 SAY "PRSTOP"
      @ 2,59 SAY "OBR. POREZ"
      @ 2,70 SAY "     SVEGA"
      *SET COLO TO
      @ 3,0 SAY CRTA
      DO WHILE WBROJ < 16
         IF Eof()
            EXIT
         ENDIF
         IF edat < wod .or. edat > wdo
            SKIP
            LOOP
         ENDIF
         @ wred,0 SAY erb PICTURE "9999"
         @ wred,5 SAY edat
         @ wred,16 SAY SUBSTR(eopis,1,13)
         @ wred,30 SAY eodp PICTURE "9999999.99"
         @ wred,41 SAY eodu PICTURE "9999999.99"
         @ wred,52 SAY estop PICTURE "999.99"
         @ wred,59 SAY eizpor PICTURE "9999999.99"
         @ wred,70 SAY esvega PICTURE "9999999.99"
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
           *RELEASE ALL
            SET FILTER TO
            close epodat
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