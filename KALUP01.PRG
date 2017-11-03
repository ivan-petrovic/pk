* - nije pregledano - *
      IF file("temp.dbf")
         erase temp.dbf
      ENDIF
      IF file("tempintar.ntx")
        erase tempintar.ntx
      ENDIF
      create radna
      store "temptar   c8  " to polje1
      store "tempmpv   n152" to polje2
      for i = 1 to 2
      broj = str(i,1)
      p1 = "polje" + broj
      append blank
      replace field_name with substr(&p1,1,10)
      replace field_type with substr(&p1,11,1)
      replace field_len with val(substr(&p1,12,2))
      replace field_dec with val(substr(&p1,14,1))
      next i
      create temp from radna
      index on temptar to tempintar
      erase radna.dbf
      use
*
*
      set date german
      set confirm on
      por = "Otkucajte neku tipku za dalje..."
      select 9
      use temp index tempintar
      select 4
      use tardat index tarinsif
      go top
      DO WHILE ! Eof()
        replace tardp with 0
        replace tarkp with 0
        replace tarpor with 0
        SKIP
      ENDDO
      select 2
      use ppdat index ppinsif
      select 1
      use dmpdat index dmpinbro,dmpinbs
      DO WHILE .t.
          select 1
          store 0 to indik,indik1,indik2
          CLEAR SCREEN
          do esck
          @ 1,30 SAY "STAMPA KALKULACIJE"
          wdmpbro = Space(10)
          xxx = 0
          yyy = 0
          wnv = val("000000000000.00")
          wporpaus = val("000000000000.00")
          store wnv to wakciza,wtaksa
          wvrb = val("000000000000.00")
          rb = 0
          wdarko = 0
          wr = 0
          wrab = 0
          wmarza = val("000000000000.00")
          wzt = val("000000000000.00")
          wvr = val("000000000000.00")
          wmpv = 0
          rpd = 0
          rpk = 0
          ruk = 0
          puk = 0
          wruc = val("000000000000.00")
          wwruc = val("000000000000.00")
          @ 3,1 SAY "Kalkulacija:" GET wdmpbro PICTURE "@!" VALID ! Empty(wdmpbro)
          READ
          IF Lastkey() = 27
             EXIT
          ENDIF
          seek wdmpbro
          IF ! Found()
             @ 19,1 SAY "Ne postoji takva kalkulacija!"
             ? " "
             wait por
             LOOP
          ENDIF
          wdmpdat = dmpdat
          wdmpfak = dmpfak
          wdmpdfak = dmpdfak
          wpp = dmpdob
          @ 3,40 SAY "Datum:"
          ?? wdmpdat
          @ 3,60 SAY "Posl.partner"
          select 2
          seek wpp
          IF ! Found()
             wnaz = Space(30)
          else
             wnaz = ppnaz
          ENDIF
          select 1
          red = 7
          bst = 0
          set device to printer
         set printer to lista.dat
          set printer on
         IF lLaser
            ? Chr(27) + '(s17.5H'      && kondenz On za laserski
         ELSE
            ? Chr(15)                  && kondenz On za matricni
         ENDIF
          setprc(0,0)
          **********************************
          * odluka koja je kalkulacija
            IF ! Empty(vrsta)
               set proc to ccigb
               do ccigb
               return
            ENDIF
          **********************************
          DO WHILE (dmpbro = wdmpbro)
               wruc = 0
               zez = 0
               wp1 = 0
               wp2 = 0
               wp3 = 0
               wp11 = 0
               wp22 = 0
               wp33 = 0
               wzel = 0
               wrep = 0
               wsav3 = 0
               wvoj = 0
               perazez = val("000.00")
            *  do case
            *     case dmppor = 26
            *          perazez = round((dmppor * 100) / (dmppor + 100),2)
            *          perazez = perazez + 0.01
            *     case dmppor = 9
            *          perazez = round((dmppor * 100) / (dmppor + 100),2)
            *          perazez = perazez - 0.01
            *     case dmppor = 0
            *          perazez = round((dmppor * 100) / (dmppor + 100),2)
            *  endcase
               perazez = round((dmppor * 100) / (dmppor + 100),2)
               store 0 to xzel,xrep,xsav3,xvoj,x01,x02,x03,x04
               store 0 to wpom1,wpom2,wpom3,wpom4,wpom5,wpom6,wp01,wp02,wp03,wp04
               IF red = 7
                  set proc to ncaslovb
                  do ncaslovb
               ENDIF
               wnv = wnv + (dmpnc * dmpkol)       && fakturna vrednost
               ww = ((dmpmbp * 100) / dmpnc) - 100
*              ww = (dmpnc / dmpmbp) * 100
               wr = dmpirab
               wrab = wrab + wr
               wporpaus = wporpaus + akciza
               wmarza = wmarza + dmpmiz     && ovo je razlika u ceni po starom
               wzt = wzt + dmpziz
               wvr = wvr + dmpvsp   && prodajna vrednost robe
               wvrb = wvrb + (dmpmbp * dmpkol)
               wp1 = dmpppd    && preneti porez dobavljac
               wp2 = dmpppk    && preneti porez kupcu
               wp3 = dmppor    && poreska stopa za tu robu
               wpx = wp1 * dmpkol  && preneti porez dobavljac ukupno
               wpy = wp2 * dmpkol  && preneti porez kupcu ukupno
               wtar = dmptar
               wpor = round(dmpmsp * dmpkol * perazez / 100,2)
       *       wpor = round((dmpmsp - dmpmbp) * dmpkol,2)
       *       wpor = ((dmppor / 100) * dmpmbp) * dmpkol
               wruc = round(round(dmpmsp * dmpkol,2) - (round(wpor + dmpziz + round(dmpnc * dmpkol,2),2)),2)
               wwruc = round(wwruc + wruc,2)
               select 4
               seek wtar
               IF Found()
                    zez = tarzbir
                    IF tarzbir = 0
                        zez = 1
                    ENDIF
                    wp01 = tarrst/zez
                    wp02 = tarost/zez
                    wp03 = tarsst/zez
                    wp04 = tarvoj/zez
                    wp11 = tardp    &&
                    wp22 = tarkp    &&  vec oformljeni zbirovi u tardat
                    wp33 = tarpor   &&
                    wp11 = wp11 + wpx
                    wp22 = wp22 + wpy
                    IF wp1 = 0 .and. wp2 = 0
                      wp33 = wp33 + wpor
                    ENDIF
                    replace tardp with wp11
                    replace tarkp with wp22
                    replace tarpor with wp33
                ENDIF
                select 9
                seek wtar
                IF ! Found()
                   append blank
                   replace temptar with wtar
                   wmpv = 0
                else
                   wmpv = tempmpv
                ENDIF
                 wmpv = wmpv + A->dmpmsp * A->dmpkol
                 replace tempmpv with wmpv
                 wmpv = 0
                select 1
                IF red > 58
                  red = 1
                  @ red,0 SAY " "
                  set procedure to naslovb
                  do naslovb
                ENDIF
                red = red + 1
                rb = rb + 1
    *           @ red,1 SAY rb PICTURE "999"
                @ red,5 SAY dmpnaz
                @ red,36 SAY dmpjm
                @ red,44 SAY round(dmpnc,2) PICTURE "999,999,999,999.99"
                @ red,68 SAY round(dmpmbp * dmpkol,2) PICTURE "999,999,999,999.99"
                @ red,98 SAY dmptar
                @ red,117 SAY dmpmsp PICTURE "999,999,999,999.99"
                red = red + 1
                @ red,5 SAY dmpsif PICTURE "9999999999999"
                @ red,36 SAY dmpkol PICTURE "99999.999"
                @ red,46 SAY round(dmpnc * dmpkol,2) PICTURE "9,999,999,999.99"
                @ red,68 SAY round(wruc,2) PICTURE "999,999,999,999.99"
              * @ red,68 SAY round(dmpmiz,2) PICTURE "999,999,999,999.99"
              * @ red,68 SAY round((dmpmbp - dmpnc) * dmpkol,2) PICTURE "999,999,999,999.99"
              * @ red,92 SAY round((dmpmsp - dmpmbp) * dmpkol,2) PICTURE "999,999,999,999.99"
                @ red,92 SAY round(dmpmsp * dmpkol * perazez / 100,2) PICTURE "999,999,999,999.99"
                @ red,117 SAY round(dmpmsp * dmpkol,2) PICTURE "999,999,999,999.99"
                IF ! (dmpppd = 0 .and. dmpppk = 0)
                   red = red + 1
                   @ red,50 SAY "PRENETI POREZ PO ("
                   @ red,69 SAY dmpjm
                   @ red,72 SAY ")"
                   @ red+1,10 SAY "OD DOBAVLJACA"
                   @ red+1,49 SAY "OBRACUNATI POREZ"
                   @ red+1,79 SAY "ZA UPLATU"
                   red = red + 2
                   @ red,4 SAY round(dmpppd,2) PICTURE "999,999,999,999.99"
                   @ red,38 SAY round(dmpppk,2) PICTURE "999,999,999,999.99"
                   @ red,67 SAY round((dmpppk - dmpppd),2) PICTURE "999,999,999,999.99"
                ENDIF
                red = red + 1
                @ red,5 SAY Replicate("-",131)
                SKIP
          ENDDO
          IF red > 55
             bst = bst + 1
             red = 1
             @ red,0 SAY " "
             @ red,130 SAY "str."
             @ red,134 SAY bst PICTURE "999"
           ENDIF
           red = red + 3
           @ red,60 SAY "UKUPNO ZA KALKULACIJU"
           red = red + 1
           @ red,4 SAY "FAKTURNA VREDNOST"
           @ red,24 SAY "ZAVISNI TROSKOVI"
           @ red,53 SAY "RAZLIKA U CENI"
           @ red,75  SAY "MP VREDNOST BEZ POREZA"
           @ red,115 SAY "MP VREDNOST SA POREZOM"
           red = red + 1
           @ red,1 SAY round(wnv,2) PICTURE "999,999,999,999.99"
           @ red,25 SAY round(wzt,2) PICTURE "999,999,999,999.99"
         * @ red,49 SAY round(wmarza,2) PICTURE "999,999,999,999.99"
           @ red,49 SAY round(wwruc - wporpaus,2) PICTURE "999,999,999,999.99"
           @ red,75 SAY round(wvrb,2) PICTURE "999,999,999,999.99"
           @ red,115 SAY round(wvr,2) PICTURE "999,999,999,999.99"
          IF red > 55
              red = 1
              @ red,0 SAY " "
              bst = bst + 1
              @ red,130 SAY "str."
              @ red,134 SAY bst PICTURE "999"
          ENDIF
          * POCINJE STAMPA PORESKE REKAPITULACIJE ( PRENETOG POREZA)
          select 4
          go top
          DO WHILE ! Eof()
                     zez = 0
             IF ! (tardp = 0 .and. tarkp = 0)
                IF indik = 0
                   indik = 1
                   red = red + 3
                   @ red,50 SAY "REKAPITULACIJA PRENETOG POREZA"
                   red = red + 1
                   @ red,1 SAY "TARIFA"
                   @ red,15 SAY "OD DOBAVLJACA"
                   @ red,35 SAY "OBRACUNATI POREZ"
                   @ red,55 SAY "RAZLIKA ZA UPLATU"
                   @ red,75 SAY "REPUBLICKI"
                   @ red,95 SAY "DEO ZA ZELEZN."
                   @ red,115 SAY "MP VRED.PO TARIFI"
                ENDIF
                red = red + 1
                @ red,1 SAY tarsif
                @ red,15 SAY round(tardp,2) PICTURE "999,999,999,999.99"
                wdarko = wdarko + tardp
                wdijana = tarsif
                select 9
                seek wdijana
                IF ! Found()
                  wmpv = 0
                else
                  wmpv = tempmpv
                ENDIF
                select 4
                @ red,35 SAY round(tarkp,2) PICTURE "999,999,999,999.99"
                @ red,55 SAY round((tarkp - tardp),2) PICTURE "999,999,999,999.99"
                wpom1 = tarkp - tardp
                zez = tarzbir
                IF tarzbir = 0
                    zez = 1
                ENDIF
                wp01 = tarrst / zez
                wp02 = tarost / zez
                wpom2 = wpom1 * wp01
                wpom3 = wpom1 * wp02
                @ red,75 SAY round(wpom2,2) PICTURE "999,999,999,999.99"
                @ red,95 SAY round(wpom3,2) PICTURE "999,999,999,999.99"
                @ red,115 SAY round(wmpv,2) PICTURE "999,999,999,999.99"
                wrep = wrep + wpom2
                wzel = wzel + wpom3
                rpd = rpd + tardp
                rpk = rpk + tarkp
                IF red > 58
                   red = 1
                   bst = bst + 1
                   @ red,0 SAY " "
                   @ red,130 SAY "str."
                   @ red,134 SAY bst
                   indik = 0
                ENDIF
             ENDIF
             SKIP
          ENDDO
          red = red + 1
          IF ! (rpd = 0 .and. rpk = 0)
          @ red,1 SAY "UKUPNO: "
          @ red,15 SAY round(rpd,2) PICTURE "999,999,999,999.99"
          @ red,35 SAY round(rpk,2) PICTURE "999,999,999,999.99"
          @ red,55 SAY round((rpk - rpd),2) PICTURE "999,999,999,999.99"
          @ red,75 SAY round(wrep,2) PICTURE "999,999,999,999.99"
          @ red,95 SAY round(wzel,2) PICTURE "999,999,999,999.99"
          ENDIF
          puk = puk + (rpk - rpd)
          indik = 0
          * STAMPA REKAPITULACIJE POREZA (BEZ PRENETOG)
          select 4
          go top
          DO WHILE ! Eof()
                     zez = 0
             IF ! tarpor = 0 .or. tarzbir = 0
                IF indik = 0
                   indik = 1
                   red = red + 3
                   @ red,30 SAY "REKAPITULACIJA POREZA (BEZ PRENETOG) "
                red = red + 1
                @ red,1 SAY "TARIFA"
                @ red,21 SAY "UKUPNI POREZ"
                @ red,44 SAY "REP.POREZ"
                @ red,60 SAY "ZEL.POREZ"
                @ red,76 SAY "DOD.POR. 3 %"
                @ red,89 SAY "POSEB.SAVEZNI"
                @ red,112 SAY "MALOPR.VREDNOST PO TARIFI"
                ENDIF
                red = red + 1
                @ red,1 SAY tarsif
                wdijana = tarsif
                select 9
                seek wdijana
                IF ! Found()
                   wmpv = 0
                else
                   wmpv = tempmpv
                ENDIF
                select 4
                @ red,15 SAY round(tarpor,2) PICTURE "999,999,999,999.99"
                xrep = tarpor * wp01
                xzel = tarpor * wp02
                xsav3 = tarpor * wp03
                xVOJ = tarpor * wp04
                zez = tarzbir
                IF tarzbir = 0
                   zez = 1
                ENDIF
                xrep = tarpor * (tarrst / zez)
                xzel = tarpor * (tarost / zez)
                xsav3 = tarpor * (tarsst / zez)
                xvoj = tarpor * (tarvoj / zez)
                @ red,35 SAY round(xrep,2) PICTURE "999,999,999,999.99"
                @ red,55 SAY round(xzel,2) PICTURE "999,999,999.99"
                @ red,70 SAY round(xsav3,2) PICTURE "999,999,999,999.99"
                @ red,89 SAY round(xvoj,2) PICTURE "999,999,999,999.99"
                @ red,115 SAY round(wmpv,2) PICTURE "999,999,999,999.99"
                ruk = ruk + tarpor
                x01 = x01 + xrep
                x02 = x02 + xzel
                x03 = x03 + xsav3
                x04 = x04 + xvoj
              ENDIF
              SKIP
          ENDDO
          red = red + 1
         IF ! ruk = 0
            @ red,1 SAY "UKUPNO: "
            @ red,15 SAY round(ruk,2) PICTURE "999,999,999,999.99"
            @ red,35 SAY round(x01,2) PICTURE "999,999,999,999.99"
            @ red,55 SAY round(x02,2) PICTURE "999,999,999.99"
            @ red,70 SAY round(x03,2) PICTURE "999,999,999,999.99"
            @ red,89 SAY round(x04,2) PICTURE "999,999,999,999.99"
         ENDIF
          puk = puk + ruk
          red = red + 2
          @ red,1 SAY "Ukupan porez"
          @ red,44 SAY "Rep.porez"
          @ red,60 SAY "Zel.porez"
          @ red,76 SAY "Dod.por. 3 %"
          @ red,89 SAY "Poseb.savezni"
          red = red + 2
          @ red,15 SAY round(puk,2) PICTURE "999,999,999,999.99"
          @ red,35 SAY round((wrep + x01),2) PICTURE "999,999,999,999.99"
          @ red,55 SAY round((wzel + x02),2) PICTURE "999,999,999.99"
          @ red,70 SAY round((wsav3 + x03),2) PICTURE "999,999,999,999.99"
          @ red,89 SAY round((wvoj + x04),2) PICTURE "999,999,999,999.99"
          select 4
          go top
          DO WHILE ! Eof()
             replace tardp with 0
             replace tarkp with 0
             replace tarpor with 0
             SKIP
          ENDDO
          red = red + 2
          @ red,30 SAY "Prenet Porez            :"
          @ red,78 SAY round(wporpaus,2) PICTURE "999,999,999,999.99"
          red = red + 1
          @ red,30 SAY "Obaveze prema dobavljacu:"
          @ red,78 SAY round((wnv + wdarko + wporpaus),2) PICTURE "999,999,999,999.99"
          red = red + 2
          @ red,110 SAY "K A L K U L I S A O"
          red = red + 2
          @ red,108 SAY Replicate("-",22)
          @ red + 1,1 SAY " "
         IF lLaser
            ? Chr(27) + '&k0S' + chr(27) + '(s10.5H'  && kondenz Off za laserski
         ELSE
            ? Chr(18)                                 && kondenz Off za matricni
         ENDIF

          eject
          set device to screen
          set printer off
          SET PRINT TO
          * ubacen deo za prikaz na ekranu
            izmenio:= .t.
           DO WHILE izmenio
              izmenio = m_type("lista.dat",140)
           ENDDO
           * kraj ubacenog dela za prikaz na ekranu
           set cursor on
          EXIT
      ENDDO
  *
      use
      erase temp.dbf
      erase tempintar.ntx
      close databases
      *release al
      CLEAR SCREEN
      return
      proc ncaslovb
         red = 7
         bst = bst + 1
         @ 1,5 SAY gcNazRad
         @ 1,95 SAY "PK-1:____  PK-2:____  KPP:____"
         @ 1,129 SAY "str."
         @ 1,133 SAY bst PICTURE "999"
         @ 2,5 SAY "Fak/otp. dobavljaca:"
         @ 2,26 SAY wdmpfak
         @ 2,39 SAY "Datum:"
         @ 2,47 SAY wdmpdfak
         @ 3,5 SAY "KALKULACIJA:"
         @ 3,19 SAY wdmpbro
         @ 3,44 SAY "DATUM:"
         @ 3,54 SAY wdmpdat
         @ 3,74 SAY "DOBAVLJAC:"
         @ 3,93 SAY wpp
         @ 3,99 SAY wnaz
         @ 4,5 SAY Replicate ("*",131)
        * @ 4,96 SAY gcNazRad
         @ 5,5 SAY "NAZIV ARTIKLA"
         @ 5,37 SAY "JM "
         @ 5,45 SAY "CENA PO JED MERE"
         @ 5,71 SAY "MP VRED. BEZ P/P"
         @ 5,99 SAY "TR/ST"
         @ 5,119 SAY "MPC SA P/P PO JM"
         @ 6,5 SAY "SIFRA ARTIKLA"
         @ 6,37 SAY "KOL"
         @ 6,45 SAY "UKP CEN PO JM"
         @ 6,71 SAY "RAZLIKA U CENI"
         @ 6,99 SAY "UK POREZ NA PROMET"
         @ 6,119 SAY "UKUPNA MPC SA P/P"
         @ 7,5 SAY Replicate("*",131)
       return
       *
       *
              proc ccigb
                 DO WHILE (dmpbro = wdmpbro)
                      wVrsta = vrsta
                      wruc = 0
                      zez = 0
                      wp1 = 0
                      wp2 = 0
                      wp3 = 0
                      wp11 = 0
                      wp22 = 0
                      wp33 = 0
                      wzel = 0
                      wrep = 0
                      wsav3 = 0
                      wvoj = 0
                      wtak = 0
                      wmarza1 = val("000000000000.00")
                      store wmarza1 to mPorOsnov,mPorIznos,mVrRab,mRuc,mPorIz,mPomozi,mPomozi1
                      mNabCen = val("00000.000000")
                      perazez = val("000.00")
                      perazez = round((dmppor * 100) / (dmppor + 100),2)
                    * perazez = perazez + 0.01
                      store 0 to xzel,xrep,xsav3,xvoj,xtak,x01,x02,x03,x04,x05
                      store 0 to wpom1,wpom2,wpom3,wpom4,wpom5,wpom6,wp01,wp02,wp03,wp04,wp05
                      IF vrsta = "J" .or. vrsta = "P"
                         mNabcen = round(dmpnc / dmpkol,6)
                         mVrRab1 = round(dmpirab / dmpkol,6)
                      ENDIF
                      IF vrsta = "R"
                         mNabCen = round((dmpnc - dmpirab + dmpppd) / dmpkol,6)
                         mVrRab1 = round(dmpirab / dmpkol,6)
                      ENDIF
                      IF vrsta = "N"
                       *  mPomozi = round((dmpnc - dmpirab + akciza * dmpkol),6)
                       *  mPomozi1 = round(mPomozi * dmppor / 100 + (taksa * dmpkol),2)
                       *  mNabCen = round((mPomozi + mPomozi1) / dmpkol,6)
                         mNabCen = round(dmpnc / dmpkol,6)
                      ENDIF
                     *else
                     *   mNabCen = round((dmpnc - dmpirab + (taksa + akciza) * dmpkol) / dmpkol,6)
                     *ENDIF
                      *mVrRab = round(mNabCen * dmprab / 100,6)
                       do case
                        * case Vrsta = "N"
                        *      mRuc = round(round(dmpmsp - mNabCen,6) * dmpkol,2)
                        *      mPorIz = round(mRuc * (round((dmppor * 100) / (dmppor + 100),2)) / 100,2)
                        *      wmarza1 = round(mRuc - mPorIz,2)
                              *wmarza1 = round(round(dmpmsp - mNabCen + mVrRab,6) * dmpkol,2)
                          case Vrsta = "A"
                               wmarza1 = round(round((mNabCen + Akciza) * dmprab / 100,6) * dmpkol,2)
                          case Vrsta = "T"
                               wmarza1 = round(round((mNabCen + Taksa) * dmprab / 100,6) * dmpkol,2)
                          case Vrsta = "S"
                               wmarza1 = round(round((mNabCen + Akciza + Taksa) * dmprab / 100,6) * dmpkol,2)
                          case Vrsta = "R"
                              * wmarza1 = dmpirab
                               * wmarza1 = round(dmpvsp - (dmpnc - dmpirab + dmpppd) - dmpraz,2)
                                wmarza1 = dmpirab
                                mPorIz = dmpppk
                          case Vrsta = "O"
                                mNabCen = round(dmpnc / dmpkol,6)
                              *  wmarza1 = round(dmpmsp - mNabCen - dmpraz,2)
                                 wmarza1 = round(dmpvsp - (dmpnc + dmpppd) - dmpraz,2)
                                mPorIz = dmpppk
                       endcase
                      * mPorOsnov = round((dmpmsp - Taksa) * dmpkol,2)
                      * mPorIznos = round(mPorOsnov * perazez / 100,2)
                       IF Vrsta = "P"
                         *wmarza1 = round(mPorOsnov - mPorIznos - dmpnc + Taksa * dmpkol,2)  && pokusaj sve zajedno
                          mRuc = round(round(dmpmsp - mNabCen + mVrRab,6) * dmpkol,2)
                        * mPorIz = round(mRuc * perazez / 100,2)
                          mPorIz = dmpppk
                         *wmarza1 = round(mRuc - mPorIz,2)
                        * wmarza1 = round(dmpvsp - dmpnc - dmpraz,2)    && do 15.03.97
                          wmarza1 = round(dmpvsp - dmpnc - dmpraz - dmpziz,2)
                       ENDIF
                       IF vrsta = "J"
                          *wmarza1 = round(mPorOsnov - mPorIznos - dmpnc + Taksa * dmpkol,2)  && pokusaj sve zajedno
                          mRuc = round(round(dmpmsp - mNabCen,6) * dmpkol,2)
                          mPorIz = round(mRuc * perazez / 100,2)
                          wmarza1 = round(mRuc - mPorIz,2)
                       ENDIF
                      IF red = 7
                         set proc to ncascigb
                         do ncascigb
                      ENDIF
                    * wnv = round(wnv + (mNabCen * dmpkol),2)
                      IF vrsta = "R"
                       *  wnv = round(wnv + (dmpnc - dmpirab + dmpppd),2)
                         wnv = round(wnv + dmpnc,2)
                      else
                         IF vrsta = "O"
                             wnv = wnv + round(dmpnc + dmpppd,2)
                         else
                             IF vrsta = "N"
                               * wnv = wnv + round(dmpnc + dmpppd - dmpirab + round((akciza + taksa) * dmpkol ,2),2)
                               wnv = round(wnv + dmpnc + dmpppd,2)
                             else
                                wnv = round(wnv + (mNabCen * dmpkol),2)
                             ENDIF
                         ENDIF
                      ENDIF
                      wakciza = round(wakciza + akciza * dmpkol,2)
                      wtaksa = round(wtaksa + taksa * dmpkol,2)
                      IF vrsta = "N"
                         *wmarza1 = round(round((dmpmsp - mNabCen) * dmpkol,2) - dmpraz,2)
                         wmarza1 = round(dmpirab - dmpraz,2)
                         mPorIz = dmpppk
                      ENDIF
                      ww = ((dmpmbp * 100) / dmpnc) - 100
       *              ww = (dmpnc / dmpmbp) * 100
                      wr = dmpirab
                      wrab = wrab + wr
                      wmarza = round(wmarza + wmarza1,2)
                      wzt = wzt + dmpziz
                      wvr = round(wvr + dmpmsp * dmpkol,2)
                    * wvrb = round(wvrb + mPorOsnov,2)
                    *  wvrb = round(wvrb + round(dmpvsp - taksa * dmpkol,2),2)    && umesto mRuc verovatno wmarza1
                     * wvrb = round(wvrb + round(dmpppk * 100 / 23,2),2)    && umesto mRuc verovatno wmarza1
                       wvrb = round(wvrb + round(dmpppk * 100 / dmppor,2),2)    && umesto mRuc verovatno wmarza1
                      wp1 = dmpppd
                      wp2 = dmpppk
                      wp3 = dmppor
                      wpx = wp1   && * dmpkol  pomereno 14.01.96 jer pamtim pun iznos
                      wpy = wp2   && * dmpkol  pomereno 14.01.96 jer pamtim pun iznos
                      wtar = dmptar
                      wpor = mPorIz
                     *wpor = round(dmpmsp * dmpkol * perazez / 100,2)
                     *wpor = round((dmpmsp - dmpmbp) * dmpkol,2)
                     *wpor = ((dmppor / 100) * dmpmbp) * dmpkol
                      select 4
                      seek wtar
                      IF Found()
                           zez = tarzbir
                           IF tarzbir = 0
                              zez = 1
                           ENDIF
                           wp01 = tarrst/zez
                           wp02 = tarost/zez
                           wp03 = tarsst/zez
                           wp04 = tarvoj/zez
                           wp05 = tartak/zez
                           wp11 = tardp
                           wp22 = tarkp
                           wp33 = tarpor
                           wp11 = wp11 + wpx
                           wp22 = wp22 + wpy
                           IF wp1 = 0 .and. wp2 = 0
                             wp33 = wp33 + wpor
                           ENDIF
                           replace tardp with wp11
                           replace tarkp with wp22
                           replace tarpor with wp33
                       ENDIF
                       select 9
                       seek wtar
                       IF ! Found()
                          append blank
                          replace temptar with wtar
                          wmpv = 0
                       else
                          wmpv = tempmpv
                       ENDIF
                        wmpv = wmpv + A->dmpmsp * A->dmpkol
                        replace tempmpv with wmpv
                        wmpv = 0
                       select 1
                       IF red > 58
                         red = 1
                         @ red,0 SAY " "
                         set procedure to ncascigb
                         do ncascigb
                       ENDIF
                       red = red + 1
                       rb = rb + 1
           *           @ red,1 SAY rb PICTURE "999"
                       @ red,5 SAY dmpnaz
                       @ red,36 SAY dmpjm
                      *@ red,44 SAY round(dmpnc / dmpkol,6) PICTURE "999,999,999.999999"
                       @ red,44 SAY round(mNabCen,6) PICTURE "999,999,999.999999"
                   *   @ red,68 SAY round((dmpmsp - taksa) * dmpkol,2) PICTURE "999,999,999,999.99"
                   * osnovica za porez
                      *@ red,68 SAY mRuc PICTURE "999,999,999,999.99"
                      *@ red,68 SAY round(dmpvsp - taksa * dmpkol,2) PICTURE "999,999,999,999.99"
                     * @ red,68 SAY round(dmpppk * 100 / 23,2) PICTURE "999,999,999,999.99"
                       @ red,68 SAY round(dmpppk * 100 / dmppor,2) PICTURE "999,999,999,999.99"
                       @ red,90 SAY substr(dmptar,1,4)
                       @ red,95 SAY round(dmpvsp - dmpppk,2) PICTURE "9999,999,999.99"
                       @ red,117 SAY dmpmsp PICTURE "999,999,999.99"
                       red = red + 1
                       @ red,5 SAY dmpsif PICTURE "9999999999999"
                       @ red,36 SAY dmpkol PICTURE "99999.999"
                       @ red,46 SAY round(mNabCen * dmpkol,2) PICTURE "9,999,999,999.99"
                       @ red,68 SAY round(wmarza1,2) PICTURE "999,999,999,999.99"
                     * @ red,92 SAY round((dmpmsp - dmpmbp) * dmpkol,2) PICTURE "999,999,999,999.99"
                     * @ red,92 SAY round(mPorIznos,2) PICTURE "999,999,999,999.99"
                     * iznos poreza
                       @ red,92 SAY mPorIz PICTURE "999,999,999,999.99"
                       @ red,117 SAY round(dmpmsp * dmpkol,2) PICTURE "999,999,999.99"
                       * blokirano 16.04.2005. na zahtev korisnika
                      *IF ! (dmpppd = 0 .and. dmpppk = 0)
                      *   red = red + 1
                      *   @ red,50 SAY "PRENETI POREZ"  && PO ("
                      * * @ red,69 SAY dmpjm
                      * * @ red,72 SAY ")"
                      *   @ red+1,10 SAY "OD DOBAVLJACA"
                      *   @ red+1,49 SAY "OBRACUNATI POREZ"
                      *   @ red+1,79 SAY "ZA UPLATU"
                      *   red = red + 2
                      *   @ red,4 SAY round(dmpppd,2) PICTURE "999,999,999,999.99"
                      *   @ red,38 SAY round(dmpppk,2) PICTURE "999,999,999,999.99"
                      *   @ red,67 SAY round((dmpppk - dmpppd),2) PICTURE "999,999,999,999.99"
                      *ENDIF
                       * kraj blokade
                       red = red + 1
                       @ red,5 SAY Replicate("-",131)
                       SKIP
                 ENDDO
                 IF red > 55
                    bst = bst + 1
                    red = 1
                    @ red,0 SAY " "
                    @ red,119 SAY "str."
                    @ red,124 SAY bst PICTURE "999"
                  ENDIF
                  red = red + 3
                  @ red,60 SAY "UKUPNO ZA KALKULACIJU"
                  red = red + 1
                  @ red,4 SAY "NABAVNA  VREDNOST"
                  @ red,28 SAY "A  K  C  I  Z   A"
                  @ red,50 SAY "T   A   K   S   A"
                  @ red,75 SAY "RAZLIKA U CENI "
                  @ red,92  SAY "OSNOVICA ZA POREZ"
                  @ red,115 SAY "MPV SA POREZOM "   && POREZOM"
                  red = red + 1
                  @ red,4 SAY round(wnv + WZT,2) PICTURE "99,999,999,999.99"
                  @ red,28 SAY round(wakciza,2) PICTURE "99,999,999,999.99"
                  @ red,50 SAY round(wtaksa,2) PICTURE "99,999,999,999.99"
                * IF wVrsta = "P"
                *    @ red,75 SAY round(wmarza + wtaksa,2) PICTURE "999,999,999.99"
                * else
                     @ red,75 SAY round(wmarza,2) PICTURE "999,999,999.99"
                * ENDIF
                  @ red,92 SAY round(wvrb,2) PICTURE "99,999,999,999.99"
                  @ red,115 SAY round(wvr,2) PICTURE "9,999,999,999.99"
                 IF red > 55
                     red = 1
                     @ red,0 SAY " "
                     bst = bst + 1
                     @ red,119 SAY "str."
                     @ red,124 SAY bst PICTURE "999"
                 ENDIF
                 select 4
                 go top
                 DO WHILE ! Eof()
                            zez = 0
                    IF ! (tardp = 0 .and. tarkp = 0)
                       IF indik = 0
                          indik = 1
                          red = red + 3
                          @ red,50 SAY "REKAPITULACIJA PRENETOG POREZA"
                          red = red + 1
                          @ red,1 SAY "TARIFA"
                          @ red,15 SAY "OD DOBAVLJACA"
                          @ red,35 SAY "OBRACUNATI POREZ"
                          @ red,55 SAY "RAZLIKA ZA UPLATU"
                          @ red,79 SAY "REP.POREZ"
                          @ red,90 SAY "ZEL.POREZ"
                          @ red,100 SAY "DOD.POR.3%"
                          @ red,111 SAY "POSEB.SAVE"
                          @ red,122 SAY "POSEB.TAKS"
                         * @ red,122 SAY "MP VRED.PO T"
                       ENDIF
                       red = red + 1
                       @ red,1 SAY tarsif
                       @ red,15 SAY round(tardp,2) PICTURE "999,999,999,999.99"
                       wdarko = wdarko + tardp
                       wdijana = tarsif
                       select 9
                       seek wdijana
                       IF ! Found()
                         wmpv = 0
                       else
                         wmpv = tempmpv
                       ENDIF
                       select 4
                       @ red,35 SAY round(tarkp,2) PICTURE "999,999,999,999.99"
                       @ red,55 SAY round((tarkp - tardp),2) PICTURE "999,999,999,999.99"
                       wpom1 = tarkp - tardp
                       zez = tarzbir
                       IF tarzbir = 0
                       zez = 1
                       ENDIF
                       wp01 = tarrst / zez
                       wp02 = tarost / zez
                       wp03 = tarsst / zez
                       wp04 = tarvoj / zez
                       wp05 = tartak / zez
                       wpom2 = round(wpom1 * wp01,2)
                       wpom3 = round(wpom1 * wp02,2)
                       wpom4 = round(wpom1 * wp03,3)
                       wpom5 = round(wpom1 * wp04,3)
                       wpom6 = round(wpom1 * wp05,3)
                       @ red,75 SAY round(wpom2,2) PICTURE "99,999,999.99"
                       @ red,89 SAY round(wpom3,2) PICTURE "9999999.99"
                       @ red,100 SAY round(wpom4,2) PICTURE "9999999.99"
                       @ red,111 SAY round(wpom5,2) PICTURE "9999999.99"
                       @ red,122 SAY round(wpom6,2) PICTURE "9999999.99"
                      * @ red,122 SAY round(wmpv,2) PICTURE "999,999,999.99"
                       wrep = wrep + wpom2
                       wzel = wzel + wpom3
                       wsav3 = wsav3 + wpom4
                       wvoj = wvoj + wpom5
                       wtak = wtak + wpom6
                       rpd = rpd + tardp
                       rpk = rpk + tarkp
                       IF red > 58
                          red = 1
                          bst = bst + 1
                          @ red,0 SAY " "
                          @ red,119 SAY "str."
                          @ red,124 SAY bst
                          indik = 0
                       ENDIF
                    ENDIF
                    SKIP
                 ENDDO
                 red = red + 1
                 IF ! (rpd = 0 .and. rpk = 0)
                 @ red,1 SAY "UKUPNO: "
                 @ red,15 SAY round(rpd,2) PICTURE "999,999,999,999.99"
                 @ red,35 SAY round(rpk,2) PICTURE "999,999,999,999.99"
                 @ red,55 SAY round((rpk - rpd),2) PICTURE "999,999,999,999.99"
                 @ red,75 SAY round(wrep,2) PICTURE "99,999,999.99"
                 @ red,89 SAY round(wzel,2) PICTURE "9999999.99"
                 @ red,100 SAY round(wsav3,2) PICTURE "9999999.99"
                 @ red,111 SAY round(wvoj,2) PICTURE "9999999.99"
                 @ red,122 SAY round(wtak,2) PICTURE "9999999.99"
                 ENDIF
                 puk = puk + (rpk - rpd)
                 indik = 0
                 *  blokirano bez prenetog 14.01.96. zbog pica,kafe i duvana
               * select 4
               * go top
               * DO WHILE ! Eof()
               *            zez = 0
               *    IF ! tarpor = 0 .or. tarzbir = 0
               *       IF indik = 0
               *          indik = 1
               *          red = red + 3
               *          @ red,30 SAY "REKAPITULACIJA POREZA (BEZ PRENETOG) "
               *          red = red + 1
               *          @ red,1 SAY "TARIFA"
               *          @ red,15 SAY "UKUPNI POREZ"
               *          @ red,35 SAY "REP.POREZ"
               *          @ red,55 SAY "ZEL.POREZ"
               *          @ red,106 SAY "MALOPR.VREDNOST PO TARIFI"
               *       ENDIF
               *       red = red + 1
               *       @ red,1 SAY tarsif
               *       wdijana = tarsif
               *       select 9
                *      seek wdijana
                *      IF ! Found()
                *         wmpv = 0
                *      else
                *         wmpv = tempmpv
                *      ENDIF
                *      select 4
                *      @ red,15 SAY round(tarpor,2) PICTURE "999,999,999,999.99"
                *      xrep = tarpor * wp01
                *      xzel = tarpor * wp02
                *      zez = tarzbir
                *      IF tarzbir = 0
                *         zez = 1
                *      ENDIF
                *      xrep = tarpor * (tarrst / zez)
                *      xzel = tarpor * (tarost / zez)
                *      @ red,35 SAY round(xrep,2) PICTURE "999,999,999,999.99"
                *      @ red,55 SAY round(xzel,2) PICTURE "999,999,999,999.99"
                *      @ red,115 SAY round(wmpv,2) PICTURE "9,999,999,999.99"
                *      ruk = ruk + tarpor
                *      x01 = x01 + xrep
                *      x02 = x02 + xzel
                *   ENDIF
                *    SKIP
                *ENDDO
                *red = red + 1
                *f ! ruk = 0
                *@ red,1 SAY "UKUPNO: "
                *@ red,15 SAY round(ruk,2) PICTURE "999,999,999,999.99"
                *@ red,35 SAY round(x01,2) PICTURE "999,999,999,999.99"
                *@ red,55 SAY round(x02,2) PICTURE "999,999,999,999.99"
                *ndif
                *puk = puk + ruk
                *red = red + 2
                *@ red,1 SAY "Ukupan porez"
                *@ red,35 SAY "Republ.porez"
                *@ red,55 SAY "Zeleznica por."
                *red = red + 2
                *@ red,1 SAY round(puk,2) PICTURE "999,999,999,999.99"
                *@ red,35 SAY round((wrep + x01),2) PICTURE "999,999,999,999.99"
                *@ red,55 SAY round((wzel + x02),2) PICTURE "999,999,999,999.99"
                 * kraj poreza
                 select 4
                 go top
                 DO WHILE ! Eof()
                    replace tardp with 0
                    replace tarkp with 0
                    replace tarpor with 0
                    SKIP
                 ENDDO
                 red = red + 2
                 do case
                    case wVrsta = "P" .or. wVrsta = "N"
                         @ red,10 SAY "OBAVEZA PREMA DOBAVLJACU:"  && (nabavna vrednost - rabat + akciza + taksa):"
                         @ red,80 SAY wnv PICTURE "999,999,999.99"  && round((wnv - wmarza + wakciza + wtaksa),2) PICTURE "999,999,999,999.99"
                         red = red + 1
                         @ red,10 SAY "ZAVISNI TROSKOVI"
                         @ red,80 SAY wZT PICTURE "999,999,999.99"  && round((wnv - wmarza + wakciza + wtaksa),2) PICTURE "999,999,999,999.99"
                    case wVrsta = " "
                         @ red,10 SAY "OBAVEZA PREMA DOBAVLJACU(nabavna vrednost - rabat + akciza + taksa):"
                         @ red,80 SAY round((wnv - wmarza + wakciza + wtaksa),2) PICTURE "999,999,999,999.99"
                    case wVrsta = "R" .or. wvrsta = "J"
                         @ red,10 SAY "OBAVEZA PREMA DOBAVLJACU:"
                         @ red,80 SAY round(wnv,2) PICTURE "999,999,999.99"
                 endcase
                 red = red + 2
                 @ red,110 SAY "K A L K U L I S A O"
                 red = red + 2
                 @ red,108 SAY Replicate("-",22)
                 @ red + 1,1 SAY " "

                  IF lLaser
                     ? Chr(27) + '&k0S' + chr(27) + '(s10.5H'  && kondenz Off za laserski
                  ELSE
                     ? Chr(18)                                 && kondenz Off za matricni
                  ENDIF

                 eject
                 set device to screen
                 set printer off
                 SET PRINT TO
                 * ubacen deo za pregled
                 izmenio:= .t.
                 DO WHILE izmenio
                    izmenio = m_type("lista.dat",140)
                 ENDDO
                 * kraj ubacenog dela
                 set cursor on
          *       EXIT
          *   ENDDO
         *
             use
             erase temp.dbf
             erase tempintar.ntx
             close databases
             *release al
             CLEAR SCREEN
              return
          *
          *

             proc ncascigb
                red = 7
                bst = bst + 1
                @ 1,5 SAY gcNazRad
                @ 1,88 SAY "PK-1:____  PK-2:____  KPP:____"
                @ 1,119 SAY "str."
                @ 1,124 SAY bst PICTURE "999"
                @ 2,5 SAY "Fak/otp. dobavljaca:"
                @ 2,26 SAY wdmpfak
                @ 2,39 SAY "Datum:"
                @ 2,47 SAY wdmpdfak
                @ 3,5 SAY "KALKULACIJA:"
                @ 3,19 SAY wdmpbro
                @ 3,44 SAY "DATUM:"
                @ 3,54 SAY wdmpdat
                @ 3,74 SAY "DOBAVLJAC:"
                @ 3,93 SAY wpp
                @ 3,99 SAY wnaz
                @ 4,5 SAY Replicate ("*",131)
               * @ 4,96 SAY gcNazRad
                @ 5,5 SAY "NAZIV ARTIKLA"
                @ 5,37 SAY "JM "
                @ 5,45 SAY "CENA PO JED MERE"
                * @ 5,71 SAY "OSNOVICA ZA POREZ"
                @ 5,71 SAY "OSNOVICA ZA PDV  "
                @ 5,90 SAY "TR/ST MPV BEZ PDV"
                @ 5,119 SAY "MPC SA PDV"
                @ 6,5 SAY "SIFRA ARTIKLA"
                @ 6,37 SAY "KOL"
                @ 6,45 SAY "UKP CEN PO JM"
                @ 6,71 SAY "RAZLIKA U CENI"
                @ 6,90 SAY "UK POREZ NA PROMET"
                @ 6,119 SAY "MPV SA PDV"
                @ 7,5 SAY Replicate("*",131)
              return

