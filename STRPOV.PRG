* - nije pregledano - *

PUBLIC wdmpdob

b = Space(10)

USE DMPDAT
GO BOTTOM
b = Str(Val(dmpbro) + 1)
bdar = Space(10)
bdar = Ltrim(b) + "          "
bdar = Substr(bdar,1,10)
USE

WKRRB = VAL("0000")
USE RASHODN
GO BOTTOM
wkrrb = rrb + 1
USE

SELECT 1
USE DMPDAT INDEX DMPINBRO,DMPINBS
SELECT 2
USE ARTPANE INDEX APINSIF
SELECT 5
USE TARDAT INDEX TARINSIF

DO WHILE .T.   && main
	inddd = 0
	perazez = val("00.00")
	wdmpdat = date()
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
	bb = val("9999")
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
   Esckey()
   @ 1,13 SAY "POVRACAJ ROBE DOBAVLJACU SA KALKULACIJOM CENA"
   @ 2,10 SAY "Broj kalkulacije:"
   @ 2,28 GET bdar
   READ

	IF Lastkey() = 27
		EXIT
	ENDIF

   SELECT 1
   SEEK BDAR
   IF Found()
   	MessageBox("KALKULACIJA POD TIM BROJEM VEC POSTOJI")
      LOOP
   ENDIF

   SELECT 2
   @ 2,40 SAY "DATUM KALKULACIJE" GET wdmpdat
   READ
   
	IF Lastkey() = 27
   	EXIT
   ENDIF

   wdmpdfak = date()
   wdmpbk = bdar
   DO HELPP

   DO WHILE .T. &&   (2) u programu

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
      wdmpart = VAL("0000000000000")
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
      perazez = val("00.00")
      rezlika = val("000000000000.000000")

		@ 5,1 SAY "Sifra artikla:" GET wdmpart PICTURE "9999999999999"
		@ 5,35 SAY "kolicina za povracaj:" GET wdmpkol1 PICTURE "999999999999.999"
		@ 6,35 SAY "% razlike u ceni    :" GET wpruc PICTURE "99.99999"
		READ

		IF Lastkey() = 27
			ind = 1
			EXIT
		ENDIF
      
		SELECT 2
      SEEK wdmpart
      IF ! Found()
      	MessageBox("NEMA ARTIKLA SA TOM SIFROM")
      	@ 20,10 SAY Replicate(" ",68)
         LOOP
      ENDIF
      
		IF wdmpkol1 > artkol
			@ 20,10 SAY "NA LAGERU IMATE"
			@ 20,26 SAY artkol PICTURE "999,999.999"
			WAIT " "
			@ 20,10 SAY Replicate(" ",68)
			LOOP
		ENDIF

		wdmpnaz = artnaz
		wdmpjm = artjm
		wdmptar = arttar

		SELECT 5
		SEEK WDMPTAR
      IF Found()
			wtarzbir = tarsst + tarrst + tarost + tarvoj
			wvoz = tarost
      ELSE
			MessageBox("NEMA TARIFE ZA TAJ ARTIKAL.BRISITE KALKULACIJU,OTVORITE TARIFU,PA PONOVO!")
			@ 20,1 SAY Replicate(" ",78)
			CLOSE DATABASES
			CLEAR SCREEN
			RETURN
      ENDIF

		@ 4,0 SAY Space(80)
		@ 7,1 SAY wdmpnaz
		wdmpmsp = gnBod * B->artcen
		@ 21,1  SAY "MP cena sa por.:"  &&  GET wdmpmsp PICTURE "999999999999.99" VALID ! Empty(wdmpmsp)
		@ 21,18 SAY wdmpmsp PICTURE "999999999999.99"
		@ 21,34 SAY "MP vrednost sa por.:"
		wdmpvsp = Round(wdmpmsp * wdmpkol1,2)
		@ 21,55 SAY wdmpvsp PICTURE "999999999999.99"
		perazez = Round((wtarzbir * 100) / (wtarzbir + 100),2)
		wdmpmbp = Round(wdmpmsp - (perazez / 100) * wdmpmsp,2)
		@ 19,1  SAY "MP cena bez por.:"
		@ 19,18 SAY wdmpmbp PICTURE "999999999999.99"
		wbezv = Round(wdmpmbp * wdmpkol1,2)
		@ 19,35 SAY "Vredn.bez poreza:"
		@ 19,53 SAY wbezv PICTURE "999999999999.99"
		razlika = Round((wpruc / 100) * wdmpmbp,6)
		wnabc = Round(wdmpmbp - razlika,2)
		wdmpmap = Round((razlika * 100) / wnabc,2)
		wdmpmai = Round((wdmpmbp - wnabc) * wdmpkol1,2)
		@ 17,1  SAY "Raz. u ceni(marza %)"
		@ 17,23 SAY wdmpmap PICTURE "999.99"
		@ 17,31 SAY "Raz.u ceni (vrednost):"
		@ 17,55 SAY wdmpmai PICTURE "999999999999.99"
		@ 15,1  SAY "Nabavna cena:"
		@ 15,15 SAY wnabc PICTURE "999999999999.99"
		@ 15,31 SAY "Nabavna vrednost:"
		@ 15,50 SAY round(wnabc * wdmpkol1,2) PICTURE "999999999999.99"
      
		IF ! wdmpztp = 0
			prer = (100 * wdmpztp) / (wdmpztp + 100)
			wfcen = (1 - (prer / 100)) * wnabc
			wdmpzjm = wnabc - wfcen
			wdmpzti = wdmpzjm * wdmpkol1
      ELSE
			IF Lastkey() = 27
				ind = 1
				LOOP
			ENDIF
         wdmpzti = wdmpzjm * wdmpkol1
         wfcen = wnabc - wdmpzjm
      ENDIF

		@ 10,1 SAY "Fak.cena:"
		@ 10,11 SAY wfcen PICTURE "999999999999.99"
		@ 10,28 SAY "Fak.vrednost:"
		@ 10,43 SAY wfcen * wdmpkol1 PICTURE "999999999999.99"

		wdmpppd = (wtarzbir / 100) * (wdmpmsp - razlika)
		wdmpraz = (wtarzbir / 100) * razlika
		wdmpppk = wdmpppd + wdmpraz
		wdmpppd = 0
		wdmpppk = 0
		wdmpraz = 0

		@ 24,10 SAY "Upis obracunatih vrednosti  (d/n)? " GET dn PICTURE "!" VALID (dn $ "DN")
		READ
		IF Lastkey() = 27 .or. dn = "N"
			ind = 1
			FOR i = 4 TO 24
				@ i,0 SAY Replicate(" ",78)
			NEXT i
			LOOP
		ENDIF
      
		inddd = 1
      SELECT 2
		REPLACE ARTKOL WITH (ARTKOL - wdmpkol1)

		SELECT 1
		APPEND BLANK
		REPLACE dmpsif  WITH wdmpart
		REPLACE dmpnaz  WITH wdmpnaz
		REPLACE dmpjm   WITH wdmpjm
		REPLACE dmpkol  WITH wdmpkol1
		REPLACE dmpnc   WITH wfcen
		REPLACE dmpppd  WITH wdmpppd
		REPLACE dmpztr  WITH wdmpztp
		REPLACE dmpziz  WITH wdmpzti
		REPLACE dmpmar  WITH wdmpmap
		REPLACE dmpmiz  WITH wdmpmai
		REPLACE dmpmbp  WITH wdmpmbp
		REPLACE dmpppk  WITH wdmpppk
		REPLACE dmpraz  WITH wdmpraz
		REPLACE dmppor  WITH wtarzbir
		REPLACE dmptar  WITH wdmptar
		REPLACE dmpmsp  WITH wdmpmsp
		REPLACE dmpvsp  WITH wdmpvsp
		REPLACE dmpbro  WITH bdar
		REPLACE dmpdat  WITH wdmpdat
		REPLACE dmprab  WITH wdmprab
		REPLACE dmpdob  WITH wdmpdob
		REPLACE dmpirab WITH wirab
		REPLACE dmpfak  WITH Str(0)
		REPLACE dmpdfak WITH wdmpdat

      DO KNOVMIN
      wdmpart = wdmpart + 1

		* ubacen deo za rashod;  vrsi racunanje zbirova
      s1 = s1 + round(wdmpkol1 * wfcen,2)
      s2 = s2 + round((wdmpmbp - wfcen) * wdmpkol1,2)
      s3 = s3 + round(wdmpmsp * wdmpkol1 * perazez / 100,2)
      s4 = s4 + wdmpvsp
      s5 = s1

      KRPAA1()
      SELECT 1
   ENDDO && (2) u algoritmu
   
	IF ind = 0
   	LOOP
   ENDIF

	* upis u datoteku rashod
	IF inddd = 1
		USE RASHODN INDEX RASHINKN,RASHINDN
		APPEND BLANK
		REPLACE rrb WITH wkrrb
		REPLACE rdk WITH wdmpdat
		REPLACE ropis WITH "KALKULACIJA POVRACAJA"
		REPLACE rbr WITH bdar
		REPLACE rdatdok WITH wdmpdat
		REPLACE rnvrrr WITH (s1 * (-1))
		REPLACE rrucp WITH (s2 * (-1))
		REPLACE robpor WITH (s3 * (-1))
		REPLACE rprodv WITH (s4 * (-1))
		REPLACE rrasuk WITH (s5 * (-1))
		USE
	ENDIF

   EXIT
ENDDO   && *** main

CLOSE DATABASES
CLEAR SCREEN

RETURN

***************************************
PROCEDURE Krpaa1
	FOR i = 7 TO 24
		@ i,0 SAY Replicate(" ",78)
	NEXT i
RETURN
***************************************
