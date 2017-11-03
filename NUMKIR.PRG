CLEAR SCREEN
@ 0,0 TO 24,79 DOUBLE
@ 1,1 SAY Centriraj("NUMERISANJE STAVKI KIR-a", 78)

mOdl = "T"
@ 3,10 SAY "NUMERISEM KNJIGU IZDATIH RACUNA"
@ 5,10 SAY "MESECNO / TROMESECNO (M/T) " GET mOdl PICTURE "!" VALID(mOdl $ "MmTt")
READ

IF Lastkey() = 27
    RETURN
ENDIF

SELECT 0
USE KIR INDEX KIRDK

wRrb = 1

DO CASE
	CASE mOdl = "M"
		DO WHILE ! Eof()
			wPrem = Month(DATKKIR)
			DO WHILE wPrem = Month(DATKKIR)		&& vrti jedan mesec
				REPLACE RBKIR WITH wRrb
				wRrb = wRrb + 1
				SKIP
				IF Eof()
					EXIT
				ENDIF
			ENDDO											&& kraj vrcenja jednog meseca
			wRrb = 1
		ENDDO

	CASE mOdl = "T"
		DO WHILE ! Eof()
			DO WHILE Month(DATKKIR) < 4			&& vrti prvo tromesecje
				REPLACE RBKIR WITH wRrb
				wRrb = wRrb + 1
				SKIP
				IF Eof()
					EXIT
				ENDIF
			ENDDO											&& kraj vrcenja prvog tromesecja
			wRrb = 1

			DO WHILE Month(DATKKIR) > 3 .AND. Month(DATKKIR) < 7		&& vrti drugo tromesecje
				REPLACE RBKIR WITH wRrb
				wRrb = wRrb + 1
				SKIP
				IF Eof()
					EXIT
				ENDIF
			ENDDO											&& kraj vrcenja drugog tromesecja
			wRrb = 1
	
			DO WHILE Month(DATKKIR) > 6 .AND. Month(DATKKIR) < 10		&& vrti trece tromesecje
				REPLACE RBKIR WITH wRrb
				wRrb = wRrb + 1
				SKIP
				IF Eof()
					EXIT
				ENDIF
			ENDDO											&& kraj vrcenja treceg tromesecja
			wRrb = 1
	
			DO WHILE Month(DATKKIR) > 9 .AND. Month(DATKKIR) <= 12	&& vrti cetvrto tromesecje
				REPLACE RBKIR WITH wRrb
				wRrb = wRrb + 1
				SKIP
				IF Eof()
					EXIT
				ENDIF
			ENDDO											&& kraj vrcenja cetvrtog tromesecja
			wRrb = 1
		ENDDO
ENDCASE

CLOSE DATABASES

RETURN
