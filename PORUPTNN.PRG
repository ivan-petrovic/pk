* - nije pregledano - *
*******     menja podatke u datoteci poreza ********

select 1
use porezn index poreznb   && inkal,inkt
set date german
set confirm on
poruka = "Otkucajte neku tipku za dalje..."
DO WHILE .t.
*
    wwsk = " "
    go top
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
    wdatod = ctod("  .  .  ")
    wdatdo = ctod("  .  .  ")
    stop = 0
    indik = 0
*
  * store Space(10) to wkal,wotp
  * store 0 to wosn,wpor,woddob,wraz,wzakup,wzel,wbzel
  * wdat = ctod("  .  .  ")
  * store Space(8) to wtar
    stop = 0
    indik = 0
*
  * @ 5,5 SAY "Kalkulacija:    " GET wkal VALID ! Empty(wkal)
  * READ
  * IF Lastkey() = 27
  *    EXIT
  * ENDIF
  * kljuc = val(wkal)
  * seek kljuc
  * IF ! Found()
  *    @ 19,1 SAY "Ne postoji takva kalkulacija u poreskoj evidenciji !"
  *    ? " "
  *    wait poruka
  *    LOOP
  * ENDIF
 *
 @ 5,10 SAY "STR ili KOMISION ili SVE" GET wwsk
 READ
 IF Lastkey() = 27
    close databases
    CLEAR SCREEN
    return
 ENDIF
 IF wwsk = "S" .or. wwsk = "s"
    set filter to sk = 0
    go top
 ENDIF
 IF wwsk = "K" .or. wwsk = "k"
    set filter to sk = 1
    go top
 ENDIF
 @ 10,10 SAY "OD DATUMA " GET wdatod
 @ 10,32 SAY "DO DATUMA " GET wdatdo VALID(wdatdo >= wdatod)
 READ
 IF Lastkey() = 27
    EXIT
 ENDIF
 @ 10,0 SAY repli(" ",78)
    DO WHILE ! Eof()
  *  @ 1,2 SAY "ESC  - izlaz   N - Naredna stavka  P - predhodna stavka"
       * wdatk = datk
       * wrbpk1 = rbpk1
       * wbroj = broj
       * wopis = opis
       IF datk >= wdatod .and. datk <= wdatdo
         wtaks = round(wtaks + taks,2)
         wvisakpc = round(wvisakpc + visakpc,2)
         wvisa = round(wvisa + visa,2)
         wniza = round(wniza + niza,2)
         wniza1 = round(wniza1 + niza1,2)
         wnula = round(wnula + nula,2)
         wnula06 = round(wnula06 + nula06,2)
         wnula2 = round(wnula2 + nula2,2)
         wnula3 = round(wnula3 + nula3,2)
         wnula4 = round(wnula4 + nula4,2)
         wnula1 = round(wnula1 + nula1,2)
         wvrrobe = round(wvrrobe + vrrobe,2)
         wpazar = round(wpazar + pazar,2)
        *wzalihe = round(wzalihe + zalihe,2)
         wzalihe = round(wvrrobe - wpazar,2)
         wsk = sk
       ENDIF
       SKIP
    ENDDO
 *
    @ 1,5 SAY gcNazRad
    @ 3,20 SAY "ZBIR KNJIGE POREZA OD"
    @ 3,43 SAY wdatod
    @ 3,53 SAY "DO"
    @ 3,56 SAY wdatdo
    @ 4,4 to 18,68
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
    @ 12,42 SAY wnula2 PICTURE "999999999999.99"
    @ 12,58 SAY "28 %"
    @ 13,5 SAY "Niza stopa        "
    @ 13,26 SAY wniza PICTURE "999999999999.99"
    @ 13,42 SAY wniza1 PICTURE "999999999999.99"
    @ 13,58 SAY "21 %"
    @ 14,5 SAY "Oslobodjena poreza"
    @ 14,26 SAY wnula PICTURE "999999999999.99"
    @ 14,42 SAY wnula06 PICTURE "999999999999.99"
    @ 14,58 SAY "20 %"
    @ 15,5 SAY "Prod.vred.sa pp.  "
    @ 15,26 SAY wvrrobe PICTURE "999999999999.99"
    @ 15,42 SAY wnula4 PICTURE "999999999999.99"
    @ 15,58 SAY "12 %"
    @ 16,5 SAY "Vred.prodate robe "
    @ 16,26 SAY wpazar PICTURE "999999999999.99"
    @ 16,42 SAY wnula3 PICTURE "999999999999.99"
    @ 16,58 SAY "3  %"
    @ 17,5 SAY "Stanje zaliha     "
    @ 17,26 SAY wzalihe PICTURE "999999999999.99"
    @ 17,42 SAY wnula1 PICTURE "999999999999.99"
    @ 17,58 SAY "1  %"
  * @ 18,5 SAY "Str/Kom.  0/1     "
 wait " "
ENDDO
*
set filter to
close databases
CLEAR SCREEN
return

