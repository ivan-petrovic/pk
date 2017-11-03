*******************************************
* Upit o poslovnim partnerima - po sifri
*******************************************
LOCAL wPpsif, Red

SET SOFTSEEK ON

SELECT 1
USE PPDAT INDEX PPINSIF

DO WHILE .T.
	
	MainMask("UPIT O POSLOVNIM PARTNERIMA - PO SIFRI")

	wPpsif = 0
	@ 10,10 SAY "SIFRA PP: "  GET wPpsif PICTURE "999999"
	READ

	IF Lastkey () = 27
		EXIT
	ENDIF

	CLEAR SCREEN
	ESCK()

	@ 2,26 SAY "LISTANJE PP OD ZADATE SIFRE"

	Red = 4
	SEEK wPpsif
	IF ! Found()
		MessageBox("Ne postoji ta sifra!")
		LOOP
	ENDIF

	DO WHILE ! Eof()
		IF Red = 4
			@ Red,1 SAY "  SIFRA                   NAZIV"
			?? "                        M E S T O"
		ENDIF

		Red = Red + 1
		@ Red,1 SAY Ppsif
		?? Space(13)
		?? Ppnaz
		?? Space(6)
		?? Ppmes

		IF Red > 16
			Red = 4
			@ 21,1 SAY " "
			WAIT "Page Down-->prethodna strana   RETURN-->dalje"
			IF Lastkey() = 3
				SKIP -29
				CLEAR SCREEN
				ESCK()
				@ 2,26 SAY "LISTANJE PP OD ZADATE SIFRE"
				LOOP
			ENDIF

			IF Lastkey () = 27
	  			EXIT
			ENDIF

			CLEAR SCREEN
			ESCK()
			@ 2,26 SAY "LISTANJE PP OD ZADATE SIFRE"
		ENDIF

		SKIP
	ENDDO

	@ 22,0 SAY Space(80)
	@ 21,20 SAY " "
	WAIT "Otkucajte neku tipku za dalje..."

ENDDO
    
USE

RETURN
