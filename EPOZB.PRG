* - nije pregledano - *
*******     menja podatke u datoteci poreza ********
LOCAL ekran:=SAVESCREEN(0,0,24,79), KURSOR:=SETCURSOR(1), OBLAST:=SELECT(1)
select 0
use epodat index epoinrb,epoind
set date german
set confirm on
poruka = "Otkucajte neku tipku za dalje..."
    wod = date()
    wdo = date()
    werb = val("00000")
    wedat = date()
    weopis = Space(30)
    wweodp = val("000000000000.00")
    wweodu = val("000000000000.00")
    westop = val("000.00")
    wweizpor = val("000000000000.00")
    wwesvega = val("000000000000.00")
DO WHILE .t.
*
    CLEAR SCREEN
    @ 2,10 SAY "ZBIROVI STAVKI U KNJIZI PAUSALNO OPOREZOVANIH"
    @ 10,10 SAY "OD DATUMA" GET wOD
    @ 10,30 SAY "DO DATUMA" GET wdo VALID(wdo >= wod)
    READ
    IF Lastkey() = 27
       EXIT
    ENDIF
    DO WHILE ! Eof()
       IF edat < wod
          SKIP
          LOOP
       ENDIF
       *
       IF edat > wdo
          SKIP
          LOOP
       ENDIF
       wweodp = round(wweodp + eodp,2)
       wweodu = round(wweodu + eodu,2)
      *wweizpor = round(wweizpor + eizpor,2)
       wwesvega = round(wwesvega + esvega,2)
       SKIP
    ENDDO
    *
    @ 4,4 to 19,60
    @ 12,5 SAY "Prihod od prodaje proizvoda "
    @ 12,35 SAY wweodp PICTURE "999999999999.99"
    @ 13,5 SAY "Prihod od izvrsenih usluga  "
    @ 13,35 SAY wweodu PICTURE "999999999999.99"
   *@ 14,5 SAY "Iznos obracunatog poreza    "
   *@ 14,35 SAY wweizpor PICTURE "999999999999.99"
    @ 15,5 SAY "S V E G A                   "
    @ 15,35 SAY wwesvega PICTURE "999999999999.99"
        wait " "
    EXIT
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