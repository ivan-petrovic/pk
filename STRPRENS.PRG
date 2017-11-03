IF File("temp.dbf")
	Erase temp.dbf
ENDIF
IF File("tempintar.ntx")
	Erase tempintar.ntx
ENDIF

CREATE RADNA
STORE "temptar   c8  " TO polje1
STORE "tempmpv   n152" TO polje2
FOR i = 1 TO 2
	broj = str(i,1)
   p1 = "polje" + broj
   APPEND BLANK
   REPLACE field_name WITH SubStr(&p1,1,10)
	REPLACE field_type WITH SubStr(&p1,11,1)
	REPLACE field_len  WITH Val(SubStr(&p1,12,2))
	REPLACE field_dec  WITH Val(SubStr(&p1,14,1))
NEXT i
CREATE TEMP FROM RADNA
INDEX ON TEMPTAR TO TEMPINTAR
ERASE RADNA.DBF
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
SELECT 3
USE PRENDOS INDEX PRENKALI

DO WHILE .T.
	SELECT 1
   STORE 0 TO indik,indik1,indik2

	CLEAR SCREEN
   DO ESCK
   @ 1,30 SAY "STAMPA DOSTAVNICA"

	wdmpbro = Space(10)
	xxx     = 0
	yyy     = 0
	wnv     = Val("000000000000.00")
	wvrb    = Val("000000000000.00")
	rb      = 0
	wdarko  = 0
	wr      = 0
	wrab    = 0
	wmarza  = Val("000000000000.00")
	wzt     = Val("000000000000.00")
	wvr     = Val("000000000000.00")
	wmpv = 0
	rpd  = 0
	rpk  = 0
	ruk  = 0
	puk  = 0

	@ 3,1 SAY "Kalkulacija dostavnice:" GET wdmpbro PICTURE "@!" VALID ! Empty(wdmpbro)
   READ

	IF Lastkey() = 27
		EXIT
	ENDIF

	SEEK wdmpbro
   IF ! Found()
   	MessageBox("Ne postoji takva kalkulacija dostavnice!")
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

	SELECT 3
	SEEK wdmpbro      && trazimo broj dostavnice
	IF Found()
		wprenbr = PRENBR
	ELSE
		wprenbr = 0
	ENDIF

   SELECT 1
   red = 7
   bst = 0

	SET DEVICE TO PRINTER
   SET PRINTER TO LPT1
   * SET PRINTER TO LISTA
   SET PRINTER ON
   SetPrc(0,0)
   IF lLaser
      ? Chr(27) + '(s17.5H'      && kondenz On za laserski
   ELSE
      ? Chr(15)                  && kondenz On za matricni
   ENDIF

   DO WHILE (DMPBRO = wdmpbro) .AND. ! Eof()
		perazez = Val("00.00")
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
		store 0 to xzel,xrep,xsav3,xvoj,x01,x02,x03,x04
		store 0 to wpom1,wpom2,wpom3,wpom4,wpom5,wp01,wp02,wp03,wp04

		IF red = 7
         DO JJJ
      ENDIF

		perazez = Round((dmppor * 100) / (dmppor + 100),2)
      wnv = wnv + (dmpnc * dmpkol)
      ww = ((dmpmbp * 100) / dmpnc) - 100
      wr = dmpirab
		wrab = wrab + wr
		wmarza = wmarza + dmpmiz
		wzt = wzt + dmpziz
		wvr = wvr + dmpvsp
		wvrb = wvrb + (dmpmbp * dmpkol)
		wp1 = dmpppd
		wp2 = dmpppk
		wp3 = dmppor
		wpx = wp1 * dmpkol
		wpy = wp2 * dmpkol
		wtar = dmptar
      wpor = Round(dmpmsp * dmpkol * perazez / 100,2)

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
			wp22 = tarkp
			wp33 = tarpor
			wp11 = wp11 + wpx
			wp22 = wp22 + wpy
         IF wp1 = 0 .AND. wp2 = 0
         	wp33 = wp33 + wpor
         ENDIF
         REPLACE TARDP WITH wp11
         REPLACE TARKP WITH wp22
         REPLACE TARPOR WITH wp33
      ENDIF

      SELECT 9
      SEEK wtar
      IF ! Found()
      	APPEND BLANK
         REPLACE TEMPTAR WITH wtar
         wmpv = 0
      ELSE
         wmpv = TEMPMPV
      ENDIF

		wmpv = wmpv + A->dmpmsp * A->dmpkol
      REPLACE TEMPMPV WITH wmpv
      wmpv = 0

      SELECT 1
      IF red > 58
      	red = 1
         @ red,0 SAY " "
         DO JJJ
      ENDIF
      red = red + 1
      rb = rb + 1

		@ red,5 SAY dmpnaz
		@ red,36 SAY dmpjm
		@ red,44 SAY Round(dmpnc,2) PICTURE "999,999,999,999.99"
		@ red,68 SAY Round(dmpmbp * dmpkol,2) PICTURE "999,999,999,999.99"
		@ red,98 SAY dmptar
		@ red,117 SAY dmpmsp PICTURE "999,999,999,999.99"
		red = red + 1

		@ red,5 SAY dmpsif PICTURE "999999"
		@ red,36 SAY dmpkol PICTURE "99999.999"
		@ red,46 SAY Round(dmpnc * dmpkol,2) PICTURE "9,999,999,999.99"
		@ red,68 SAY Round((dmpmbp - dmpnc) * dmpkol,2) PICTURE "999,999,999,999.99"
		@ red,92 SAY Round(dmpmsp * dmpkol * perazez / 100,2) PICTURE "999,999,999,999.99"
		@ red,117 SAY Round(dmpmsp * dmpkol,2) PICTURE "999,999,999,999.99"

		IF ! (dmpppd = 0 .AND. dmpppk = 0)
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

		SELECT 1
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
	@ red,75  SAY "MP vrednost bez poreza"
	@ red,115 SAY "MP vrednost sa porezom"
	red = red + 1
	@ red,1 SAY Round(wnv,2) PICTURE "999,999,999,999.99"
	@ red,25 SAY Round(wzt,2) PICTURE "999,999,999,999.99"
	@ red,49 SAY Round(wmarza,2) PICTURE "999,999,999,999.99"
	@ red,75 SAY Round(wvrb,2) PICTURE "999,999,999,999.99"
	@ red,115 SAY Round(wvr,2) PICTURE "999,999,999,999.99"

	IF red > 55
		red = 1
		@ red,0 SAY " "
		bst = bst + 1
		@ red,130 SAY "str."
		@ red,134 SAY bst PICTURE "999"
   ENDIF

	SELECT 4
   GO TOP
   DO WHILE ! Eof()
   	zez = 0
      IF ! (tardp = 0 .AND. tarkp = 0)
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
			@ red,15 SAY Round(tardp,2) PICTURE "999,999,999,999.99"
			wdarko = wdarko + tardp
			wdijana = tarsif

			SELECT 9
         SEEK wdijana
         IF ! Found()
         	wmpv = 0
         ELSE
         	wmpv = TEMPMPV
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
			wpom2 = wpom1 * wp01
			wpom3 = wpom1 * wp02
			@ red,75 SAY Round(wpom2,2) PICTURE "999,999,999,999.99"
			@ red,95 SAY Round(wpom3,2) PICTURE "999,999,999,999.99"
			@ red,115 SAY Round(wmpv,2) PICTURE "999,999,999,999.99"
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
   IF ! (rpd = 0 .AND. rpk = 0)
		@ red,1 SAY "UKUPNO: "
		@ red,15 SAY Round(rpd,2) PICTURE "999,999,999,999.99"
		@ red,35 SAY Round(rpk,2) PICTURE "999,999,999,999.99"
		@ red,55 SAY Round((rpk - rpd),2) PICTURE "999,999,999,999.99"
		@ red,75 SAY Round(wrep,2) PICTURE "999,999,999,999.99"
		@ red,95 SAY Round(wzel,2) PICTURE "999,999,999,999.99"
   ENDIF

	puk = puk + (rpk - rpd)
   indik = 0

	SELECT 4
	GO TOP
   DO WHILE ! Eof()
   	zez = 0
      IF ! tarpor = 0 .or. tarzbir = 0
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
				@ red,108 SAY "MALOPR.VREDNOST PO TARIFI"
			ENDIF

			red = red + 1
         @ red,1 SAY tarsif
         wdijana = tarsif

			SELECT 9
         SEEK wdijana
         IF ! Found()
         	wmpv = 0
         ELSE
            wmpv = TEMPMPV
         ENDIF

         SELECT 4
			@ red,15 SAY Round(tarpor,2) PICTURE "999,999,999,999.99"
			xrep = tarpor * wp01
			xzel = tarpor * wp02
			zez = tarzbir
			IF tarzbir = 0
				zez = 1
			ENDIF
			xrep = tarpor * (tarrst / zez)
			xzel = tarpor * (tarost / zez)
			xsav3 = tarpor * (tarsst / zez)
			xVOJ = tarpor * (tarvoj / zez)
			@ red,35 SAY Round(xrep,2) PICTURE "999,999,999,999.99"
			@ red,55 SAY Round(xzel,2) PICTURE "9999999.99"
			@ red,66 SAY Round(xsav3,2) PICTURE "9,999,999.99"
			@ red,79 SAY Round(xvoj,2) PICTURE "9,999,999.99"
			@ red,115 SAY Round(wmpv,2) PICTURE "999,999,999,999.99"
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
		@ red,15 SAY Round(ruk,2) PICTURE "999,999,999,999.99"
		@ red,35 SAY Round(x01,2) PICTURE "999,999,999,999.99"
		@ red,55 SAY Round(x02,2) PICTURE "9999999.99"
		@ red,66 SAY Round(x03,2) PICTURE "9,999,999.99"
		@ red,79 SAY Round(x04,2) PICTURE "9,999,999.99"
	ENDIF

	puk = puk + ruk
   red = red + 2
	@ red,1 SAY "Ukupan porez"
	@ red,35 SAY "Republ.porez"
	@ red,55 SAY "Zel.porez"
	@ red,66 SAY "Dod.por. 3 %"
	@ red,79 SAY "Poseb.savezni"
	red = red + 2
	@ red,1 SAY Round(puk,2) PICTURE "999,999,999,999.99"
	@ red,35 SAY Round((wrep + x01),2) PICTURE "999,999,999,999.99"
	@ red,55 SAY Round((wzel + x02),2) PICTURE "9999999.99"
	@ red,66 SAY Round((wsav3 + x03),2) PICTURE "9,999,999.99"
	@ red,79 SAY Round((wvoj + x04),2) PICTURE "9,999,999.99"

	SELECT 4
	GO TOP
	DO WHILE ! Eof()
		REPLACE TARDP  WITH 0
		REPLACE TARKP  WITH 0
		REPLACE TARPOR WITH 0
		SKIP
	ENDDO

   red = red + 2
   @ red,110 SAY "K A L K U L I S A O"
   red = red + 2
   @ red,108 SAY Replicate("-",22)
   @ red + 1,1 SAY " "

   IF lLaser
      ? Chr(27) + '&k0S' + Chr(27) + '(s10.5H'  && kondenz Off za laserski
   ELSE
      ? Chr(18)                                 && kondenz Off za matricni
   ENDIF

   EJECT
   SET DEVICE TO SCREEN
   SET PRINTER OFF
   EXIT
ENDDO

USE
ERASE TEMP.DBF
ERASE TEMPINTAR.NTX
CLOSE DATABASES

RETURN

PROCEDURE JJJ
	red = 7
	bst = bst + 1
	@ 1 , 5 SAY gcNazRad
	@ 1 ,95 SAY "PK-1:____  PK-2:____  KPP:____"
	@ 1,129 SAY "str."
	@ 1,133 SAY bst PICTURE "999"
	@ 2 , 5 SAY "INTERNA DOSTAVNICA :"
	@ 2 ,26 SAY wprenbr PICTURE "9999"
	@ 2 ,39 SAY "Datum:"
	@ 2 ,47 SAY wdmpdfak
	@ 3 , 4 SAY "KALKULACIJA BROJ     :"
	@ 3 ,28 SAY wdmpbro
	@ 3 ,44 SAY "DATUM:"
	@ 3 ,54 SAY wdmpdat
	@ 3 ,74 SAY "DOBAVLJAC:"
	@ 3 ,93 SAY wpp
	@ 3 ,99 SAY wnaz
	@ 4 , 5 SAY Replicate ("*",131)
	@ 5 , 5 SAY "NAZIV ARTIKLA"
	@ 5 ,37 SAY "JM "
	@ 5 ,45 SAY "CENA PO JED MERE"
	@ 5 ,71 SAY "MP VRED. BEZ P/P"
	@ 5 ,99 SAY "TR/ST"
	@ 5,119 SAY "MPC SA P/P PO JM"
	@ 6 , 5 SAY "SIFRA ARTIKLA"
	@ 6 ,37 SAY "KOL"
	@ 6 ,45 SAY "UKP CEN PO JM"
	@ 6 ,71 SAY "RAZLIKA U CENI"
	@ 6 ,99 SAY "UK POREZ NA PROMET"
	@ 6,119 SAY "UKUPNA MPC SA P/P"
	@ 7 , 5 SAY Replicate("*",131)
RETURN
