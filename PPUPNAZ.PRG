*******************************************
* Upit o poslovnim partnerima - po nazivu
*******************************************
LOCAL wPpnaz, Red

SELECT 1
USE PPDAT

DO WHILE .T.

	MainMask("UPIT O POSLOVNIM PARTNERIMA - PO NAZIVU")

	wPpnaz = Space(30)
	@ 10,10 SAY "UNESITE DEO NAZIVA PP: " GET wPpnaz
	READ

	IF Lastkey () = 27
		EXIT
	ENDIF

	CLEAR SCREEN
	ESCK()
	@ 2,26 SAY "LISTANJE PP PO NAZIVU"

	wPpnaz = upper(wPpnaz)
	SET FILTER TO ! At(Alltrim(wPpnaz),PPNAZ) = 0
	GO TOP

	Red = 4
	DO WHILE ! Eof()
		IF Red = 4
			@ Red,1 SAY "   SIFRA                 NAZIV               "
			?? "        M E S T O"
		ENDIF

		Red = Red + 1
		@ Red,1 SAY PPSIF
		?? Space(17)
		?? PPNAZ
		?? " "
		?? PPMES

		IF Red > 16
			Red = 4
			@ 21,1 SAY " "
			WAIT "F2-prethodna strana RETURN-dalje"
			IF Inkey(0) = -1
				SKIP -29
				CLEAR SCREEN
				ESCK()
				@ 2,26 SAY "LISTANJE PP PO NAZIVU"
				LOOP
			ENDIF

			IF Lastkey () = 27
				EXIT
			ENDIF

			CLEAR SCREEN
			ESCK()
			@ 2,26 SAY "LISTANJE PP PO NAZIVU"
		ENDIF

		SKIP
	ENDDO

	@ 21,10 SAY " "
	WAIT "Otkucaj neku tipku za dalje..."

ENDDO

SET FILTER TO
USE

RETURN
