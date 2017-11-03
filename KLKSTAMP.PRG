IF File("temp.dbf")
   ERASE temp.dbf
ENDIF
IF File("tempintar.ntx")
  ERASE tempintar.ntx
ENDIF

CREATE radna
STORE "temptar   c8  " TO polje1
STORE "tempmpv   n152" TO polje2
FOR i = 1 TO 2
   broj = Str(i,1)
   p1 = "polje" + broj
   APPEND BLANK
   REPLACE field_name WITH Substr(&p1,1,10)
   REPLACE field_type WITH Substr(&p1,11,1)
   REPLACE field_len  WITH Val(Substr(&p1,12,2))
   REPLACE field_dec  WITH Val(Substr(&p1,14,1))
NEXT i
CREATE temp FROM radna
INDEX ON temptar TO tempintar
ERASE radna.dbf
USE

SELECT 9
USE TEMP INDEX TEMPINTAR

SELECT 4
USE TARDAT INDEX TARINSIF
GO TOP

DO WHILE ! Eof()
   REPLACE TARDP WITH 0
   REPLACE TARKP WITH 0
   REPLACE TARPOR WITH 0
   SKIP
ENDDO

SELECT 2
USE PPDAT INDEX PPINSIF

SELECT 1
USE DMPDAT INDEX DMPINBRO,DMPINBS

DO WHILE .T.

   MainMask("STAMPA KALKULACIJE OD BROJA DO BROJA")

   indik = 0
   wdmpbro = Space(10)
   wdmpbrodo = Space(10)
   wnv = Val("000000000000.00")
   wprenpdv = Val("000000000000.00")
   wporpaus = Val("000000000000.00")
   store wnv to wakciza,wtaksa
   wvrb = Val("000000000000.00")
   rb = 0
   wdarko = 0
   wr = 0
   wrab = 0
   wmarza = Val("000000000000.00")
   wzt = Val("000000000000.00")
   wvr = Val("000000000000.00")
   wmpv = 0
   rpd = 0
   rpk = 0
   ruk = 0
   puk = 0
   wruc = Val("000000000000.00")
   wwruc = Val("000000000000.00")
   nBrKalOd = 0
   nBrKalDo = 0

   @ 3,2 SAY "Kalkulacija: " GET wdmpbro PICTURE "@!" VALID ! Empty(wdmpbro)
   @ 4,2 SAY "Kalkulacija: " GET wdmpbrodo PICTURE "@!" VALID ! Empty(wdmpbrodo)
   READ

   IF Lastkey() = 27
      EXIT
   ENDIF
   
   nBrKalOd = Val(wdmpbro)
   nBrKalDo = Val(wdmpbrodo)

   SET DEVICE TO PRINTER
   * SET PRINTER TO Lista
   SET PRINTER TO LPT1
   SET PRINTER ON
   IF lLaser
      ? Chr(27) + '(s17.5H'      && kondenz On za laserski
   ELSE
      ? Chr(15)                  && kondenz On za matricni
   ENDIF
   Setprc(0,0)

   SELECT 1
   GO TOP

   DO WHILE .NOT. Eof()
      indik = 0
      wnv = Val("000000000000.00")
      wprenpdv = Val("000000000000.00")
      wporpaus = Val("000000000000.00")
      store wnv to wakciza,wtaksa
      wvrb = Val("000000000000.00")
      rb = 0
      wdarko = 0
      wr = 0
      wrab = 0
      wmarza = Val("000000000000.00")
      wzt = Val("000000000000.00")
      wvr = Val("000000000000.00")
      wmpv = 0
      rpd = 0
      rpk = 0
      ruk = 0
      puk = 0
      wruc = Val("000000000000.00")
      wwruc = Val("000000000000.00")

      SELECT 1

      IF Val(DMPBRO) < nBrKalOd .OR. Val(DMPBRO) > nBrKalDo
         SKIP
         LOOP
      ENDIF

      wdmpbro  = DMPBRO
      wdmpdat  = DMPDAT
      wdmpfak  = DMPFAK
      wdmpdfak = DMPDFAK
      wpp      = DMPDOB

      SELECT 2
      SEEK wpp
      IF ! Found()
         wnaz = Space(30)
      ELSE
         wnaz = PPNAZ
      ENDIF

      SELECT 1
      red = 7
      bst = 0

      * odluka koja je kalkulacija
      IF ! Empty(vrsta)
         DO cigb1
         LOOP
      ENDIF

      DO WHILE (DMPBRO = wdmpbro)
         wruc  = 0
         zez   = 0
         wp1   = 0
         wp2   = 0
         wp3   = 0
         wp11  = 0
         wp22  = 0
         wp33  = 0
         wzel  = 0
         wrep  = 0
         wsav3 = 0
         wvoj  = 0
         perazez = Val("000.00")
         perazez = Round((dmppor * 100) / (dmppor + 100),2)
         STORE 0 TO xzel,xrep,xsav3,xvoj,x01,x02,x03,x04
         STORE 0 TO wpom1,wpom2,wpom3,wpom4,wpom5,wpom6,wp01,wp02,wp03,wp04

         IF red = 7
            DO naslovb
         ENDIF

         wprenpdv = Round(wprenpdv + dmpppd,2)
         wnv = wnv + (dmpnc * dmpkol)        && fakturna vrednost
         ww = ((dmpmbp * 100) / dmpnc) - 100
         wr = dmpirab
         wrab = wrab + wr
         wporpaus = wporpaus + akciza
         wmarza = wmarza + dmpmiz            && ovo je razlika u ceni po starom
         wzt = wzt + dmpziz
         wvr = wvr + dmpvsp                  && prodajna vrednost robe
         wvrb = wvrb + (dmpmbp * dmpkol)
         wp1 = dmpppd                        && preneti porez dobavljac
         wp2 = dmpppk                        && preneti porez kupcu
         wp3 = dmppor                        && poreska stopa za tu robu
         wpx = wp1 * dmpkol                  && preneti porez dobavljac ukupno
         wpy = wp2 * dmpkol                  && preneti porez kupcu ukupno
         wtar = dmptar
         wpor = Round(dmpmsp * dmpkol * perazez / 100,2)
         wruc = Round(Round(dmpmsp * dmpkol,2) - (Round(wpor + dmpziz + Round(dmpnc * dmpkol,2),2)),2)
         wwruc = Round(wwruc + wruc,2)

         SELECT 4
         SEEK wtar
         IF Found()
            zez = tarzbir
            IF tarzbir = 0
               zez = 1
            ENDIF
            wp01 = tarrst/zez
            wp02 = tarost/zez
            wp03 = tarsst/zez
            wp04 = tarvoj/zez
            wp11 = tardp
            wp22 = tarkp    &&  vec oformljeni zbirovi u tardat
            wp33 = tarpor
            wp11 = wp11 + wpx
            wp22 = wp22 + wpy
            IF wp1 = 0 .AND. wp2 = 0
               wp33 = wp33 + wpor
            ENDIF
            REPLACE TARDP  WITH wp11
            REPLACE TARKP  WITH wp22
            REPLACE TARPOR WITH wp33
         ENDIF

         SELECT 9
         SEEK wtar
         IF ! Found()
            APPEND BLANK
            REPLACE TEMPTAR WITH wtar
            wmpv = 0
         ELSE
            wmpv = tempmpv
         ENDIF
         wmpv = wmpv + A->dmpmsp * A->dmpkol
         REPLACE TEMPMPV WITH wmpv
         wmpv = 0

         SELECT 1
         IF red > 58
            red = 1
            @ red,0 SAY " "
            DO naslovb
         ENDIF

         red = red + 1
         rb = rb + 1
         @ red,  5 SAY dmpnaz
         @ red, 36 SAY dmpjm
         @ red, 44 SAY Round(dmpnc,2) PICTURE "999,999,999,999.99"
         @ red, 68 SAY Round(dmpmbp * dmpkol,2) PICTURE "999,999,999,999.99"
         @ red, 98 SAY dmptar
         @ red,117 SAY dmpmsp PICTURE "999,999,999,999.99"
         red = red + 1
         @ red,  5 SAY dmpsif PICTURE "9999999999999"
         @ red, 34 SAY dmpkol PICTURE "9999999.999"
         @ red, 46 SAY Round(dmpnc * dmpkol,2) PICTURE "9,999,999,999.99"
         @ red, 68 SAY Round(wruc,2) PICTURE "999,999,999,999.99"
         @ red, 92 SAY Round(dmpmsp * dmpkol * perazez / 100,2) PICTURE "999,999,999,999.99"
         @ red,117 SAY Round(dmpmsp * dmpkol,2) PICTURE "999,999,999,999.99"
         IF ! (dmpppd = 0 .and. dmpppk = 0)
            red = red + 1
            @ red,50 SAY "PRENETI POREZ PO ("
            @ red,69 SAY dmpjm
            @ red,72 SAY ")"
            @ red+1,10 SAY "OD DOBAVLJACA"
            @ red+1,49 SAY "OBRACUNATI POREZ"
            @ red+1,79 SAY "ZA UPLATU"
            red = red + 2
            @ red, 4 SAY Round(dmpppd,2) PICTURE "999,999,999,999.99"
            @ red,38 SAY Round(dmpppk,2) PICTURE "999,999,999,999.99"
            @ red,67 SAY Round((dmpppk - dmpppd),2) PICTURE "999,999,999,999.99"
         ENDIF
         red = red + 1
         @ red,5 SAY Replicate("-",131)

         SKIP
      ENDDO

      IF red > 55
         bst = bst + 1
         red = 1
         @ red,  0 SAY " "
         @ red,130 SAY "str."
         @ red,134 SAY bst PICTURE "999"
      ENDIF

      red = red + 3
      @ red, 60 SAY "UKUPNO ZA KALKULACIJU"
      red = red + 1
      @ red,  4 SAY "FAKTURNA VREDNOST"
      @ red, 24 SAY "ZAVISNI TROSKOVI"
      @ red, 53 SAY "RAZLIKA U CENI"
      @ red, 75 SAY "MP VREDNOST BEZ PDV   "
      @ red,115 SAY "MP VREDNOST SA PDV    "
      red = red + 1
      @ red,  1 SAY Round(wnv+wprenpdv,2) PICTURE "999,999,999,999.99"
      @ red, 25 SAY Round(wzt,2) PICTURE "999,999,999,999.99"
      @ red, 49 SAY Round(wwruc - wprenpdv,2) PICTURE "999,999,999,999.99"
      @ red, 75 SAY Round(wvrb,2) PICTURE "999,999,999,999.99"
      @ red,115 SAY Round(wvr,2) PICTURE "999,999,999,999.99"

      SELECT 4
      GO TOP
      DO WHILE ! Eof()
         REPLACE TARDP WITH 0
         REPLACE TARKP WITH 0
         REPLACE TARPOR WITH 0
         SKIP
      ENDDO

      red = red + 2
      @ red,30 SAY "Obaveze prema dobavljacu:"
      @ red,78 SAY Round(wnv+wprenpdv,2) PICTURE "999,999,999,999.99"
      red = red + 2
      @ red,110 SAY "K A L K U L I S A O"
      red = red + 2
      @ red,108 SAY Replicate("-",22)
      @ red + 1,1 SAY " "

      EJECT
      Setprc(0,0)
   ENDDO

   IF lLaser
      ? Chr(27) + '&k0S' + Chr(27) + '(s10.5H'  && kondenz Off za laserski
   ELSE
      ? Chr(18)                                 && kondenz Off za matricni
   ENDIF

   EJECT
   SET DEVICE TO SCREEN
   SET PRINTER OFF
   SET PRINT TO
   EXIT
ENDDO

USE
ERASE TEMP.DBF
ERASE TEMPINTAR.NTX
CLOSE DATABASES

RETURN

***************************************************************
PROCEDURE cigb1

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
   wmarza1 = Val("000000000000.00")
   store wmarza1 to mPorOsnov,mPorIznos,mVrRab,mRuc,mPorIz,mPomozi,mPomozi1
   mNabCen = Val("00000.000000")
   perazez = Val("000.00")
   perazez = Round((dmppor * 100) / (dmppor + 100),2)
   store 0 to xzel,xrep,xsav3,xvoj,xtak,x01,x02,x03,x04,x05
   store 0 to wpom1,wpom2,wpom3,wpom4,wpom5,wpom6,wp01,wp02,wp03,wp04,wp05

   IF vrsta = "J" .or. vrsta = "P"
      mNabcen = Round(dmpnc / dmpkol,6)
      mVrRab1 = Round(dmpirab / dmpkol,6)
   ENDIF
   IF vrsta = "R"
      mNabCen = Round((dmpnc - dmpirab + dmpppd) / dmpkol,6)
      mVrRab1 = Round(dmpirab / dmpkol,6)
   ENDIF
   IF vrsta = "N"
      mNabCen = Round(dmpnc / dmpkol,6)
   ENDIF
   DO CASE
      CASE Vrsta = "A"
         wmarza1 = Round(Round((mNabCen + Akciza) * dmprab / 100,6) * dmpkol,2)
      CASE Vrsta = "T"
         wmarza1 = Round(Round((mNabCen + Taksa) * dmprab / 100,6) * dmpkol,2)
      CASE Vrsta = "S"
         wmarza1 = Round(Round((mNabCen + Akciza + Taksa) * dmprab / 100,6) * dmpkol,2)
      CASE Vrsta = "R"
         wmarza1 = dmpirab
         mPorIz = dmpppk
      CASE Vrsta = "O"
         mNabCen = Round(dmpnc / dmpkol,6)
         wmarza1 = Round(dmpvsp - (dmpnc + dmpppd) - dmpraz,2)
         mPorIz = dmpppk
   ENDCASE
   IF Vrsta = "P"
      mRuc = Round(Round(dmpmsp - mNabCen + mVrRab,6) * dmpkol,2)
      mPorIz = dmpppk
      wmarza1 = Round(dmpvsp - dmpnc - dmpraz - dmpziz,2)
   ENDIF
   IF vrsta = "J"
      mRuc = Round(Round(dmpmsp - mNabCen,6) * dmpkol,2)
      mPorIz = Round(mRuc * perazez / 100,2)
      wmarza1 = Round(mRuc - mPorIz,2)
   ENDIF

   IF red = 7
      DO nascigb
   ENDIF

   IF vrsta = "R"
      wnv = Round(wnv + dmpnc,2)
   ELSE
      IF vrsta = "O"
         wnv = wnv + Round(dmpnc + dmpppd,2)
      ELSE
         IF vrsta = "N"
            wnv = Round(wnv + dmpnc + dmpppd,2)
         ELSE
            wnv = Round(wnv + (mNabCen * dmpkol),2)
         ENDIF
      ENDIF
   ENDIF

   wakciza = Round(wakciza + akciza * dmpkol,2)
   wtaksa = Round(wtaksa + taksa * dmpkol,2)

   IF vrsta = "N"
      wmarza1 = Round(dmpirab - dmpraz,2)
      mPorIz = dmpppk
   ENDIF

   ww = ((dmpmbp * 100) / dmpnc) - 100
   wr = dmpirab
   wrab = wrab + wr
   wmarza = Round(wmarza + wmarza1,2)
   wzt = wzt + dmpziz
   wvr = Round(wvr + dmpmsp * dmpkol,2)
   wvrb = Round(wvrb + Round(dmpppk * 100 / dmppor,2),2)
   wp1 = dmpppd
   wp2 = dmpppk
   wp3 = dmppor
   wpx = wp1
   wpy = wp2
   wtar = dmptar
   wpor = mPorIz

   SELECT 4
   SEEK wtar
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
      REPLACE TARDP  WITH wp11
      REPLACE TARKP  WITH wp22
      REPLACE TARPOR WITH wp33
   ENDIF

   SELECT 9
   SEEK wtar
   IF ! Found()
      APPEND BLANK
      REPLACE TEMPTAR WITH wtar
      wmpv = 0
   ELSE
      wmpv = tempmpv
   ENDIF
   wmpv = wmpv + A->dmpmsp * A->dmpkol
   REPLACE TEMPMPV WITH wmpv
   wmpv = 0

   SELECT 1
   IF red > 58
      red = 1
      @ red,0 SAY " "
      DO nascigb
   ENDIF

   red = red + 1
   rb = rb + 1
   @ red,  5 SAY dmpnaz
   @ red, 36 SAY dmpjm
   @ red, 44 SAY Round(mNabCen,6) PICTURE "999,999,999.999999"
   @ red, 68 SAY Round(dmpppk * 100 / dmppor,2) PICTURE "999,999,999,999.99"
   @ red, 90 SAY substr(dmptar,1,4)
   @ red, 95 SAY Round(dmpvsp - dmpppk,2) PICTURE "9999,999,999.99"
   @ red,117 SAY dmpmsp PICTURE "999,999,999.99"
   red = red + 1
   @ red,  5 SAY dmpsif PICTURE "9999999999999"
   @ red, 34 SAY dmpkol PICTURE "9999999.999"
   @ red, 46 SAY Round(mNabCen * dmpkol,2) PICTURE "9,999,999,999.99"
   @ red, 68 SAY Round(wmarza1,2) PICTURE "999,999,999,999.99"
   @ red, 92 SAY mPorIz PICTURE "999,999,999,999.99"
   @ red,117 SAY Round(dmpmsp * dmpkol,2) PICTURE "999,999,999.99"
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
@ red, 60 SAY "UKUPNO ZA KALKULACIJU"
red = red + 1
@ red,  4 SAY "NABAVNA  VREDNOST"
@ red, 28 SAY "A  K  C  I  Z   A"
@ red, 50 SAY "T   A   K   S   A"
@ red, 75 SAY "RAZLIKA U CENI "
@ red, 92 SAY "OSNOVICA ZA PDV  "
@ red,115 SAY "MPV SA PDV     "   && POREZOM"
red = red + 1
@ red,  4 SAY Round(wnv + WZT,2) PICTURE "99,999,999,999.99"
@ red, 28 SAY Round(wakciza,2) PICTURE "99,999,999,999.99"
@ red, 50 SAY Round(wtaksa,2) PICTURE "99,999,999,999.99"
@ red, 75 SAY Round(wmarza,2) PICTURE "999,999,999.99"
@ red, 92 SAY Round(wvrb,2) PICTURE "99,999,999,999.99"
@ red,115 SAY Round(wvr,2) PICTURE "9,999,999,999.99"

IF red > 55
   red = 1
   @ red,0 SAY " "
   bst = bst + 1
   @ red,119 SAY "str."
   @ red,124 SAY bst PICTURE "999"
ENDIF

SELECT 4
GO TOP
DO WHILE ! Eof()
   zez = 0
   IF ! (TARDP = 0 .AND. TARKP = 0)
      IF indik = 0
         indik = 1
         red = red + 3
         @ red,50 SAY "REKAPITULACIJA PRENETOG POREZA"
         red = red + 1
         @ red, 1 SAY "TARIFA"
         @ red,15 SAY "OD DOBAVLJACA"
         @ red,35 SAY "OBRACUNATI POREZ"
         @ red,55 SAY "RAZLIKA ZA UPLATU"
      ENDIF

      red = red + 1
      @ red,1 SAY tarsif
      @ red,15 SAY Round(tardp,2) PICTURE "999,999,999,999.99"
      wdarko = wdarko + tardp
      wdijana = tarsif

      SELECT 9
      SEEK wdijana
      IF ! Found()
         wmpv = 0
      ELSE
         wmpv = tempmpv
      ENDIF

      SELECT 4
      @ red,35 SAY Round(tarkp,2) PICTURE "999,999,999,999.99"
      @ red,55 SAY Round((tarkp - tardp),2) PICTURE "999,999,999,999.99"
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
      wpom2 = Round(wpom1 * wp01,2)
      wpom3 = Round(wpom1 * wp02,2)
      wpom4 = Round(wpom1 * wp03,3)
      wpom5 = Round(wpom1 * wp04,3)
      wpom6 = Round(wpom1 * wp05,3)

      @ red,75 SAY Round(wpom2,2) PICTURE "99,999,999.99"
      @ red,89 SAY Round(wpom3,2) PICTURE "9999999.99"
      @ red,100 SAY Round(wpom4,2) PICTURE "9999999.99"
      @ red,111 SAY Round(wpom5,2) PICTURE "9999999.99"
      @ red,122 SAY Round(wpom6,2) PICTURE "9999999.99"

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
   @ red,  1 SAY "UKUPNO: "
   @ red, 15 SAY Round(rpd,2) PICTURE "999,999,999,999.99"
   @ red, 35 SAY Round(rpk,2) PICTURE "999,999,999,999.99"
   @ red, 55 SAY Round((rpk - rpd),2) PICTURE "999,999,999,999.99"
   @ red, 75 SAY Round(wrep,2) PICTURE "99,999,999.99"
   @ red, 89 SAY Round(wzel,2) PICTURE "9999999.99"
   @ red,100 SAY Round(wsav3,2) PICTURE "9999999.99"
   @ red,111 SAY Round(wvoj,2) PICTURE "9999999.99"
   @ red,122 SAY Round(wtak,2) PICTURE "9999999.99"
ENDIF

puk = puk + (rpk - rpd)
indik = 0

SELECT 4
GO TOP
DO WHILE ! Eof()
   REPLACE TARDP WITH 0
   REPLACE TARKP WITH 0
   REPLACE TARPOR WITH 0
   SKIP
ENDDO

red = red + 2
DO CASE
   CASE wVrsta = "P" .or. wVrsta = "N"
      @ red,10 SAY "OBAVEZA PREMA DOBAVLJACU:"  && (nabavna vrednost - rabat + akciza + taksa):"
      @ red,80 SAY wnv PICTURE "999,999,999.99"  && Round((wnv - wmarza + wakciza + wtaksa),2) PICTURE "999,999,999,999.99"
      red = red + 1
      @ red,10 SAY "ZAVISNI TROSKOVI"
      @ red,80 SAY wZT PICTURE "999,999,999.99"  && Round((wnv - wmarza + wakciza + wtaksa),2) PICTURE "999,999,999,999.99"
   CASE wVrsta = " "
      @ red,10 SAY "OBAVEZA PREMA DOBAVLJACU(nabavna vrednost - rabat + akciza + taksa):"
      @ red,80 SAY Round((wnv - wmarza + wakciza + wtaksa),2) PICTURE "999,999,999,999.99"
   CASE wVrsta = "R" .or. wvrsta = "J"
      @ red,10 SAY "OBAVEZA PREMA DOBAVLJACU:"
      @ red,80 SAY Round(wnv,2) PICTURE "999,999,999.99"
ENDCASE

red = red + 2
@ red,110 SAY "K A L K U L I S A O"
red = red + 2
@ red,108 SAY Replicate("-",22)
@ red + 1,1 SAY " "

EJECT
Setprc(0,0)
SELECT 1

RETURN
***************************************************************
