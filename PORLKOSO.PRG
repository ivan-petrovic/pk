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
    *  @ 23,0 TO 24,79 DOUBLE
      ESCKEY()
      WBROJ = 1
      WRED = 5
      @ 1,0 SAY CRTA
      *SET COLO TO /W
      @ 2,0 SAY "REDB"
      @ 2,5 SAY "DAT.KNJIZE"
      @ 2,16 SAY "OPIS KNJIZ"
      @ 2,27 SAY "     TAKSA"
      @ 2,38 SAY "   VISAKPC"
      @ 2,49 SAY "   VISAOST"
      @ 2,60 SAY "      NIZA"
      @ 2,71 SAY "    PAZAR"
      @ 3,03 SAY "     NIZA1"     && 21
      @ 3,14 SAY "     NIZA2"     && 20
      @ 3,25 SAY "     NIZA3"     && 28
      @ 3,36 SAY "     NIZA4"     && 12
      @ 3,47 SAY "     NIZA5"     && 3
      @ 3,58 SAY "      NULA"     && 0
      @ 3,69 SAY "     VRROBE"
      *SET COLO TO
      @ 4,0 SAY CRTA
      DO WHILE WBROJ < 16
         IF Eof()
            EXIT
         ENDIF
         IF datk < wod .or. datk > wdo
            SKIP
            LOOP
         ENDIF
         @ wred,0 SAY rbpk1 PICTURE "9999"
         @ wred,5 SAY datk
         @ wred,16 SAY broj
         @ wred,27 SAY taks PICTURE "9999999.99"
         @ wred,38 SAY visakpc PICTURE "9999999.99"
         @ wred,49 SAY visa PICTURE "9999999.99"
         @ wred,60 SAY niza PICTURE "9999999.99"
         @ wred,71 SAY pazar PICTURE "999999.99"
         wred = wred + 1
         WBROJ = WBROJ + 1
         @ wred,03 SAY niza1 PICTURE "9999999.99"
         @ wred,14 SAY nula06 PICTURE "9999999.99"
         @ wred,25 SAY nula2 PICTURE "9999999.99"
         @ wred,36 SAY nula4 PICTURE "9999999.99"
         @ wred,47 SAY nula3 PICTURE "9999999.99"
         @ wred,58 SAY nula PICTURE "9999999.99"
         @ wred,69 SAY vrrobe PICTURE "99999999.99"
        wred = wred + 1
        wbroj = wbroj + 1
         SKIP
      ENDDO
      IF Eof()
         IZBOR = 3
         ELSE
         IZBOR = 1
      ENDIF
      @ 23,25 PROMPT " Dalje " MESSAGE "Sledeca stranica"
      @ 23,32 PROMPT " Nazad " MESSAGE "Predhodna stranica"
      @ 23,39 PROMPT " Pocetak " MESSAGE "Lista od pocetka"
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