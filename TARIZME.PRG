LOCAL wTarSif, wTarDat, wTar, DN, wKljuc
LOCAL	wTarSst,	wTarRst,	wTarOst,	wTarVoj,	wTarTak, wTarZbir

SELECT 2
USE ARTDAT INDEX ARTINSIF, ARTINNAZ
SELECT 1
USE TARDAT INDEX TARINSIF

DO WHILE .T.

	wTarSif = Space(8)
	wTarDat = Date()
	wTar    = Space(8)
	DN = " "

	MainMask("IZMENA TARIFE")
	@ 5,1 SAY "Tarifa:" GET wTarSif PICTURE "@!" VALID ! Empty(wTarSif)
	@ 6,1 SAY "Datum pocetka vazenja tarife:" GET wTarDat VALID ! Empty(wTarDat)
	READ

	IF Lastkey() = 27
		EXIT
	ENDIF

	wKljuc = wTarSif + Dtos(wTarDat)
	SEEK wKljuc
	IF ! Found()
		MessageBox("Ne postoji takva tarifa ili niste uneli dobar datum!")
		LOOP
	ENDIF

	wTarSst = TARSST
	wTarRst = TARRST
	wTarOst = TAROST
	wTarVoj = TARVOJ
	wTarTak = TARTAK

	@ 7,1 SAY "ZELEZNICA"
	@ 8,5 GET wTarSst PICTURE "999.99"
	@ 7,11 SAY "REPUBLICKA STOPA"
	@ 8,15 GET wTarRst PICTURE "999.99"
	@ 7,30 SAY "TAKSA 3 %"
	@ 8,32 GET wTarOst PICTURE "999.99"
	@ 7,40 SAY "POSEBAN SAVEZNI"
	@ 8,46 GET wTarVoj PICTURE "999.99"
	@ 7,53 SAY "POSEBNA TAKSA "
	@ 8,60 GET wTarTak PICTURE "999.99"
	@ 13,5 SAY "Stari naziv tarife : "
	?? wTarSif
	@ 13,40 SAY "Novi naziv tarife :" GET wTar PICTURE "@!" VALID ! Empty(wTar)
	READ

	IF Lastkey() = 27
		LOOP
	ENDIF

	@ 15,10 SAY "Upis podataka (D/N)? " GET DN PICTURE "!" VALID (DN $ "DN")
	READ

	IF Lastkey() = 27
		LOOP
	ENDIF

	IF DN = "D"
		SELECT 1
		DELETE
		PACK
		APPEND BLANK
		wTarZbir = wTarSst + wTarRst + wTarOst + wTarVoj + wTarTak
		REPLACE TARSST WITH wTarSst
		REPLACE TARRST WITH wTarRst
		REPLACE TAROST WITH wTarOst
		REPLACE TARVOJ WITH wTarVoj
		REPLACE TARTAK WITH wTarTak
		REPLACE TARZBIR WITH wTarZbir
		REPLACE TARSIF WITH wTar
		REPLACE TARDAT WITH wTarDat

		SELECT 2
		SET FILTER TO ARTTAR = wTarSif
		GO TOP
		IF Eof()
			SET FILTER TO
			SELECT 1
			LOOP
		ENDIF
		DO WHILE ! Eof()
			REPLACE ARTTAR WITH wTar
			SKIP
		ENDDO
		SET FILTER TO
		SELECT 1
	ENDIF

ENDDO

CLOSE DATABASES
RETURN
