*******************************************
* Program za izradu kalkulacije
*******************************************
LOCAL b, mod, wq, Izbor, cEkran, nPoslIzbor
LOCAL wDmpNvr, wPriv, wIzn
LOCAL wKropkr, wKropk1, wRb, wOpk

PRIVATE wDmpBk, wDmpKol, wTarZbir, wDmpVsp, wDmpDat
PRIVATE wDmpArt, wArtCen, wDmpMsp 
PRIVATE wKrRb, wDmpFak, wKrOpk, wDmpDob, kpc, mTaksa
PRIVATE wVoz, wDmpTar, wDmpPpd, wDmpPpk, wDmpDFak
PRIVATE s1, s2, s3, s4, s5, s6, indik, DN
* prebacene u PRIVATE na osnovu PIVOKOSO fajla koji se poziva
* iz ovog potprograma
PRIVATE wwDmpPpd, wwDmpPpk, UpisRa, Prer, wKrBDok
PRIVATE wKrBof, wKrDof, wKljuc, wDmpNaz, wDmpJM
PRIVATE wDmpZtp, wDmpZti, wDmpMap, wDmpMaI, wDmpMbp, wDmpRaz
* prebacene u PRIVATE na osnovu KDMPNAZA fajla koji se poziva
* iz ovog potprograma
PRIVATE wFCen, wCenRac, wDmpZjm, wIRab, wDmpRab, wDmpNC

b = Space(10)
wDmpBk = Space(10)

USE DMPDAT
GO BOTTOM
b = Str(Val(DMPBRO) + 1)
wDmpBk = Ltrim(b) + Space(11)
wDmpBk = Substr(wDmpBk,1,10)
USE

wKrRb = Val("0000")
USE RASHODN
GO BOTTOM
wKrRb = RRB + 1
USE

DO WHILE .T.

	SELECT 1
	USE DMPDAT INDEX DMPINBRO,DMPINBS
	SELECT 2
	USE TARDAT INDEX TARINSIF
	SELECT 3
	USE ARTPANE INDEX APINSIF

	MainMask("IZRADA MALOPRODAJNE KALKULACIJE")
	
	*******************************************
	* Inicijalizacija potrebnih promenljivih
	*******************************************
   UpisRa = 0
   indik = 0
	dn = " "
	
	wDmpDob  = Val("000000")					&& Poslovni partner
	wDmpDat  = Date()								&& Datum kalkulacije
	wDmpFak  = Space(10)							&& Faktura dobavljaca
	wDmpDFak = CtoD("00.00.00")				&& Datum fakture dobavljaca

	wKrBDok = Space(10)
	wKrBof  = Space(10)
	wKrDof  = Date()
	wKrOpk  = Space(30)

	s1 = Val("00000000000000.00")				&& Zbirovi za datoteku rashod
	s2 = Val("00000000000000.00")
	s3 = Val("00000000000000.00")
	s4 = Val("00000000000000.00")
	s5 = Val("00000000000000.00")
	s6 = Val("00000000000000.00")
	*******************************************

   @ 3,1 SAY "Poslovni partner:" GET wDmpDob PICTURE "999999" VALID Provdob(wDmpDob)
   READ

	IF Lastkey() = 27
   	EXIT
	ENDIF

   @ 4, 1 SAY "Kalkulacija broj:  " GET wDmpBk PICTURE "@!" VALID ! Empty(wDmpBk)
   @ 5, 1 SAY "Datum:             " GET wDmpDat
   READ

	IF Lastkey() = 27
   	EXIT
   ENDIF

	SELECT 1
   SEEK wDmpBk
   IF Found()
   	IF ! DMPDOB = wDmpDob
         MessageBox("Postoji takva kalkulacija ali sa posl.partnerom: " + Str(DMPDOB,6,0))
         LOOP
      ENDIF

      IF DMPDAT = wDmpDat
			@ 19,1 SAY "Takva kalkulacija postoji! Nastavak (d/n)? " ;
			       GET DN PICTURE "!" VALID (DN $ "DN")
			READ

			IF Lastkey() = 27 .OR. DN = "N"
				LOOP
			ENDIF

			wDmpFak  = DMPFAK
			wDmpDFak = DMPDFAK
		  	@ 6, 1 SAY "Faktura dobavljaca:" + wDmpFak
   		@ 7, 1 SAY "Datum fakture:     " + DtoC(wDmpDFak)

			indik9 = 1
		ELSE
			MessageBox("Postoji takva kalkulacija pod datumom: " + DtoC(DMPDAT))
         MessageBox("Morate uzeti drugi broj kalkulacije ili promeniti datum!")
         LOOP
      ENDIF
	ELSE
		wDmpDFak = wDmpDat
	  	@ 6, 1 SAY "Faktura dobavljaca:" GET wDmpFak VALID ! Empty(wDmpFak)
   	@ 7, 1 SAY "Datum fakture:     " GET wDmpDFak
      READ

		IF Lastkey() = 27
      	LOOP
      ENDIF
   ENDIF

	cEkran := SaveScreen()
	nPoslIzbor = 1

	DO WHILE .T.	&&	(2) u programu

   	SELECT 3
   	
      Izbor = nPoslIzbor	&&  default izbor
 
		@ 9,22 CLEAR TO 14,58
		@ 9,22 TO 14,58
      @ 10,23 PROMPT " KALKULACIJA PDV                   "
		@ 11,23 PROMPT " KALKULACIJA BEZ PDV - UNAPRED     "
      @ 12,23 PROMPT " KALKULACIJA BEZ PDV - UNAZAD      "
      @ 13,23 PROMPT " KALKULACIJA PAUSALNO OPOREZOVANIH "
      
		MENU TO Izbor
		 
		DO CASE
      	CASE Lastkey() = 27
         	indik = 1
            EXIT
         CASE Izbor = 1
         	mod = "B"
				nPoslIzbor = 1
				DO PIVOKOSO
				RestScreen(,,,,cEkran)
				LOOP
         CASE Izbor = 2
            nPoslIzbor = 2
            mod = "B"		&& kalkulacija unapred nastavlja se u ovom fajlu
         CASE Izbor = 3
         	mod = "B"
         	nPoslIzbor = 3
         	DO KDMPNAZA
         	RestScreen(,,,,cEkran)
         	LOOP
         CASE Izbor = 4
         	mod = "B"
         	nPoslIzbor = 4
            DO KDMPPAUS
            RestScreen(,,,,cEkran)
            LOOP
      ENDCASE

		* kalkulacija unapred nastavlja se u ovom fajlu
      DN     = " "
      kpc    = 0
      mTaksa = 0

      wDmpArt = Val("0000000000000")			&& Sifra artikla
      wDmpJM  = Space(3)							&& Jedinica mere
      wDmpNaz = Space(30)							&& Naziv artikla
      wCenRac = Val("000000000000.00")			&& Cena artikla (u ARTPANE)
      wDmpTar = Space(8)							&& Tarifa artikla
		wDmpKol = Val("00000000000.000")			&& Kolicina u fakturi
		wDmpNC  = Val("000000000000.00")			&& Cena u fakturi
      wDmpRab = Val("000.00")						&& Rabat
      wDmpZtp = Val("000.00")						&& Zavisni troskovi
      wFCen   = Val("000000000000.00")			&& Fakturisana cena
      wIRab   = Val("000000000000.00")			&& Iznos rabata
      wDmpZjm = 0										&& Zavisni troskovi po JM
      wDmpZti = Val("000000000000.00")			&& Zavisni troskovi iznos
      wDmpPpd = Val("000000000000.00")			&& Preneti porez po JM
      wDmpMap = Val("000.00")						&& Marza po JM
      wDmpMaI = Val("000000000000.00")			&& Marza iznos
      wDmpMbp = Val("000000000000.00")			&& Maloprodajna cena bez poreza
		wDmpMsp = Val("000000000000.00")			&& Maloprodajna cena sa porezom
      wDmpVsp = Val("000000000000.00")			&& Ukupno sa porezom (wDmpMsp * wDmpKol)
		wDmpPpk = Val("000000000000.00")			&& Porez po JM
		wDmpRaz = Val("000000000000.00")			&& Razlika: wDmpPpk - wDmpPpd
      wwDmpPpd = Val("000000000000.00")
		wwDmpPpk = Val("000000000000.00")
		wPriv   = Val("000000000000.00")
      prer    = Val("000.00")
      wIzn    = Val("000000000000.00")

		MainMask("IZRADA MALOPRODAJNE KALKULACIJE BEZ PDV-a - UNAPRED")

      @ 2 ,1 SAY "Sifra artikla:" GET wDmpArt;
		       PICTURE "9999999999999" VALID KalProvArt(wDmpArt)
      READ

		IF Lastkey() = 27
      	EXIT
      ENDIF

		SELECT 3
      SEEK wDmpArt
      IF ! Found()
      	MessageBox("Ne postoji takav artikal!")
      	RestScreen(,,,,cEkran)
         LOOP
      ENDIF

		SELECT 1
      SET ORDER TO 2
      wKljuc = wDmpBk + str(wDmpArt)
      SEEK wKljuc
      IF Found()
      	MessageBox("Vec ste uneli ovaj artikal u kalkulaciju!")
         SET ORDER TO 1
         RestScreen(,,,,cEkran)
         LOOP
      ENDIF
		SET ORDER TO 1

		SELECT 3
		@ 3,1 SAY "Naziv artikla: " + Alltrim(ARTNAZ) + " [" + ARTJM + "]"
	   @ 4,1 SAY "Tarifa: " + ARTTAR
		
		wDmpJM  = ARTJM
		wDmpNaz = ARTNAZ
	   wCenRac = ARTCEN
		wDmpTar = ARTTAR

      SELECT 2
      SET FILTER TO TARSIF = wDmpTar
      GO TOP

		IF Eof()
      	MessageBox("Nije otvorena ta tarifa ili ste je brisali posle otvaranja artikla!")
      	RestScreen(,,,,cEkran)
      	LOOP
      ENDIF
      GO BOTTOM

		wTarZbir = TARZBIR
		wVoz     = TAROST
	
		@ 5,1 SAY "Stopa: " + Str(TARZBIR,6,2) + "%"
		@ 6,1 SAY "Cena u racunaru: " + Str(wCenRac,17,2)
		SET FILTER TO
		
      @  7, 1 SAY "Kolicina:               " GET wDmpKol PICTURE "99999999999.999" VALID ! Empty(wDmpKol)
      @  8, 1 SAY "Cena (bez pren.poreza): " GET wDmpNC  PICTURE "999999999999.99" VALID ! Empty(wDmpNC)
      READ

      IF Lastkey() = 27
      	RestScreen(,,,,cEkran)
         LOOP
      ENDIF

      @ 9 ,1 SAY "Rabat(%): " + Space(23) GET wDmpRab PICTURE "999.99"
      @ 10,1 SAY "Zavisni troskovi(%): " + Space(12) GET wDmpZtp PICTURE "999.99"
      READ
      
		IF Lastkey() = 27
			RestScreen(,,,,cEkran)
      	LOOP
      ENDIF
      
		wFCen = Round((1 - (wDmpRab / 100)) * wDmpNC,2)
      wIRab = Round((wDmpNC - wFCen) * wDmpKol,2)
		wDmpNvr = Round(wDmpKol * wFCen,2)
		
		@ 11,1 SAY "Fakturisana cena:        " + Str(wFCen,15,2)
      @ 12,1 SAY "Fakturisna vrednost:     " + Str(wDmpNvr,15,2)
      
      wPriv = wFCen
      IF wDmpZtp <> 0
			wDmpZjm = (wDmpZtp / 100) * wFCen
			wDmpZti = Round(wDmpZjm * wDmpKol,2)
			@ 13,1 SAY "Zavisni troskovi iznos:  " + Str(wDmpZti,15,2)
      ELSE
         @ 13,1 SAY "Zavisni troskovi po jm.:" GET wDmpZjm PICTURE "999999999999.99"
         READ
         
			IF Lastkey() = 27
				RestScreen(,,,,cEkran)
         	LOOP
         ENDIF
         
			wDmpZti = Round(wDmpZjm * wDmpKol,2)
			wIzn = wDmpZti
         @ 14,1 SAY "Zavisni troskovi iznos:  " + Str(wDmpZti,15,2)
      ENDIF

      wPriv = Round(wPriv + wDmpZjm,2)
      
		IF mod = "P"
      	wDmpPpd = (wTarZbir / 100) * wFCen
         @ 15,1 SAY "Preneti porez po (" + wDmpJM + ")" + Str(wDmpPpd,15,2)
      ENDIF
      
      @ 16,1 SAY "Marza(%) :" + Space(27) GET wDmpMap PICTURE "999.99" ;
		        VALID (! Empty(wDmpMap) .AND. (! wDmpMap < 0))
      READ
      
		IF Lastkey() = 27
      	RestScreen(,,,,cEkran)
         LOOP
      ENDIF
      
		wDmpMbp = Round(wPriv + Round((wDmpMap / 100) * wPriv,2),2)
      wq = Round(wDmpMbp - wPriv,2)
      wDmpMaI = Round(wq * wDmpKol,2)
      
		@ 17,1 SAY "Marza (iznos): "+ Space(14) + Str(wDmpMaI,15,2)
      @ 18,1 SAY "Maloprodajna cena bez poreza:" + Str(wDmpMbp,15,2)
      
		IF mod = "B"
      	wDmpMsp = Round(Round((wTarZbir / 100) * wDmpMbp,2) + wDmpMbp,2)
         wDmpVsp = Round(wDmpMsp * wDmpKol,2)
         @ 19,1 SAY "Stopa poreza(%): " + Space(21) + Str(wTarZbir,6,2)
      ENDIF
      
		IF mod = "P"
			wDmpPpk = (wTarZbir / 100) * wDmpMbp
			wDmpRaz = wDmpPpk - wDmpPpd
			wDmpMsp = wDmpMbp + wDmpPpk
			wDmpVsp = Round(wDmpMsp * wDmpKol,2)
			@ 19,1 SAY "Obracunati porez u dinarima: " + Str(wDmpPpk,15,2)
      ENDIF

      @ 20,1 SAY "Maloprodajna cena sa porezom:" + Str(wDmpMsp,15,2)      
	
		@ 23,64 SAY "Upis (D/N)? " GET DN PICTURE "!" VALID (DN $ "DN+-")
		READ

      IF Lastkey() = 27 .OR. DN = "N" .OR. DN = "-"
      	RestScreen(,,,,cEkran)
			LOOP
      ENDIF
         
      SELECT 3
      DO CASE
      	CASE ARTKOL = 0
            REPLACE ARTKOL WITH wDmpKol
            REPLACE ARTCEN WITH wDmpMsp
         CASE ARTCEN = wDmpMsp
            REPLACE ARTKOL WITH (ARTKOL + wDmpKol)
         CASE ARTCEN <> wDmpMsp
            Nive1()
            RestScreen(,,,,cEkran)
            LOOP
      ENDCASE
      
      UpisRa = 1
      DO KNOV
      
		SELECT 1
      APPEND BLANK
		REPLACE DMPSIF  WITH wDmpArt
		REPLACE DMPNAZ  WITH wDmpNaz
		REPLACE DMPJM   WITH wDmpJM
		REPLACE DMPKOL  WITH wDmpKol
		REPLACE DMPNC   WITH wFCen
		REPLACE DMPPPD  WITH wDmpPpd
		REPLACE DMPZTR  WITH wDmpZtp
		REPLACE DMPZIZ  WITH wDmpZti
		REPLACE DMPMIZ  WITH wDmpMaI
		REPLACE DMPMBP  WITH wDmpMbp
		REPLACE DMPPPK  WITH wDmpPpk
		REPLACE DMPRAZ  WITH wDmpRaz
		REPLACE DMPPOR  WITH wTarZbir
		REPLACE DMPTAR  WITH wDmpTar
		REPLACE DMPMSP  WITH wDmpMsp
		REPLACE DMPVSP  WITH wDmpVsp
		REPLACE DMPBRO  WITH wDmpBk
		REPLACE DMPDAT  WITH wDmpDat
		REPLACE DMPRAB  WITH wDmpRab
		REPLACE DMPDOB  WITH wDmpDob
		REPLACE DMPIRAB WITH wIRab
		REPLACE DMPFAK  WITH wDmpFak
		REPLACE DMPDFAK WITH wDmpDFak

		prer = Round((wTarZbir * 100) / (wTarZbir + 100),2)
		s1 = s1 + Round(wDmpKol * wDmpNC,2)
		s2 = s2 + Round(wDmpVsp - (Round(wDmpMsp * wDmpKol * prer /100,2) + Round(wDmpKol * wDmpNC,2) + wDmpZti),2)
		s3 = s3 + Round(wDmpMsp * wDmpKol * prer /100,2)
		s4 = s4 + wDmpVsp
		s5 = s1
		s6 = Round(s6 + wDmpZti,2)

		wKrBDok = DMPBRO
		wKrBof  = DMPFAK
		wKrDof  = DMPDFAK
		
		RestScreen(,,,,cEkran)
   ENDDO && (2) u algoritmu
	
	*********************************************
	* Upis u Knjigu prihoda-rashoda
	*********************************************	
   CLOSE DATABASES
   IF UpisRa = 1
   	wKropkr = Space(30)
      
		SELECT 0
      USE PPDAT INDEX PPINSIF
      SEEK wDmpDob
      IF Found()
         wKropkr = PPNAZ
      ELSE
         wKropkr = " "
      ENDIF
      CLOSE PPDAT

      SELECT 0
      USE RASHODN INDEX RASHINKN,RASHINDN
      SEEK wKrBDok
      IF Found()
         IF RDK = wDmpDat
         	* ubacen upis zbirova za PDV
            REPLACE RPBEZ06 WITH (RPBEZ06 + wwDmpPpk)
            REPLACE RPBEZ2  WITH (RPBEZ2 + wwDmpPpd)
            * kraj ubacenih zbirova za PDV
            REPLACE RNVRRR  WITH Round(RNVRRR + s1 + s6,2)
            REPLACE RRUCP   WITH Round(RRUCP + s2,2)
            REPLACE ROBPOR  WITH Round(ROBPOR + s3,2)
            REPLACE RPRODV  WITH Round(RPRODV + s4,2)
            REPLACE RRASUK  WITH Round(RRASUK + s1 + s6,2)
         ENDIF
		ELSE
         APPEND BLANK
         REPLACE RRB     WITH wKrRb
			REPLACE RDK     WITH wDmpDat
			REPLACE ROPIS   WITH wKropkr
			REPLACE RBR     WITH wKrBDok
			REPLACE RDATDOK WITH wKrDof
			* ubacen upis zbirova za PDV
			REPLACE RPBEZ2  WITH wwDmpPpd
			* kraj ubacenih zbirova za PDV
			REPLACE RNVRRR  WITH Round(s1 + s6,2)
			REPLACE RRUCP   WITH Round(s2,2)
			REPLACE ROBPOR  WITH s3
			REPLACE RPRODV  WITH s4
			REPLACE RRASUK  WITH Round(s1 + s6,2)
      ENDIF
      CLOSE RASHODN
	ENDIF

	*********************************************
	* Upis u trgovacku knjigu
	*********************************************
	IF UpisRa = 1
		wKropk1 = Space(30)

		SELECT 0
		USE PPDAT INDEX PPINSIF
		SEEK wDmpDob
		IF Found()
			wKropk1 = PPNAZ
		ELSE
			wKropk1 = " "
		ENDIF
		CLOSE PPDAT
		
		wRb = Val("0000")
		SELECT 0
		USE TRG INDEX TINOR,TRGKAL
		GO BOTTOM
		wRb = RB + 1
		CLOSE TRG

		wOpk = Space(55)
		wOpk = Substr((Alltrim(Str(wDmpDob,6)) + " " + Alltrim(wKropk1) +;
		       " " + Alltrim(wDmpBk) + " " + Alltrim(wDmpFak)), 1, 55)
		
		SELECT 0
		USE TRG INDEX TRGKAL,TINOR
		SEEK wKrBDok
		IF Found()
			REPLACE ZAD WITH Round(ZAD + s4,2)
		ELSE
			APPEND BLANK
			REPLACE ORGJ  WITH " "
			REPLACE RB    WITH wRb
			REPLACE BRKAL WITH wKrBDok
			REPLACE DK    WITH wDmpDat
			REPLACE OPK   WITH wOpk
			REPLACE ZAD   WITH s4
		ENDIF
		CLOSE TRG
	ENDIF
	*********************************************

	IF indik = 1
		indik = 0
		LOOP
	ENDIF

	EXIT

ENDDO

CLOSE DATABASES

RETURN


*******************************************************
* Pomoce procedure
*******************************************************
PROCEDURE Nive1
	cScreen := SaveScreen( 5,10,21,69 )
	@ 5,10 CLEAR TO 21,69
	@ 5,10 TO 21,69

	@ 6 ,11 SAY Centriraj("NIVELACIJA  ILI  NOVA SIFRA",68-10)
	@ 9 ,12 SAY Str(ARTSIF,13) + " - " + ARTNAZ
	@ 11,12 SAY "Artikal u racunaru kosta: "
	@ 11,38 SAY ARTCEN PICTURE "999,999,999.99"
	@ 13,12 SAY "Vi ste dali cenu:         "
	@ 13,38 SAY wDmpMsp PICTURE "999,999,999.99"
	@ 20,12 SAY "Pritisnite ENTER za nastavak..."
	WAIT ""

	RestScreen( 5,10,21,69, cScreen )
RETURN

*******************************************************
FUNCTION ProvDob(SifDob)
	LOCAL SelSav := Select()
	LOCAL buttons := {"  Novi  "," Lista  "}

   USE PPDAT INDEX PPINSIF,PPINNAZ,PPINMES,PPINZIR NEW

	IF (DBSEEK(SifDob))
	   @ 03,26 SAY SUBSTR(PPNAZ,1,30)
	   wpibkpr = PPPIB
	   mDmpdob = PPSIF
	   wDmpDob = PPSIF
	   CLOSE PPDAT
	   SELECT(SelSav)
	   RETURN(.T.)
	ELSE
	   izb = al_box("Niste upisali sifru DOBAVLJACA",2,buttons,2,6,25,12,59)
	   DO CASE
	      CASE izb = 1
	         IF (PPUnos1(1))
	            @ 03,26 SAY SUBSTR(PPNAZ,1,30)
	            CLOSE PPDAT
	            SELECT(SelSav)
	            RETURN(.T.)
	         END IF
	         CLOSE PPDAT
	         SELECT(SelSav)
	         RETURN(.F.)
	      CASE izb = 2
				IF (ListDobavljac())
	            @ 03,26 SAY SUBSTR(PPNAZ,1,30)
	            CLOSE PPDAT
	            SELECT(SelSav)
	            RETURN(.T.)
	         END IF
	         CLOSE PPDAT
	         SELECT(SelSav)
	         RETURN(.F.)
	   END CASE
END IF
*******************************************************
