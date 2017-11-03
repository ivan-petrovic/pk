LOCAL control_str, nMaxRow := 92

SELECT 1
USE ARTPANE INDEX APINSIF
SELECT 2
USE KPCPAZ INDEX KPCPAZD

DO WHILE .T.
   CLEAR SCREEN
   wdat = Date()
   nivo = Val("0")
   indd = 0
   @ 1, 0 SAY "ESC - izlaz"
   @ 1,60 SAY "Datum:"
   @ 1,67 SAY date()
   @ 6,10 SAY "STAMPA PAZARA ZA DATUM:" GET wdat
   @ 8,10 SAY "UNESITE NIVO LAGERA (BROJ PRODAVNICE)" GET nivo PICTURE "9" rang 0,9
   READ
   
   IF Lastkey() = 27 ; EXIT ; ENDIF

   IF nivo = 0
      indd = 0
   ELSE
      indd = 1
   ENDIF
   
   SELECT 2
   kljuc = DtoS(wdat)
   SEEK kljuc
   IF ! Found()
      Messagebox("Nema pazara za taj datum!")
      LOOP
   ENDIF
   
   SELECT 2
   red = nMaxRow + 5
   wukmar = 0
   wukdin = 0
   
   SET DEVICE TO PRINTER
   SET PRINT ON
   SET CONSOLE OFF
   * SET PRINTER TO LISTA

   IF lLaser
      control_str = Chr(27) + '(s17H' + Chr(27) + '&l5C'
      @ 0,0 SAY control_str              && kondenz On za laserski
   ELSE
      @ 0,0 SAY Chr(15)                  && kondenz On za matricni
   ENDIF
   Setprc(0,0)

   DO WHILE wdat = PAZDAT
      IF red > nMaxRow
         DO KPCN_STR
      ENDIF
      
      IF indd = 1
         pom1 = Ltrim(Str(PAZART,13,0))
         pom1 = Substr(pom1,1,1)
         IF Val(pom1) = nivo
            red = red + 1
            wart = 0
            wnaz = Space(30)
            wart = PAZART

            SELECT 1
            SEEK wart
            IF ! Found()
               wnaz = Space(30)
            ELSE
               wnaz = artnaz
            ENDIF
         
            SELECT 2
            @ red, 1 SAY wart
            @ red,15 SAY wnaz
            @ red,47 SAY PAZKOL PICTURE "999999.99"
            @ red,85 SAY PAZCDIN PICTURE "99999999999.99"
            @ red,104 SAY Round(PAZKOL * PAZCDIN,2) PICTURE "99999999999.99"
            wukdin = wukdin + Round(PAZCDIN * PAZKOL,2)
            wukmar = wukmar + PAZKOL * PAZCMARK
         ENDIF
      ELSE
         red = red + 1
         wart = 0
         wnaz = Space(30)
         wart = pazart
         
         SELECT 1
         SEEK wart
         IF ! Found()
            wnaz = Space(30)
         ELSE
            wnaz = artnaz
         ENDIF
         
         SELECT 2
         @ red, 1 SAY wart
         @ red,15 SAY wnaz
         @ red,47 SAY PAZKOL PICTURE "999999.99"
         @ red,85 SAY PAZCDIN PICTURE "99999999999.99"
         @ red,104 SAY Round(PAZKOL * PAZCDIN,2) PICTURE "99999999999.99"
         wukdin = wukdin + Round(PAZCDIN * PAZKOL,2)
         wukmar = wukmar + PAZKOL * PAZCMARK
      ENDIF
      SKIP
   ENDDO

   red = red + 2
   @ red,1 SAY Replicate("-",136)
   red = red + 1
   @ red,80 SAY "Ukupno     dinara  :"
   @ red,104 SAY wukdin PICTURE "99999999999.99"
   red = red + 1
   @ red,0 SAY " "

   IF lLaser
      ? Chr(27)+ Chr(69)         && kondenz Off za laserski
   ELSE
      ? Chr(18)                  && kondenz Off za matricni
   ENDIF

   SET DEVICE TO SCREEN
   SET PRINT OFF
   SET CONSOLE ON
ENDDO

CLOSE DATABASES
RETURN

***************************************************************
PROCEDURE kpcn_str
   red = 0
   red = red + 2
   @ red, 5 SAY gcNazRad
   @ red,60 SAY "PREGLED PAZARA ZA DATUM:"
   ?? wdat
   red = red + 1
   @ red,1 SAY Replicate("*",136)
   red = red + 1
   @ red,  1 SAY "SIFRA ARTIKLA"
   @ red, 20 SAY "NAZIV ARTIKLA"
   @ red, 52 SAY "KOLICINA"
   @ red, 86 SAY "POJEDINAC. CENA"
   @ red,110 SAY "VREDNOST U DINARIMA"
   red = red + 1
   @ red,1 SAY Replicate("*",136)
   red = red + 1
RETURN

***************************************************************
