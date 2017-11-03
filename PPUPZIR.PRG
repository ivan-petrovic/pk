*******************************************
* Upit o poslovnim partnerima -
* po ziro racunu
*******************************************
LOCAL wPpzir, Red

SELECT 1
USE PPDAT

DO WHILE .T.

	MainMask("UPIT O POSLOVNIM PARTNERIMA - PO ZIRO RACUNU")

	wPpzir = Space(30)
	@ 10,10 SAY "UNESITE DEO ZIRO-RACUNA: " GET wPpzir
	READ

	IF Lastkey () = 27
		EXIT
	ENDIF

	CLEAR SCREEN
	ESCK()
	@ 2,26 SAY "LISTANJE PP PO ZIRO-RACUNU"

	SET FILTER TO ! At(Alltrim(wPpzir), PPZIR) = 0
	GO TOP

	Red = 4
	DO WHILE ! Eof()
		IF Red = 4
			@ Red,1 SAY "  SIFRA              NAZIV               "
			?? "        ZIRO-RACUN"
		ENDIF

		Red = Red + 1
		@ Red,1 SAY PPSIF
		?? Space(9)
		?? PPNAZ
		?? " "
		?? PPZIR

		IF Red > 16
			Red = 4
			@ 21,1 SAY " "
			WAIT "F2-prethodna strana RETURN-dalje"
			IF Inkey(0) = -1
				SKIP -29
				CLEAR SCREEN
				ESCK()
				@ 2,26 SAY "LISTANJE PP ZIRO-RACUNU"
				LOOP
			ENDIF

			IF Lastkey () = 27
				EXIT
			ENDIF

			CLEAR SCREEN
			ESCK()
			@ 2,26 SAY "LISTANJE PP ZIRO-RACUNU"
		ENDIF

		SKIP
	ENDDO

	@ 21,10 SAY " "
	WAIT "Otkucaj neku tipku za dalje..."

ENDDO
    
SET FILTER TO
USE

RETURN


