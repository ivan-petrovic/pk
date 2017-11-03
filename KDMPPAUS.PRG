LOCAL wDodPor, wRab,	wNabc, wAkciza, wKl
LOCAL wSav3, indik15, cPorEkran, wBezV

DO WHILE .T.		&& (2) u programu

	MainMask("IZRADA MALOPRODAJNE KALKULACIJE PAUSALNO OPOREZOVANIH")

	SELECT 3

	DN  = " "
	kpc = 0
	wDodPor  = "D"
	mTaksa   = 0
	wNabc    = 0
	wCenRac  = 0
	wDmpZjm  = 0
	wRab     = 0
	wDmpRab  = Val("000.00")
	wDmpArt  = Val("0000000000000")
	wDmpNaz  = Space(30)
	wDmpJM   = Space(3)
	wDmpKol  = Val("00000000000.000")
	wDmpNC   = Val("000000000000.00")
	wDmpPpd  = Val("000000000000.00")
	wAkciza  = Val("000000000000.00")
	wDmpZtp  = Val("000.00")
	wDmpZti  = Val("000000000000.00")
	wDmpMap  = Val("000.00")
	wDmpMaI  = Val("000000000000.00")
	wDmpMbp  = Val("000000000000.00")
	wDmpPpk  = Val("000000000000.00")
	wDmpRaz  = Val("000000000000.00")
	wDmpTar  = Space(8)
	wDmpMsp  = Val("000000000000.00")
	wDmpVsp  = Val("000000000000.00")
	wFCen    = Val("000000000000.00")
	wIRab    = Val("000000000000.00")
	Prer     = Val("00.00")

   @ 2,1 SAY "Na nabavnu dodati porez  D/N? " GET wDodPor PICTURE "!" VALID (wDodPor $ "DdNn")
   @ 3,1 SAY "Sifra artikla:    " GET wDmpArt PICTURE "9999999999999" VALID kalProvArt(wDmpArt)
   READ
   
	IF Lastkey() = 27
   	EXIT
   ENDIF

	SELECT 3
	SEEK wDmpArt
	IF ! Found()
		MessageBOx("Ne postoji takav artikal!")
		LOOP
	ENDIF
   
	SELECT 1
   SET ORDER TO 2
   wKl = wDmpBk + str(wDmpArt)
   SEEK wKl
   IF Found()
		MessageBox("Vec ste uneli ovaj artikal u kalkulaciju!")
      SET ORDER TO 1
      LOOP
   ENDIF
   SET ORDER TO 1

	SELECT 3
   @ 4,1 SAY "Naziv artikla: " + Alltrim(ARTNAZ) + " [" + ARTJM + "] - tarifa: " + ARTTAR 
	
	wDmpJM  = ARTJM
	wDmpNaz = ARTNAZ
   wCenRac = ARTCEN
	wDmpTar = ARTTAR

	SELECT 2
	SET FILTER TO TARSIF = wDmpTar
	GO TOP

	IF Eof()
		MessageBox("Nije otvorena ta tarifa ili ste je brisali posle otvaranja artikla!")
		LOOP
	ENDIF
	GO BOTTOM

	wTarZbir = TARZBIR
	wVoz     = TAROST
   wSav3    = TARSST

	@ 5,1 SAY "Stopa: " + Str(TARZBIR,6,2) + "%"
	@ 6,1 SAY "Cena u racunaru: " + Str(wCenRac,17,2)
	SET FILTER TO

	@ 7,1 SAY "Kolicina:   " GET wDmpKol PICTURE "99999999999.999" VALID ! Empty(wDmpKol)
	@ 8,1 SAY "Cena:       " GET wDmpNC  PICTURE "999999999999.99" VALID ! Empty(wDmpNC)
	READ

	IF Lastkey() = 27
		LOOP
	ENDIF

	@ 9 ,1 SAY "Rabat(%):            " GET wDmpRab PICTURE "999.99"
   @ 10,1 SAY "Porez:        " GET wAkciza PICTURE "9999999999.99"	&& OVO JE SUSTINA PAUSALA
   @ 11,1 SAY "Zavisni troskovi(%): " GET wDmpZtp PICTURE "999.99"
   READ
   
	IF Lastkey() = 27
   	LOOP
   ENDIF

	wRab = (wDmpRab / 100) * wDmpNC
	wIRab = wRab * wDmpKol
	wFCen = wDmpNC - (wDmpRab / 100) * wDmpNC

	* ide nabacivanje poreza na nabavnu
	IF wDodPor = "D"   && dodacemo porez
		wFCen = Round(wFCen + Round(wFCen * wTarZbir /100,2) ,2)
		wTarZbir = 0
	ELSE
		wTarZbir = 0
	ENDIF
   * kraj nabacivanja na nabavnu
   
	@ 12,1 SAY "Fakturisana cena:                " + Str(wFCen,15,2)
   @ 13,1 SAY "Fakturisana vrednost:            " + Str(wFCen * wDmpKol,15,2)

   IF wDmpZtp <> 0
		wDmpZjm = (wDmpZtp / 100) * wFCen
		@ 14,1 SAY "Zavisni troskovi po jm.:        " + Str(wDmpZjm,15,2)
   ELSE
      @ 14,1 SAY "Zavisni troskovi po jm.:        " GET wDmpZjm PICTURE "999999999999.99"
      READ
      
		IF Lastkey() = 27
      	LOOP
      ENDIF
   ENDIF
   
   wDmpZti = Round(wDmpZjm * wDmpKol,2)
	@ 15,1 SAY "Zavisni troskovi iznos:          " + Str(wDmpZti,15,2)

   wNabc = wFCen + wDmpZjm       && povecana za zavisne troskove
	@ 16,1 SAY "Nabavna cena:                    " + Str(wNabc,15,2)
	@ 17,1 SAY "Nabavna vrednost:                " + Str(wNabc * wDmpKol,15,2)

   DO WHILE .T.
		indik15 = 0
		@ 18,1 SAY "Maloprodajna cena sa porezom:   " GET wDmpMsp ;
		       PICTURE "999999999999.99" VALID ! Empty(wDmpMsp)
		READ
		
		IF Lastkey() = 27
			indik15 = 1
			EXIT
		ENDIF
		
		wDmpVsp = Round(wDmpMsp * wDmpKol,2)
		@ 19,1 SAY "Maloprodajna vrednost sa porezom:" + Str(wDmpVsp,15,2) 
		
		Prer = Round((100 * wTarZbir) / (100 + wTarZbir),2)
		wDmpMbp = Round(wDmpMsp - (wDmpMsp * Prer / 100),2)
		@ 20,1 SAY "Maloprodajna cena bez poreza:    " + Str(wDmpMbp,15,2)

		IF wNabc > wDmpMbp
			cPorEkran = SaveScreen(10,10,16,69)
			@ 10,10 CLEAR TO 16,69
			@ 10,10 TO 16,69
   		@ 12,12 SAY "Maloprodajna cena bez poreza manja od nabavne cene!"
      	@ 14,12 SAY "Morate dati vecu maloprodajnu cenu sa porezom!"
      	WAIT ""
      	RestScreen(10,10,16,69,cPorEkran)
      	LOOP
		ENDIF

		EXIT
      indik15 = 0
	ENDDO
   
	IF indik15 = 1
   	indik15 = 0
      LOOP
   ENDIF
   
	wBezV = Round(wDmpMbp * wDmpKol,2)
   @ 21,1 SAY "Vrednost bez poreza:             " + Str(wBezV,15,2) 

   wDmpMap = ((wDmpMbp - wNabc) * 100) / wNabc
   @ 22,1 SAY "Razlika u ceni (marza[%]):                " + Str(wDmpMap,6,2)
   
	wDmpMaI = Round((wDmpMbp - wNabc) * wDmpKol,2)
   @ 23,1 SAY "Razlika u ceni (vrednost):       " + Str(wDmpMaI, 15,2)

	@ 23,64 SAY "Upis (D/N)? " GET DN PICTURE "!" VALID (DN $ "DN+-")
	READ

	IF Lastkey() = 27 .OR. DN = "N" .OR. DN = "-"
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
			LOOP
	ENDCASE

	DO KNOV
	UpisRa = 1

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
	REPLACE DMPMIZ  WITH Round(wDmpVsp - (Round(wDmpMsp * wDmpKol * Prer / 100,2) + Round(wDmpKol * DMPNC,2) + wDmpZti),2)
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
	REPLACE AKCIZA  WITH wAkciza      && ovde je porez za pausalce

	s1 = s1 + Round(wDmpKol * DMPNC,2)   					&&  nabavna cena
	s2 = s2 + Round(wDmpVsp - (Round(wDmpMsp * wDmpKol * Prer / 100,2) + Round(wDmpKol * DMPNC,2) + wDmpZti),2)
	s3 = s3 + Round(wDmpMsp * wDmpKol * Prer / 100,2)  && obracunati porez
	s4 = s4 + wDmpVsp												&&  maloprodajna vrednost
	s5 = s1
	s6 = Round(s6 + wDmpZti,2)   								&& zavisni troskovi

	* wkrdatk = DMPDAT
	wKrBDok = DMPBRO
	wKrBof  = DMPFAK
	wKrDof  = DMPDFAK

	EXIT
ENDDO && (2) u algoritmu

RETURN
