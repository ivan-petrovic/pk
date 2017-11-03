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
    *  select 2
    *  use ugovori index ugokal,ugorev
*     use ppdat index ppinsif
      select 1
      use dmpdat index dmpinbro,dmpinbs
      DO WHILE .t.
          perazez = val("99.99")
          select 1
          store 0 to indik,indik1,indik2
          CLEAR SCREEN
          do esck
          @ 1,30 SAY "STAMPA KALKULACIJE NIVELACIJE"
          wdmpbro = Space(10)
          indz = 0
          xxx = 0
          yyy = 0
          wnv = 0
          wvrb = 0
          rb = 0
          wdarko = 0
          wr = 0
          wrab = 0
          wmarza = 0
          wzt = 0
          wvr = 0
          wmpv = 0
          rpd = 0
          rpk = 0
          ruk = 0
          puk = 0
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
          wubk = wdmpbro
          wdmpdat = dmpdat
          wdmpfak = dmpfak
          wdmpdfak = dmpdfak
          wpp = dmpdob
          @ 3,40 SAY "Datum:"
          ?? wdmpdat
          @ 3,60 SAY "Komitent    "
        *  select 2
        *  seek wubk
        *  IF ! Found()
             wnaz = Space(30)
        *  else
        *     wnaz = uime
        *  ENDIF
*         select 1
          red = 0   && videti sta je sa redom
          bst = 0
*         set printer to lista
          set device to printer
          * set printer to lista
          set printer on
          setprc(0,0)
         IF lLaser
            ? Chr(27) + '(s17.5H'      && kondenz On za laserski
         ELSE
            ? Chr(15)                  && kondenz On za matricni
         ENDIF

          select 1
          DO WHILE (dmpbro = wdmpbro)
               perazez = 0
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
               store 0 to xzel,xrep,xsav3,xvoj,xtak,x01,x02,x03,x04,x05
               store 0 to wpom1,wpom2,wpom3,wpom4,wpom5,wpom6,wp01,wp02,wp03,wp04,wp05
               IF red = 0 .and. indz = 0
                  indz = 1
                  set proc to zagl171
                  do zagl171
               ENDIF
               perazez = round((dmppor * 100) / (dmppor + 100),2)
               wnv = wnv + round(dmpnc * dmpkol,2)
               ww = round(((dmpmbp * 100) / dmpnc) - 100,2)
*              ww = round(dmpnc / dmpmbp,2) * 100
               wr = dmpirab
**   ubacen drugaciji nacin obracuna poreza zbog neslaganja na zaokruzenju
**   novi     ***
**             wrab = wrab + round(((dmppor / 100) * dmpmbp) * dmpkol,2)
*****************
  **** stari *****
               wrab = wrab + round(dmpmsp * dmpkol * perazez / 100,2)
  *****************
             *  wmarza = wmarza + round(dmpmbp * dmprab / 100 * dmpkol,2)
               wmarza = wmarza + round(dmpmbp * dmpkol,2)
               wzt = wzt + dmpziz
               wvr = wvr + dmpvsp
               wvrb = wvrb + round(dmpmbp * dmpkol,2)
               wp1 = dmpppd
               wp2 = dmpppk
               wp3 = dmppor
               wpx = wp1 * dmpkol
               wpy = wp2 * dmpkol
               wtar = dmptar
            *  wpor = round(((dmppor / 100) * dmpmbp) * dmpkol,2)
               wpor = round(dmpmsp * dmpkol * perazez / 100,2)
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
                 wmpv = wmpv + round(A->dmpmsp * A->dmpkol,2)
                 replace tempmpv with wmpv
                 wmpv = 0
                select 1
                IF red > 60
                  red = 1
                  @ red,0 SAY " "
                  set procedure to zagl171
                  do zagl171
                ENDIF
                red = red + 1
                rb = rb + 1
   *            @ red,1 SAY rb PICTURE "999"
                @ red,5 SAY dmpnaz
       *         @ red,36 SAY dmpjm
    *           @ red,40 SAY dmpkol PICTURE "99,999,999,999.999"
        *        @ red,44 SAY round(dmpnc,2) PICTURE "999,999,999,999.99"
     *          @ red,79 SAY dmpztr PICTURE "999.99"
     *          @ red,86 SAY dmpmar PICTURE "999.99"
    *           @ red,88 SAY dmprab PICTURE "999.99"
    *           @ red,95 SAY dmpmar PICTURE "999.99"
    *           @ red,88 SAY ww PICTURE "999.99"
                @ red,68 SAY round(dmpmbp * dmpkol,2) PICTURE "999,999,999,999.99"
                @ red,96 SAY substr(dmptar,1,4)
                @ red,101 SAY "/"
                @ red,103 SAY dmppor PICTURE "9999"
    *           @ red,101 SAY round(dmpmbp * dmpkol,2) PICTURE "999,999,999,999.99"
     *           @ red,117 SAY dmpmsp PICTURE "999,999,999,999.99"
                red = red + 1
        *       @ red,99 SAY "TARIFA:"
        *       @ red,107 SAY dmptar
        *       @ red,116 SAY "MALOPRODAJNA VREDNOST"
      *          @ red,5 SAY dmpsif PICTURE "999999"
       *         @ red,36 SAY dmpkol PICTURE "999"
                @ red,44 SAY round(dmpnc * dmpkol,2) PICTURE "999,999,999,999.99"
              *  @ red,68 SAY round(dmpmbp * dmprab / 100 * dmpkol,2) PICTURE "999,999,999,999.99"
                @ red,68 SAY round(dmpmbp * dmpkol,2) PICTURE "999,999,999,999.99"
              * @ red,92 SAY round(((dmppor / 100) * dmpmbp) * dmpkol,2) PICTURE "999,999,999,999.99"
                @ red,92 SAY round(dmpmsp * dmpkol * perazez / 100,2) PICTURE "999,999,999,999.99"
                @ red,117 SAY (dmpmsp * dmpkol) PICTURE "999,999,999,999.99"
                red = red + 1
     *          @ red,119 SAY round(dmpvsp,2) PICTURE "999,999,999,999"
     *          red = red + 1
     *          IF ! (dmpppd = 0 .and. dmpppk = 0)
     *             @ red,50 SAY "PRENETI POREZ PO ("
     *             @ red,69 SAY dmpjm
     *             @ red,72 SAY ")"
     *             @ red+1,10 SAY "OD DOBAVLJACA"
     *             @ red+1,49 SAY "OBRACUNATI POREZ"
     *             @ red+1,79 SAY "ZA UPLATU"
     *             red = red + 2
     *             @ red,4 SAY round(dmpppd,0) PICTURE "999,999,999,999"
     *             @ red,38 SAY round(dmpppk,0) PICTURE "999,999,999,999"
     *             @ red,67 SAY round((dmpppk - dmpppd),0) PICTURE "999,999,999,999"
     *          ENDIF
     *          red = red + 1
                @ red,5 SAY Replicate("-",131)
                SKIP
                IF red > 56
   *            red = red + 1
   *            @ red,0 SAY " "  && red 57
                red = red + 1
                @ red,0 SAY " "  && red 58
                red = 1
                ENDIF
          ENDDO
          IF red > 53
 *           bst = bst + 1
 *           red = red + 1
 *           @ red,0 SAY " "   && red 54
             red = red + 1
             @ red,0 SAY " "   && red 55
             red = red + 1
             @ red,0 SAY " "   && red 56
             red = red + 1
             @ red,0 SAY " "    && red 57
             red = red + 1
             @ red,0 SAY " "    && red 58
 *           @ red,130 SAY "str."
 *           @ red,134 SAY bst PICTURE "999"
             red = 1
           ENDIF
           red = red + 1
           @ red,60 SAY "UKUPNO ZA KALKULACIJU"
           red = red + 1
           @ red,4 SAY "NABAVNA  VREDNOST"
       *   @ red,24 SAY "ZAVISNI TROSKOVI"
           @ red,53 SAY "RAZLIKA U CENI"
           @ red,75  SAY "UK POREZ NA PROMET  "
           @ red,115 SAY "MP VREDNOST SA POREZOM"
           red = red + 1
           @ red,1 SAY round(wnv,2) PICTURE "999,999,999,999.99"
       *   @ red,25 SAY round(wzt,2) PICTURE "999,999,999,999.99"
           @ red,49 SAY round(wmarza,2) PICTURE "999,999,999,999.99"
           @ red,75 SAY round(wrab,2) PICTURE "999,999,999,999.99"
           @ red,115 SAY round(wvr,2) PICTURE "999,999,999,999.99"
          IF red > 55
              red = 1
              @ red,0 SAY " "
              bst = bst + 1
              @ red,130 SAY "str."
              @ red,134 SAY bst PICTURE "999"
          ENDIF
          select 4
          go top
      *   DO WHILE ! Eof()
      *              zez = 0
      *      IF ! (tardp = 0 .and. tarkp = 0)
      *         IF indik = 0
      *            indik = 1
      *            red = red + 3
      *            @ red,50 SAY "REKAPITULACIJA PRENETOG POREZA"
      *            red = red + 1
      *            @ red,1 SAY "TARIFA"
      *            @ red,15 SAY "OD DOBAVLJACA"
      *            @ red,35 SAY "OBRACUNATI POREZ"
      *            @ red,55 SAY "RAZLIKA ZA UPLATU"
      *            @ red,75 SAY "REPUBLICKI"
      *            @ red,95 SAY "DEO ZA ZELEZN."
      *            @ red,115 SAY "MP VRED.PO TARIFI"
      *         ENDIF
      *         red = red + 1
      *         @ red,1 SAY tarsif
      *         @ red,15 SAY round(tardp,0) PICTURE "999,999,999,999"
      *         wdarko = wdarko + tardp
      *         wdijana = tarsif
      *         select 9
      *         seek wdijana
      *         IF ! Found()
      *           wmpv = 0
      *         else
      *           wmpv = tempmpv
      *         ENDIF
      *         select 4
      *         @ red,35 SAY round(tarkp,0) PICTURE "999,999,999,999"
      *         @ red,55 SAY round((tarkp - tardp),0) PICTURE "999,999,999,999"
      *         wpom1 = tarkp - tardp
      *         zez = tarzbir
      *         IF tarzbir = 0
      *         zez = 1
      *         ENDIF
      *         wp01 = tarrst / zez
      *         wp02 = tarost / zez
      *         wpom2 = wpom1 * wp01
      *         wpom3 = wpom1 * wp02
      *         @ red,75 SAY round(wpom2,0) PICTURE "999,999,999,999"
      *         @ red,95 SAY round(wpom3,0) PICTURE "999,999,999,999"
      *         @ red,115 SAY round(wmpv,0) PICTURE "999,999,999,999"
      *         wrep = wrep + wpom2
      *         wzel = wzel + wpom3
      *         rpd = rpd + tardp
      *         rpk = rpk + tarkp
      *         IF red > 60
      *            red = 1
      *            bst = bst + 1
      *            @ red,0 SAY " "
      *            @ red,130 SAY "str."
      *            @ red,134 SAY bst
      *            indik = 0
      *         ENDIF
      *      ENDIF
      *      SKIP
      *   ENDDO
      *   red = red + 1
      *   IF ! (rpd = 0 .and. rpk = 0)
      *   @ red,1 SAY "UKUPNO: "
      *   @ red,15 SAY round(rpd,0) PICTURE "999,999,999,999"
      *   @ red,35 SAY round(rpk,0) PICTURE "999,999,999,999"
      *   @ red,55 SAY round((rpk - rpd),0) PICTURE "999,999,999,999"
      *   @ red,75 SAY round(wrep,0) PICTURE "999,999,999,999"
      *   @ red,95 SAY round(wzel,0) PICTURE "999,999,999,999"
      *   ENDIF
      *   puk = puk + (rpk - rpd)
      *   indik = 0
      *   select 4
      *   go top
          DO WHILE ! Eof()
                     zez = 0
              IF ! tarpor = 0          && blok da izlaze svi
                IF indik = 0
                   indik = 1
                   red = red + 3
                   @ red,30 SAY "REKAPITULACIJA POREZA (BEZ PRENETOG) "
                   red = red + 1
                   @ red,1 SAY "TARIFA"
                   @ red,15 SAY "UKUPNI POREZ"
                   @ red,35 SAY "REP.POREZ"
                   @ red,55 SAY "ZEL.POREZ"
                   @ red,66 SAY "DOD.POR. 3 %"
                   @ red,79 SAY "POSEB.SAVEZNI"
                   @ red,93 SAY "POSEBNA TAKSA"
                  * @ red,112 SAY "MALOPR.VREDNOST PO TARIFI"
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
*     *         xrep = tarpor * wp01
*     *         xzel = tarpor * wp02
                zez = tarzbir
                IF tarzbir = 0
                   zez = 1
                ENDIF
                xrep = tarpor * (tarrst / zez)
                xzel = tarpor * (tarost / zez)
                xSAV3 = tarpor * (tarsst / zez)
                xvoj = tarpor * (tarVOJ / zez)
                xtak = tarpor * (tartak / zez)
                @ red,35 SAY round(xrep,2) PICTURE "999,999,999,999.99"
                @ red,55 SAY round(xzel,2) PICTURE "9999999.99"
                @ red,66 SAY round(xsav3,2) PICTURE "9,999,999.99"
                @ red,79 SAY round(xvoj,2) PICTURE "9,999,999.99"
                @ red,93 SAY round(xtak,2) PICTURE "9,999,999.99"
               * @ red,115 SAY round(wmpv,2) PICTURE "999,999,999,999.99"
                ruk = ruk + tarpor
                x01 = x01 + xrep
                x02 = x02 + xzel
                x03 = x03 + xsav3
                x04 = x04 + xvoj
                x05 = x05 + xTAK
               ENDIF                      && kraj bloka da izlaze svi
              SKIP
          ENDDO
          red = red + 1
         IF ! ruk = 0
          @ red,1 SAY "UKUPNO: "
          @ red,15 SAY round(ruk,2) PICTURE "999,999,999,999.99"
          @ red,35 SAY round(x01,2) PICTURE "999,999,999,999.99"
          @ red,55 SAY round(x02,2) PICTURE "9999999.99"
          @ red,66 SAY round(x03,2) PICTURE "9,999,999.99"
          @ red,79 SAY round(x04,2) PICTURE "9,999,999.99"
          @ red,93 SAY round(x05,2) PICTURE "9,999,999.99"
         ENDIF
          puk = puk + ruk
          red = red + 2
          @ red,1 SAY "Ukupan porez"
          @ red,35 SAY "Republ.porez"
          @ red,55 SAY "Zel. por."
          @ red,66 SAY "Dod.por. 3 %"
          @ red,79 SAY "Poseb.savezni"
          @ red,93 SAY "Posebna taksa"
          red = red + 2
          @ red,1 SAY round(puk,2) PICTURE "999,999,999,999.99"
          @ red,35 SAY round((wrep + x01),2) PICTURE "999,999,999,999.99"
          @ red,55 SAY round((wzel + x02),2) PICTURE "9999999.99"
          @ red,66 SAY round((wsav3 + x03),2) PICTURE "9,999,999.99"
          @ red,79 SAY round((wvoj + x04),2) PICTURE "9,999,999.99"
          @ red,93 SAY round((wtak + x05),2) PICTURE "9,999,999.99"
          select 4
          go top
          DO WHILE ! Eof()
             replace tardp with 0
             replace tarkp with 0
             replace tarpor with 0
             SKIP
          ENDDO
          red = red + 2
          @ red,30 SAY "Obaveze prema dobavljacu:"
          @ red,78 SAY round((wnv + wdarko),2) PICTURE "999,999,999,999.99"
          red = red + 2
      *   @ red,5 SAY "K O M I N T E N T"
          @ red,110 SAY "K A L K U L I S A O"
          red = red + 2
      *   @ red,3 SAY repli("-",22)
          @ red,108 SAY Replicate("-",22)
          @ red + 1,1 SAY " "

         IF lLaser
            ? Chr(27) + '&k0S' + Chr(27) + '(s10.5H'  && kondenz Off za laserski
         ELSE
            ? Chr(18)                                 && kondenz Off za matricni
         ENDIF

          eject
          set device to screen
          set printer off
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
      proc zagl171
         red = 0
         bst = bst + 1

         @ 1,6 SAY "KALKULACIJA:"
         @ 1,20 SAY wdmpbro
         @ 1,31 SAY "NIVELACIJA CENA BR."
         @ 1,50 SAY wdmpfak
         @ 1,60 SAY "URADJENA DANA"
         @ 1,74 SAY dmpdat
         @ 1,87 SAY "PO POPISU ROBE DANA"
         @ 1,107 SAY dmpdfak
         @ 1,118 SAY substr(gcNazRad,1,16)
         @ 2,5 SAY Replicate ("*",131)
         @ 3,5 SAY "NAZIV ARTIKLA"
         @ 3,37 SAY "JM "
         @ 3,45 SAY "CENA PO JED.MERE"
         @ 3,71 SAY "MP VRED.BEZ P/P"
         @ 3,99 SAY "TB/ST"
         @ 3,119 SAY "MPC SA P/P PO JM"
         @ 4,5 SAY "SIFRA ARTIKLA"
         @ 4,37 SAY "KOL"
         @ 4,45 SAY "UKP CEN PO JM"
         @ 4,71 SAY "RAZLIKA U CENI"
         @ 4,92 SAY "UK POREZ NA PROMET"
         @ 4,119 SAY "UKUPNA MPC SA P/P"
         @ 5,5 SAY Replicate("*",131)
         red = 5
       return
