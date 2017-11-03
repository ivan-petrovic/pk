LOCAL wSifop, wAutoop, DN

SELECT 1
USE OPIS INDEX OPIN

DO WHILE .T.

	MainMask("OTVARANJE NOVIH SIFARA GRUPA ARTIKALA")

   wSifop = val("00000")
   wAutoop = Space(45)

   @ 10,10 SAY "SIFRA OPISA: "
   @ 10,24 GET wSifop PICTURE "99999" VALID ! Empty(wSifop)
   @ 12,10 SAY "GRUPA ROBE: "
   @ 12,24 GET wAutoop
   READ

   IF Lastkey() = 27
      EXIT
   ENDIF

   SEEK wSifop
   IF Found()
      MessageBox("TAKVA SIFRA VEC POSTOJI! BILO STA ZA NASTAVAK...")
   	LOOP
	ENDIF

	DN = " "
	@ 22,10 SAY "UPIS PODATAKA (D/N)? " GET DN PICTURE "!" VALID(DN $ "DdNn")
	READ

	IF Lastkey() = 27
		EXIT
	ENDIF

	IF DN = "N"
		LOOP
	ENDIF

	APPEND BLANK
	REPLACE SIFOP WITH wSifop
	REPLACE AUTOOP WITH Upper(wAutoop)

ENDDO

USE

RETURN
