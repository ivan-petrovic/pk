* - nije pregledano - *
SET CONFIRM ON
SET DATE GERMAN
SET MESSAGE TO 24 CENTER
PUBLIC DATUM,V
DATUM = DATE()
SELECT 0
USE GKZIRO INDEX gkzinbB,GKZINPB    &&  gkzinbr,GKZINDP
DO WHILE .T.
   CLEAR SCREEN
    ESCKEY()
    V = 0
    wodl = " "
    DN = " "
    WRB = VAL("000")
    @ 10,10 SAY "UNESITE BROJ IZVODA" GET WRB PICTURE "999"
    READ
    IF Lastkey() = 27
       EXIT
    ENDIF
    SEEK WRB
    IF !Found()
       @ 20,20 SAY "NEMA IZVODA POD TIM DATUMOM"
       WAIT " "
       @ 20,20 SAY Replicate(" ",50)
       @ 22,20 SAY Replicate(" ",50)
       LOOP
    ENDIF
   * WRB = RB
  DO WHILE wrb = rb
    WBDIZ = BDIZ
    WOPIS= OPIS
   * wzirpp = zirpp
    WUPL = UPL
    WISPL = ISPL
    WSALDO = SALDO
    *WINDIK = INDIK
    DO GKZIMAS
    IF V = 2          && OCE SLEDECU STAVKU
       SKIP
       IF WRB = RB
          LOOP
       ELSE
          SKIP - 1
          @ 22,20 SAY "POSLEDNJA STAVKA"
          WAIT " "
          @ 22,20 SAY Replicate(" ",50)
          LOOP
       ENDIF
    ENDIF
    *
    IF V = 3          && OCE PREDHODNU STAVKU
       SKIP - 1
       IF BOF()
          @ 22,20 SAY "PRVA STAVKA"
          WAIT " "
          @ 22,20 SAY Replicate(" ",50)
          LOOP
       ENDIF
       IF WRB = RB
          LOOP
       ELSE
          SKIP 1
          @ 22,20 SAY "PRVA STAVKA"
          WAIT " "
          @ 22,20 SAY Replicate(" ",50)
          LOOP
       ENDIF
    ENDIF
    IF V = 1 .or. v = 4
       EXIT
    ENDIF
  ENDDO
    IF V = 1
       EXIT
    ENDIF
    IF v = 4
        @ 23,24 SAY "UPIS   D/N  ?  " GET DN PICTURE "!" VALID(DN $ "DN")
        READ
        IF Lastkey() = 27
           EXIT
        ENDIF
        IF DN = "N"
           LOOP
        ENDIF
        REPLACE RB WITH WRB
        REPLACE BDIZ WITH WBDIZ
        REPLACE OPIS WITH WOPIS
        REPLACE UPL WITH WUPL
        REPLACE ISPL WITH WISPL
        REPLACE SALDO WITH WSALDO
        *REPLACE INDIK WITH WINDIK
    ENDIF
ENDDO
*
CLOSE GKZIRO
*CLEAR ALL
CLEAR SCREEN
RETURN

