LOCAL indik, wAutoOp, wSiOp, Red, Izbor, Broj

USE ARTPANE 
INDEX ON SIOP TO SIOPIN
USE

SELECT 1
USE ARTPANE INDEX SIOPIN

SELECT 2
USE OPIS INDEX OPIN

indik = 0

DO WHILE .T.

	wSiOp = val("00000")

	MainMask("LISTANJE SVIH ARTIKALA VEZANIH ZA JEDNU GRUPU ROBE")
	@ 5,10 SAY "Sifra grupe robe :"              
	@ 6,15 GET wSiOp PICTURE "99999"        
	READ

	IF Lastkey() = 27
		EXIT
	ENDIF

	SELECT 1
	SEEK wSiOp  
	IF ! Found()
		MessageBox("Nema artikala za tu grupu robe!")
		LOOP
	ENDIF

	SELECT 2
	SEEK wSiOp
	IF Found()
		wAutoOp = AUTOOP
	ELSE
		MessageBox("NEMATE TU GRUPU OBUCE U EVIDENCIJI!")
		LOOP
	ENDIF

	SELECT 1
	GO TOP
	SET FILTER TO SIOP = wSiOp
	GO TOP

	Red = 5
	DO WHILE .T.
		
		IF ! Eof()
			IF Red = 5 
				CLEAR SCREEN
				ESCK()

				@ 2,12 SAY wAutoOp
				@ 3,1  SAY Replicate("*",78)
				@ 4,4  SAY "SIFRA"  
				@ 4,22 SAY "NAZIV ARTIKLA"
				@ 4,44 SAY "KOLICINA"
				@ 4,56 SAY "CENA"
				@ 4,70 SAY "DINARA"
				@ 5,1  SAY Replicate("*",78)
			ENDIF

			Red = Red + 1
			@ Red,0  SAY ARTSIF
			@ Red,14 SAY ARTNAZ
			@ Red,44 SAY ARTKOL PICTURE "999,999"
			@ Red,52 SAY ARTCEN PICTURE "999,999.99"
			@ Red,63 SAY (ARTCEN * gnBod) PICTURE "9999,999,999.99"

			IF Red > 15
				Red = 5
				Izbor = 1

				@ 22,1 PROMPT "DALJE"
				@ 22,30 PROMPT "PRETHODNI EKRAN"
				@ 22,55 PROMPT "OD POCETKA"
				
				MENU TO Izbor

				DO CASE
					CASE Lastkey() = 27
						indik = 1
						EXIT
					CASE Izbor = 2
						IF Recno() > 22
							SKIP -22
						ELSE 
							GO TOP
						ENDIF
						LOOP
					CASE Izbor = 3
						GO TOP
						LOOP
					CASE Izbor = 1
				ENDCASE
			ENDIF

			SKIP
			LOOP
		ENDIF
		
		@ 19,1 SAY "Zavrseno listanje!!"
		Izbor = 1
		@ 22,1 PROMPT "PRETHODNI EKRAN"
		@ 22,30 PROMPT "OD POCETKA"
		
		MENU TO Izbor

		DO CASE
			CASE Lastkey() = 27
				indik = 1
				EXIT
			CASE Izbor = 1
				IF Recno() > 22
					Broj = (Red - 5) + 11
					SKIP -Broj
					Red = 5
					LOOP
				ELSE
					GO TOP
					Red = 5
					LOOP
				ENDIF
			CASE Izbor = 2
				GO TOP
				Red = 5
				LOOP
			OTHERWISE
				indik = 1
				EXIT
		ENDCASE

		EXIT
	ENDDO
	
	IF indik = 1
		SET FILTER TO
		indik = 0
		LOOP
	ENDIF

ENDDO

CLOSE DATABASES

RETURN
