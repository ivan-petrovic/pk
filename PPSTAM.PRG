*******************************************
* Stampa jednog poslovnog partnera
*******************************************
LOCAL wPpnaz, wPpadr, wPpzir, wPptel, wPpmes
LOCAL wPib, wPppos, wPpsif, wPpdmg

SELECT 1
USE PPDAT INDEX PPINSIF, PPINZIR, PPINNAZ, PPINMES

DO WHILE .T.

	MainMask("STAMPANJE POSLOVNOG PARTNERA")
	
	DN = " "
	STORE Space(30) TO wPpnaz, wPpadr, wPpzir
	STORE Space(20) TO wPptel, wPpmes
	STORE 0 TO wPpsif, wPppos
	wPpdmg = Date()

	@ 5,10 SAY "SIFRA...." GET wPpsif PICTURE "999999"
	READ

	IF Lastkey() = 27
		EXIT
	ENDIF

	SEEK wPpsif
	IF ! Found()
		MessageBox("Takva sifra ne postoji!")
		LOOP
	ENDIF

	@ 2,56 SAY wPpsif

	SET DEVICE TO PRINTER
	SET PRINTER ON

	@ 1,24 SAY "STAMPA PODATAKA O POSLOVNOM PARTNERU"
	@ 6,10 SAY "SIFRA..............."
	?? PPSIF
	@ 8,10 SAY "NAZIV..............."
	?? PPNAZ
	@ 10,10 SAY "ADRESA.............." 
	?? PPADR
	@ 12,10 SAY "POSTA..............."
	?? PPPOS
	@ 14,10 SAY "MESTO..............."
	?? PPMES
	@ 16,10 SAY "ZIRO-RACUN.........."
	?? PPZIR
	@ 18,10 SAY "TEL/FAX............."
	?? PPTEL

	SET DEVICE TO SCREEN
	SET PRINTER OFF

ENDDO

USE 

RETURN
