* - nije pregledano - *
        set date german
        set message to 24 center
        set confirm on
        public wdmpdob
        b = Space(10)
        use dmpdat
        go bottom
        b = str(val(dmpbro) + 1)
        bdar = Space(10)
        bdar = ltrim(b) + "          "
        bdar = substr(bdar,1,10)
        use
        *
        WKRRB = VAL("0000")
        USE RASHODN
        GO bottom
        wkrrb = rrb + 1
        use
        *
        select 1
        use dmpdat index dmpinbro,dmpinbs
        select 2
        use artpane index apinsif
        select 5
        use tardat index tarinsif
    *   select 2
    *   use revers index revart,revbr
    *   select 3
    *   use revpovr index revpobr,revpoart
*       select 5
*       use rashod index rashink,rashind
        DO WHILE .t.   && main
            inddd = 0
            perazez = val("00.00")
            wdmpdat = date()
          *  wkrrb = val("0000")
            wkrdatk = date()
            wkropk = Space(30)
            wkrbdok = Space(10)
            wkrbof = Space(10)
            wkrdof = date()
            wkrmt = val("00000000000000.00")
            wkrnt = val("00000000000000.00")
            wkrop = val("00000000000000.00")
            wkrnvp = val("00000000000000.00")
            wkrnvr = val("00000000000000.00")
            wkrrc = val("00000000000000.00")
            wkropnp = val("00000000000000.00")
            wkrpvr = val("00000000000000.00")
            wkrrf = val("00000000000000.00")
            wkrvr = val("00000000000000.00")
            wkrur = val("00000000000000.00")
            wkrhum = val("00000000000000.00")
            wkrizr = val("00000000000000.00")
            wkrizp = val("00000000000000.00")
            wkrink = val("00000000000000.00")
            s1 = val("00000000000000.00")
            s2 = val("00000000000000.00")
            s3 = val("00000000000000.00")
            s4 = val("00000000000000.00")
            s5 = val("00000000000000.00")
            dn = " "
     *      b = Space(10)
            bb = val("9999")
     *      select 1
     *      go bottom
     *      b = str(val(dmpbro) +  1)
     *      bdar = Space(10)
     *      bdar = ltrim(b) + "          "
     *      bdar = substr(bdar,1,10)
     *      go top
     *      select 3
     *      go bottom
     *      bb = rpbr + 1
     *      go top
     *      ind = val("0")
            wbrrev = val("0000")
            wbrrev = bb
            pomoc = val("000000")
            brstavka = val("0000000000000")
            wdmpart = val("0000000000000")
            wdug = date()
            wv1 = Space(30)
            wv2 = Space(15)
            wv3 = Space(30)
            wv4 = Space(6)
            wv5 = Space(10)
            wv6 = Space(12)
            CLEAR SCREEN
            select 1
            esckey()
            @ 1,13 SAY "POVRACAJ ROBE DOBAVLJACU  SA KALKULACIJOM CENA"
            @ 2,10 SAY "broj kalkulacije:"
            @ 2,28 GET bdar
   *        @ 2,40 SAY "broj reversa"
   *        @ 2,43 SAY bb
   *        @ 2,53 GET bb PICTURE "9999"
   *        @ 2,55 SAY "dalje   d/n " GET dn PICTURE "!" VALID(dn $ "dDnN")
            READ
   *        dn = upper(dn)
            IF Lastkey() = 27
            EXIT
            ENDIF
            seek bdar
            IF Found()
            @ 20,10 SAY "KALKULACIJA POD TIM BROJEM VEC POSTOJI"
            wait " "
            LOOP
            ENDIF
            select 2
            @ 2,40 SAY "DATUM KALKULACIJE" GET wdmpdat
            READ
            IF Lastkey() = 27
               EXIT
            ENDIF
            wdmpdfak = date()
            wdmpbk = bdar
            do helpp
       *    CLEAR SCREEN
       *     do esck
      *     @ 1,10 SAY "IZRADA UGOVORA,REVERSA I KOMISIONE KALKULACIJE ZA POVRACAJ ROBE"
          DO WHILE .t. &&   (2) u programu
        *   CLEAR SCREEN
        *   do esck
        *   @ 3,10 SAY "POVRACAJ ROBE DOBAVLJACU SA KALKULACIJOM CENA "
      *     wdmpdob = val("000000")
            wtarzbir = val("000000.00")
            wpruc = val("00.00000")
            wnabc = 0
            kpc = 0
            mtaksa = 0
            wfcen = 0
            wdmpzjm = 0
            wrab = 0
            wirab = 0
            wdmprab = val("000.00")
       *    wdmprab = 10
            wdmpart = VAL("0000000000000")
*           wdmpart = brstavka
            wdmpnaz = Space(30)
            wdmpjm = Space(3)
            wdmpkol = val("00000000000.000")
            wdmpkol1 = val("00000000000.000")
            wpriv = val("000000000000.00")
            wdmpnc = val("000000000000.00")
            wdmpppd = val("000000000000.00")
            wdmpztp = val("000.00")
            wdmpzti = val("000000000000.00")
            wizn = val("000000000000.00")
            wdmpmap = val("000.00")
            wdmpmai = val("000000000000.00")
            dn = " "
            wdmpmbp = val("000000000000.00")
            wdmpppk = val("000000000000.00")
            wdmpraz = val("000000000000.00")
            wdmppor = val("000.00")
            wdmptar = Space(8)
            wdmpmsp = val("000000000000.00")
            wdmpvsp = val("000000000000.00")
            wpriv = val("000000000000.00")
            wfcen = val("000000000000.00")
            wnabc = val("000000000000.00")
            wirab = val("000000000000.00")
            perazez = val("00.000000")
            rezlika = val("000000000000.000000")
          @ 5,1 SAY "Sifra artikla:" GET wdmpart PICTURE "9999999999999"
          @ 5,35 SAY "kolicina za povracaj:" GET wdmpkol1 PICTURE "999999999999.999"
          @ 6,35 SAY "nabavna cena        :" GET wnabc PICTURE "999999999999.99"
       *  @ 6,35 SAY "% razlike u ceni    :" GET wpruc PICTURE "99.99999"
          READ
*         IF wdmpart = 0
*            LOOP
*         ENDIF
          IF Lastkey() = 27
             ind = 1
             EXIT
          ENDIF
          select 2
          seek wdmpart
          IF ! Found()
          @ 20,10 SAY "NEMA ARTIKLA SA TOM SIFROM"
          wait " "
          @ 20,10 SAY REPLI(" ",68)
          LOOP
          ENDIF
          IF wdmpkol1 > artkol
          @ 20,10 SAY "NA LAGERU IMATE"
          @ 20,26 SAY artkol PICTURE "999,999.999"
          wait " "
          @ 20,10 SAY repli(" ",68)
          LOOP
          ENDIF
*         replace rkol with (rkol - wdmpkol1)
*         replace rvra with (rvra + wdmpkol1)
          wdmpnaz = artnaz
          wdmpjm = artjm
          wdmptar = arttar
          select 5
          seek wdmptar
             IF Found()
                wtarzbir = tarsst + tarrst + tarost + tarvoj
                wvoz = tarost
             else
                @ 20,1 SAY " NEMA TARIFE ZA TAJ ARTIKAL.BRISITE KALKULACIJU,OTVORITE TARIFU,PA PONOVO!"
                wait " "
                @ 20,1 SAY repli(" ",78)
                close databases
                *release al
                CLEAR SCREEN
                return
             ENDIF
          @ 4,0 SAY Space(80)
          @ 7,1 SAY wdmpnaz
            wdmpmsp = gnBod * B->artcen
          @ 21,1 SAY "MP cena sa por.:"  &&  GET wdmpmsp PICTURE "999999999999.99" VALID ! Empty(wdmpmsp)
          @ 21,18 SAY wdmpmsp PICTURE "999999999999.99"
          @ 21,34 SAY "MP vrednost sa por.:"
          wdmpvsp = round(wdmpmsp * wdmpkol1,2)
          @ 21,55 SAY wdmpvsp PICTURE "999999999999.99"
          perazez = round((wtarzbir * 100) / (wtarzbir + 100),4)
          wdmpmbp = round(wdmpmsp - (perazez / 100) * wdmpmsp,2)
          @ 19,1 SAY "MP cena bez por.:"
          @ 19,18 SAY wdmpmbp PICTURE "999999999999.99"
          wbezv = round(wdmpmbp * wdmpkol1,2)
          @ 19,35 SAY "Vredn.bez poreza:"
          @ 19,53 SAY wbezv PICTURE "999999999999.99"
         * razlika = round((wpruc / 100) * wdmpmbp,6)
         * wnabc = round(wdmpmbp - razlika,2)
         * wdmpmap = round((razlika * 100) / wnabc,2)
          wdmpmai = round((wdmpmbp - wnabc) * wdmpkol1,2)
      *   wdmpmai = razlika * wdmpkol1
          @ 17,1 SAY "Raz. u ceni(marza %)"
          @ 17,23 SAY wdmpmap PICTURE "999.99"
          @ 17,31 SAY "Raz.u ceni (vrednost):"
          @ 17,55 SAY wdmpmai PICTURE "999999999999.99"
          @ 15,1 SAY "Nabavna cena:"
          @ 15,15 SAY wnabc PICTURE "999999999999.99"
          @ 15,31 SAY "Nabavna vrednost:"
          @ 15,50 SAY round(wnabc * wdmpkol1,2) PICTURE "999999999999.99"
          IF ! wdmpztp = 0
             prer = (100 * wdmpztp) / (wdmpztp + 100)
             wfcen = (1 - (prer / 100)) * wnabc
             wdmpzjm = wnabc - wfcen
             wdmpzti = wdmpzjm * wdmpkol1
   *         @ 12,24 SAY "Z.tr. po (jm):"
   *         @ 12,38 SAY wdmpzjm PICTURE "999999999999.99"
          else
   *         @ 12,24 SAY "Z.tr po (jm):" GET wdmpzjm PICTURE "999999999999.99"
   *         READ
             IF Lastkey() = 27
               ind = 1
               LOOP
             ENDIF
             wdmpzti = wdmpzjm * wdmpkol1
             wfcen = wnabc - wdmpzjm
           ENDIF
    *      @ 12,55 SAY "Z.tr.izn:"
    *      @ 12,65 SAY wdmpzti PICTURE "999999999999.99"
           @ 10,1 SAY "Fak.cena:"
           @ 10,11 SAY wfcen PICTURE "999999999999.99"
           @ 10,28 SAY "Fak.vrednost:"
           @ 10,43 SAY wfcen * wdmpkol1 PICTURE "999999999999.99"
         * wdmpppd = (wtarzbir / 100) * (wdmpmsp - razlika)
         * wdmpraz = (wtarzbir / 100) * razlika
         * wdmpppk = wdmpppd + wdmpraz
   *      wdmpppd = (wtarzbir / 100) * wfcen
   *      wdmpppk = wdmpmsp - wdmpmbp
   *      wdmpraz = wdmpppk - wdmpppd
          wdmpppd = 0
          wdmpppk = 0
          wdmpraz = 0
*         DO WHILE .t.
          @ 24,10 SAY "Upis obracunatih vrednosti  (d/n) ? " GET dn PICTURE "!" VALID (dn $ "DN")
          READ
          IF Lastkey() = 27 .or. dn = "N"
             ind = 1
             for i = 4 to 24
             @ i,0 SAY repli(" ",78)
             next i
             LOOP
          ENDIF
          inddd = 1
          select 2
          replace artkol with (artkol - wdmpkol1)
          select 1
          append blank
          replace dmpsif with wdmpart
          replace dmpnaz with wdmpnaz
          replace dmpjm with wdmpjm
          replace dmpkol with wdmpkol1
          replace dmpnc with wfcen
          replace dmpppd with wdmpppd
          replace dmpztr with wdmpztp
          replace dmpziz with wdmpzti
          replace dmpmar with wdmpmap
          replace dmpmiz with wdmpmai
        * replace dmpmiz with round((wdmpmsp * wdmpkol1,2) - (round(wdmpmsp * wdmpkol1 * perazez  / 100,2) + round(wdmpkol1 * wfcen,2)),2)  && wdmpmai
          replace dmpmbp with wdmpmbp
          replace dmpppk with wdmpppk
          replace dmpraz with wdmpraz
          replace dmppor with wtarzbir
          replace dmptar with wdmptar
          replace dmpmsp  with wdmpmsp
          replace dmpvsp with wdmpvsp
          replace dmpbro with bdar
          replace dmpdat with wdmpdat
         replace dmprab with wdmprab
         replace dmpdob with wdmpdob
         replace dmpirab with wirab
         replace dmpfak with str(0)  && wdmpfak
         replace dmpdfak with wdmpdat && wdmpdfak
*        wdmpart = wdmpart + 1
        *do kminu   && do 01.01.96.
         do knovmin
         wdmpart = wdmpart + 1
**********************************************************
* ubacen deo za rashod  ;  vrsi racunanje zbirova
         s1 = s1 + round(wdmpkol1 * wfcen,2)
         s2 = s2 + round((wdmpmbp - wfcen) * wdmpkol1,2)
       * s2 = s2 + round((wdmpmsp * wdmpkol1,2) - (round(wdmpmsp * wdmpkol1 * perazez  / 100,2) + round(wdmpkol1 * wfcen,2)),2)
         s3 = s3 + round(wdmpmsp * wdmpkol1 * perazez / 100,2)
         s4 = s4 + wdmpvsp
         s5 = s1
**********************************************************
         krpaa1()
         select 1
         ENDDO && (2) u algoritmu
         IF ind = 0
            LOOP
         ENDIF
**************************************************
* upis u datoteku rashod
*         select 5
       IF inddd = 1
        * use rashod index rashink,rashind
          use rashodn index rashinkn,rashindn
          append blank
          replace rrb with wkrrb
          replace rdk with wdmpdat
          replace ropis with "KALKULACIJA POVRACAJA"
          replace rbr with bdar
        * replace krbof with str(0)   && wdmpfak
          replace rdatdok with wdmpdat
          replace rnvrrr with (s1 * (-1))
          replace rrucp with (s2 * (-1))
          replace robpor with (s3 * (-1))
          replace rprodv with (s4 * (-1))
          replace rrasuk with (s5 * (-1))
          use
     ENDIF
**************************************************
*           LOOP
*        ENDIF
         EXIT
        ENDDO   && *** main
        *set colo to
 *
        close databases
        *release al
        CLEAR SCREEN
        return
*
function krPpaa1
for i = 7 to 24
@ i,0 SAY repli(" ",78)
next i
return(" ")
