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

   SELECT 1
   indik = 0

   MainMask("STAMPA KALKULACIJE PO BROJU")

   wdmpbro = Space(10)
   wnv = Val("000000000000.00")
   wprenpdv = Val("000000000000.00")
   wporpaus = Val("000000000000.00")
   store wnv to wakciza,wtaksa
   wvrb = Val("000000000000.00")
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

   @ 3,2 SAY "Kalkulacija: " GET wdmpbro PICTURE "@!" VALID ! Empty(wdmpbro)
   READ

   IF Lastkey() = 27
      EXIT
   ENDIF

   SEEK wdmpbro
   IF ! Found()
      MessageBox("Ne postoji takva kalkulacija!")
      LOOP
   ENDIF

   wdmpdat  = DMPDAT
   wdmpfak  = DMPFAK
   wdmpdfak = DMPDFAK
   wpp      = DMPDOB

   @ 3,40 SAY "Datum:"
   ?? wdmpdat
   @ 3,60 SAY "Posl.partner"

   SELECT 2
   SEEK wpp
   IF ! Found()
      wnaz = Space(30)
   ELSE
      wnaz = PPNAZ
   ENDIF

   SELECT 1

   SET CONSOLE OFF
   SET ALTERNATE TO c:\PK\kalk.html
   SET ALTERNATE ON
   header("Stampa kalkulacije","kalk.css")
   makeHeader(Alltrim(gcNazRad) + " - kalkulacija")

   * odluka koja je kalkulacija
   IF ! Empty(vrsta)
      DO cigb
      RETURN
   ENDIF

   DO naslovb
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

      ? TR_El_open("gore", 12)
      ? TD_El_Str(dmpnaz,12)
      ? TD_El_Str(dmpjm,12)
      ? TD_El_Num(dmpnc,2,12)
      ? TD_El_Num(dmpmbp * dmpkol,2,12)
      ? TD_El_Str(dmptar,12)
      ? TD_El_Str("",12)
      ? TD_El_Num(dmpmsp,2,12)
      ? TR_El_close("gore", 12)

      ? TR_El_open("dole", 12)
      ? TD_El_Str(Str(dmpsif,13,0),12)
      ? TD_El_Num(dmpkol,3,12)
      ? TD_El_Num(dmpnc * dmpkol,2,12)
      ? TD_El_Num(wruc,2,12)
      ? TD_El_Str("",12)
      ? TD_El_Num(dmpmsp * dmpkol * perazez / 100,2,12)
      ? TD_El_Num(dmpmsp * dmpkol,2,12)
      ? TR_El_close("dole", 12)

      IF ! (dmpppd = 0 .and. dmpppk = 0)
         ? TR_El_open("", 12)
         ? General_El('<td colspan="7" class="centriraj">PRENETI POREZ PO (' + dmpjm + ')</td>',12)
         ? TR_El_close("", 12)
         
         ? TR_El_open("", 12)
         ? General_El('<td colspan="2" class="centriraj">Od dobavljaca</td>',12)
         ? General_El('<td colspan="3" class="centriraj">Obracunati porez</td>',12)
         ? General_El('<td colspan="2" class="centriraj">Za ulplatu</td>',12)
         ? TR_El_close("", 12)
         
         ? TR_El_open("podvuci", 12)
         ? General_El('<td colspan="2" class="centriraj">' + Alltrim(Str(Round(dmpppd,2),15,2)) + '</td>',12)
         ? General_El('<td colspan="3" class="centriraj">' + Alltrim(Str(Round(dmpppk,2),15,2)) + '</td>',12)
         ? General_El('<td colspan="2" class="centriraj">' + Alltrim(Str(Round(dmpppk - dmpppd,2),15,2)) + '</td>',12)
         ? TR_El_close("podvuci", 12)
      ENDIF

      SKIP
   ENDDO
   
   ? TBL_El_close("kalk-table", 6)
   ? General_El('<div class="futer">',9)

   ? TBL_El_open("", 9)

   ? TR_EL_open("", 12)
   ? Space(12) + "<th colspan='5'>UKUPNO ZA KALKULACIJU</th>"
   ? TR_EL_close("", 12)

   ? TR_EL_open("", 12)
   ? Space(12) + "<th>FAKTURNA VREDNOST</th><th>ZAVISNI TROSKOVI</th><th>RAZLIKA U CENI</th><th>MP VREDNOST BEZ PDV</th><th>MP VREDNOST SA PDV</th>"
   ? TR_EL_close("", 12)

   ? TR_EL_open("", 12)
   ? TD_EL_Num(wnv+wprenpdv, 2, 12)
   ? TD_EL_Num(wzt, 2, 12)
   ? TD_EL_Num(wwruc - wprenpdv, 2, 12)
   ? TD_EL_Num(wvrb, 2, 12)
   ? TD_EL_Num(wvr, 2, 12)
   ? TR_EL_close("", 12)

   ? TBL_El_close("", 9)

   SELECT 4
   GO TOP
   DO WHILE ! Eof()
      REPLACE TARDP WITH 0
      REPLACE TARKP WITH 0
      REPLACE TARPOR WITH 0
      SKIP
   ENDDO

   ? TBL_El_open("kalk-rezime", 9)

   ? TR_EL_open("", 12)
   ? TH_EL_Str("Obaveze prema dobavljacu:",12)
   ? TD_EL_Num(wnv+wprenpdv, 2, 12)
   ? TR_EL_close("", 12)

   ? TBL_El_close("kalk-rezime", 9)

   ? General_El('<p class="potpis">K A L K U L I S A O</p>',9)
   ? General_El("</div> <!-- futer -->",9)
   ? General_El("</div> <!-- kalk -->",6)
   
   EXIT
ENDDO

DO futer

SET ALTERNATE TO
SET ALTERNATE OFF
SET CONSOLE ON

USE
ERASE TEMP.DBF
ERASE TEMPINTAR.NTX
CLOSE DATABASES

RETURN

***************************************************************
PROCEDURE naslovb

? General_El('<div class="kalk">',6)
? TBL_El_open("kalk-zaglavlje", 9)

? TR_El_open("", 12)
? TD_El_Str(gcNazRad, 12)
? TD_El_Str("", 12)
? TD_El_Str("PK-1:____  PK-2:____  KPP:____", 12)
? TR_El_close("", 12)

? TR_El_open("", 12)
? TD_El_Str("Fakt/otpr dobavljaca: " + Alltrim(wdmpfak), 12)
? TD_El_Str("Datum: " + DtoC(wdmpdfak), 12)
? TD_El_Str("", 12)
? TR_El_close("", 12)

? TR_El_open("", 12)
? TD_El_Str("Kalkulacija: " + Alltrim(wdmpbro), 12)
? TD_El_Str("Datum: " + DtoC(wdmpdat), 12)
? TD_El_Str("Dobavljac: " + Alltrim(Str(wpp,6)) + " " + Alltrim(wnaz), 12)
? TR_El_close("", 12)

? TBL_El_close("kalk-zaglavlje", 9)

? TBL_El_open("kalk-table", 9)

? General_El("<thead>",9)
? TR_El_open("", 12)
? TH_El_Str("Naziv artikla<br/>Sifra artikla", 12)
? TH_El_Str("JM<br/>Kol", 12)
? TH_El_Str("Cena po jed mere<br/>Ukupna cena po jed mere", 12)
? TH_El_Str("Osnovica za PDV<br/>Razlika u ceni", 12)
? TH_El_Str("TR/ST", 12)
? TH_El_Str("MVP bez PDV<br/>Uk porez na promet", 12)
? TH_El_Str("MPC sa PDV<br/>MPV sa PDV", 12)
? TR_El_close("", 12)
? General_El("</thead>",9)

RETURN

***************************************************************
PROCEDURE cigb

DO nascigb

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

   ? TR_El_open("gore", 12)
   ? TD_El_Str(dmpnaz,12)
   ? TD_El_Str(dmpjm,12)
   ? TD_El_Num(mNabCen,6,12)
   ? TD_El_Num(dmpppk * 100 / dmppor,2,12)
   ? TD_El_Str(dmptar,12)
   ? TD_El_Num(dmpvsp - dmpppk,2,12)
   ? TD_El_Num(dmpmsp,2,12)
   ? TR_El_close("gore", 12)

   ? TR_El_open("dole", 12)
   ? TD_El_Str(Str(dmpsif,13,0),12)
   ? TD_El_Num(dmpkol,3,12)
   ? TD_El_Num(mNabCen * dmpkol,2,12)
   ? TD_El_Num(wmarza1,2,12)
   ? TD_El_Str("",12)
   ? TD_El_Num(mPorIz,2,12)
   ? TD_El_Num(dmpmsp * dmpkol,2,12)
   ? TR_El_close("dole", 12)

   SKIP
ENDDO
? TBL_El_close("kalk-table", 9)

? General_El('<div class="futer">',9)

? TBL_El_open("kalk-uk", 9)

? TR_EL_open("", 12)
? Space(12) + "<th colspan='6'>UKUPNO ZA KALKULACIJU</th>"
? TR_EL_close("", 12)

? TR_EL_open("", 12)
? Space(12) + "<th>Nabavna vrednost</th><th>Akciza</th><th>Taksa</th><th>Razlika u ceni</th><th>Osnovica za PDV</th><th>MPV SA PDV</th>"
? TR_EL_close("", 12)

? TR_EL_open("", 12)
? TD_EL_Num(wnv + WZT, 2, 12)
? TD_EL_Num(wakciza, 2, 12)
? TD_EL_Num(wtaksa, 2, 12)
? TD_EL_Num(wmarza, 2, 12)
? TD_EL_Num(wvrb, 2, 12)
? TD_EL_Num(wvr, 2, 12)
? TR_EL_close("", 12)

? TBL_El_close("kalk-uk", 9)

SELECT 4
GO TOP
DO WHILE ! Eof()
   zez = 0
   IF ! (TARDP = 0 .AND. TARKP = 0)
      IF indik = 0
         indik = 1

         ? TBL_El_open("kalk-porez", 9)

         ? TR_EL_open("", 12)
         ? Space(12) + "<th colspan='9'>REKAPITULACIJA PRENETOG POREZA</th>"
         ? TR_EL_close("", 12)

         ? TR_EL_open("", 12)
         ? Space(12) + "<th>Tarifa</th><th>Od dobavljaca</th><th>Obracunati porez</th><th>Razlika za uplatu</th><th></th><th></th><th></th><th></th><th></th>"
         ? TR_EL_close("", 12)
      ENDIF

      ? TR_EL_open("", 12)
      ? TD_EL_Str(tarsif, 12)
      ? TD_EL_Num(tardp, 2, 12)
      
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

      ? TD_EL_Num(tarkp, 2, 12)
      ? TD_EL_Num(tarkp - tardp, 2, 12)

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

      ? TD_EL_Num(wpom2, 2, 12)
      ? TD_EL_Num(wpom3, 2, 12)
      ? TD_EL_Num(wpom4, 2, 12)
      ? TD_EL_Num(wpom5, 2, 12)
      ? TD_EL_Num(wpom6, 2, 12)
      ? TR_EL_close("", 12)

      wrep = wrep + wpom2
      wzel = wzel + wpom3
      wsav3 = wsav3 + wpom4
      wvoj = wvoj + wpom5
      wtak = wtak + wpom6
      rpd = rpd + tardp
      rpk = rpk + tarkp

      * IF red > 58
      *  indik = 0
      * ENDIF
   ENDIF

   SKIP
ENDDO

IF ! (rpd = 0 .and. rpk = 0)

   ? TR_EL_open("", 12)
   ? TD_EL_Str("UKUPNO:", 12)
   ? TD_EL_Num(rpd, 2, 12)
   ? TD_EL_Num(rpk, 2, 12)
   ? TD_EL_Num(rpk - rpd, 2, 12)
   ? TD_EL_Num(wrep, 2, 12)
   ? TD_EL_Num(wzel, 2, 12)
   ? TD_EL_Num(wsav3, 2, 12)
   ? TD_EL_Num(wvoj, 2, 12)
   ? TD_EL_Num(wtak, 2, 12)
   ? TR_EL_close("", 12)

ENDIF

? TBL_El_close("kalk-porez", 9)

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

DO CASE
   CASE wVrsta = "P" .or. wVrsta = "N"
      ? TBL_El_open("kalk-rezime", 9)

      ? TR_EL_open("", 12)
      ? TD_EL_Str("Obaveza prema dobavljacu:",12)
      ? TD_EL_Num(wnv, 2, 12)
      ? TR_EL_close("", 12)

      ? TR_EL_open("", 12)
      ? TD_EL_Str("Zavisni troskovi:",12)
      ? TD_EL_Num(wZT, 2, 12)
      ? TR_EL_close("", 12)

      ? TBL_El_close("kalk-rezime", 9)

   CASE wVrsta = " "
      ? TBL_El_open("kalk-rezime", 9)

      ? TR_EL_open("", 12)
      ? TD_EL_Str("OBAVEZA PREMA DOBAVLJACU(nabavna vrednost - rabat + akciza + taksa):",12)
      ? TD_EL_Num(wnv - wmarza + wakciza + wtaksa, 2, 12)
      ? TR_EL_close("", 12)

      ? TBL_El_close("kalk-rezime", 9)

   CASE wVrsta = "R" .or. wvrsta = "J"
      ? TBL_El_open("kalk-rezime", 9)

      ? TR_EL_open("", 12)
      ? TD_EL_Str("OBAVEZA PREMA DOBAVLJACU:",12)
      ? TD_EL_Num(wnv, 2, 12)
      ? TR_EL_close("", 12)

      ? TBL_El_close("kalk-rezime", 9)
ENDCASE

   ? General_El('<p class="potpis">K A L K U L I S A O</p>',9)
   ? General_El("</div> <!-- futer -->",9)

   ? General_El("</div> <!-- kalk -->",6)
   
DO futer

SET ALTERNATE TO
SET ALTERNATE OFF
SET CONSOLE ON

USE
ERASE TEMP.DBF
ERASE TEMPINTAR.NTX
CLOSE DATABASES

RETURN

***************************************************************
PROCEDURE nascigb

? General_El('<div class="kalk">',6)
? TBL_El_open("kalk-zaglavlje", 9)

? TR_El_open("", 12)
? TD_El_Str(gcNazRad, 12)
? TD_El_Str("", 12)
? TD_El_Str("PK-1:____  PK-2:____  KPP:____", 12)
? TR_El_close("", 12)

? TR_El_open("", 12)
? TD_El_Str("Fakt/otpr dobavljaca: " + Alltrim(wdmpfak), 12)
? TD_El_Str("Datum: " + DtoC(wdmpdfak), 12)
? TD_El_Str("", 12)
? TR_El_close("", 12)

? TR_El_open("", 12)
? TD_El_Str("Kalkulacija: " + Alltrim(wdmpbro), 12)
? TD_El_Str("Datum: " + DtoC(wdmpdat), 12)
? TD_El_Str("Dobavljac: " + Alltrim(Str(wpp,6)) + " " + Alltrim(wnaz), 12)
? TR_El_close("", 12)

? TBL_El_close("kalk-zaglavlje", 9)

? TBL_El_open("kalk-table", 9)

? General_El("<thead>",9)
? TR_El_open("", 12)
? TH_El_Str("Naziv artikla<br/>Sifra artikla", 12)
? TH_El_Str("JM<br/>Kol", 12)
? TH_El_Str("Cena po jed mere<br/>Ukupna cena po jed mere", 12)
? TH_El_Str("Osnovica za PDV<br/>Razlika u ceni", 12)
? TH_El_Str("TR/ST", 12)
? TH_El_Str("MVP bez PDV<br/>Uk porez na promet", 12)
? TH_El_Str("MPC sa PDV<br/>MPV sa PDV", 12)
? TR_El_close("", 12)
? General_El("</thead>",9)

RETURN

***************************************************************
