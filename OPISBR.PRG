LOCAL wSifop, wAutoop, DN

SELECT 1
USE OPIS INDEX OPIN

DO WHILE .T.

	MainMask("BRISANJE SIFARA GRUPA ARTIKALA")
	
   wSifop  = Val("00000")
   wAutoop = Space(45)

   @ 10,10 SAY "SIFRA OPISA :"
   @ 10,24 GET wSifop PICTURE "99999" VALID ! Empty(wSifop)
   READ

   IF Lastkey() = 27
      EXIT
   ENDIF

   SEEK wSifop
   IF Found()
      wAutoop = AUTOOP
   ELSE
   	MessageBox("TAKVA SIFRA NIJE OTVORENA! BILO STA ZA NASTAVAK...")
   	LOOP
   ENDIF

   @ 12,10 SAY "GRUPA ROBE  :"
   @ 12,24 SAY wAutoop

	DN = " "
   @ 22,10 SAY "BRISANJE PODATAKA (D/N)? " GET DN PICTURE "!" VALID(DN $ "DdNn")
   READ

	IF Lastkey() = 27
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
