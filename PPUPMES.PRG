*******************************************
* Upit o poslovnim partnerima - po mestu
*******************************************
LOCAL wPpmes, Red

SELECT 1
USE PPDAT

DO WHILE .T.

	MainMask("UPIT O POSLOVNIM PARTNERIMA - PO MESTU")

	wPpmes = Space(20)
	@ 10,10 SAY "UNESITE DEO NAZIVA MESTA: " GET wPpmes
	READ

	IF Lastkey () = 27
		EXIT
	ENDIF

	CLEAR SCREEN
	ESCK()
	@ 2,26 SAY "LISTANJE PP PO MESTU"

	wPpmes = upper(wPpmes)
	SET FILTER TO ! At(Alltrim(wPpmes),PPMES) = 0
	GO TOP
	
	Red = 4
	DO WHILE ! Eof()
		IF Red = 4
			@ Red,1 SAY "   SIFRA                    NAZIV"
			?? "                          M E S T O"
		ENDIF

      Red = Red + 1
      @ Red,1 SAY PPSIF
      ?? Space(13)
      ?? PPNAZ
      ?? Space(9)
      ?? PPMES

      IF Red > 16
			Red = 4
			@ 21,1 SAY " "
			WAIT "F2-prethodna strana RETURN-dalje"
			IF Inkey(0) = -1
				SKIP -29
				CLEAR SCREEN
				ESCK()
				@ 2,26 SAY "LISTANJE PP PO MESTU"
				LOOP
			ENDIF

			IF Lastkey () = 27
				EXIT
			ENDIF

			CLEAR SCREEN
			ESCK()
			@ 2,26 SAY "LISTANJE PP PO MESTU"
		ENDIF

		SKIP
	ENDDO

	@ 21,10 SAY " "
	WAIT "Otkucaj neku tipku za dalje..."

ENDDO

SET FILTER TO
USE

RETURN
