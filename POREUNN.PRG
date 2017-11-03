* - nije pregledano - *
* menja podatke u datoteci poreza

   IF ! FILE("POREZNXX.DBF")
        ! ren porezn.dbf poreznxx.dbf
      CREATE RADNA
      STORE "DATK      D8  " TO POLJE1
      STORE "RBPK1     N 5 " TO POLJE2
      STORE "BROJ      C10 " TO POLJE3
      STORE "OPIS      C30 " TO POLJE4
      STORE "TAKS      N152" TO POLJE5
      STORE "VISAKPC   N152" TO POLJE6
      STORE "VISA      N152" TO POLJE7
      STORE "NIZA      N152" TO POLJE8
      STORE "NIZA1     N152" TO POLJE9
      STORE "NULA      N152" TO POLJE10
      STORE "NULA06    N152" TO POLJE11
      STORE "NULA2     N152" TO POLJE12
      STORE "NULA3     N152" TO POLJE13
      STORE "NULA4     N152" TO POLJE14
      STORE "NULA1     N152" TO POLJE15
      STORE "VRROBE    N152" TO POLJE16
      STORE "PAZAR     N152" TO POLJE17
      STORE "ZALIHE    N152" TO POLJE18
      STORE "SK        N1  " TO POLJE19
      FOR I = 1 TO 19
         IF I < 10
            STORE  STR(I,1) TO BROJ
         ELSE
            STORE  STR(I,2) TO BROJ
         ENDIF
         P1 = "POLJE" + BROJ
      APPEND BLANK
      REPLACE FIELD_NAME WITH SUBSTR(&P1,1,10)
      REPLACE FIELD_TYPE WITH SUBSTR(&P1,11,1)
      REPLACE FIELD_LEN WITH VAL(SUBSTR(&P1,12,2))
      REPLACE FIELD_DEC WITH VAL(SUBSTR(&P1,14,1))
      NEXT I
      CREATE POREZN FROM RADNA
      INDEX ON VAL(BROJ) TO POREZNB
      INDEX ON DATK TO POREZND
      INDEX ON BROJ TO POREZNBB
      USE
      ERASE RADNA.DBF
   *ENDIF
*
     * PREPISATI IZ TARDATX.DBF U TARDAT.DBF
     select 0
     use porezn index poreznb,POREZND  &&  inkal,inkt
     select 0
     use poreznxx
     DO WHILE ! Eof()
        select porezn
        append blank
        replace DATK  with poreznxx->DATK
        replace RBPK1 with poreznxx->RBPK1
        replace BROJ  with poreznxx->BROJ
        replace OPIS  with poreznxx->OPIS
        replace TAKS  with poreznxx->TAKS
        replace VISAKPC with poreznxx->VISAKPC
        replace VISA  with poreznxx->VISA
        replace NIZA  with poreznxx->NIZA
        replace NIZA1 with poreznxx->NIZA1
        replace NULA  with poreznxx->NULA
        replace NULA06 with poreznxx->NULA06
        replace NULA2 with poreznxx->NULA2
     *  replace NULA3 with poreznxx->NULA3
        replace NULA4 with poreznxx->NULA4
     *  replace NULA1 with poreznxx->NULA1
        replace VRROBE with poreznxx->VRROBE
        replace PAZAR with poreznxx->PAZAR
        replace ZALIHE with poreznxx->ZALIHE
        replace SK with poreznxx->SK
        select poreznxx
        SKIP
     ENDDO
     * kraj spemanja
     select poreznxx
     close poreznxx
     select porezn
     close porezn
  ENDIF
*
select 1
use porezn index poreznb,POREZND  &&  inkal,inkt
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
*   @ 5,5 SAY "Kalkulacija:    " GET wkal VALID ! Empty(wkal)
*   READ
*   IF Lastkey() = 27
*      EXIT
*   ENDIF
*   kljuc = val(wkal)
*   seek kljuc
*   IF ! Found()
*      @ 19,1 SAY "Ne postoji takva kalkulacija u poreskoj evidenciji !"
*      ? " "
*      wait poruka
*      LOOP
*   ENDIF
**
*   DO WHILE kal = wkal
*   @ 1,2 SAY "ESC  - izlaz   PgDn - sledeca stavka  PgUp - predhodna stavka"
*   wkal = kal
*   wstop = stop
*   wtar = tar
*   wdat = dat
*   wotp = otp
*   wosn = osn
*   wpor = por
*   woddob = oddob
*   wraz = raz
*   wzakup = zakup
*   wzel = zel
 *
*   @ 5,5 SAY Space(60)
    @ 4,4 to 19,60
    @ 5,5 SAY "Datum knjizenja    " GET wdatk VALID ! Empty(wdatk)
    @ 7,5 SAY "Rb. iz knjige PK 1 " GET wrbpk1
    @ 8,5 SAY "Broj za knjizenje  " GET wbroj VALID ! Empty(wbroj)
    @ 9,5 SAY "Opis za knjizenje  "  GET wopis
    @ 10,5 SAY "Posebna taksa     " GET wtaks
    @ 11,5 SAY "Opsta KA.PI.CI    " GET wvisakpc PICTURE "999999999999.99"
    @ 12,5 SAY "Opsta ost.proizvo." GET wvisa PICTURE "999999999999.99"
    @ 12,40 GET wnula2 PICTURE "999999999.99"
    @ 12,53 SAY "28 %"
    @ 13,5 SAY "Niza stopa        " GET wniza PICTURE "999999999999.99"
    @ 13,40 GET wniza1 PICTURE "999999999.99"
    @ 13,53 SAY "2/20"
    @ 14,5 SAY "Oslobodjena poreza" GET wnula PICTURE "999999999999.99"
    @ 14,40 GET wnula06 PICTURE "999999999.99"
    @ 14,53 SAY "20 %"
    @ 15,5 SAY "Prod.vred.sa pp.  " GET wvrrobe PICTURE "999999999999.99"
    @ 15,40 GET wnula4 PICTURE "999999999.99"
    @ 15,53 SAY "12 %"
    @ 16,5 SAY "Vred.prodate robe " GET wpazar PICTURE "999999999999.99"
    @ 16,40 GET wnula3 PICTURE "999999999.99"
    @ 16,53 SAY "3  %"
    @ 17,5 SAY "Stanje zaliha     " GET wzalihe PICTURE "999999999999.99"
    @ 17,40 GET wnula1 PICTURE "999999999.99"
    @ 17,53 SAY "1  %"
    @ 18,5 SAY "Str/Kom.  0/1     " GET wsk VALID(wsk = 0 .or. wsk = 1)
    READ
    IF Lastkey() = 27
       indik = 1
       EXIT
    ENDIF
*   IF Lastkey() = 3
*      SKIP
*      IF Eof() .or. (! wkal = kal)
*        @ 19,1 SAY "Ovo je poslednja stavka !"
*        ? " "
*        SKIP -1
*        wait poruka
*        @ 19,1 SAY Space(79)
*        @ 21,0 SAY Space(80)
*        LOOP
*      ENDIF
*      LOOP
*    ENDIF
*    IF Lastkey() = 18
*      SKIP -1
*      IF bof() .or. (! wkal = kal)
*         @ 19,1 SAY "Ovo je prva stavka !"
*         ? " "
*         SKIP
*         wait poruka
*         @ 19,1 SAY Space(79)
*         @ 21,0 SAY Space(80)
*         LOOP
*      ENDIF
*      LOOP
*     ENDIF
      wvrrobe = round(wvisakpc+wvisa+wniza+wniza1+wnula2+wnula06+wnula+wnula4+wnula3+wnula1,2)
    @ 15,5 SAY "Prod.vred.sa pp.  "
    @ 15,24 SAY wvrrobe PICTURE "999999999999.99"

      dn = " "
      @ 21,10 SAY "Upis  (d/n) ? " GET dn PICTURE "!" VALID (dn $ "DN")
      READ
      IF Lastkey() = 27
         indik = 1
         EXIT
      ENDIF
      IF dn = "N"
         @ 21,0 SAY Space(80)
         LOOP
      ENDIF
      IF dn = "D"
         @ 21,0 SAY Space(80)
         append blank
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
         replace nula3 with wnula3
         replace nula4 with wnula4
         replace nula1 with wnula1
         replace vrrobe with wvrrobe
         replace pazar with wpazar
         replace zalihe with wzalihe
         replace sk with wsk
        @ 19,1 SAY "Stavka upisana !"
        ? " "
        wait poruka
        @ 19,0 SAY Space(80)
        @ 21,0 SAY Space(80)
      ENDIF
*   SKIP
*ENDDO
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
