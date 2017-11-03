LOCAL indik, DN
LOCAL	wArtTar, wArtSif,	wArtNaz,	wArtJM, wArtKol, wArtCen
LOCAL	wAutoOp, wDatNab, wSiOp

SELECT 1
USE ARTPANE INDEX APINSIF, APINART
GO TOP

SELECT 2
USE TARDAT INDEX TARINSIF

SELECT 3
USE OPIS INDEX OPIN

SELECT 2 && TARDAT
wArtTar = "5/20    "

MainMask("UNOS NOVOG ARTIKLA")

@ 10,10 SAY "TARIFA KOJU NAJCESCE KORISTITE" GET wArtTar
READ

IF Lastkey() = 27
	CLOSE DATABASES
	RETURN
ENDIF

SEEK wArtTar
IF ! Found()
	MessageBox("NEMATE OTVORENU TAKVU TARIFU")
	CLOSE DATABASES
	RETURN
ENDIF

SELECT 1 && ARTPANE
DO WHILE .T.

	wArtSif = Val("0000000000000")
	wArtNaz = Space(30)
	wArtJM = "KOM"
	wArtKol = Val("000000000.000")
	wArtCen = Val("00000000000000.00")
	wDatNab = Date()
	wSiOp = 1
	DN = " "
	indik = 0

	MainMask("UNOS NOVOG ARTIKLA")

	@ 6,4 SAY "SIFRA"
	@ 6,10 GET wArtSif PICTURE "9999999999999" VALID ! Empty(wArtSif)
	READ

	IF Lastkey() = 27
	   EXIT
	ENDIF

	SEEK wArtSif
	IF Found()
	   MessageBox("Vec je otvoren artikal sa tom sifrom!")
	   LOOP
	ENDIF

	DO WHILE .T.
		@ 8 , 4 SAY "NAZIV ARTIKLA"
		@ 8 ,18 GET wArtNaz PICTURE "@!" VALID ! Empty(wArtNaz)
		@ 10, 4 SAY "JED.MERE"
		@ 10,13 GET wArtJM PICTURE "@!" VALID ! Empty(wArtJM)
		@ 12, 4 SAY "KOLICINA"
		@ 12,13 GET wArtKol PICTURE "999999999.999"
		@ 14, 4 SAY "CENA"
		@ 14, 9 GET wArtCen PICTURE "@!"
		READ

		IF Lastkey() = 27
			indik = 3
			EXIT
		ENDIF

		@ 14,35 SAY "DINARA:"
		@ 14,43 SAY (wArtCen * gnBod) PICTURE "999,999,999,999,999.99"
		@ 16,4 SAY "SIFRA OPISA"
		@ 16,16 GET wSiOp PICTURE "99999"
		READ

		IF Lastkey() = 27
			indik = 3
			EXIT
		ENDIF

		SELECT 3 && OPIS
		SEEK wSiOp
		IF Found()
			wAutoOp = AUTOOP
		ELSE
			MessageBox("NEMATE OTVORENU SIFRU OPISA! OTVORITE JE!")
			indik = 3
			EXIT
		ENDIF

		@ 16,22 SAY wAutoOp
		@ 18,4 SAY "DATUM NABAVKE"
		@ 18,18 GET wDatNab
		@ 20,4 SAY "TARIFA"
		@ 20,11 GET wArtTar
		READ

		IF Lastkey() = 27
			indik = 1
			EXIT
		ENDIF

		SELECT 2 && TARDAT
		SEEK wArtTar
		IF ! Found()
			MessageBox("Ne postoji takva tarifa u tarifniku!")
			SELECT 1 && ARTPANE
			LOOP
		ENDIF

		SELECT 1 && ARTPANE
		EXIT
	ENDDO

	IF indik = 3
		EXIT
	ENDIF

	SELECT 1 && ARTPANE
	IF indik = 1
		indik = 0
		LOOP
	ENDIF

	@ 22,10 SAY "Upis ove sifre u datoteku (D/N)? " GET DN ;
	        PICTURE "!" VALID (DN $ "DN")
	READ

	IF Lastkey() = 27
		LOOP
	ENDIF

	IF DN = "D"
		APPEND BLANK
		REPLACE ARTSIF WITH wArtSif
		REPLACE ARTNAZ WITH wArtNaz
		REPLACE ARTJM  WITH wArtJM
		REPLACE ARTTAR WITH wArtTar
		REPLACE ARTCEN WITH wArtCen
		REPLACE SIOP   WITH wSiOp
		REPLACE DATNAB WITH wDatNab
		REPLACE ARTKOL WITH wArtKol
	ENDIF

ENDDO

CLOSE DATABASES

RETURN
