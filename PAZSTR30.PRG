LOCAL nPDV_Koef := 0.0, nPDV_KNiza := 0.0

SELECT 0
USE TARDAT
INDEX ON TARSIF TO TARINN
CLOSE TARDAT

WBR = Val("0000")
SELECT 0
USE RASHODN
GO BOTTOM
WBR = RRB + 1
CLOSE RASHODN

SELECT 8
USE KIR INDEX KIRDK,KIRBRAC
SELECT 1
USE ARTPANE INDEX APINSIF,APINART
SELECT 2
USE RASHODN INDEX RASHINDN,RASHINKN
SELECT 6
USE TARDAT INDEX TARINN
SELECT 3
USE PRITAR INDEX PRITIN,PRITSD,dddin
SELECT 5
USE PAZDAT INDEX PAZINDAT,PAZINDA
SELECT 7
USE POREZN INDEX POREZNd,POREZNB,POREZNBB

IND    = 0
INDD   = 0
INDDAT = 0
WZ1     = Val("00000000000000.00")
Wpor18  = Val("00000000000000.00")
Wpor8   = Val("00000000000000.00")
WZ2     = Val("00000000000000.00")
WVISA   = Val("00000000000000.00")
WNIZA   = Val("00000000000000.00")
WNIZA1  = Val("00000000000000.00")
WNULA   = Val("00000000000000.00")
WNULA06 = Val("00000000000000.00")
WNULA2  = Val("00000000000000.00")
WNULA4  = Val("00000000000000.00")
WRAC    = Space(10)
WDMPNAZ = Space(30)

DO WHILE .T.	&& pocetak glavnog

   ind = ind + 1
   WDAT    = Date()
   PRERAC  = Val("00.00")
   POREZ   = Val("000000000000.00")
   WSIFART = Val("0000000000000")
   WKOL    = Val("00000000000.000")
   WPRIH   = Val("00000000000000.00")
   WPRIH1  = Val("00000000000000.00")
   WPRIH2  = Val("00000000000000.00")
   WDPH    = Date()
   WDK     = Date()
   WTPH    = Space(8)
   WSPH    = Val("000.00")
   PN   = "N"
   mPaz = "D"
   WRB  = Val("00.00")
   JJ   = " "
   WPIR = "PAZAR"
   WDRP = DATE()
   WBRP = Val("0000")

   MainMask("UNOS U KNJIGU PRIHODA-RASHODA - STR-a")
   @ 10,10 SAY "DATUM PAZARA: "
   @ 10,25 GET WDAT
   @ 12,10 SAY "BROJ RACUNA:  "
   @ 12,25 GET WRAC
   READ

   IF Lastkey() = 27
      EXIT
   ENDIF

	*******************************************************************
	* UBACEN DEO ZA PAZAR SAMO JEDAN DATUM ZA VISE PRODAJA U TOKU DANA 
	*******************************************************************
   SELECT 2
   SEEK WDAT
   IF Found()
   	DO WHILE WDAT = RDK
      	IF (RPV > 0 .OR. RPN > 0 .OR. RPN1 > 0 .OR. RPBEZ > 0 .OR. RUSP > 0 .OR. RUSBEZP > 0) .AND. RSK = 0
         	INDDAT = 1
         	EXIT
      	ENDIF
         SKIP
    	ENDDO
   ENDIF

   SELECT 7
   SEEK WDAT
   IF Found()
   	DO WHILE WDAT = datk
      	IF (PAZAR > 0 .AND. SK = 0)
         	INDDAT = 1
         	EXIT
      	ENDIF
         SKIP
    	ENDDO
   ENDIF

	DO WHILE .T.
   	wdmpnaz = Space(30)
   	indik   = 0
   	indik3  = 0
   	WSIFART = Val("0000000000000")
   	POMSTOP = Val("000.00")
   	WKOL    = Val("00000000000.000")
   	DN  = " "
   	IND = IND + 1

		@ 14,10 SAY "SIF.ARTIKLA:  "
   	@ 14,25 GET WSIFART PICTURE "9999999999999"
		READ
		
		* ovde ubaciti za pomoc
      IF Lastkey() = 3
      	@ 19,1 SAY "Unesite deo naziva artikla:" GET wdmpnaz PICTURE "@!" VALID ! Empty(wdmpnaz)
         READ
         
			IF Lastkey() = 27
         	LOOP
         ENDIF
         
			SELECT 1
         SET FILTER TO ! At(Alltrim(wdmpnaz),ARTNAZ) = 0
         GO TOP
         
			IF Eof()
         	MessageBox("Ne postoji artikal sa takvim delom naziva!")
            @ 19,1 CLEAR TO 23,78
            SET FILTER TO
            LOOP
         ENDIF
         
			DO WHILE ! Eof()
         	dn = " "
				@ 19, 1 SAY Space(78)
				@ 19, 1 SAY ARTSIF
				@ 19,20 SAY ARTNAZ
				@ 19,51 SAY ARTKOL PICTURE "99999.999"
				@ 19,61 SAY ARTCEN PICTURE "99999.99"
				@ 20,70 SAY AllTrim(ARTTAR)
            
				@ 21,10 SAY "Da li ste mislili na ovaj artikal ? " GET dn;
                    PICTURE "!" VALID (dn $ "DN")
            READ
            
				IF Lastkey() = 27
            	indik = 1
               EXIT
            ENDIF

            IF dn = "N"
               SKIP
               LOOP
            ENDIF

            IF dn = "D"
            	indik3 = 1
            	wsifart = ARTSIF
               wdmpnaz = ARTNAZ
               wartcen = ARTCEN
               EXIT
            ENDIF
            SKIP
         ENDDO

			SET FILTER TO
			GO TOP
         
			IF indik = 1
         	indik = 0
            LOOP
         ENDIF
         
			IF indik3 = 0
         	MessageBox("Nema vise artikala sa tim delom naziva!")
            @ 19,1 CLEAR TO 23,78
            LOOP
         ENDIF
         
			@ 19,1 CLEAR TO 23,78
			wdmpnaz = ARTNAZ
			@ 14,23 SAY wsifart
			@ 14,36 SAY wdmpnaz
			@ 14,71 SAY wARTCEN
			indik3 = 0
			SET FILTER TO
		ENDIF	&& od help-a (Lastkey() = 3)

   	IF Lastkey() = 27
      	EXIT
   	ENDIF
   	
		SELECT 1
   	SEEK WSIFART
   	IF !Found()
      	MessageBox("NE POSTOJI TA SIFRA ARTIKLA")
      	@ 20,20 SAY Replicate(" ",50)
      	IND = 0
      	LOOP
   	ENDIF
 		
		SELECT 6
 		SEEK A->ARTTAR
  		IF Found()
     		pomstop = TARZBIR
  		ELSE
     		@ 20,1 SAY "NEMA TARIFE ZA ARTIKAL"
     		@ 20,25 SAY ARTSIF PICTURE "9999999999999"
     		WAIT " "
     		@ 20,1 SAY Replicate(" ",78)
  		ENDIF

		SELECT 1
		@ 14,37 SAY ARTNAZ
		@ 14,67 SAY "CE"
		@ 14,69 SAY ARTCEN PICTURE "999,999.99"
		@ 16,10 SAY "KOLICINA   "
		@ 16,23 GET WKOL
		READ

		IF Lastkey() = 27
   		EXIT
		ENDIF

		IF WKOL > ARTKOL
			MessageBox("NA LAGERU IMATE" + Str(ARTKOL,13,3))
			IND = 0
			@ 14,37 SAY Replicate(" ",42)
			@ 16,10 SAY Replicate(" ",60)
			@ 20,20 SAY Replicate(" ",50)
			WKOL = 0
			LOOP
		ENDIF
		
		@ 20,10 SAY " DA LI SU PODACI ISPRAVNI D/N  " GET DN PICTURE "!" VALID(DN $ "DdNn+")
		READ
		
		IF Lastkey() = 27
   		EXIT
		ENDIF
		
		IF DN = "N"
   		@ 20,10 SAY Replicate(" ",68)
   		@ 16,10 SAY Replicate(" ",60)
   		@ 14,37 SAY Replicate(" ",42)
		   LOOP
		ENDIF
		
		REPLACE ARTKOL WITH (ARTKOL - WKOL)    && SMANJI KOLICINU; POTVRDIO PRODAJU ARTIKLA
		PRERAC = Round((POMSTOP * 100) / (POMSTOP + 100),2)
		POREZ  = Round(ARTCEN * gnBod * PRERAC / 100,2)
		WZ1 = WZ1 + Round(ARTCEN * gnBod * WKOL,2)
		WZ2 = WZ2 + WPRIH2

		SELECT 3
		APPEND BLANK
		REPLACE DPH WITH WDAT
		REPLACE TPH WITH A->ARTTAR
		REPLACE SPH WITH POMSTOP
		REPLACE Z1  WITH ROUND(A->ARTCEN * gnBod * WKOL,2)
		REPLACE Z2  WITH 0

     	DO CASE
      * bilo je samo CASE POMSTOP = 18, ali je 2012. dodata stopa 20%
		CASE POMSTOP = 18 .OR. POMSTOP = 20
			WVISA = ROUND(WVISA + ROUND(A->ARTCEN * gnBod * WKOL,2),2)
		CASE POMSTOP = 8
			WNIZA = ROUND(WNIZA + ROUND(A->ARTCEN * gnBod * WKOL,2),2)
		CASE POMSTOP = 21 &&.or. pomstop = 16
			WNIZA1 = ROUND(WNIZA1 + ROUND(A->ARTCEN * gnBod * WKOL,2),2)
		CASE POMSTOP = 20
			WNULA06 = ROUND(WNULA06 + ROUND(A->ARTCEN * gnBod * WKOL,2),2)
		CASE POMSTOP = 28
			WNULA2 = ROUND(WNULA2 + ROUND(A->ARTCEN * gnBod * WKOL,2),2)
		CASE POMSTOP = 12
			WNULA4 = ROUND(WNULA4 + ROUND(A->ARTCEN * gnBod * WKOL,2),2)
		CASE POMSTOP = 0
			WNULA = ROUND(WNULA + ROUND(A->ARTCEN * gnBod * WKOL,2),2)
		ENDCASE

		SELECT 5
		APPEND BLANK
		REPLACE PAZDAT   WITH WDAT
		REPLACE PAZART   WITH WSIFART
		REPLACE PAZKOL   WITH WKOL
		REPLACE PAZCMARK WITH A->ARTCEN
		REPLACE PAZCDIN  WITH  ROUND(A->ARTCEN * gnBod,2)
		REPLACE SK       WITH 0
		REPLACE PAZTAR   WITH A->ARTTAR
		REPLACE PAZSTOP  WITH POMSTOP
		pomstop = 0

		@ 14,10 SAY Replicate(" ",69)
		@ 16,10 SAY Replicate(" ",60)
		@ 20,10 SAY Replicate(" ",68)
		
		INDD = 1
		WKOL = 0
		WRAB = 0
	ENDDO		&& tekuci artikal

	IF INDD = 1
   	SELECT 2
   	IF INDDAT = 0
	      APPEND BLANK
	      REPLACE RRB     WITH WBR
	      REPLACE RDK     WITH WDAT
	      REPLACE RBR     WITH ("5/" + ALLTRIM(STR(WBR,4,0)))
	      REPLACE RDATDOK WITH WDAT
	      REPLACE ROPIS   WITH "PAZAR STR"
	      REPLACE RPV     WITH WVISA
	      REPLACE RPN     WITH WNIZA
	      REPLACE RPN1    WITH WNIZA1
	      REPLACE RPBEZ   WITH WNULA
	      * obracun poreza
   	   wpor18 = 0
      	wpor8  = 0
      	nPDV_Koef = KoefPDV(WDAT)            
      	wpor18 = Round(WVISA * nPDV_Koef,2)
      	nPDV_KNiza := KoefPDVNiza(WDAT)
      	wpor8  = Round(WNIZA * nPDV_KNiza,2)
      	* kraj obracuna poreza
       	REPLACE RPBEZ06 WITH Round(wpor18+wpor8,2)
	      REPLACE RSVEP   WITH Round(WVISA + WNIZA + WNIZA1 + WNULA,2)

	      SELECT 7
   	   APPEND BLANK
      	REPLACE DATK  WITH WDAT
      	REPLACE RBPK1 WITH WBR
      	REPLACE BROJ  WITH ("5/" + ALLTRIM(STR(WBR,4,0)))
      	REPLACE OPIS  WITH "PAZAR STR"
      	REPLACE PAZAR WITH Round(WVISA + WNIZA + WNIZA1 + WNULA,2)
      
			SELECT 8
      	APPEND BLANK
      	REPLACE DATKKIR   WITH WDAT
      	REPLACE BRRACKIR  WITH ("5/" + ALLTRIM(WRAC))
      	REPLACE DATRACKIR WITH wDAT
      	* obracun poreza
      	wpor18 = 0
      	wpor8  = 0
      	nPDV_Koef = KoefPDV(WDAT)            
      	wpor18 = Round(WVISA * nPDV_Koef,2)
      	nPDV_KNiza := KoefPDVNiza(WDAT)
      	wpor8  = Round(WNIZA * nPDV_KNiza,2)
      	* kraj obracuna poreza
      	REPLACE OSN18 WITH Round(WVISA - wpor18,2)
      	REPLACE IZN18 WITH wpor18
      	REPLACE OSN8  WITH Round(WNIZA - wpor8,2)
      	REPLACE IZN8  WITH wpor8
      	REPLACE UKSIB WITH (WVISA + WNIZA)
      	REPLACE UKS   WITH (WVISA + WNIZA)
   	ELSE
	      REPLACE RPV   WITH Round(RPV + WVISA,2)
   	   REPLACE RPN   WITH Round(RPN + WNIZA,2)
      	REPLACE RPN1  WITH Round(RPN1 + WNIZA1,2)
      	REPLACE RPBEZ WITH Round(RPBEZ + WNULA,2)
	      REPLACE RSVEP WITH Round(RSVEP + Round(WVISA + WNIZA + WNIZA1 + WNULA,2),2)
      
			SELECT 7
      	REPLACE PAZAR WITH ROUND(PAZAR + WVISA + WNIZA + WNIZA1 + WNULA,2)
   	ENDIF
	ENDIF

EXIT
ENDDO		&& kraj od glavnog

CLOSE DATABASES
RETURN
