* - nije pregledano - *
* menja podatke u datoteci poreza
use porezn
index on broj to poricizm
use
*
select 1
use porezn index poricizm,poreznb,poreznd   && inkal,inkt
set date german
set confirm on
poruka = "Otkucajte neku tipku za dalje..."
indbris = 0
DO WHILE .t.
*
    CLEAR SCREEN
    store Space(10) to wbroj
    wrbpk1 = val("00000")
    wopis = Space(30)
    wtaks = val("000000000000.00")
    wvisakpc = val("000000000000.00")
    wvisa = val("000000000000.00")
    wniza = val("000000000000.00")
    wniza1 = val("000000000000.00")
    wnula = val("000000000000.00")
    wvrrobe = val("000000000000.00")
    wpazar = val("000000000000.00")
    wzalihe = val("000000000000.00")
    wsk = val("0")
    wdatk = ctod("  .  .  ")
    stop = 0
    indik = 0
*
    store Space(10) to wkal,wotp
  * store 0 to wosn,wpor,woddob,wraz,wzakup,wzel,wbzel
  * wdat = ctod("  .  .  ")
  * store Space(8) to wtar
    stop = 0
    indik = 0
*
    @ 3,17 SAY "BRISANJE STAVKE (KALKULACIJE) IZ KNJIGE POREZA"
    @ 5,5 SAY "Kalkulacija:    " GET wkal   && VALID ! Empty(wkal)
    READ
    IF Lastkey() = 27
       EXIT
    ENDIF
*    kljuc = val(wkal)
    kljuc = wkal
    seek kljuc
    IF ! Found()
       @ 19,1 SAY "Ne postoji takva kalkulacija u poreskoj evidenciji !"
       ? " "
       wait poruka
       LOOP
    ENDIF
    @ 5,0 SAY repli(" ",78)
 *
*    DO WHILE kal = wkal
*    @ 1,2 SAY "ESC  - izlaz   PgDn - sledeca stavka  PgUp - predhodna stavka"
         wdatk = datk
         wrbpk1 = rbpk1
         wbroj = broj
         wopis = opis
         wtaks = taks
         wvisakpc = visakpc
         wvisa = visa
         wniza = niza
         wniza1 = niza1
         wnula = nula
         wvrrobe = vrrobe
         wpazar = pazar
         wzalihe = zalihe
         wsk = sk
 *
    @ 4,4 to 19,60
    @ 5,5 SAY "Datum knjizenja    "
    @ 5,26 SAY wdatk
    @ 7,5 SAY "Rb. iz knjige PK 1 "
    @ 7,26 SAY wrbpk1 PICTURE "99999"
    @ 8,5 SAY "Broj za knjizenje  "
    @ 8,26 SAY wbroj
    @ 9,5 SAY "Opis za knjizenje  "
    @ 9,26 SAY wopis
    @ 10,5 SAY "Posebna taksa     "
    @ 10,26 SAY wtaks PICTURE "999999999999.99"
    @ 11,5 SAY "Opsta KA.PI.CI    "
    @ 11,26 SAY wvisakpc PICTURE "999999999999.99"
    @ 12,5 SAY "Opsta ost.proizvo."
    @ 12,26 SAY wvisa PICTURE "999999999999.99"
    @ 13,5 SAY "Niza stopa        "
    @ 13,26 SAY wniza PICTURE "999999999999.99"
    @ 13,45 SAY wniza1 PICTURE "999999999999.99"
    @ 14,5 SAY "Oslobodjena poreza"
    @ 14,26 SAY wnula PICTURE "999999999999.99"
    @ 15,5 SAY "Prod.vred.sa pp.  "
    @ 15,26 SAY wvrrobe PICTURE "999999999999.99"
    @ 16,5 SAY "Vred.prodate robe "
    @ 16,26 SAY wpazar PICTURE "999999999999.99"
    @ 17,5 SAY "Stanje zaliha     "
    @ 17,26 SAY wzalihe PICTURE "999999999999.99"
    @ 18,5 SAY "Str/Kom.  0/1     "
    @ 18,26 SAY wsk
    READ
    IF Lastkey() = 27
       indik = 0
       EXIT
    ENDIF
   *IF Lastkey() = 3
   *   SKIP
   *   IF Eof() .or. (! wkal = kal)
   *     @ 19,1 SAY "Ovo je poslednja stavka !"
   *     ? " "
   *     SKIP -1
   *     wait poruka
   *     @ 19,1 SAY Space(79)
   *     @ 21,0 SAY Space(80)
   *     LOOP
   *   ENDIF
   *   LOOP
   * ENDIF
   * IF Lastkey() = 18
   *   SKIP -1
   *   IF bof() .or. (! wkal = kal)
   *      @ 19,1 SAY "Ovo je prva stavka !"
   *      ? " "
   *      SKIP
   *      wait poruka
   *      @ 19,1 SAY Space(79)
   *      @ 21,0 SAY Space(80)
   *      LOOP
   *   ENDIF
   *   LOOP
   *  ENDIF
      dn = " "
      @ 20,10 SAY "Brisanje  (d/n) ? " GET dn PICTURE "!" VALID (dn $ "DN")
      READ
      IF Lastkey() = 27
         indik = 0
         EXIT
      ENDIF
      IF dn = "N"
         @ 20,0 SAY Space(80)
         LOOP
      ENDIF
      IF dn = "D"
         delete
        @ 19,1 SAY "Stavka obrisana !"
        ? " "
        wait poruka
        indbris = indbris + 1
        @ 19,0 SAY Space(80)
        @ 21,0 SAY Space(80)
      ENDIF
   *SKIP
*ENDDO
* IF indik = 1
*   indik = 0
*   LOOP
* ENDIF
ENDDO
*
IF indbris > 0
   pack
ENDIF
close databases
*release al
CLEAR SCREEN
return

