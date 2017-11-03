* - nije pregledano - *
        set date german
        set message to 24 center
        set confirm on
        public wdmpdob
        b = Space(10)
        select 1
        use dmpdat
        go bottom
        b = str(val(dmpbro) + 1)
        bdar = Space(10)
        bdar = ltrim(b) + "          "
        bdar = substr(bdar,1,10)
        index on dmpsif to dmpins
        use
        *
        wkrrb = val("0000")
        use rashodn
        go bottom
        wkrrb = rrb + 1
        use
        *
        select 1
        use dmpdat index dmpinbro,dmpinbs,dmpins
        select 2
        use artpane index apinsif
        select 5
        use tardat index tarinsif
    *   select 2
    *   use revers index revart,revbr
        select 3
        use prendos index prendosi,prenkali
*       select 5
*       use rashod index rashink,rashind
        DO WHILE .t.   && main
            indup = 0
            mtaksa = val("000000000000.00")
            kpc = 0
            perazez = val("00.00")
            wdmpdat = date()
          *  wkrrb = val("0000")
            wkrdatk = date()
            wkropk = Space(30)
            wkrbdok = Space(10)
            wkrbof = Space(10)
            wkrdof = date()
            wkdn = "N"
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
            select 3
            go bottom
            bb = prenbr + 1
            go top
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
            @ 1,13 SAY "PRENOS ROBE IZ STR_a U STR SA KALKULACIJOM CENA"
            @ 2,10 SAY "broj kalkulacije:"
            @ 2,28 GET bdar
            @ 2,40 SAY "broj prenosne dostavnice "
   *        @ 2,43 SAY bb
            @ 2,66 GET bb PICTURE "9999"
   *        @ 2,55 SAY "dalje   d/n " GET dn PICTURE "!" VALID(dn $ "dDnN")
            READ
   *        dn = upper(dn)
            IF Lastkey() = 27
            EXIT
            ENDIF
            seek bdar
            IF Found()
               @ 20,10 SAY "KALKULACIJA POD TIM BROJEM VEC POSTOJI. sledi nastavak"
               wait " "
              * LOOP
            ENDIF
            select 2
            @ 3,25 SAY "DATUM DOSTAVNICE" GET wdmpdat
            @ 3,55 SAY "UPIS U KNJIGE  D/N" GET wkdn PICTURE "!" VALID(wkdn $ "dDnN")
            READ
            IF Lastkey() = 27
               EXIT
            ENDIF
            wdmpdfak = date()
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
            razlika = val("000000000000.000000")
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
            perazez = val("00.00")
          @ 5,1 SAY "Sifra artikla:" GET wdmpart PICTURE "9999999999999"
          @ 5,35 SAY "Kolicina za prenos:" GET wdmpkol1 PICTURE "999999999999.999"
      **  @ 6,35 SAY "Nabavna cena        :" GET wnabc PICTURE "999999999999.99"
      **  @ 6,35 SAY "% razlike u ceni    :" GET wpruc PICTURE "99.99999"
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
             @ 20,10 SAY repli(" ",68)
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
                @ 20,1 SAY " NEMA TARIFE ZA TAJ ARTIKAL.BRISITE DOSTAVNICU,OTVORITE TARIFU,PA PONOVO!"
                wait " "
                @ 20,1 SAY repli(" ",78)
                close databases
                *release al
                CLEAR SCREEN
                return
             ENDIF
          ****************************************
          * ubaceno da ide po nabavnu vrednost
          select 1
          set order to 3
          seek wdmpart
          IF Found()
             DO WHILE wdmpart = dmpsif
                wdmpnc = dmpnc
                SKIP
             ENDDO
             set order to 1
          else
             @ 20,1 SAY " NEMA ARTIKLA U NABAVCI.BRISITE DOSTAVNICU,REGULISITE PROBLEM,PA PONOVO!"
             wait " "
             @ 20,1 SAY repli(" ",78)
             close databases
             CLEAR SCREEN
             return
          ENDIF
          * kraj ubacenog za nabavnu vrednost
          ****************************************
          @ 4,0 SAY Space(80)
          @ 7,1 SAY wdmpnaz
            wdmpmsp = gnBod * B->artcen
          @ 21,1 SAY "MP cena sa por.:"  &&  GET wdmpmsp PICTURE "999999999999.99" VALID ! Empty(wdmpmsp)
          @ 21,18 SAY wdmpmsp PICTURE "999999999999.99"
          @ 21,34 SAY "MP vrednost sa por.:"
          wdmpvsp = round(wdmpmsp * wdmpkol1,2)
          @ 21,55 SAY wdmpvsp PICTURE "999999999999.99"
          perazez = round((wtarzbir * 100) / (wtarzbir + 100),2)
          wdmpmbp = round(wdmpmsp - (perazez / 100) * wdmpmsp,2)
          @ 19,1 SAY "MP cena bez por.:"
          @ 19,18 SAY wdmpmbp PICTURE "999999999999.99"
          wbezv = round(wdmpmbp * wdmpkol1,2)
          @ 19,35 SAY "Vredn.bez poreza:"
          @ 19,53 SAY wbezv PICTURE "999999999999.99"
         * razlika = round(wpruc / 100 * wdmpmbp,6) && BLOK RUC %
          razlika = round(wdmpmbp - wdmpnc,2) && sa nab.cen iz dmpdat
         * wnabc = round(wdmpmbp - razlika,2)
          wnabc = wdmpnc && sa nab.cen. iz dmpdat
          wdmpmap = (razlika * 100) / wnabc
      *   wdmpmai = round((wdmpmbp - wnabc) * wdmpkol1,2)
          wdmpmai = round(razlika * wdmpkol1,2)
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
          wdmpppd = (wtarzbir / 100) * (wdmpmsp - razlika)
          wdmpraz = (wtarzbir / 100) * razlika
          wdmpppk = wdmpppd + wdmpraz
   *      wdmpppd = (wtarzbir / 100) * wfcen
   *      wdmpppk = wdmpmsp - wdmpmbp
   *      wdmpraz = wdmpppk - wdmpppd
          wdmpppd = 0
          wdmpppk = 0
          wdmpraz = 0
          wdmpbk = bdar  && da knige puni dostavnica a ne kalkulacija
         *  wdmpbk = bb    && da knige puni dostavnica a ne kalkulacija
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
         *
         IF indup = 0
            indup = 1
            select 3
            append blank
            replace prenbr with bb
            replace prenkal with bdar
         ENDIF
        *
*        wdmpart = wdmpart + 1
        *do kminu   && do 01.01.96.
        IF wkdn = "D"
          do knovmin   &&  blok za sve ostale osim za Veru
        ENDIF
         wdmpart = wdmpart + 1
**********************************************************
* ubacen deo za rashod  ;  vrsi racunanje zbirova
         s1 = s1 + round(wdmpkol1 * wfcen,2)
      *   s2 = s2 + round(wdmpmbp * wpruc / 100 * wdmpkol1,2)
         s2 = s2 + round(razlika * wdmpkol1,2)
         s3 = s3 + round(wdmpmsp * wdmpkol1 * perazez / 100,2)
         s4 = s4 + wdmpvsp
         s5 = s1
**********************************************************
         kaaa1()
         select 1
         ENDDO && (2) u algoritmu
         IF ind = 0
            LOOP
         ENDIF
**************************************************
* upis u datoteku rashod
     *    select 5
       IF wkdn = "D"
        * use rashod index rashink,rashind
          use rashodn index rashinkn,rashindn
         seek bdar
         IF Found()
            IF rdk = wdmpdat    &&  wkrdatk
               replace rnvrrr with round(rnvrrr + s1 * (-1),2)
               replace rrucp with round(rrucp + s2 * (-1),2)   &&  izbaceno - s6
               replace robpor with round(robpor + s3 * (-1),2)
               replace rprodv with round(rprodv + s4 * (-1),2)
             *  replace rmin with round(rmin + s6,2)
                replace rrasuk with round(rrasuk + s1 * (-1),2)
              *replace rrasuk with round(rrasuk + s5,2)
            ENDIF
         else
            append blank
            replace rrb with wkrrb
            replace rdk with wdmpdat   && wkrdatk
            replace ropis with "INTERNA DOSTAVNICA Str_a"
            replace rbr with bdar
          * replace krbof with wkrbof
            replace rdatdok with wdmpdat
          replace rdatdok with wdmpdat
          replace rnvrrr with (s1 * (-1))
          replace rrucp with (s2 * (-1))
          replace robpor with (s3 * (-1))
          replace rprodv with (s4 * (-1))
          replace rrasuk with (s1 * (-1))
          replace rsk with 0
            use
         ENDIF
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
function kaaa1
for i = 7 to 24
@ i,0 SAY repli(" ",78)
next i
return
