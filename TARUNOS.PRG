LOCAL wTarSif,	wTarDat,	BR, wTarSst, wTarRst, wTarOst
LOCAL	wTarVoj, wTarTak, wTarZbir, DN, wKljuc

SELECT 1
USE TARDAT INDEX TARINSIF

DO WHILE .T.

	MainMask("OTVARANJE NOVE TARIFE")

	wTarSif = Space(8)
	wTarDat = DATE()
	BR = "000.00"
	wTarSst  = 0
	wTarRst  = 0
	wTarOst  = 0
	wTarVoj  = 0
	wTarTak  = 0
	wTarZbir = 0
	DN = " "

	@ 5,1 SAY "TARIFA:" GET wTarSif PICTURE "@!" VALID ! Empty(wTarSif)
	READ

	IF Lastkey() = 27
		EXIT
	ENDIF

	@ 7,1 SAY "ZELEZNICA"
	@ 8,5 GET wTarSst PICTURE "999.99"
	@ 7,11 SAY "REPUBLICKA STOPA"
	@ 8,15 GET wTarRst PICTURE "999.99"
	@ 7,30 SAY "TAKSA 3 %"
	@ 8,32 GET wTarOst PICTURE "999.99"
	@ 7,40 SAY "POSEBAN SAVEZNI"
	@ 8,46 GET wTarVoj PICTURE "999.99"
	@ 7,53 SAY "POSEBNA TAKSA  "
	@ 8,60 GET wTarTak PICTURE "999.99"
	@ 10,25 SAY "DATUM POCETKA VAZENJA TARIFE:" GET wTarDat VALID ! Empty(wTarDat)
	READ

	IF Lastkey() = 27
		LOOP
	ENDIF

	wKljuc = wTarSif + DTOS(wTarDat)
	SEEK wKljuc

	IF Found()
	   MessageBox("VEC POSTOJI OTVORENA TAKVA TARIFA!")
		LOOP
	ENDIF

	@ 15,10 SAY "UPIS UNETIH PODATAKA (D/N)? " GET DN PICTURE "!"	VALID (DN $ "DN")
	READ

	IF Lastkey() = 27
		LOOP
	ENDIF

	IF DN = "D"
		wTarZbir = ROUND(wTarSst + wTarRst + wTarOst + wTarVoj + wTarTak, 2)
		APPEND BLANK
		REPLACE TARSIF WITH wTarSif
		REPLACE TARSST WITH wTarSst
		REPLACE TARRST WITH wTarRst
		REPLACE TAROST WITH wTarOst
		REPLACE TARVOJ WITH wTarVoj
		REPLACE TARTAK WITH wTarTak
		REPLACE TARZBIR WITH wTarZbir
		REPLACE TARDAT WITH wTarDat
	ENDIF

ENDDO

USE
RETURN
