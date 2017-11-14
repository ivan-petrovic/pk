SELECT 0
USE KPR
INDEX ON DKKPR TO KPRDK
INDEX ON BRKAL + BRACKPR TO KPRBRACK
INDEX ON BRACKPR TO KPRBRAC
CLOSE KPR

wRRb = Val("0000")
SELECT 0
USE RASHODN
GO BOTTOM
wRRb = RRB + 1
CLOSE RASHODN

SELECT 0
USE KPR INDEX KPRDK,KPRBRAC,KPRBRACK
SELECT 0
USE RASHODN INDEX RASHINKN,RASHINDN
SELECT 0
USE POREZN INDEX POREZNB,POREZND

SELECT RASHODN

DO WHILE .T.

   DN = " "
   WRDK     = Date()
   WROPIS   = Space(30)
   WRBR     = Space(10)
   WRDATDOK = Date()
   WRPV     = Val("00000000000000.00")
   WRPN     = Val("00000000000000.00")
   WRPN1    = Val("00000000000000.00")
   WRPBEZ   = Val("00000000000000.00")
   WRPBEZ06 = Val("00000000000000.00")
   WRPBEZ2  = Val("00000000000000.00")
   WRPBEZ4  = Val("00000000000000.00")
   WRUSP    = Val("00000000000000.00")
   WRUSBEZP = Val("00000000000000.00")
   WRPLACP  = Val("00000000000000.00")
   WRSVEP   = Val("00000000000000.00")
   WROSP    = Val("00000000000000.00")
   WOBRPDV  = Val("00000000000000.00")
   WPREPDV  = Val("00000000000000.00")
   WUPLPDV  = Val("00000000000000.00")
   WRNVRRR  = Val("00000000000000.00")
   WRVSP    = Val("00000000000000.00")
   WRRUCP   = Val("00000000000000.00")
   WROBPOR  = Val("00000000000000.00")
   WROBPORu = Val("00000000000000.00")
   WRPRODV  = Val("00000000000000.00")
   WRMIN    = Val("00000000000000.00")
   WRDOP    = Val("00000000000000.00")
   WRRASF   = Val("00000000000000.00")
   WRRASUK  = Val("00000000000000.00")
   WRZIRU   = Val("00000000000000.00")
   WRZIRI   = Val("00000000000000.00")
   wrsk     = Val("0")

   * promenljive za KPR
   WRBkPr    = Val("0000")
   WdkkPr    = Date()
   WdPPVDKPR = Date()
   wbracKPR  = Space(10)
   wdracKPR  = Date()
   Wkupkpr   = Val("000000")
   mDmpdob   = Val("000000")
   wDmpdob   = Val("000000")
   wpibkpr   = Space(13)
   wukspdv   = Val("000000000.00")
   wukspdv1  = Val("000000000.00")
   woslpdv   = Val("000000000.00")
   wnpdv     = Val("000000000.00")
   wuvozn    = Val("000000000.00")
   wukppdv   = Val("000000000.00")
   wodpdv    = Val("000000000.00")
   wneodpdv  = Val("000000000.00")
   wvbezpdvu = Val("000000000.00")
   wiznpdvu  = Val("000000000.00")
   wvdu      = Val("000000000.00")
   wiznn5    = Val("000000000.00")

   * DO RASMPUNN - ranije je ovaj fajl radio sledeci segment koda
	**********************************************************
   MainMask("UNOS PODATAKA U KNJIGU PRIHODA-RASHODA (ESC - Izlaz)")

	@ 2,1   SAY "REDNI BROJ                   " GET wRRb PICTURE "9999"
	@ 2,36  SAY "DATUM KNJIZENJA" GET WRDK VALID InicWRDatDok(@WRDatDok, WRDK)
	@ 3,1   SAY "BROJ DOKUMENTA               " GET WRBR
	@ 3,42  SAY "OPIS" GET WROPIS
	@ 4,1   SAY "DATUM DOKUMENTA ZA KNJIZENJE " GET WRDATDOK
	@ 5,1   SAY "PRIHOD OD DOBARA SA PDV OPSTA" GET WRPV     PICTURE "999999999999.99"
	@ 6,1   SAY "PRIHOD OD DOBARA SA PDV POSE." GET WRPN     PICTURE "999999999999.99"
	@ 7,1   SAY "PRIHOD OD DOBARA BEZ PDV     " GET WRPBEZ   PICTURE "999999999999.99"
	@ 8,1   SAY "PRIHOD OD USLUGA SA PDV      " GET WRUSP    PICTURE "999999999999.99"
	@ 9,1   SAY "PRIHOD OD USLUGA BEZ PDV     " GET WRUSBEZP PICTURE "999999999999.99"
	@ 10,1  SAY "OSTALI PRIHODI (63 DO 69)    " GET WROSP    PICTURE "999999999999.99"
	@ 11,1  SAY "SVEGA PRIHODA                " GET WRSVEP   PICTURE "999999999999.99"
	@ 12,1  SAY "OBRACUNATI PDV " GET WOBRPDV PICTURE "999999999999.99"
	@ 12,33 SAY "PRETHODNI PDV "  GET WPREPDV PICTURE "999999999999.99"
	@ 13,1  SAY "UPLACEN PDV                  " GET WUPLPDV  PICTURE "999999999999.99"
	@ 14,1  SAY "NAB.VRED.ROBE,REPRO.,REZ.DEL " GET WRNVRRR  PICTURE "999999999999.99"
	@ 15,1  SAY "VRED.SOPSTVEN.PROIZVODA      " GET WRVSP    PICTURE "999999999999.99"
	@ 16,1  SAY "RAZLIKA U CENI,PROVIZIJA     " GET WRRUCP   PICTURE "999999999999.99"
	@ 17,1  SAY "OBRACUNAT PDV                " GET WROBPOR  PICTURE "999999999999.99"
	@ 18,1  SAY "PROD.VRADNOST ROB. I PROIZ.  " GET WRPRODV  PICTURE "999999999999.99"
	@ 19,1  SAY "TR.ZARAD.NAKNAD.OST.LI.RA(52)" GET WRDOP    PICTURE "999999999999.99"
	@ 20,1  SAY "TR.PR.U.NEMAT.TROS. I AMORT. " GET WRMIN    PICTURE "999999999999.99"
	@ 21,1  SAY "FINAN.I OSTALI RASHODI(56-59)" GET WRRASF   PICTURE "999999999999.99"
	@ 22,1  SAY "RASHODI                      " GET WRRASUK  PICTURE "999999999999.99"
	@ 23,1  SAY "TEKUCI RA UPLACENO/ISPLACENO " GET WRZIRU   PICTURE "999999999999.99"
	@ 23,52 GET WRZIRI PICTURE "999999999999.99"
	@ 23,68 SAY "S/K  0/1" GET WRSK PICTURE "9"

	READ

	IF Lastkey() = 27
      EXIT
	ENDIF

	wrsvep = Round(wrpv + wrpn + wrpbez + wrusp + wrusbezp + wrosp,2)
	@ 11,1  SAY "SVEGA PRIHODA                "
	@ 11,31 SAY WRSVEP PICTURE "999999999999.99"

	wrrasuk = round(wrnvrrr + wrmin + wrdop + wrrasf,2)
	@ 22,5  SAY "RASHODI                      "
	@ 22,31 SAY WRRASUK PICTURE "999999999999.99"
	**********************************************************

   * ovde ubaciti deo programa za KPR
   @ 13,1 CLEAR TO 23,78
   @ 13,0 SAY Chr(199) + Replicate(Chr(196),78) + Chr(182)
   * @ 13,0 SAY Chr(204) + Replicate(Chr(205),78) + Chr(185)
   
	* o istom trosku da se ucitaju i podaci za KPR; videti da to bude samo jednom
   @ 14,12 SAY " UNOS PODATAKA U KNJIGU PRIMLJENIH RACUNA (ESC - Izlaz) "

   WRBKpR    = wRRb
   WDKKpR    = wRDK
   WDppvdkpr = wRDK
   WDRACKPR  = wRDK
   wBRacKPR  = wRBr
   @ 15,1  SAY "REDNI BROJ" GET WRBKpR PICTURE "9999"
   @ 15,17 SAY "DAT.KNJIZ." GET WDKKpR
   @ 15,39 SAY "DAT.PLAC.U.P." GET WDppvdkpr
   @ 15,64 SAY "B.RA" GET WBRACKPR
   @ 16,1  SAY "DAT.IZ.RAC." GET WDRACKPR
   @ 16,23 SAY "KUPAC(sif.)" GET mDmpdob PICTURE "999999" VALID ProvPP(@mDmpdob, @WPIBKPR)
   @ 16,42 SAY "PIB ili JMBG" GET WPIBKPR
   @ 17,1  SAY "UK.NAK.SA PDV" GET WUKSPDV PICTURE "999999999.99"
   @ 17,29 SAY "UK. NAK. SA PDV pom." GET WUKSPDV1 PICTURE "9999999.99"
   @ 18,1  SAY "OSL.NAB. LICA NE PDV (18.15)" GET WOSLPDV PICTURE "999999999.99"
   @ 19,1  SAY "UVOZ;NE PDV (T.22)" GET WUVOZN PICTURE "999999999.99"
   @ 19,35 SAY "UKUPNA NAKNADA BEZ PDV " GET WNPDV PICTURE "999999999.99"
   @ 20,1  SAY "UK.IZN.OBR.PRETHODN. PDV" GET WUKPPDV PICTURE "999999999.99" ;
	        VALID InicWODPDV(@WODPDV, WUKPPDV)
   @ 20,40 SAY "IZN.PRE.PDV MOZE SE ODB." GET WODPDV PICTURE "999999999.99"
   @ 21,1  SAY "IZN.PRE.PDV NE MOZE SE OD." GET WNEODPDV PICTURE "999999999.99"
   @ 21,40 SAY "VRED.BEZ PDV UVOZ t.21" GET WVBEZPDVU PICTURE "999999999.99"
   @ 22,1  SAY "IZNOS PDV UVOZ tac. 23" GET WIZNPDVU PICTURE "999999999.99"
   @ 22,40 SAY "VRED.PRIM.DOB.I ULUGA t.25" GET WVDU PICTURE "999999999.99"
   @ 23,1  SAY "IZNOS NAKNADE OD 5 %  t. 24  " GET WIZNN5 PICTURE "999999999.99"
   * kraj programa za KPR

   @ 24,24 SAY "Upis (D/N)? " GET DN PICTURE "!" VALID(DN $ "DN")
   READ

   IF Lastkey() = 27
      EXIT
   ENDIF

   IF DN = "N"
      LOOP
   ENDIF

	APPEND BLANK
	REPLACE RRB     WITH wRRb
	REPLACE RDK     WITH WRDK
	REPLACE ROPIS   WITH WROPIS
	REPLACE RBR     WITH WRBR
	REPLACE RDATDOK WITH WRDATDOK
	REPLACE RPV     WITH WRPV
	REPLACE RPN     WITH WRPN
	REPLACE RPN1    WITH WRPN1
	REPLACE RPBEZ   WITH WRPBEZ
	REPLACE RPBEZ06 WITH WOBRPDV
	REPLACE RPBEZ2  WITH WPREPDV
	REPLACE RPBEZ4  WITH WUPLPDV
	REPLACE RUSP    WITH WRUSP
	REPLACE RUSBEZP WITH WRUSBEZP
	REPLACE RPLACP  WITH WROSP
	REPLACE RSVEP   WITH WRSVEP
	REPLACE RNVRRR  WITH WRNVRRR
	REPLACE RVSP    WITH WRVSP
	REPLACE RRUCP   WITH WRRUCP
	REPLACE ROBPOR  WITH WROBPOR
	REPLACE ROBPORU WITH WROBPORU
	REPLACE RPRODV  WITH WRPRODV
	REPLACE RMIN    WITH WRMIN
	REPLACE RDOP    WITH WRDOP
	REPLACE RRASF   WITH WRRASF
	REPLACE RRASUK  WITH WRRASUK
	REPLACE RZIRU   WITH WRZIRU
	REPLACE RZIRI   WITH WRZIRI
	REPLACE RSK     WITH WRSK
   REPLACE PP      WITH wDmpdob

	IF wrsvep <> 0
		SELECT POREZN
		APPEND BLANK
		REPLACE DATK  WITH WRDK
		REPLACE RBPK1 WITH wRRb
		REPLACE BROJ  WITH WRBR
		REPLACE OPIS  WITH WROPIS
		IF WRUSP + WRUSBEZP <> 0
			REPLACE PAZAR WITH ROUND(WRSVEP - WRUSP - WRUSBEZP,2)
		ELSE
			REPLACE PAZAR WITH WRSVEP
		ENDIF
		REPLACE SK WITH WRSK
	ENDIF

   * upis za KPR samo jedan put i to ako ima razlicitih stavki od nule
   IF (wukspdv+wukspdv1+woslpdv+wnpdv+wuvozn+wukppdv+wodpdv+wneodpdv+wvbezpdvu+wiznpdvu+wvdu+wiznn5) <> 0
		mdmpdob = wdmpdob
		SELECT KPR
		APPEND BLANK
		REPLACE RBkPr    WITH WRBkPr
		REPLACE dkkPr    WITH WdkkPr
		REPLACE dPPVDKPR WITh WdPPVDKPR
		REPLACE bracKPR  WITH wbracKPR
		REPLACE dracKPR  with wdracKPR
		REPLACE kupkpr   WITH mDmpdob
		REPLACE kupkpr   WITH wDmpdob
		REPLACE pibkpr   WITH wpibkpr
		REPLACE ukspdv   WITH wukspdv
		REPLACE ukspdv1  WITH wukspdv1
		REPLACE oslpdv   WITH woslpdv
		REPLACE uvozn    WITH wuvozn
		REPLACE npdv     WITH wnpdv
		REPLACE ukppdv   WITH wukppdv
		REPLACE odpdv    WITH wodpdv
		REPLACE neodpdv  WITH wneodpdv
		REPLACE vbezpdvu WITH wvbezpdvu
		REPLACE iznpdvu  WITH wiznpdvu
		REPLACE vdu      WITH wvdu
		REPLACE IZNN5    WITH wiznn5
	ENDIF

	SELECT RASHODN
	wRRb = wRRb + 1
ENDDO

CLOSE DATABASES
RETURN

*******************************************************
PROCEDURE InicWODPDV(pODPDV, pUKPPDV)
	pODPDV = pUKPPDV
RETURN .T.
*******************************************************

*******************************************************
PROCEDURE InicWRDatDok(pWRDatDok, pWRDK)
	pWRDatDok = pWRDK
RETURN .T.
*******************************************************

*******************************************************
FUNCTION ProvPP(SifDob, PIBDob)
	LOCAL SelSav := SELECT()
	LOCAL buttons := {"  Novi  "," Lista  "}

	#IFDEF PREDUZECE
   	USE (ProgDir+"ppdat") INDEX (ProgDir+"ppinsif"),;
      	                         (ProgDir+"ppinnaz"),;
         	                      (ProgDir+"ppinmes"),;
            	                   (ProgDir+"ppinzir") NEW
	#ELSE
   	USE ppdat INDEX ppinsif,ppinnaz,ppinmes,ppinzir NEW
	#ENDIF

	IF (DBSEEK(SifDob))
	   @ 03,26 SAY SUBSTR(ppnaz,1,30)
	   wpibkpr = pppib
	   mDmpdob = ppsif
	   wDmpDob = ppsif
	   SifDob = PPSIF
	   PIBDob = PPPIB
	   CLOSE PpDat
	   SELECT(SelSav)
	   RETURN(.T.)
	ELSE
	   izb = al_box("Niste upisali sifru DOBAVLJACA",2,buttons,2,6,25,12,59)
	   DO CASE
	      CASE izb = 1
	         IF (PPUnos1(1))
	            @ 03,26 SAY SUBSTR(ppnaz,1,30)
	            SifDob = PPSIF
	            PIBDob = PPPIB
	            CLOSE PpDat
	            SELECT(SelSav)
	            RETURN(.T.)
	         END IF
	         CLOSE PpDat
	         SELECT(SelSav)
	         RETURN(.F.)
	      CASE izb = 2
				IF (ListDobavljac())
	            @ 03,26 SAY SUBSTR(ppnaz,1,30)
	            SifDob = PPSIF
	            PIBDob = PPPIB
	            CLOSE PpDat
	            SELECT(SelSav)
	            RETURN(.T.)
	         END IF
	         CLOSE PpDat
	         SELECT(SelSav)
	         RETURN(.F.)
	   END CASE
END IF
*******************************************************
