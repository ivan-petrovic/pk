LOCAL mNabCen, mVrRab, mNabVre, mPrenPor, mJm, mKol
LOCAL mAkciza, mRabat, mVrsta, wwDmpRaz
LOCAL mMalPCen, mPorOsnov, mPorIznos, wKrDat 

wwDmpPpd = Val("000000000000.00")  && zbirovi donetog
wwDmpPpk = Val("000000000000.00")  && zbirovi obracunatog
wwDmpRaz = Val("000000000000.00")  && zbirovi razlika

DO WHILE .T. &&   (2) u programu

	MainMask("IZRADA MALOPRODAJNE KALKULACIJE PDV")
	
   mNabCen  = Val("00000000.000000")
   mVrRab   = Val("00000000.000000")
   mNabVre  = Val("000000000000.00")
   mPrenPor = Val("00000000.00")
   mKol     = Val("0000000000.000")
   mAkciza  = Val("000000.00")
   mTaksa   = Val("000000.00")
   mRabat   = Val("000.00")
   Prer     = Val("00.00")
   mJm      = Space(3)
   mVrsta   = "P"
   STORE mNabVre TO mMalPCen, mPorOsnov, mPorIznos

	kpc = 1
	DN = " "
	wDmpArt = Val("0000000000000")
	wDmpNaz = Space(30)
	wDmpJM  = Space(3)
	wDmpKol = Val("00000000000.000")
	wDmpPpd = Val("000000000000.00")
	wDmpZtp = Val("000.00")   && zavisni troskovi %
	wDmpZti = Val("000000000000.00")
	wDmpMap = Val("000.00")
	wDmpMaI = Val("000000000000.00")
	wDmpMbp = Val("000000000000.00")
	wDmpPpk = Val("000000000000.00")
	wDmpRaz = Val("000000000000.00")
	wDmpTar = Space(8)
	wDmpMsp = Val("000000000000.00")
	wDmpVsp = Val("000000000000.00")
	wArtCen = Val("000000000000.00")

	@ 2,1 SAY "Sifra artikla: " GET wDmpArt ;
	      PICTURE "9999999999999" VALID KalProvArt(wDmpArt)
	READ

	IF Lastkey() = 27
		EXIT
	ENDIF

   SELECT 3
   SEEK wDmpArt
	IF ! Found()
		MessageBox("Ne postoji takav artikal!")
      LOOP
   ENDIF
   
	SELECT 1
   SET ORDER TO 2
   wKljuc = wDmpBk + Str(wDmpArt)
   SEEK wKljuc
   IF Found()
   	MessageBox("Vec ste uneli ovaj artikal u kalkulaciju!")
      SET ORDER TO 1
      LOOP
	ENDIF
   SET ORDER TO 1
   
	SELECT 3
	@ 3,1 SAY "Naziv artikla: " + Alltrim(ARTNAZ) + " [" + ARTJM + "]"
   @ 4,1 SAY "Tarifa: " + ARTTAR
	
	wDmpJM  = ARTJM
	wDmpNaz = ARTNAZ
	wArtCen = ARTCEN
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

	@ 5,1 SAY "Stopa: " + Str(TARZBIR,6,2) + "%"
	@ 6,1 SAY "Cena u racunaru: " + Str(wArtCen,17,2)
	SET FILTER TO

	Prer = Round((wTarZbir * 100) / (wTarZbir + 100),2)

	@ 7 , 1 SAY "Ukupna fakturna vrednost:   " GET mNabVre ;
	        PICTURE "999999999.99" VALID(mNabVre <> 0)
	@ 8 , 1 SAY "Kolicina:                     " GET mKol ;
           PICTURE "999999.999" VALID(mKol <> 0)
	@ 9 , 1 SAY "Maloprodajna cena po jm.:    " GET mMalPCen ;
           PICTURE "99999999.99" VALID(mMalPcen > 0)
	@ 10, 1 SAY "Preneti porez:               " GET mPrenPor ;
	        PICTURE "99999999.99"
	@ 7 ,43 SAY "Akciza( flasa):          " GET mAkciza ;
	        PICTURE "999999.99"
	@ 8 ,43 SAY "Taksa (flasa):           " GET mTaksa ;
	        PICTURE "999999.99"
	@ 9 ,43 SAY "Rabat(%):                   " GET mRabat ;
	        PICTURE "999.99"
	@ 10,43 SAY "Zavisni troskovi(%):        " GET wDmpZtp ;
	        PICTURE "999.99"
	READ
   
	IF Lastkey() = 27
   	EXIT
	ENDIF

   IF wDmpZtp <> 0
   	wDmpZti = Round(mNabVre * wDmpZtp / 100,2)
		@ 11,1  SAY "Iznos zavisnih troskova   " + Str(wDmpZti,15,2)
   ENDIF
   
	mVrsta  = Upper(mVrsta)
   mNabCen = Round(mNabVre / mKol,6)
   
	DO CASE
		CASE mVrsta = "N"
			mVrRab = Round(mNabCen * mRabat / 100,6)
		CASE mVrsta = "A"
			mVrRab = Round((mNabCen + mAkciza) * mRabat / 100,6)
		CASE mVrsta = "T"
			mVrRab = Round((mNabCen + mTaksa) * mRabat / 100,6)
		CASE mVrsta = "S"
			mVrRab = Round((mNabCen + mAkciza + mTaksa) * mRabat / 100,6)
		CASE mVrsta = "P"
			mVrRab  = Round(mNabCen * mRabat / 100,6)
			mNabVre = Round(mNabVre - mVrRab * mKol,2)
	ENDCASE
   
	mPorOsnov = Round((mMalPCen - mTaksa) * mKol,2)
   mPorIznos = Round(mPorOsnov * Prer / 100,2)
   * mPorIznos zavisi od stope; zavisno od toga cemo vrsiti zbirove
   wDmpPpk = mPorIznos
   wDmpPpd = mPrenPor
   wDmpRaz = Round(mPorIznos - mPrenPor,2)
   
	* pamcenje zbirova za knjigu rashoda
	wwDmpPpk = Round(wwDmpPpk + mPorIznos,2)
	wwDmpPpd = Round(wwDmpPpd + mPrenPor,2)
	wwDmpRaz = Round(wwDmpPpk - wwDmpPpd,2)

	@ 12, 0 SAY Chr(199) + Replicate(Chr(196),55) + Chr(194) + Replicate(Chr(196),22) + Chr(182)
	@ 13, 1 SAY "                                Flasa            Ukupno" + Chr(179)
	@ 14, 1 SAY "Fakturna cena         " + Str(mNabCen,15,6)           + Space(1) + Str(mNabVre,17,2) + Chr(179)
	@ 15, 1 SAY "Kolicina              " + Space(14) + "1"             + Space(1) + Str(mKol,17,2) + Chr(179)
	@ 16, 1 SAY "Rabat                 " + Str(mVrRab,15,6)            + Space(1) + Str(mVrRab * mKol,17,4) + Chr(179)
	@ 17, 1 SAY "Fakturna vrednost     " + Str(mNabCen - mVrRab,15,6)  + Space(1) + Str(Round(mNabCen - mVrRab,6) * mKol,17,4) + Chr(179)
	@ 18, 1 SAY "Akciza                " + Str(mAkciza,15,2)           + Space(1) + Str(mAkciza * mKol,17,2) + Chr(179)
	@ 19, 1 SAY "Taksa                 " + Str(mTaksa,15,2)            + Space(1) + Str(mTaksa * mKol,17,2) + Chr(179)
	@ 20, 1  SAY "Osnova za PDV         " + Str(mMalPCen - mTaksa,15,2)+ Space(1) + Str(mPorOsnov,17,2) + Chr(179)
	@ 21, 1 SAY "Obracunat PDV         " + Str((mMalPCen - mTaksa)*Prer/100,15,6) + Space(1) + Str(mPorIznos,17,2) + Chr(179) 
	@ 22, 1 SAY "Preneti porez         " + Str(mPrenPor / mKol,15,2)   + Space(1) + Str(mPrenPor,17,2) + Chr(179)
	@ 23, 1 SAY "Maloprodajna vrednost " + Str(mMalPCen,15,2)          + Space(1) + Str(mMalPCen * mKol,17,2) + Chr(179)
   @ 24,56 SAY Chr(207)
   
	wDmpVsp = Round(mMalPcen * mKol,2)
   
	* UBACENA NABAVNA I ZAVISNI TROSKOVI
	@ 13,57 SAY "Nabavna vrednost:"
   @ 14,57 SAY Round(mNabVre + Round(mNabVre * wDmpZtp / 100,2),2) PICTURE "999999999999.99"
	@ 16,57 SAY "Zavisni troskovi:"
	@ 17,57 SAY Round(mNabVre * wDmpZtp / 100,2) PICTURE "999999999999.99"
	@ 19,57 SAY "Obaveze prema"
	@ 20,57 SAY "dobavljacu:"
   @ 21,57 SAY Round(mNabVre,2) PICTURE "999999999999.99"

	@ 22,56 SAY Chr(195) + Replicate(Chr(196),22) + Chr(182)
	@ 23,64 SAY "Upis (D/N)? " GET DN PICTURE "!" VALID (DN $ "DN+-")
	READ
   
	IF Lastkey() = 27 .OR. DN = "N" .OR. DN = "-"
		LOOP
   ENDIF

   wDmpMsp = mMalPCen
   wDmpKol = mKol

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
   
   UpisRa = 1
   wDmpMsp = Round(mMalPCen - mTaksa,2)

	DO KNN     && porez kpc
	DO KNOV    && porez normalan

	SELECT 1
	APPEND BLANK
	REPLACE DMPSIF  WITH wDmpArt
	REPLACE DMPNAZ  WITH wDmpNaz
	REPLACE DMPJM   WITH wDmpJM
	REPLACE DMPKOL  WITH mKol
	REPLACE DMPNC   WITH mNabVre
	REPLACE DMPPPD  WITH mPrenPor
	REPLACE DMPZTR  WITH wDmpZtp
	REPLACE DMPZIZ  WITH wDmpZti
	REPLACE DMPMAR  WITH wDmpMap
	REPLACE DMPMIZ  WITH wDmpMaI
	REPLACE DMPMBP  WITH wDmpMbp
	REPLACE DMPPPK  WITH mPorIznos
	REPLACE DMPRAZ  WITH Round(mPorIznos - mPrenPor,2)
	REPLACE DMPPOR  WITH wTarZbir
	REPLACE DMPTAR  WITH wDmpTar
	REPLACE DMPMSP  WITH mMalPCen
	REPLACE DMPVSP  WITH Round(mMalPcen * mKol,2)
	REPLACE DMPBRO  WITH wDmpBk
	REPLACE DMPDAT  WITH wDmpDat
	REPLACE DMPRAB  WITH mRabat
	REPLACE DMPDOB  WITH wDmpDob
	REPLACE DMPIRAB WITH mVrRab
	REPLACE DMPFAK  WITH wDmpFak
	REPLACE DMPDFAK WITH wDmpDFak
	REPLACE VRSTA   WITH mVrsta
	REPLACE AKCIZA  WITH mAkciza
	REPLACE TAKSA   WITH mTaksa

   s1 = s1 + Round(mNabVre - mPrenPor + wDmpZti,2)
	s2 = Round(s2 + Round(wDmpVsp - mNabVre - wDmpRaz - wDmpZti,2),2)
   s3 = Round(s3 + mPorIznos,2)
	s4 = Round(s4 + Round(mMalPCen * mKol,2),2)
	s5 = s1

	wKrDat  = DMPDAT
	wKrBDok = DMPBRO
	wKrBof  = DMPFAK
	wKrDof  = DMPDFAK

ENDDO && (2) u algoritmu

RETURN
