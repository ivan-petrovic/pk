* - nije pregledano - *
* menja podatke u datoteci poreza
use porezn
index on broj to poric
use
*
select 1
use porezn index poric,poreznb,POREZND  && inkal,inkt
set date german
set confirm on
poruka = "Otkucajte neku tipku za dalje..."
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
    wnula06 = val("000000000000.00")
    wnula2 = val("000000000000.00")
    wnula3 = val("000000000000.00")
    wnula4 = val("000000000000.00")
    wnula1 = val("000000000000.00")
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
    @ 5,5 SAY "Kalkulacija:    " GET wkal   && VALID ! Empty(wkal)
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
    @ 5,5 SAY Space(70)
 *
    DO WHILE broj = wkal
    @ 1,2 SAY "ESC  - izlaz   PgDn - sledeca stavka  PgUp - predhodna stavka"
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
         wnula06 = nula06
         wnula2 = nula2
         wnula3 = nula3
         wnula4 = nula4
         wnula1 = nula1
         wvrrobe =vrrobe
         wpazar = pazar
         wzalihe = zalihe
         wsk = sk
 *
    @ 4,4 to 19,60
    @ 5,5 SAY "Datum knjizenja    " GET wdatk VALID ! Empty(wdatk)
    @ 7,5 SAY "Rb. iz knjige PK 1 " GET wrbpk1
    @ 8,5 SAY "Broj za knjizenje  " GET wbroj VALID ! Empty(wbroj)
    @ 9,5 SAY "Opis za knjizenje  "  GET wopis
    @ 10,5 SAY "Posebna taksa     " GET wtaks
    @ 11,5 SAY "Opsta KA.PI.CI    " GET wvisakpc PICTURE "999999999999.99"
    @ 12,5 SAY "Opsta ost.proizvo." GET wvisa PICTURE "999999999999.99"
    @ 12,40 GET wnula2 PICTURE "999999999999.99"
    @ 12,56 SAY "28 %"
    @ 13,5 SAY "Niza stopa        " GET wniza PICTURE "999999999999.99"
    @ 13,40 GET wniza1 PICTURE "999999999999.99"
    @ 13,56 SAY "21 %"
    @ 14,5 SAY "Oslobodjena poreza" GET wnula PICTURE "999999999999.99"
    @ 14,40 GET wnula06 PICTURE "999999999999.99"
    @ 14,56 SAY "20 %"
    @ 15,5 SAY "Prod.vred.sa pp.  " GET wvrrobe PICTURE "999999999999.99"
    @ 15,40 GET wnula4 PICTURE "999999999999.99"
    @ 15,56 SAY "12 %"
    @ 16,5 SAY "Vred.prodate robe " GET wpazar PICTURE "999999999999.99"
    @ 16,40 GET wnula3 PICTURE "999999999999.99"
    @ 16,56 SAY "3  %"
    @ 17,5 SAY "Stanje zaliha     " GET wzalihe PICTURE "999999999999.99"
    @ 17,40 GET wnula1 PICTURE "999999999999.99"
    @ 17,56 SAY "1  %"
    @ 18,5 SAY "Str/Kom.  0/1     " GET wsk VALID(wsk = 0 .or. wsk = 1)
    READ
    IF Lastkey() = 27
       indik = 1
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
         replace datk with wdatk
         replace rbpk1 with wrbpk1
         replace broj with wbroj
         replace opis with wopis
         replace taks with wtaks
         replace visakpc with wvisakpc
         replace visa with wvisa
         replace niza with wniza
         replace niza1 with wniza1
         replace nula with wnula
         replace nula06 with wnula06
         replace nula2 with wnula2
         replace nula4 with wnula4
         replace nula3 with wnula3
         replace nula1 with wnula1
         replace vrrobe with wvrrobe
         replace pazar with wpazar
         replace zalihe with wzalihe
         replace sk with wsk
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
