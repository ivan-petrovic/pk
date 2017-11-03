* - nije pregledano - *
*******     menja podatke u datoteci poreza ********
LOCAL ekran:=SAVESCREEN(0,0,24,79), KURSOR:=SETCURSOR(1), OBLAST:=SELECT(1)
select 0
use epodat index epoinrb,epoind
set date german
set confirm on
poruka = "Otkucajte neku tipku za dalje..."
    werb = val("00000")
    wedat = date()
    weopis = Space(30)
    weodp = val("000000000000.00")
    weodu = val("000000000000.00")
    westop = val("000.00")
    weizpor = val("000000000000.00")
    wesvega = val("000000000000.00")
DO WHILE .t.
*
    CLEAR SCREEN
    @ 2,10 SAY "IZMENA STAVKE U KNJIZI PAUSALNO OPOREZOVANIH"
    @ 10,10 SAY "BROJ STAVKE ZA IZMENU" GET werb PICTURE "9999" VALID (werb > 0)
    READ
    IF Lastkey() = 27
       EXIT
    ENDIF
    seek werb
    IF ! Found()
       @ 20,10 SAY "NE POSTOJI TAKAV BROJ STAVKE"
       wait " "
       @ 20,10 SAY repli(" ",68)
       LOOP
    ENDIF
    werb = erb
    wedat = edat
    weopis = eopis
    weodp = eodp
    weodu = eodu
    westop = estop
    weizpor = eizpor
    wesvega = esvega
    CLEAR SCREEN
    *
    @ 4,4 to 19,60
    @ 5,5 SAY "Redni broj                  " GET werb PICTURE "9999" VALID(werb > 0)
    @ 7,5 SAY "Datum knjizenja             " GET wedat
    @ 8,5 SAY "Opis knjizenja              " GET weopis VALID ! Empty(weopis)
    @ 9,5 SAY "Prihod od prodaje proizvoda " GET weodp PICTURE "999999999999.99"
    @ 10,5 SAY "Prihod od izvrsenih usluga  " GET weodu PICTURE "999999999999.99"
    wesvega = round(weodp + weodu,2)
   *@ 11,5 SAY "Preracunata stopa           " GET westop PICTURE "999.99"
   *@ 12,5 SAY "Iznos obracunatog poreza    " GET weizpor PICTURE "999999999999.99"
    @ 11,5 SAY "SVEGA PRIHODI OD DELATNOSTI " GET wesvega PICTURE "999999999999.99"
    READ
    IF Lastkey() = 27
       EXIT
    ENDIF
      dn = " "
      @ 21,10 SAY "Ispravka   (d/n) ? " GET dn PICTURE "!" VALID (dn $ "DN")
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