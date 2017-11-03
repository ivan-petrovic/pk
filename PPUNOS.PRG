*******************************************
* Unos podataka o poslovnim partnerima
*******************************************
LOCAL b, wPpnaz, wPpadr, wPpzir, wPptel, wPpmes
LOCAL wPib, wPppos, wPpsif, wPpdmg

SELECT 1
USE PPDAT INDEX PPINSIF, PPINNAZ, PPINMES, PPINZIR

b = Lastrec()
b = b + 1

DO WHILE .T.

	MainMask("OTVARANJE POSLOVNOG PARTNERA")

	DN = " "
	STORE Space(30) TO wPpnaz, wPpadr, wPpzir
	STORE Space(20) TO wPptel, wPpmes
	wPib = Space(9)
	wPppos = 0
	wPpsif = b
	wPpdmg = date()

	@ 5,10 SAY "SIFRA......" GET wPpsif PICTURE "999999"
	READ

	IF Lastkey() = 27
	  EXIT
	ENDIF

	SEEK wPpsif
	IF Found()
		MessageBox("Takva sifra vec postoji!")
		LOOP
   ENDIF

   @ 8,10  SAY "NAZIV......" GET wPpnaz
   @ 10,10 SAY "ADRESA....." GET wPpadr
   @ 12,10 SAY "POSTA......" GET wPppos PICTURE "99999"
   @ 14,10 SAY "MESTO......" GET wPpmes
   @ 16,10 SAY "ZIRO-RACUN." GET wPpzir
   @ 18,10 SAY "TEL/FAX...." GET wPptel
   @ 20,10 SAY "PIB ......." GET wPib
   READ

   IF Lastkey () = 27
       EXIT
   ENDIF

	@ 22,10 SAY "Upis d/n? " GET DN PICTURE "!" VALID (DN $ "DN")
	READ

	IF Lastkey() = 27
		EXIT
	ENDIF

	IF DN = "N"
		LOOP
	ENDIF

	APPEND BLANK
	REPLACE PPSIF WITH wPpsif
	REPLACE PPNAZ WITH Upper(wPpnaz)
	REPLACE PPADR WITH Upper(wPpadr)
	REPLACE PPPOS WITH wPppos
	REPLACE PPMES WITH Upper(wPpmes)
	REPLACE PPZIR WITH wPpzir
	REPLACE PPDMG WITH wPpdmg
	REPLACE PPTEL WITH wPptel
	REPLACE PPPIB WITH wPib

	b = b + 1
ENDDO

USE

RETURN
