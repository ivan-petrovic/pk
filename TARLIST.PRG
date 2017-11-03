LOCAL wTarSif, wTarDat, wTar, DN, wKljuc, Broj, Red, Izbor
LOCAL	wTarSst,	wTarRst,	wTarOst,	wTarVoj,	wTarTak, wTarZbir
LOCAL indik := 0

SELECT 1
USE TARDAT INDEX TARINSIF

DO WHILE .T.

	CLEAR SCREEN
	ESCK()

	wTarSif = Space(8)

	@ 2,35 SAY "LISTANJE TARIFA"
	@ 5,10 SAY "Tarifa od koje zelite pregled"
	@ 6,33 SAY "(ENTER - od pocetka do kraja)"
	@ 6,15 GET wTarSif PICTURE "@!"
	READ

	IF Lastkey() = 27
		EXIT
	ENDIF

	IF Empty(wTarSif)
		GO TOP
	ELSE
		wTarDat = Ctod("00.00.00")
		SET SOFTSEEK ON
		wKljuc = wTarSif + Dtos(wTarDat)
		SEEK wKljuc
		IF ! TARSIF = wTarSif
			MessageBox("Ne postoji takva tarifa!")
			LOOP
		ENDIF
	ENDIF

	Red = 5
	DO WHILE .T.
		IF ! Eof()
			IF Red = 5
				CLEAR SCREEN
				ESCK()

				@ 2,35 SAY "LISTANJE TARIFA"
				@ 3,1  SAY Replicate("*",78)
				@ 4,1  SAY "TARIFA"
				@ 4,10 SAY "ZELEZNICA"
				@ 4,21 SAY "REP.STOPA"
				@ 4,32 SAY "TAKSA 3 %"
				@ 4,44 SAY "POS.S.STOPA"
				@ 4,56 SAY "POS.NAK"
				@ 4,65 SAY "VAZI    OD"
				@ 5,1  SAY Replicate("*",78)
			ENDIF

			Red = Red + 1
			@ Red,1 SAY TARSIF
			@ Red,14 SAY TARSST
			@ Red,23 SAY TARRST
			@ Red,34 SAY TAROST
			@ Red,47 SAY TARVOJ
			@ Red,57 SAY TARTAK
			@ Red,65 SAY TARDAT

			IF Red > 15
				Red = 5
				Izbor = 1
				@ 22,1  PROMPT "DALJE"
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
		ENDIF	&& ! Eof()

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
	ENDDO  && *** OD DO WHILE ! Eof()

	IF indik = 1
		indik = 0
		LOOP
	ENDIF

ENDDO

CLOSE DATABASES
CLEAR SCREEN

RETURN
