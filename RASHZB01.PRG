LOCAL nPDV_Koef := 0.0, nPDV_KNiza := 0.0

USE RASHODN INDEX RASHINDN

	SK = " "
	OznT = Val("000")
	CLEAR SCREEN
   @ 10,10 SAY "STR ILI KOMISION ILI SVE  S/K " GET SK
   @ 12,10 SAY "OZNAKA TROSKA                 " GET OznT
   READ

   IF Lastkey() = 27
      CLOSE RASHODN
      RETURN
   ENDIF

   @ 0,1 SAY " Izlaz = ESC "

   IF SK = "S" .OR. SK = "s"
      IF Empty(OznT)
      	SET FILTER TO RSK = 0
		ELSE
		   SET FILTER TO RSK = 0 .AND. ;
				Val(SubStr(RBR, 1, IIF(At("/", RBR) != 0, At("/", RBR) - 1, 0 ) ) ) = OznT
      ENDIF
   ELSE
	   IF SK = "K" .OR. SK = "k"
	      IF Empty(OznT)
	      	SET FILTER TO RSK = 1
			ELSE
			   SET FILTER TO RSK = 1 .AND. ;
					Val(SubStr(RBR, 1, IIF(At("/", RBR) != 0, At("/", RBR) - 1, 0 ) ) ) = OznT
	      ENDIF
		ELSE
	      IF ! Empty(OznT)
			   SET FILTER TO Val(SubStr(RBR, 1, IIF(At("/", RBR) != 0, At("/", RBR) - 1, 0 ) ) ) = OznT
	      ENDIF
	   ENDIF
	ENDIF
	GO TOP

   DAT1 = Date()
   DAT2 = Date()

	WRPV     = Val("00000000000000.00")
	WRPN     = Val("00000000000000.00")
	WRPN1    = Val("00000000000000.00")
	WRPBEZ   = Val("00000000000000.00")
	WRPBEZ06 = Val("00000000000000.00")      && UKALKULISANI PDV
	WRPBEZ2  = Val("00000000000000.00")      && PRENETI PDV
	WRPBEZ4  = Val("00000000000000.00")      && PLACENI PDV
	WRUSP    = Val("00000000000000.00")
   nPorezRUSP = Val("00000000000000.00")
   nPorezRPV = Val("00000000000000.00")
	WRUSBEZP = Val("00000000000000.00")
	WRPLACP  = Val("00000000000000.00")      && OSTALI PRIHODI
	WRSVEP   = Val("00000000000000.00")
	WRNVRRR  = Val("00000000000000.00")
	WRVSP    = Val("00000000000000.00")
	WRRUCP   = Val("00000000000000.00")
	WROBPOR  = Val("00000000000000.00")
	WROBPORU = Val("00000000000000.00")
	WRPRODV  = Val("00000000000000.00")
	WRMIN    = Val("00000000000000.00")
	WRDOP    = Val("00000000000000.00")
	WRRASF   = Val("00000000000000.00")
	WRRASUK  = Val("00000000000000.00")
	WRZIRU   = Val("00000000000000.00")
	WRZIRI   = Val("00000000000000.00")
	wp       = Val("000000000000.00")
	wpv      = Val("000000000000.00")
	wpn      = Val("000000000000.00")
	wd       = Val("000000000000.00")
	wdp      = Val("000000000000.00")
	wdd      = Val("000000000000.00")
	wpuv     = Val("000000000000.00")
	wt       = Val("000000000000.00")
	wtz      = Val("000000000000.00")
	wtsz     = Val("000000000000.00")
	wtnsupr  = Val("000000000000.00")
	wputun   = Val("000.00")

	CLEAR SCREEN
   @ 10,10 SAY "ZBIROVI KNJIGE RASHODA OD DATUMA" GET DAT1
   @ 10,53 SAY "DO DATUMA" GET DAT2
   READ

   IF Lastkey() = 27
      SET FILTER TO
      CLOSE RASHODN
      RETURN
   ENDIF

	DO WHILE .T.
	   IF Eof()
	      EXIT
	   ENDIF
	   IF RDK >= DAT1 .AND. RDK <= DAT2

         nPDV_Koef = KoefPDV(RDK)
         nPorezRPV = Round(nPorezRPV + RPV * nPDV_Koef, 2)
         nPorezRUSP = Round(nPorezRUSP + RUSP * nPDV_Koef, 2)
      
	      WRPV     = Round(WRPV + RPV,2)
	      WRPN     = Round(WRPN + RPN,2)
	      WRPN1    = Round(WRPN1 + RPN1,2)
	      WRPBEZ   = Round(WRPBEZ + RPBEZ,2)
	      WRPBEZ06 = Round(WRPBEZ06 + RPBEZ06,2)
	      WRPBEZ2  = Round(WRPBEZ2 + RPBEZ2,2)
	      WRPBEZ4  = Round(WRPBEZ4 + RPBEZ4,2)
	      WRUSP    = Round(WRUSP + RUSP,2)
	      WRUSBEZP = Round(WRUSBEZP + RUSBEZP,2)
	      WRPLACP  = Round(WRPLACP + RPLACP,2)
	      WRSVEP   = Round(WRSVEP + RSVEP,2)
	      WRNVRRR  = Round(WRNVRRR + RNVRRR,2)
	      WRVSP    = Round(WRVSP + RVSP,2)
	      WRRUCP   = Round(WRRUCP + RRUCP,2)
	      WROBPOR  = Round(WROBPOR + ROBPOR,2)
	      WROBPORU = Round(WROBPORU + ROBPORU,2)
	      WRPRODV  = Round(WRPRODV + RPRODV,2)
	      WRMIN    = Round(WRMIN + RMIN,2)
	      WRDOP    = Round(WRDOP + RDOP,2)
	      WRRASF   = Round(WRRASF + RRASF,2)
	      WRRASUK  = Round(WRRASUK + RRASUK,2)
	      WRZIRU   = Round(WRZIRU + RZIRU,2)
	      WRZIRI   = Round(WRZIRI + RZIRI,2)
	   ENDIF
	 	SKIP
	ENDDO

	* ide obracun Peri za dobit
   wpv  = Round(wrpv - nPorezRPV,2)
   nPDV_KNiza = KoefPDVNiza(DAT1)
	wpn  = Round(wrpn - Round(wrpn * nPDV_KNiza,2),2)
   wpuv = Round(wrusp - nPorezRUSP,2)
	* racunamo prihod
	wp = Round(wpv + wpn + wrpbez + wpuv + wrusbezp,2)  && prihod
	* kraj racuna prihoda
	wtz = Round(wrprodv - Round(wrsvep - wrusp - wrusbezp,2),2)
	wputun = Round((wrnvrrr * 100) / wrprodv,2)
	wtsz = Round(wtz * (wputun / 100),2)
	wtnsupr = Round(wrnvrrr - wtsz,2)
	* racunamo trosak
	wt = Round(wrnvrrr - wtsz + wrmin + wrdop + wrrasf,2)   && trosak
	* kraj racuna troska
	* racunam dobit i poreze iz dobiti
   wd = Round(wp - wt,2)      && dobit
	wdp = Round(wd * 0.1000,2)  && porez iz dobiti
	wdd = Round(wd * 0.378,2)  && doprinosi iz dobiti
	* kraj racuna dobit i poreza iz dobiti
	* kraj obracuna Peri za dobit

	CLEAR SCREEN
   @ 0,1 SAY " Izlaz = ESC "
   @ 1,0 TO 24,79 DOUBLE
	@ 2, 5 SAY gcNazRad
	@ 3,20 SAY "ZBIROVI OD"
	@ 3,31 SAY DAT1
	@ 3,43 SAY "DO"
	@ 3,46 SAY DAT2

   @  4, 5 SAY "PRIHOD OD DOBARA OPSTA       "
   @  4,35 SAY WRPV PICTURE "999999999999.99"
   @  5, 5 SAY "PRIHOD OD DOBARA POSEBNA     "
   @  5,35 SAY WRPN PICTURE "999999999999.99"
   @  6, 5 SAY "PRIHOD OD DOBARA BEZ PDV     "
   @  6,35 SAY WRPBEZ PICTURE "999999999999.99"
   @  7, 5 SAY "PRIHOD OD USLUGA SA PDV      "
   @  7,35 SAY WRUSP PICTURE "999999999999.99"
   @  8, 5 SAY "PRIHOD OD USLUGA BEZ PDV    "
   @  8,35 SAY WRUSBEZP PICTURE "999999999999.99"
   @  9, 5 SAY "OSTALI PRIHODI (63 - 69)    "
   @  9,35 SAY WRPLACP PICTURE "999999999999.99"
   @ 10, 5 SAY "SVEGA PRIHODA               "
   @ 10,35 SAY WRSVEP PICTURE "999999999999.99"
   @ 11, 5 SAY "OBRACUNATI PDV "
   @ 11,22 SAY  WRPBEZ06 PICTURE "999999999999.99"
   @ 11,40 SAY "PRETHODNI PDV "
   @ 11,56 SAY  WRPBEZ2 PICTURE "999999999999.99"
   @ 12, 5 SAY "UPLACEN PDV                  "
   @ 12,35 SAY WRPBEZ4 PICTURE "999999999999.99"
   @ 13, 5 SAY "NAB.VRED.ROBE,REPRO.REZ.DEL "
   @ 13,35 SAY WRNVRRR PICTURE "999999999999.99"
   @ 14, 5 SAY "VRED.SOPSTVEN.PROIZVODA     "
   @ 14,35 SAY WRVSP PICTURE "999999999999.99"
   @ 15, 5 SAY "RAZLIKA U CENI              "
   @ 15,35 SAY WRRUCP PICTURE "999999999999.99"
   @ 16, 5 SAY "OBRACUNATI PDV              "
   @ 16,35 SAY WROBPOR PICTURE "999999999999.99"
   @ 17, 5 SAY "PROD.VRADNOST ROB. I PROIZ. "
   @ 17,35 SAY WRPRODV PICTURE "999999999999.99"
   @ 18, 5 SAY "TR.ZARAD.NAKNA.OS.LI.RA.(52)"
   @ 18,35 SAY WRDOP PICTURE "999999999999.99"
   @ 19, 5 SAY "TR.PR.US.AMO.I NEM.(53-55)  "
   @ 19,35 SAY WRMIN PICTURE "999999999999.99"
   @ 20, 5 SAY "FINANSIJ.IOSTA.RASH.(56-59)"
   @ 20,35 SAY WRRASF PICTURE "999999999999.99"
   @ 21, 5 SAY "RASHODI                     "
   @ 21,35 SAY WRRASUK PICTURE "999999999999.99"
   @ 22, 5 SAY "TEKUCI RA.UPLACENO/ISPLACENO"
   @ 22,35 SAY WRZIRU PICTURE "999999999999.99"
   @ 22,52 SAY WRZIRI PICTURE "999999999999.99"

	INKEY(0)

	CLEAR SCREEN
	* ovde ubaciti gledanje rezultata poslovanja
	@  1, 5 SAY gcNazRad
	@  3,20 SAY "ZBIROVI OD"
	@  3,31 SAY DAT1
	@  3,43 SAY "DO"
	@  3,46 SAY DAT2
	@  5,30 SAY "OBRACUN DOBITI"
	@  7, 5 SAY "PAZAR P = "
	@  7,15 SAY wp PICTURE "999,999,999.99"
	@  9, 5 SAY "ZALIHE ROBE U PRODAVNICI "
	@  9,30 SAY WTZ PICTURE "999,999,999.99"
	@ 11, 5 SAY "PROCENAT UCESCA TROSKOVA U NABAVCI "
	@ 11,40 SAY wputun PICTURE "999.99"
	@ 13, 5 SAY "TROSKOVI NABAVKE SADRZANI U ZALIHAMA "
	@ 13,42 SAY wtsz PICTURE "999,999,999.99"
	@ 15, 5 SAY "TROSKOVI NABAVKE SADRZANI U PRODATOJ ROBI "
	@ 15,47 SAY wtnsupr PICTURE "999,999,999.99"
	@ 17, 5 SAY "TROSKOVI T = "
	@ 17,18 SAY wt PICTURE "999,999,999.99"
	@ 19, 5 SAY "DOBIT "
	@ 19,11 SAY wD PICTURE "999,999,999.99"
	@ 21, 5 SAY "POREZ IZ DOBITI D X 10% = "
	@ 21,31 SAY wdp PICTURE "999,999,999.99"
	@ 23, 5 SAY "DOPRINOSI IZ DOBITI D X 37,80% = "
	@ 23,38 SAY wDD PICTURE "999,999,999.99"

	dn = " "
	@ 24,10 SAY "STAMPANJE ZBIROVA KNJIGE I OBRACUNA DOBITI (D/N)? " GET dn PICTURE "!" VALID(dn $ "DdNn")
	READ

	IF Lastkey() = 27 .OR. dn = "N"
   	CLOSE RASHODN
   	RETURN
	ENDIF

	SET DEVICE TO PRINT
	SET PRINTER TO LPT1
	* SET PRINT TO LISTA
	SET PRINT ON
	Setprc(0,0)

	@ 1, 5 SAY gcNazRad
	@ 2,20 SAY "ZBIROVI OD"
	@ 2,31 SAY DAT1
	@ 2,43 SAY "DO"
	@ 2,46 SAY DAT2

	@  4, 5 SAY "PRIHOD OD DOBARA OPSTA       "
	@  4,35 SAY WRPV PICTURE "999999999999.99"
	@  5, 5 SAY "PRIHOD OD DOBARA POSEBNA     "
	@  5,35 SAY WRPN PICTURE "999999999999.99"
	@  6, 5 SAY "PRIHOD OD DOBARA BEZ PDV     "
	@  6,35 SAY WRPBEZ PICTURE "999999999999.99"
	@  7, 5 SAY "PRIHOD OD USLUGA SA PDV      "
	@  7,35 SAY WRUSP PICTURE "999999999999.99"
	@  8, 5 SAY "PRIHOD OD USLUGA BEZ PDV    "
	@  8,35 SAY WRUSBEZP PICTURE "999999999999.99"
	@  9, 5 SAY "OSTALI PRIHODI (63 - 69)    "
	@  9,35 SAY WRPLACP PICTURE "999999999999.99"
	@ 10, 5 SAY "SVEGA PRIHODA               "
	@ 10,35 SAY WRSVEP PICTURE "999999999999.99"
	@ 11, 5 SAY "OBRACUNATI PDV "
	@ 11,22 SAY  WRPBEZ06 PICTURE "999999999999.99"
	@ 11,40 SAY "PRETHODNI PDV "
	@ 11,56 SAY  WRPBEZ2 PICTURE "999999999999.99"
	@ 12, 5 SAY "UPLACEN PDV                  "
	@ 12,35 SAY WRPBEZ4 PICTURE "999999999999.99"
	@ 13, 5 SAY "NAB.VRED.ROBE,REPRO.REZ.DEL "
	@ 13,35 SAY WRNVRRR PICTURE "999999999999.99"
	@ 14, 5 SAY "VRED.SOPSTVEN.PROIZVODA     "
	@ 14,35 SAY WRVSP PICTURE "999999999999.99"
	@ 15, 5 SAY "RAZLIKA U CENI              "
	@ 15,35 SAY WRRUCP PICTURE "999999999999.99"
	@ 16, 5 SAY "OBRACUNATI PDV              "
	@ 16,35 SAY WROBPOR PICTURE "999999999999.99"
	@ 17, 5 SAY "PROD.VRADNOST ROB. I PROIZ. "
	@ 17,35 SAY WRPRODV PICTURE "999999999999.99"
	@ 18, 5 SAY "TR.ZARAD.NAKNA.OS.LI.RA.(52)"
	@ 18,35 SAY WRDOP PICTURE "999999999999.99"
	@ 19, 5 SAY "TR.PR.US.AMO.I NEM.(53-55)  "
	@ 19,35 SAY WRMIN PICTURE "999999999999.99"
	@ 20, 5 SAY "FINANSIJ.IOSTA.RASH.(56-59)"
	@ 20,35 SAY WRRASF PICTURE "999999999999.99"
	@ 21, 5 SAY "RASHODI                     "
	@ 21,35 SAY WRRASUK PICTURE "999999999999.99"
	@ 22, 5 SAY "TEKUCI RA.UPLACENO/ISPLACENO"
	@ 22,35 SAY WRZIRU PICTURE "999999999999.99"
	@ 22,52 SAY WRZIRI PICTURE "999999999999.99"

	@ 25,30 SAY "OBRACUN DOBITI"
	@ 27, 5 SAY "PAZAR P = "
	@ 27,15 SAY wp PICTURE "999,999,999.99"
	@ 29, 5 SAY "ZALIHE ROBE U PRODAVNICI "
	@ 29,30 SAY WTZ PICTURE "999,999,999.99"
	@ 31, 5 SAY "PROCENAT UCESCA TROSKOVA U NABAVCI "
	@ 31,40 SAY wputun PICTURE "999.99"
	@ 33, 5 SAY "TROSKOVI NABAVKE SADRZANI U ZALIHAMA "
	@ 33,42 SAY wtsz PICTURE "999,999,999.99"
	@ 35, 5 SAY "TROSKOVI NABAVKE SADRZANI U PRODATOJ ROBI "
	@ 35,47 SAY wtnsupr PICTURE "999,999,999.99"
	@ 37, 5 SAY "TROSKOVI T = "
	@ 37,18 SAY wt PICTURE "999,999,999.99"
	@ 39, 5 SAY "DOBIT "
	@ 39,11 SAY wD PICTURE "999,999,999.99"
	@ 41, 5 SAY "POREZ IZ DOBITI D X 10% = "
	@ 41,31 SAY wdp PICTURE "999,999,999.99"
	@ 43, 5 SAY "DOPRINOSI IZ DOBITI D X 37,80% = "
	@ 43,38 SAY wDD PICTURE "999,999,999.99"

   EJECT

   SET PRINTER OFF
   SET PRINT TO
   SET DEVICE TO SCREEN
   SET CONSOLE ON

	SET FILTER TO
	CLOSE RASHODN
	RETURN
