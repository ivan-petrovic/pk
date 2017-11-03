LOCAL nPDV_Koef := 0.0, nPDV_KNiza := 0.0

* RAZDVOJ STAVKE U RASHODIMA KOJE SU ZAJEDNICKE ZA PAZAR I KALKULACIJU
! COPY RASHODN.DBF RASPOM05.DBF > NULL
SELECT 0
USE RASPOM05 EXCLUSIVE
ZAP
CLOSE RASPOM05

SELECT 0
USE RASPOM05

SELECT 0
USE RASHODN

DO WHILE ! Eof()
	IF RSVEP <> 0 .AND. RPRODV <> 0
		* idemo na razdvajanje
		* zapamti prethodna polja
		wrrb     = RRB
		wrdk     = RDK
		wrbr     = RBR
		wropis   = ROPIS
		wrdatdok = RDATDOK
		wrpv     = RPV
		wrpn     = RPN
		wrusp    = RUSP
		wrsvep   = RSVEP

		* ponisti postojece vrednosti pazara
		REPLACE RPV   WITH 0
		REPLACE RPN   WITH 0
		REPLACE RUSP  WITH 0
		REPLACE RSVEP WITH 0

		* dodaj stavku pazara
		SELECT RASPOM05
		APPEND BLANK
		REPLACE RRB     WITH wrrb
		REPLACE RDK     WITH wrdk
		REPLACE RBR     WITH "5/" + Str(wrrb,5,0)
		REPLACE ROPIS   WITH "PAZAR "
		REPLACE RDATDOK WITH wrdatdok
		REPLACE RPV     WITH wrpv
		REPLACE RPN     WITH wrpn
		REPLACE RUSP    WITH wrusp
		REPLACE RSVEP   WITH wrsvep

		SELECT RASHODN
	ENDIF

	SKIP
ENDDO
* KRAJ RAZDVAJANJA

* SVE ZATVORI, APENDUJ U RASHODN IZ RASPOM05,
* SVE ZATVORI, INDEKSIRAJ RASHODN, PA ONDA NASTAVI NORMALNO
SELECT RASHODN
CLOSE RASHODN
SELECT RASPOM05
CLOSE RASPOM05

SELECT 0
USE RASHODN
APPEND FROM RASPOM05.DBF
CLOSE RASHODN

SELECT 0
USE RASHODN
INDEX ON RBR TO RASHINKN
INDEX ON DTOS(RDK) TO RASHINDN
CLOSE RASHODN

* ODAVDE POCINJE NORMALNO
SELECT 0
USE RASHODN INDEX RASHINDN
SELECT 0
USE KIR INDEX KIRDK,KIRBRAC

Zbir   = Val("000000000000.00")
Zbir18 = Val("000000000000.00")
Zbir8  = Val("000000000000.00")
mPor18 = Val("000000000000.00")
mPor8  = Val("000000000000.00")
wPre   = CtoD("  .  .  ")
wPreR  = Space(10)
Dat1   = Date()
Dat2   = Date()

MainMask("AZURIRANJE KIR-a IZ KNJIGE PRIHOD-RASHOD")

@ 4,8 SAY "OD DATUMA: " GET Dat1
@ 5,8 SAY "DO DATUMA: " GET Dat2
READ

IF Lastkey() =  27
	CLOSE DATABASES
	RETURN
ENDIF

SELECT RASHODN
DO WHILE ! Eof()
	IF RDK < Dat1 .OR. RDK > Dat2
   	SKIP
      IF Eof()
         EXIT
      ELSE
         LOOP
      ENDIF
   ENDIF

	wPre = RDK
	@ 10,10 SAY "RADIM DATUM: "
	@ 10,25 SAY wPre

	DO WHILE wPre = RDK
		IF RPV <> 0 .OR. RPN <> 0 .OR. RUSP <> 0
			wPre  = RDK
			wPreR = RBR
		ENDIF
		Zbir18 = Round(Zbir18 + RPV + RUSP,2)
		Zbir8  = Round(Zbir8  + RPN,2)
		Zbir   = Round(Zbir18 + Zbir8,2)
		SKIP
	ENDDO
   
	IF Zbir = 0
   	LOOP
   ENDIF

   SELECT KIR
   SEEK DtoS(wPre)
	IF Found()
		DO WHILE wPre = DATKKIR
			IF Substr(BRRACKIR,1,2) = "5/"
				REPLACE DATRACKIR WITH wPre
				REPLACE UKNAKKIR  WITH Zbir
				* ubaceno da sredi porez
				nPDV_Koef = KoefPDV(wPre)            
            mPor18 = Round(Zbir18 * nPDV_Koef,2)
            nPDV_KNiza = KoefPDVNiza(wPre)
				mPor8  = Round(Zbir8  * nPDV_KNiza,2)
				* kraj sredjivanja poreza
				REPLACE OSN18 WITH Round(Zbir18 - mPor18,2)
				REPLACE IZN18 WITH mPor18
				REPLACE OSN8  WITH Round(Zbir8 - mPor8,2)
				REPLACE IZN8  WITH mPor8
				REPLACE UKSIB WITH (Zbir8 + Zbir18)
				REPLACE UKS   WITH (Zbir8 + Zbir18)
				EXIT
			ENDIF
			SKIP
		ENDDO
   ELSE
		APPEND BLANK
		REPLACE DATKKIR   WITH wPre
		REPLACE BRRACKIR  WITH wPreR
		REPLACE DATRACKIR WITH wPre
		REPLACE UKNAKKIR  WITH Zbir
		* ubaceno da sredi porez
		nPDV_Koef = KoefPDV(wPre)      
		mPor18 = Round(Zbir18 * nPDV_Koef,2)
		nPDV_KNiza = KoefPDVNiza(wPre)
		mPor8  = Round(Zbir8  * nPDV_KNiza,2)
		* kraj sredjivanja poreza
		REPLACE OSN18 WITH Round(Zbir18 - mPor18,2)
		REPLACE IZN18 WITH mPor18
		REPLACE OSN8  WITH Round(Zbir8 - mPor8,2)
		REPLACE IZN8  WITH mPor8
		REPLACE UKSIB WITH (Zbir8 + Zbir18)
		REPLACE UKS   WITH (Zbir8 + Zbir18)
	ENDIF
      
	Zbir18 = 0
   Zbir8  = 0
   Zbir   = 0
   mPor18 = 0
   mPor8  = 0
   SELECT RASHODN

ENDDO

CLOSE DATABASES
RETURN
