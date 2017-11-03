LOCAL lIzmenio := .T.

PRIVATE wDat1, wDat2, wSiOp

IF File("DMPINSD.NTX")
	Erase DMPINSD.NTX
ENDIF

SELECT 0
USE DMPDAT
INDEX ON Str(DMPSIF,13,0) + DtoS(DMPDAT) TO DMPINSD
CLOSE DMPDAT

SELECT 0
USE DMPDAT INDEX DMPINSD
SELECT 0
USE ARTPANE INDEX APINSIF,APINART

wSiop  = Val("00000")
wDat1  = Date()
wDat2  = Date()

MainMask("STAMPA NABAVLJENIH ARTIKALA OD DATUMA DO DATUMA")

@ 5,10 SAY "OD DATUMA: " GET wDat1
@ 7,10 SAY "DO DATUMA: " GET wDat2
@ 9,10 SAY "SIFRA OPISA: " GET wSiop
READ

IF Lastkey() = 27
	CLOSE DATABASES
	RETURN
ENDIF

ArtPoGrupi(.T.)

SET KEY -9 TO F10_Print

DO WHILE lIzmenio
   lIzmenio = m_type("artgr.prn",82)
ENDDO

SET KEY -9 TO

CLOSE DATABASES
RETURN

*************************************************
PROCEDURE F10_Print

	ArtPoGrupi(.F.)

RETURN

*************************************************
PROCEDURE ArtPoGrupi(lToFile)
	LOCAL  wPre, wArtCena, wZbirN, wZbirNUk, Red

	Red      = 80
	wZbirN   = 0
	wZbirNUk = 0

	SET DEVICE TO PRINT
	IF(lToFile)
		SET PRINT TO ARTGR
	ELSE
		SET PRINT TO LPT1
	ENDIF
	SET PRINT ON

	SELECT ARTPANE
	GO TOP
	DO WHILE ! Eof()	&& ARTPANE idemo slog po slog
		wPre     = ARTSIF
		wArtCena = ARTCEN

		IF ! SIOP = wSiop
		   SKIP
		   LOOP
		ENDIF

		* tekuci artikal u DMPDAT
		SELECT DMPDAT
		SEEK STR(ARTPANE->ARTSIF,13,0)
		IF Found()
			DO WHILE wPre = DMPSIF
				IF wDat1 <= DMPDAT .AND. DMPDAT <= wDat2
					wZbirN = Round(wZbirN + DMPKOL, 3)
				ENDIF
				SKIP
			ENDDO
		ENDIF

		SELECT ARTPANE
		IF wZbirN = 0
			SKIP
			LOOP
		ENDIF

		wZbirNUk = wZbirNUk + wZbirN * wArtCena

		* odstampati slog za artikal
		IF Red > 62
			@ 2,5  SAY "NABAVLJENI ARTIKLI OD "
			@ 2,27 SAY wDat1
			@ 2,38 SAY "DO "
			@ 2,41 SAY wDat2
			@ 2,51 SAY " - " + SubStr(gcNazRad, 1, 20)
			@ 4,2  SAY "SIFRA ARTIKLA"
			@ 4,16 SAY "         NAZIV ARTIKLA"
			@ 4,45 SAY "NABAVLJENA KOL"
			@ 4,62 SAY "PRODAJNA CENA"
			@ 5,1  SAY Replicate("-",80)
			Red = 6
		ENDIF
		@ Red, 2 SAY wPre PICTURE "9999999999999"
		@ Red,17 SAY ARTNAZ
		@ Red,48 SAY wZbirN PICTURE "9,999,999"
		@ Red,62 SAY wArtCena PICTURE "999,999,999.99"
		* @ Red,62 SAY wZbirN * wArtCena PICTURE "999,999,999.99"
		Red = Red + 1

		wZbirN = 0
		SKIP
	ENDDO	&& Eof() ARTPANE

	@ Red,1 SAY Replicate("-",80)
	Red = Red + 1
	@ Red,40 SAY "Ukupna vrednost:"
	@ Red,62 SAY wZbirNUk PICTURE "999,999,999.99"
	EJECT

	SET DEVICE TO SCREEN
	SET PRINT OFF

RETURN

*************************************************
