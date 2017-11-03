* - nije pregledano - *
        set date german
        set message to 24 center
        set confirm on
        poruka = "pritisnite bilo sta za nastavak ..."
        IF file("tempor.dbf")
           erase tempor.dbf
           erase temptar.ntx
        ENDIF
        create radna
         store "ptar      c8  " to polje1
         store "pstop     n 62" to polje2
         store "pstv      n152" to polje3
         store "pnv       n152" to polje4
         store "praz      n152" to polje5
           for i = 1 to 5
            broj = str(i,1)
            p1 = "polje" + broj
            append blank
            replace field_name with substr(&p1,1,10)
            replace field_type with substr(&p1,11,1)
            replace field_len with val(substr(&p1,12,2))
            replace field_dec with val(substr(&p1,14,1))
           next i
        create tempor from radna
        index on ptar to temptar
        use
        erase radna
        *
        b = Space(10)
        bdar = Space(10)
        use dmpdat
        go bottom
        b = str(val(dmpbro) + 1)
        bdar = ltrim(b) + "           "
        bdar = substr(bdar,1,10)
        use
        *
        wkrrb = val("0000")
        use rashodn
        go bottom
        wkrrb = rrb + 1
        use
        *
        use tardat
        index on tarsif to tarin
        use
        select 1
        use dmpdat index dmpinbro,dmpinbs
        select 2
        use popdat index popindat
        select 3
        use artpane index apinsif
  *     use artdat index artinsif
        select 4
        use tempor index temptar
        select 5
        use tardat index tarin
*       select 5
*       use rashod index rashink,rashind
        DO WHILE .t.   && main
            datniv = ctod("  .  .  ")   && date()
            ind = val("0")
            perazez = val("00.00")
          * wkrrb = val("0000")
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
        *   b = Space(10)
            bb = val("0000000000")
        *   bdar = Space(10)
            select 1
   *        go bottom
   *        b = str(val(dmpbro) +  1)
   *        bdar = Space(10)
   *        bdar = ltrim(b) + "          "
   *        bdar = substr(bdar,1,10)
   *        go top
   *        select 3
   *        go bottom
   *        bb = rbr + 1
   *        go top
            ind = val("0")
            wbrrev = val("0000")
            wbrrev = bb
            pomoc = val("000000")
            brstavka = val("0000000000000")
            wdmpart = val("0000000000000")
            wdmpdat = date()
            wdug = date()
            wv1 = "KALKULAC.NIVELACIJE STR"
            wv2 = Space(15)
            wv3 = Space(30)
            wv4 = Space(6)
            wv5 = Space(10)
            wv6 = Space(12)
            CLEAR SCREEN
            select 1
            esckey()
            @ 1,27 SAY "KALKULACIJA NIVELACIJE"
            @ 2,0 SAY "broj kal."
            @ 2,10 GET bdar
            @ 2,21 SAY "dat kal"
            @ 2,29 GET wdmpdat
            @ 2,40 SAY "broj niv."
            @ 2,50 GET bb PICTURE "9999999999"
            @ 2,61 GET datniv
            READ
            IF Lastkey() = 27
               IND = 1
               EXIT
            ENDIF
            seek bdar
            IF Found()
            @ 20,10 SAY "KALKULACIJA POD TIM BROJEM VEC POSTOJI"
            wait " "
            LOOP
            ENDIF
            select 2
            kljuc = str(bb) + dtos(datniv)
            seek kljuc
            IF ! Found()
            @ 20,10 SAY "TAKAVA NIVELACIJA NE POSTOJI"
            wait " "
            LOOP
            ENDIF
    DO WHILE bb = popbroj .and. datniv = popdat
            store 0 to wssv,wsnv,wsraz
            wssv = popsc * popst
            wsnv = popnc * popst
            wsraz = wsnv - wssv
            wart = 0
            wtar = Space(8)
            wtar1 = Space(8)
            wtar2 = val("000")
            wart = popart
            select 3
            seek wart
            IF ! Found()
              @ 19,1 SAY "nema maticnih podataka o artiklu"
              ?? wart
              ? " "
              wait poruka
              select 2
              SKIP
              LOOP
             ENDIF
        *    wtar = rtrim(rtar) + "/" + substr(str(rstopa),1,3) + "        "
        *    wtar = substr(wtar,1,8)
        *     wsstop = rstopa
             wtar = arttar
             select 5
       *     use tardat index tarin
             seek wtar
             wsstop = tarzbir
             wvoz = tarost
       *     use
             select 4
             seek wtar
             IF ! Found()
                append blank
                replace ptar with wtar
                replace pstop with wsstop
                replace pstv with wssv
                replace pnv with wsnv
                replace praz with wsraz
             else
                replace pstv with (pstv + wssv)
                replace pnv with (pnv + wsnv)
                replace praz with (praz + wsraz)
             ENDIF
             select 2
             SKIP
    ENDDO
            close databases
            select 1
            use dmpdat index dmpinbro,dmpinbs
            select 2
            use popdat index popinart,popindat
            select 4
            use tempor index temptar
            select 5
          * use rashod index rashink,rashind
            use rashodn index rashinkn,rashindn
            wdmpfak = ltrim(str(bb))
         *   wdmpbk = ltrim(b)
            wdmpbk = bdar
         *  wdmpdat = date()
            wdmpdfak = datniv
            CLEAR SCREEN
            do esck
            @ 1,13 SAY "IZRADA  KALKULACIJE"
            select 4
            go top
          DO WHILE .t. &&   (2) u programu
            CLEAR SCREEN
            wdmpdob = val("000000")
            wtarzbir = val("000000.00")
            wnabc = 0
            wfcen = 0
            wdmpzjm = 0
            wrab = 0
            kpc = 0
            mtaksa = 0
            wirab = 0
            wdmprab = val("000.00")
            wdmprab = 0     && 10
*           wdmpart = VAL("0000000000000")
*           wdmpart = brstavka
            wdmpnaz = Space(30)
            wdmpjm = Space(3)
            wdmpkol = val("00000000000.000")
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
            wirab = val("000000000000.00")
            razlika = val("000000000000.000000")
            perazez = val("00.00")
            select 4
            IF Eof()
              ind = 1
              EXIT
            ENDIF
            IF praz = 0
               SKIP
               LOOP
            ENDIF
            wdmpnaz = "roba iz tar. broja " + ptar + "        "
            wdmpnaz = substr(wdmpnaz,1,30)
            wdmpkol = 1
            wdmpjm = "-  "
            wdmptar = ptar
            wtarzbir = pstop
            wdmpmsp = praz
          @ 3,1 SAY "Sifra artikla:"
          *set colo to /w
          @ 3,16 SAY wdmpart PICTURE "9999999999999"
          *set colo to
          @ 4,0 SAY Space(80)
          @ 3,35 SAY "naziv artikla" && GET wdmpnaz VALID !Empty(wdmpnaz)
          *set colo to /w
          @ 3,49 SAY wdmpnaz
          *set colo to
          @ 5,1 SAY "JM:" && GET wdmpjm VALID !Empty(wdmpjm)
          *set colo to /w
          @ 5,5 SAY wdmpjm
          *set colo to
          @ 5,10 SAY "Tarifa:" && GET wdmptar VALID !Empty(wdmptar)
          *set colo to /w
          @ 5,18 SAY wdmptar
          *set colo to
          @ 5,30 SAY "Stopa:" && GET wtarzbir sloboda za nulu VALID !Empty(wtarzbir)
          *set colo to /w
          @ 5,37 SAY wtarzbir
          *set colo to
          @ 5,51 SAY "Kolicina:" && GET wdmpkol PICTURE "99999999999.999" && VALID ! Empty(wdmpkol)
          *set colo to /w
          @ 5,61 SAY wdmpkol
          *set colo to
  *       READ
  *       IF Lastkey() = 27
  *          ind = 1
  *          EXIT
  *       ENDIF
  *       wdmpnvr = wdmpkol * wdmpnc
  *       *set colo to gr+
  *       @ 14,65 SAY wdmpnvr PICTURE "999999999999.99"
  *       *set colo to
  *       wpriv = wdmpnc
          @ 8,1 SAY "% Razlike u ceni " GET wdmprab PICTURE "999.99"
  *
          @ 21,1 SAY "MP cena sa por.:" GET wdmpmsp PICTURE "999999999999.99" VALID ! Empty(wdmpmsp)
          READ
          IF Lastkey() = 27
             ind = 1
             LOOP
          ENDIF
          @ 21,34 SAY "MP vrednost sa por.:"
          wdmpvsp = round(wdmpmsp * wdmpkol,2)
          @ 21,55 SAY wdmpvsp PICTURE "999999999999.99"
          perazez = round((wtarzbir * 100) / (wtarzbir + 100),2)
          wdmpmbp = round(wdmpmsp - (perazez / 100) * wdmpmsp,2)
          @ 19,1 SAY "MP cena bez por.:"
          @ 19,18 SAY wdmpmbp PICTURE "999999999999.99"
          wbezv = round(wdmpmbp * wdmpkol,2)
          @ 19,35 SAY "Vredn.bez poreza:"
          @ 19,53 SAY wbezv PICTURE "999999999999.99"
          razlika = round((wdmprab / 100) * wdmpmbp,6)
          wnabc = round(wdmpmbp - razlika,2)
          wdmpmap = (razlika * 100) / wnabc
          wdmpmai = round(razlika * wdmpkol,2)
          @ 17,1 SAY "Raz. u ceni(marza %)"
          @ 17,23 SAY wdmpmap PICTURE "999.99"
          @ 17,31 SAY "Raz.u ceni (vrednost):"
          @ 17,55 SAY wdmpmbp PICTURE "999999999999.99"      && wdmpmai
          @ 15,1 SAY "Nabavna cena:"
          wnabc = 0   && sva ostvarena razlika bez poreza ide u RUC
          @ 15,15 SAY wnabc PICTURE "999999999999.99"
          @ 15,31 SAY "Nabavna vrednost:"
          @ 15,50 SAY wnabc * wdmpkol PICTURE "999999999999.99"
          IF ! wdmpztp = 0
             prer = (100 * wdmpztp) / (wdmpztp + 100)
             wfcen = (1 - (prer / 100)) * wnabc
             wdmpzjm = wnabc - wfcen
             wdmpzti = wdmpzjm * wdmpkol
   *         @ 12,24 SAY "Z.tr. po (jm):"
   *         @ 12,38 SAY wdmpzjm PICTURE "999999999999.99"
          else
   *         @ 12,24 SAY "Z.tr po (jm):" GET wdmpzjm PICTURE "999999999999.99"
   *         READ
   *         IF Lastkey() = 27
   *           ind = 1
   *           LOOP
   *         ENDIF
             wdmpzti = wdmpzjm * wdmpkol
             wfcen = wnabc - wdmpzjm
           ENDIF
    *      @ 12,55 SAY "Z.tr.izn:"
    *      @ 12,65 SAY wdmpzti PICTURE "999999999999.99"
           @ 10,1 SAY "Fak.cena:"
           @ 10,11 SAY wfcen PICTURE "999999999999.99"
           @ 10,28 SAY "Fak.vrednost:"
           @ 10,43 SAY wfcen * wdmpkol PICTURE "999999999999.99"
          wdmpppd = (wtarzbir / 100) * (wdmpmsp - razlika)
          wdmpraz = (wtarzbir / 100) * razlika
          wdmpppk = wdmpppd + wdmpraz
          wdmpppd = 0
          wdmpraz = 0
          wdmpppk = 0
   *      wdmpppd = (wtarzbir / 100) * wfcen
   *      wdmpppk = wdmpmsp - wdmpmbp
   *      wdmpraz = wdmpppk - wdmpppd
*         DO WHILE .t.
          @ 24,10 SAY "Upis obracunatih vrednosti  (d/n) ? " GET dn PICTURE "!" VALID (dn $ "DN")
          READ
          IF Lastkey() = 27 .or. dn = "N"
             ind = 1
             LOOP
          ENDIF
*         IF ! dn = "D"
*            LOOP
*         ENDIF
*         indik4 = 0
*         EXIT
*         ENDDO
  *
*         IF ind = 1
*            ind = 0
*            LOOP
*         ENDIF
          select 1
          append blank
          replace dmpsif with wdmpart
          replace dmpnaz with wdmpnaz
          replace dmpjm with wdmpjm
          replace dmpkol with wdmpkol
          replace dmpnc with wfcen
          replace dmpppd with wdmpppd
          replace dmpztr with wdmpztp
          replace dmpziz with wdmpzti
          replace dmpmar with wdmpmap
          replace dmpmiz with wdmpmbp     && wdmpmai
          replace dmpmbp with wdmpmbp
          replace dmpppk with wdmpppk
          replace dmpraz with wdmpraz
          replace dmppor with wtarzbir
          replace dmptar with wdmptar
          replace dmpmsp  with wdmpmsp
          replace dmpvsp with wdmpvsp
          replace dmpbro with wdmpbk
          replace dmpdat with wdmpdat
         replace dmprab with wdmprab
         replace dmpdob with wdmpdob
         replace dmpirab with wirab
         replace dmpfak with wdmpfak
         replace dmpdfak with wdmpdfak
*        wdmpart = wdmpart + 1
        * do k
          do knov
********************************************************
* ubacen deo za rashod  ;  vrsi racunanje zbirova
         s1 = s1 + round(wdmpkol * wfcen * 0,2)
     *    s2 = s2 + round(wdmpmbp * wdmprab / 100 * wdmpkol,2)
         s2 = s2 + round(wdmpmbp * wdmpkol,2)
         s3 = s3 + round(((perazez / 100) * wdmpmsp) * wdmpkol,2)
         s4 = s4 + round(wdmpvsp,2)
         s5 = s1
**********************************************************
         select 4
         SKIP
         ENDDO && (2) u algoritmu
     *   IF ind = 0
     *      LOOP
     *   ENDIF
**************************************************
* upis u datoteku rashod
          select 5
          append blank
        * replace krrb with wkrrb
        * replace krdatk with wdmpdat
        * replace kropk with wv1
        * replace krbdok with wdmpbk
        * replace krbof with wdmpfak
        * replace krdof with datniv
        * replace krmt with wkrmt
        * replace krnt with wkrnt
        * replace krop with wkrop
        * replace krnvp with wkrnvp
        * replace krnvr with s1     && 0
        * replace krrc with s2
        * replace kropnp with s3
        * replace krpvr with s4
        * replace krrf with wkrrf
        * replace krvr with wkrvr
        * replace krur with s1      && 0
        * replace krhum with wkrhum
        * replace krizr with wkrizr
        * replace krizp with wkrizp
        * replace krink with wkrink
        *****************************
          replace rrb with wkrrb
          replace rdk with wdmpdat
          replace ropis with wv1
          replace rbr with wdmpbk
         *replace krbof with wdmpfak
          replace rdatdok with datniv
          replace rnvrrr with s1     && 0
          replace rrucp with s2
          replace robpor with s3
          replace rprodv with s4
          replace rrasuk with s1      && 0
*********************************************
*UPIS U TRGOVACKU KNJIGU
    *IF upisra = 1
         wkropk1 = Space(30)
         select 0
         use ppdat index ppinsif
         seek wdmpdob
         IF Found()
            wkropk1 = ppnaz
         else
            wkropk1 = " "
         ENDIF
         close ppdat
         SELECT 0
         wrb = val("0000")
         SELECT 0
         use trg index tinor,TRGKAL
         go bottom
         wrb = rb +1
         CLOSE TRG
         wopk = Space(55)
         wopk = substr((alltrim(str(wdmpdob,6))+" "+alltrim(wkropk1)+" "+alltrim(wdmpbk)+" "+alltrim(wdmpfak)),1,55)
         SELECT 0
         use trg index TRGKAL,tinor
         seek wkrbdok
         IF Found()
               replace zad with round(zad + s4,2)
         else
            append blank
            replace orgj with " "
            replace rb with WRB
            replace brkal with wdmpbk    && wkrbdok
            replace dk with wdmpdat   && wkrdatk
            replace opk with wopk   && opis knjizenja
            replace zad with s4
         ENDIF
         close trg
    *ENDIF
* kraj upisa u trgovacku
******************************************

            IF ind = 1
               EXIT
            end
        ENDDO   && *** main
        *set colo to
 *
        close databases
        *release al
        CLEAR SCREEN
        return

