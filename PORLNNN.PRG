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
   WSK = " "
   @ 10,10 SAY "STR ILI KOMISION ILI SVE  S/K " GET WSK
   READ
   IF Lastkey() = 27
      EXIT
   ENDIF
   use porezn index poreznd
   ESCKEY()
   IF WSK = "S" .or. wsk = "s"
      SET FILTER TO sk = 0     &&  .and. rprodv <> 0)
      GO TOP
   ENDIF
   IF WSK = "K" .or. wsk = "k"
      SET FILTER TO sk = 1    &&  .and. rprodv <> 0)
      GO TOP
   ENDIF
   WOD = DATE()
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
      @ 2,0 SAY "REDBR"
      @ 2,6 SAY "DAT.KNJI"
      @ 2,15 SAY "OPIS KNJI"
      @ 2,25 SAY "  TAKSA"
      @ 2,33 SAY "VISAKPC"
      @ 2,41 SAY "VISAOST"
      @ 2,49 SAY "   NIZA"
      @ 2,57 SAY "   NULA"
      @ 2,65 SAY " VRROBE"
      @ 2,73 SAY "  PAZAR"
      *SET COLO TO
      @ 3,0 SAY CRTA
      DO WHILE WBROJ < 16
         IF Eof()
            EXIT
         ENDIF
         IF datk < wod .or. datk > wdo
            SKIP
            LOOP
         ENDIF
         @ wred,0 SAY rbpk1 PICTURE "99999"
         @ wred,6 SAY datk
         @ wred,15 SAY SUBSTR(broj,1,9)
         @ wred,25 SAY taks PICTURE "9999.99"
         @ wred,33 SAY visakpc PICTURE "9999.99"
         @ wred,41 SAY visa PICTURE "9999.99"
         @ wred,49 SAY niza PICTURE "9999.99"
         @ wred,57 SAY nula PICTURE "9999.99"
         @ wred,65 SAY vrrobe PICTURE "9999.99"
         @ wred,73 SAY pazar PICTURE "9999.99"
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