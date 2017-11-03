SELECT 1
USE ARTPANE INDEX APINSIF,APINART
SELECT 2
USE PAZDAT INDEX PAZINDAT
SET FILTER TO SK = 0
GO TOP

indik = 0

DO WHILE .T.

   Zbir = Val("000000000000.00")
   wDat = Date()
   Nivo = Val("0")
   indd = 0

	CLEAR SCREEN
   DO ESCK
   @ 2,28 SAY "LISTANJE DNEVNOG PAZARA"
   @ 5,10 SAY "UNESITE DATUM ZA KOJI ZELITE PREGLED" GET wDat
   @ 7,10 SAY "UNESITE NIVO LAGERA (BROJ PRODAVNICE)" GET Nivo PICTURE "9" RANGE 0,9
   @ 8,15 SAY "(0 za sve prodavnice)"
   READ

	IF Lastkey() = 27
   	EXIT
   ENDIF

	IF Nivo = 0
   	indd = 0
   ELSE
      indd = 1
   ENDIF

	kljuc = DtoS(wDat)
   SEEK kljuc
   IF ! Found()
   	MessageBox("Ne postoji pazar za taj dan!")
      LOOP
   ENDIF

   DO WHILE wDat = PAZDAT
		IF indd > 0
			pom  = Str(pazart,13,0)
			pom1 = Ltrim(pom)
			pom1 = Substr(pom1,1,1)
			IF Val(pom1) = Nivo
				Zbir = Zbir + (pazcdin * pazkol)
			ENDIF
		ELSE
			Zbir = Zbir + (PAZCDIN * PAZKOL)
		ENDIF
		SKIP
	ENDDO

	SEEK kljuc
   Red = 5
	DO WHILE .T.
      IF PAZDAT = wDat
         IF Red = 5
            CLEAR SCREEN
            DO ESCK
            @ 2,28 SAY "LISTANJE DNEVNOG PAZARA"
            @ 3, 1 SAY Replicate("*",78)
            @ 4, 4 SAY "SIFRA"
            @ 4,22 SAY "NAZIV ARTIKLA"
            @ 4,44 SAY "KOLICINA"
            @ 4,56 SAY "CENA"
            @ 4,70 SAY "DINARA"
            @ 5, 1 SAY Replicate("*",78)
         ENDIF

         SELECT 1
         SEEK B->PAZART

         SELECT 2
         Red = Red + 1
         @ Red, 0 SAY A->ARTSIF
         @ Red,14 SAY A->ARTNAZ
         @ Red,44 SAY PAZKOL PICTURE "999.99"
         @ Red,51 SAY PAZCDIN PICTURE "999,999.99"
         @ Red,63 SAY Round(PAZCDIN * PAZKOL,2) PICTURE "9999,999,999.99"
         @ 18,38 SAY "Ukupni dnevni zbir :"
         @ 18,60 SAY Zbir PICTURE "999,999,999,999.99"

         IF Red > 15
            Red = 5
            Izbor = 1
            @ 22, 1 PROMPT "DALJE"
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
         ENDIF  && od IF Red > 15

         SKIP
         LOOP
      ENDIF   && od IF PAZDAT = wDat

      @ 19,1 SAY "Zavrseno listanje!!"
      Izbor = 1
      @ 22, 1 PROMPT "PRETHODNI EKRAN"
      @ 22,30 PROMPT "OD POCETKA"
      MENU TO Izbor
      DO CASE
         CASE Lastkey() = 27
            indik = 1
            EXIT
         CASE Izbor = 1
            IF Recno() > 22
               broj = Red + 11 - 5
               SKIP -broj
               Red = 5
               LOOP
            ELSE
               GO TOP
               Red = 5
               LOOP
            ENDIF
         CASE izbor = 2
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
   	indik = 0
      LOOP
   ENDIF
ENDDO

SET FILTER TO
CLOSE DATABASES

RETURN
