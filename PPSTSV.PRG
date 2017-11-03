*******************************************
* Stampa svih poslovnih partnera
*******************************************
LOCAL Red, BrStr

SELECT 3
USE PPDAT 
GO TOP

SET DEVICE TO PRINTER
SET PRINTER ON

Red = 1
BrStr = 0

DO WHILE ! Eof()
	IF Red = 1
		BrStr = BrStr + 1
		@ Red,30 SAY "SPISAK POSLOVNIH PARTNERA"
		?? Space(14)
		?? "STR."
		@ Red,74 SAY BrStr PICTURE "999"

		Red = Red + 2
		@ Red,1 SAY Replicate("*",78)

		Red = Red + 1
		@ Red,2 SAY "SIFRA "
		?? " NAZIV/ZIRO-RACUN          "
		?? "     ADRESA          "
		?? "   TELEFON          "

		Red = Red + 1
		@ Red,1 SAY Replicate ("*",78)
		Red = Red + 1
	ENDIF

	@ Red,2 SAY PPSIF
	?? " "
	?? PPNAZ
	?? " "
	?? PPMES
	?? " "
	?? PPTEL

	Red = Red + 1
	@ Red,8 SAY PPZIR
	?? " "
	?? PPADR
	
	Red = Red + 1
	@ Red,1 SAY Replicate("-",79)
	Red = Red + 1
	
	IF Red > 50
		Red = 1
	ENDIF
	
	SKIP

ENDDO

SET DEVICE TO SCREEN
SET PRINTER OFF

USE 

RETURN
