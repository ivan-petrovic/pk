LOCAL	DN, wArtTar, wArtSif,	wArtNaz,	wArtJM
LOCAL	wArtKol, wArtCen, wDatNab, wSiOp

SELECT 1
USE ARTPANE INDEX APINSIF,APINART
GO TOP

SELECT 2
USE TARDAT INDEX TARINSIF

SELECT 1
DO WHILE .T.

	wArtSif = Val("0000000000000")
	wArtNaz = Space(30)
	wArtJM  = Space(3)
	wArtTar = Space(8)
	wArtKol = val("000000000.000")
	wArtCen = val("00000000000000.00")
	wDatNab = date()
	wSiOp   = Val("00000")
	DN = " "

	MainMask("IZMENA ELEMENATA ARTIKLA")

	SELECT 1  && ARTPANE
	@ 6,4 SAY "SIFRA"
	@ 6,10 GET wArtSif PICTURE "9999999999999" VALID ! Empty(wArtSif)
	READ

	IF Lastkey() = 27
		EXIT
	ENDIF

	SEEK wArtSif
	IF ! Found()
		MessageBox("Nije otvoren artikal sa tom sifrom!")
		LOOP
	ENDIF

	wArtNaz = ARTNAZ
	wArtJM  = ARTJM
	wArtKol = ARTKOL
	wArtCen = ARTCEN
	wSiOp   = SIOP
	wDatNab = DATNAB
	wArtTar = ARTTAR

	@ 8 , 4 SAY "NAZIV ARTIKLA"
	@ 8 ,18 GET wArtNaz PICTURE "@!" VALID ! Empty(wArtNaz)
	@ 10, 4 SAY "JED.MERE"
	@ 10,13 GET wArtJM PICTURE "@!" VALID ! Empty(wArtJM)
	@ 12, 4 SAY "KOLICINA"
	@ 12,13 GET wArtKol PICTURE "999999999.999"
	@ 14, 4 SAY "CENA"
	@ 14, 9 GET wArtCen PICTURE "@!" VALID ! Empty(wArtCen)
	@ 14,35 SAY "DINARA:"
	@ 14,43 SAY (wArtCen * gnBod) PICTURE "999,999,999,999,999.99"
	@ 16, 4 SAY "SIFRA OPISA"
	@ 16,16 GET wSiOp PICTURE "99999"
	@ 18, 4 SAY "DATUM NABAVKE"
	@ 18,18 GET wDatNab
	@ 20, 4 SAY "TARIFA"
	@ 20,11 GET wArtTar
	READ

	IF Lastkey() = 27
		LOOP
	ENDIF

	@ 14,43 SAY (wArtCen * gnBod) PICTURE "999,999,999,999,999.99"

	SELECT 2 && TARDAT
	SEEK wArtTar
	IF ! Found()
		MessageBox("Ne postoji takva tarifa u tarifniku!")
		SELECT 1
		LOOP
	ENDIF

	@ 22,10 SAY "Upis ove sifre u datoteku (D/N)? " GET DN ;
	        PICTURE "!" VALID (DN $ "DNdn+")
	READ

	SELECT 1 && ARTPANE
	IF DN = "D" .OR. DN = "+"
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
