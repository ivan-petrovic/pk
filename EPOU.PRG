* - nije pregledano - *
*******     menja podatke u datoteci poreza ********
LOCAL ekran:=SAVESCREEN(0,0,24,79), KURSOR:=SETCURSOR(1), OBLAST:=SELECT(1)
  *
      IF ! FILE("EPODAT.DBF")
        CREATE RADNA
        STORE "ERB       N4  " TO POLJE1
        STORE "EDAT      D8  " TO POLJE2
        STORE "EOPIS     C30 " TO POLJE3
        STORE "EODP      N152" TO POLJE4
        STORE "EODU      N152" TO POLJE5
        STORE "ESTOP     N6 2" TO POLJE6
        STORE "EIZPOR    N152" TO POLJE7
        STORE "ESVEGA    N152" TO POLJE8
        FOR JJ = 1 TO 8
         STORE STR(JJ,1) TO BROJ
          STORE "POLJE" + BROJ TO P1
           APPEND BLANK
           REPLACE FIELD_NAME WITH SUBSTR(&P1,1,10)
           REPLACE FIELD_TYPE WITH SUBSTR(&P1,11,1)
           REPLACE FIELD_LEN WITH VAL(SUBSTR(&P1,12,2))
           REPLACE FIELD_DEC WITH VAL(SUBSTR(&P1,14,1))
        NEXT JJ
        CREATE EPODAT FROM RADNA
        INDEX ON EDAT TO EPOIND
        INDEX ON ERB TO EPOINRB
        USE
        ERASE RADNA.DBF
    ENDIF
 *
werb = val("0000")
select 0
use epodat
  go bott
  werb = erb
close epodat
*
werb = werb + 1
select 0
use epodat index epoinrb,epoind
set date german
set confirm on
poruka = "Otkucajte neku tipku za dalje..."
    wesvega = val("000000000000.00")
DO WHILE .t.
*
    CLEAR SCREEN
    store Space(10) to wbroj
   * werb = val("00000")
    wedat = date()
    weopis = Space(30)
    weopis = "PAZAR                         "
    weodp = val("000000000000.00")
    weodu = val("000000000000.00")
    westop = val("000.00")
    weizpor = val("000000000000.00")
    *Wesvega = val("000000000000.00")
    *
    @ 4,4 to 19,60
    @ 5,5 SAY "Redni broj                  " GET werb PICTURE "9999" VALID(werb > 0)
    @ 7,5 SAY "Datum knjizenja             " GET wedat
    @ 8,5 SAY "Opis knjizenja              " GET weopis VALID ! Empty(weopis)
    @ 9,5 SAY "Prihod od prodaje proizvoda " GET weodp PICTURE "999999999999.99"
    @ 10,5 SAY "Prihod od izvrsenih usluga  " GET weodu PICTURE "999999999999.99"
     wesvega = round(weodp + weodu,2)
  * @ 11,5 SAY "Preracunata stopa           " GET westop PICTURE "999.99"
  * @ 12,5 SAY "Iznos obracunatog poreza    " GET weizpor PICTURE "999999999999.99"
    @ 11,5 SAY "SVEGA PRIHODI OD DELATNOSTI " GET wesvega PICTURE "999999999999.99"
    READ
    IF Lastkey() = 27
       indik = 1
       EXIT
    ENDIF
   * @ 13,5 SAY "SVEGA PRIHODI OD DELATNOSTI " GET wesvega PICTURE "999999999999.99"
   * weizpor = round(weodp * westop / 100,2)
   *@ 12,5 SAY "Iznos obracunatog poreza    "
   *@ 12,34 SAY weizpor PICTURE "999999999999.99"
    wesvega = round(weodp + weodu,2)
    @ 11,5 SAY "SVEGA PRIHODI OD DELATNOSTI "
    @ 11,34 SAY wesvega PICTURE "999999999999.99"
    *   READ
    *   IF Lastkey() = 27
    *      indik = 1
    *      EXIT
    *   ENDIF
      dn = " "
      @ 21,10 SAY "Upis  (d/n) ? " GET dn PICTURE "!" VALID (dn $ "DN")
      READ
      IF Lastkey() = 27
         EXIT
      ENDIF
      IF dn = "N"
         @ 21,0 SAY Space(80)
         LOOP
      ENDIF
      IF dn = "D"
         @ 21,0 SAY Space(80)
         append blank
         replace erb  with werb
         replace edat with wedat
         replace eopis with weopis
         replace eodp with weodp
         replace eodu with weodu
         replace estop with westop
         replace eizpor with weizpor
         replace esvega with wesvega
        @ 19,1 SAY "Stavka upisana !"
        ? " "
        wait poruka
        @ 19,0 SAY Space(80)
        @ 21,0 SAY Space(80)
        werb = werb + 1
      ENDIF
 ENDDO
*
close epodat
*release al
*CLEAR SCREEN
SELECT(OBLAST)
RESTSCREEN(0,0,24,79,EKRAN)
SETCURSOR(KURSOR)
return

