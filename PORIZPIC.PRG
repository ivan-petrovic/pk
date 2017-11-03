* - nije pregledano - *
*******     menja podatke u datoteci poreza ********
select 0
use porezpic
index on kal to kpckal
close porezpic
*
select 0
use porezpic index kpckal,porpicka,porpickt,porpicdd   &&inkal,inkt
set date german
set confirm on
poruka = "Otkucajte neku tipku za dalje..."
DO WHILE .t.
*
    CLEAR SCREEN
    store Space(10) to wkal,wotp
    store 0 to wosn,wpor,woddob,wraz,wzakup,wzel,wbzel
    wdat = ctod("  .  .  ")
    store Space(8) to wtar
    stop = 0
    indik = 0
*
    @ 5,5 SAY "Kalkulacija:    " GET wkal VALID ! Empty(wkal)
    READ
    IF Lastkey() = 27
       EXIT
    ENDIF
    kljuc = wkal
    seek kljuc
    IF ! Found()
       @ 19,1 SAY "Ne postoji takva kalkulacija u poreskoj evidenciji !"
       ? " "
       wait poruka
       LOOP
    ENDIF
 *
    DO WHILE kal = wkal
    @ 1,2 SAY "ESC  - izlaz   PgDn - sledeca stavka  PgUp - predhodna stavka"
    wkal = kal
    wstop = stop
    wtar = tar
    wdat = dat
    wotp = otp
    wosn = osn
    wpor = por
    woddob = oddob
    wraz = raz
    wzakup = zakup
    wzel = zel
    wbzel = bzel
 *
*   @ 5,5 SAY Space(60)
    @ 4,4 to 18,60
*   @ 5,5 SAY "Kalkulacija:    " GET wkal
    @ 7,5 SAY "Tarifa:         " GET wtar
    @ 8,5 SAY "Stopa :         " GET wstop
    @ 9,5 SAY "Datum:          " GET wdat
    @ 10,5 SAY "Otpremnica:     " GET wotp
    @ 11,5 SAY "Osnovica:       " GET wosn
    @ 12,5 SAY "Porez (bez pr.: " GET wpor
    @ 13,5 SAY "Od dobavljaca:  " GET woddob
    @ 14,5 SAY "Razlika:        " GET wraz
    @ 15,5 SAY "Za kupca:       " GET wzakup
    @ 16,5 SAY "Porez za uplatu:" GET wbzel
    @ 17,5 SAY "Za zeleznicu:   " GET wzel
    READ
    IF Lastkey() = 27
       indik = 1
       EXIT
    ENDIF
    IF Lastkey() = 3
       SKIP
       IF Eof() .or. (! wkal = kal)
         @ 19,1 SAY "Ovo je poslednja stavka !"
         ? " "
         SKIP -1
         wait poruka
         @ 19,1 SAY Space(79)
         @ 21,0 SAY Space(80)
         LOOP
       ENDIF
       LOOP
     ENDIF
     IF Lastkey() = 18
       SKIP -1
       IF bof() .or. (! wkal = kal)
          @ 19,1 SAY "Ovo je prva stavka !"
          ? " "
          SKIP
          wait poruka
          @ 19,1 SAY Space(79)
          @ 21,0 SAY Space(80)
          LOOP
       ENDIF
       LOOP
      ENDIF
      dn = " "
      @ 20,10 SAY "Upis  (d/n) ? " GET dn PICTURE "!" VALID (dn $ "DN")
      READ
      IF Lastkey() = 27
         indik = 1
         EXIT
      ENDIF
      IF dn = "N"
         @ 20,0 SAY Space(80)
         LOOP
      ENDIF
      IF dn = "D"
         @ 20,0 SAY Space(80)
 *        replace kal with wkal
         replace tar with wtar
         replace stop with wstop
         replace dat with wdat
         replace otp with wotp
         replace osn with wosn
         replace por with wpor
         replace oddob with woddob
         replace raz with wraz
         replace zakup with wzakup
         replace zel with wzel
         replace bzel with wbzel
        @ 19,1 SAY "Stavka ispravljena !"
        ? " "
        wait poruka
        @ 19,0 SAY Space(80)
        @ 21,0 SAY Space(80)
      ENDIF
    SKIP
 ENDDO
 IF indik = 1
   indik = 0
   LOOP
 ENDIF
ENDDO
*
close databases
*release al
CLEAR SCREEN
return

