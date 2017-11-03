LOCAL nPDV_Koef := 0.0, nPDV_KNiza := 0.0

SELECT 0
USE PAZDAT INDEX PAZINDAT
SELECT 0
USE KIR INDEX KIRDK,KIRBRAC

Zbir   = Val("000000000000.00")
Zbir18 = Val("000000000000.00")
Zbir8  = Val("000000000000.00")
mPor18 = Val("000000000000.00")
mPor8  = Val("000000000000.00")
wPre = CtoD("  .  .  ")
Dat1 = Date()
Dat2 = Date()

CLEAR SCREEN
@ 0,0 TO 24,79 DOUBLE
@ 1,1 SAY Centriraj("AZURIRANJE KIR-a IZ PRODATIH ARTIKALA", 78)

@ 4,8 SAY "OD DATUMA: " GET Dat1
@ 5,8 SAY "DO DATUMA: " GET Dat2
READ

IF Lastkey() =  27
	CLOSE DATABASES
	RETURN
ENDIF

SELECT PAZDAT
DO WHILE ! Eof()
	IF PAZDAT < Dat1 .OR. PAZDAT > Dat2
   	SKIP
   	IF Eof()
      	EXIT
      ELSE
      	LOOP
      ENDIF
   ENDIF

   wPre = PAZDAT
   @ 10,10 SAY "RADIM DATUM"
   @ 10,25 SAY wPre

	DO WHILE wPre = PAZDAT
		DO CASE
         * bilo je ovako CASE PAZSTOP = 18, ali u 2012 ima stopa 18% i 20%
			CASE PAZSTOP <> 8       
				Zbir18 = Round(Zbir18 + Round(PAZKOL * PAZCDIN,2),2)
			CASE PAZSTOP = 8
				Zbir8 = Round(Zbir8 + Round(PAZKOL * PAZCDIN,2),2)
		ENDCASE
		Zbir = Round(Zbir18 + Zbir8,2)
		SKIP
	ENDDO
   
	SELECT KIR
   SEEK DtoS(wPre)
	IF Found()
		DO WHILE wPre = DATKKIR
			IF Substr(brrackir,1,2) = "5/"
				REPLACE DATRACKIR WITH wPre
				* ubaceno da sredi porez
				mPor18 = 0
				mPor8  = 0
				nPDV_Koef = KoefPDV(wPre)            
            mPor18 = Round(Zbir18 * nPDV_Koef,2)
            nPDV_KNiza := KoefPDVNiza(wPre)
				mPor8  = Round(Zbir8  * nPDV_KNiza,2)
				* kraj sredjivanja poreza
				REPLACE OSN18 WITH round(Zbir18 - mPor18,2)
				REPLACE IZN18 WITH mPor18
				REPLACE OSN8  WITH round(Zbir8 - mPor8,2)
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
		REPLACE BRRACKIR  WITH "5/"
		REPLACE DATRACKIR WITH wPre
		* ubaceno da sredi porez
		mPor18 = 0
		mPor8  = 0
		nPDV_Koef = KoefPDV(wPre)      
		mPor18 = Round(Zbir18 * nPDV_Koef,2)
		nPDV_KNiza := KoefPDVNiza(wPre)
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
   SELECT PAZDAT
ENDDO

CLOSE DATABASES
RETURN
