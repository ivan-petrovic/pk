LOCAL wPpsif, DN

SELECT 1
USE PPDAT INDEX PPINSIF

DO WHILE .T.

	MainMask("BRISANJE POSLOVNOG PARTNERA")
	DN = " "
	wPpsif = val("000000")

	@ 5,10 SAY "SIFRA......" GET wPpsif PICTURE "999999" VALID ! Empty(wPpsif)
	READ

	IF Lastkey() = 27
		EXIT
	ENDIF

	SEEK wPpsif
	IF ! Found()
		MessageBox("TAKVA SIFRA NE POSTOJI!")
		LOOP
	ENDIF

	@ 8,10 SAY "NAZIV...... "
	?? PPNAZ
	@ 10,10 SAY "ADRESA.... "
	?? PPADR
	@ 12,10 SAY "POSTA..... "
	?? PPPOS
	@ 14,10 SAY "MESTO..... "
	?? PPMES
	@ 16,10 SAY "ZIRO-RACUN "
	?? PPZIR
	@ 18,10 SAY "TEL/FAX... "
	?? PPTEL

	@ 22,10 SAY "Brisanje (D/N)? " GET DN PICTURE "!" VALID (DN $ "DN")
	READ

	IF Lastkey () = 27
		EXIT
	ENDIF

	IF DN = "N"
		LOOP
	ENDIF

	DELETE
	PACK

ENDDO

USE

RETURN

