*******************************************
* Izmena podataka o poslovnim partnerima
*******************************************
LOCAL wPpnaz, wPpadr, wPpzir, wPptel, wPpmes
LOCAL wPib, wPppos, wPpsif, wPpdmg

SELECT 1
USE PPDAT INDEX PPINSIF, PPINNAZ, PPINMES, PPINZIR

DO WHILE .T.

	MainMask("IZMENA POSLOVNOG PARTNERA")
	DN = " "
	wPib = Space(9)
  	wPpsif = 0
	STORE Space(30) TO wPpnaz, wPpadr, wPpzir
	STORE Space(20) TO wPpmes, wPptel
	wPpdmg = Date()
	wPppos = 0

	@ 5,10 SAY "SIFRA....." GET wPpsif PICTURE "999999"
	READ

	IF Lastkey() = 27
		EXIT
	ENDIF

	SEEK wPpsif
	IF ! Found()
		MessageBox("TAKVA SIFRA NE POSTOJI!")
		LOOP
	ENDIF

	wPppos = PPPOS
	wPpnaz = PPNAZ
	wPpadr = PPADR
	wPpmes = PPMES
	wPptel = PPTEL
	wPpzir = PPZIR
	wPib   = PPPIB

	@ 8,10  SAY "NAZIV......" GET wPpnaz
	@ 10,10 SAY "ADRESA....." GET wPpadr
	@ 12,10 SAY "POSTA......" GET wPppos PICTURE "999999"
	@ 14,10 SAY "MESTO......" GET wPpmes 
	@ 16,10 SAY "ZIRO-RACUN." GET wPpzir
	@ 18,10 SAY "TEL/FAX...." GET wPptel
	@ 20,10 SAY "PIB ......." GET wPib
	READ
	
	IF Lastkey() = 27
		EXIT
	ENDIF

	@ 22,10 SAY "UPIS (D/N)? " GET DN PICTURE "!" VALID (DN $ "DN")
	READ
	 
	IF Lastkey() = 27
		EXIT
	ENDIF
	
	IF DN = "N" 
		LOOP
	ENDIF

	REPLACE PPSIF WITH wPpsif
	REPLACE PPADR WITH wPpadr
	REPLACE PPMES WITH wPpmes
	REPLACE PPNAZ WITH wPpnaz
	REPLACE PPPOS WITH wPppos
	REPLACE PPZIR WITH wPpzir
	REPLACE PPTEL WITH wPptel
	REPLACE PPPIB WITH wPib

ENDDO

USE

RETURN
