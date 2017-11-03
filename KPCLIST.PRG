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
   USE KPCPRI INDEX KPCPRIDK
   SET FILTER TO (PRIH > 0 .AND. DK >= WOD .AND. DK <= WDO)
   GO TOP
   DO WHILE .T.
      CLEAR SCREEN
      CRTA = REPLI("-",80)
      @ 23,0 TO 24,79 DOUBLE
      ESCKEY()
      @ 1,0 SAY CRTA
      *SET COLO TO /W
      @ 2,0 SAY " RED BROJ "
      @ 2,11 SAY " DAT.KNJI "          
      @ 2,22 SAY " PAZ./RAC. "     
      @ 2,34 SAY " DAT.PAZ./RAC. "
      @ 2,50 SAY " BROJ R./P. "
      @ 2,63 SAY " PRIHOD OD DELAT "
      *SET COLO TO
      @ 3,0 SAY CRTA
      DISP OFF NEXT 15 RB,Space(5),DK,Space(3),PIR,Space(5),DRP,Space(6),BRP,Space(2),PRIH
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