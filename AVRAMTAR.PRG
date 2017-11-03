LOCAL DN, wTarSource, wTarDest, wStops, wStopn

SELECT 1
USE ARTPANE

DO WHILE .T.

	GO TOP

	DN = " "
	wTarSource = Space(8)
	wTarDest = Space(8)
	wstops = val("000.00")
	wstopn = val("000.00")

	MainMask("PROMENA JEDNE TARIFE DRUGOM U DATOTECI ARTIKALA")
	@ 4 , 1 SAY "NAPOMENA! Pre startovanja programa obe tarife MORAJU biti otvorene u tarifama."
	@ 7 ,10 SAY "TARIFA KOJA SE MENJA"
	@ 9 ,10 SAY "Tarifa :" GET wTarSource
	@ 12,10 SAY "TARIFA U KOJU SE MENJA"
	@ 14,10 SAY "Tarifa :" GET wTarDest
	READ

   IF Lastkey() = 27
      EXIT
   ENDIF

   @ 20,10 SAY "DA LI ZAMENA MOZE DA POCNE (D/N)? " GET DN PICTURE "!" VALID(DN $ "DdNn")
   READ

   IF Lastkey() = 27
      EXIT
   ENDIF

	IF DN = "N"
      LOOP
   ENDIF

   @ 20,10 SAY Replicate(" ",69)

	DO WHILE .NOT. Eof()
		@ 17,10 SAY "Radim..."
		@ 17,16 SAY ARTTAR

		IF ARTTAR = wTarSource
			REPLACE ARTTAR WITH wTarDest
		ENDIF

		SKIP
	ENDDO

	@ 20,10 SAY "GOTOVO! ENTER ZA NASTAVAK..."
	WAIT " "

ENDDO

USE

RETURN
