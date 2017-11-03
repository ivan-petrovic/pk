LOCAL  Red, wZbirN, wZbirP, wDat1, wDat2, wPre

IF File("dmpinsd.ntx")
	Erase dmpinsd.ntx
ENDIF

SELECT 0
USE DMPDAT
INDEX ON Str(DMPSIF,13,0) + Dtos(DMPDAT) TO DMPINSD
CLOSE DMPDAT

IF File("pazsd.ntx")
	Erase pazsd.ntx
ENDIF

SELECT 0
USE PAZDAT
INDEX ON Str(PAZART,13,0) + Dtos(PAZDAT) TO PAZSD
CLOSE PAZDAT

SELECT 0
USE DMPDAT INDEX DMPINSD

SELECT 0
USE ARTPANE INDEX APINSIF,APINART

SELECT 0
USE PAZDAT INDEX PAZSD
SET FILTER TO SK = 0
GO TOP

DO WHILE .T.

	SELECT ARTPANE
	GO TOP
	
	wZbirN = val("0000000000")
	wZbirP = val("0000000000")
	wDat1 = date()
	wDat2 = date()
	Red = 80

	MainMask("STAMPA NABAVLJENIH I PRODATIH ARTIKALA")
	@ 5,10 SAY "OD DATUMA: " GET wDat1
	@ 6,10 SAY "DO DATUMA: " GET wDat2
	READ
	
	IF Lastkey() = 27
		EXIT
	ENDIF

	SET DEVICE TO PRINT
	SET PRINT TO LPT1
	SET PRINT ON

	DO WHILE ! Eof()	&& ARTPANE IDEMO SLOG PO SLOG
		wPre = ARTSIF

		SELECT DMPDAT
		SEEK STR(ARTPANE->ARTSIF,13,0)
		IF Found()
			DO WHILE wPre = DMPSIF
				IF wDat1 <= DMPDAT .and. DMPDAT <= wDat2
					wZbirN = Round(wZbirN + DMPKOL, 3)
				ENDIF
				SKIP
			ENDDO
		ENDIF
		* izasao iz jednog artikla u DMPDAT

		* sada ici i videti da li je prodavan
		SELECT PAZDAT
		SEEK STR(ARTPANE->ARTSIF,13,0)
		IF Found()
			DO WHILE wPre = PAZART
				IF wDat1 <= PAZDAT .and. PAZDAT <= wDat2
					wZbirP = Round(wZbirP + PAZKOL,3)
				ENDIF
				SKIP
			ENDDO
		ENDIF

		SELECT ARTPANE
		IF wZbirN = 0 .and. wZbirP = 0
			SKIP
			LOOP
		ENDIF	

		* odstampati slog za artikal
		IF Red > 65
			@ 2,5  SAY "NABAVLJENI I PRODATI ARTIKLI OD "
			@ 2,37 SAY wDat1
			@ 2,48 SAY "DO "
			@ 2,51 SAY wDat2
			@ 4,2  SAY "SIFRA ARTIKLA"
			@ 4,16 SAY "         NAZIV ARTIKLA        "
			@ 4,47 SAY "NABAVLJENA KOLI."
			@ 4,64 SAY "PRODATA KOLICINA"
			@ 5,1  SAY Replicate("-",80)
			Red = 6
		ENDIF
		@ Red,2  SAY wPre PICTURE "9999999999999"
		@ Red,17 SAY ARTNAZ
		@ Red,50 SAY wZbirN PICTURE "9,999,999"
		@ Red,66 SAY wZbirP PICTURE "9,999,999"
		Red = Red + 1

		wZbirN = 0
		wZbirP = 0
		SKIP
	ENDDO	&& Eof() ARTPANE

	@ Red,1 SAY Replicate("-",80)
	EJECT
	EXIT

ENDDO

SET DEVICE TO SCREEN
SET PRINT OFF
SET FILTER TO

CLOSE DATABASES

RETURN
