LOCAL wTarSif, wTarDat, wTar, DN, wKljuc, BR
LOCAL	wTarSst,	wTarRst,	wTarOst,	wTarVoj,	wTarTak, wTarZbir

SELECT 1
USE TARDAT INDEX TARINSIF

DO WHILE .T.

	wTarSif = Space(8)
	DN = " "
	BR = "000.00"
	wTarSst = 0
	wTarRst = 0
	wTarOst = 0
	wTarVoj = 0
	wTarZbir =0
	wTarDat = date()

	MainMask("BRISANJE TARIFE")
	@ 5, 1 SAY "Tarifa: " GET wTarSif PICTURE "@!" VALID ! Empty(wTarSif)
	@ 5,35 SAY "Datum pocetka vazenja te tarife:" GET wTarDat VALID ! Empty(wTarDat)
	READ

	IF Lastkey() = 27
		EXIT
	ENDIF

	wKljuc = wTarSif + Dtos(wTarDat)
	SEEK wKljuc
	IF ! Found()
		MessageBox("Ne postoji takva tarifa ili niste dobro naveli datum vazenja!")
		LOOP
	ENDIF

	wTarSst  = TARSST
	wTarRst  = TARRST
	wTarOst  = TAROST
	wTarVoj  = TARVOJ
	wTarZbir = TARZBIR
	wTarDat  = Date()

	@ 7,1 SAY "ZELEZNICA"
	@ 8,5 SAY wTarSst PICTURE "999.99"
	@ 7,11 SAY "REPUBLICKA STOPA"
	@ 8,15 SAY wTarRst PICTURE "999.99"
	@ 7,30 SAY "TAKSA 3 %"
	@ 8,32 SAY wTarOst PICTURE "999.99"
	@ 7,40 SAY "POSEBAN SAVEZNI"
	@ 8,46 SAY wTarVoj PICTURE "999.99"
	@ 15,10 SAY "Brisanje   (d/n) ? " GET DN PICTURE "!" VALID (DN $ "DN")
	READ

	IF Lastkey() = 27
		LOOP
	ENDIF

	IF DN = "D"
		DELETE
		PACK
		LOOP
	ENDIF
ENDDO

USE
CLEAR SCREEN

RETURN
