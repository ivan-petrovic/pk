LOCAL wzad, wraz, wizndin, wod, wdo

wzad = Val("000000000000000.00")
wraz = Val("000000000000000.00")
wizndin = Val("000000000000000.00")
wod = Ctod("  .  .  ")
wdo = Ctod("  .  .  ")

MainMask("ZBIROVI TRGOVACKE KNJIGE")

@ 10,10 SAY "OD DATUMA: " GET wod VALID ! Empty(wod)
@ 11,10 SAY "DO DATUMA: " GET wdo VALID(wdo >= wod)
READ

IF Lastkey() = 27
   RETURN
ENDIF

SELECT 0
USE TRG INDEX TINOR,TRGKAL
GO TOP

DO WHILE ! Eof()
   IF ! (wod <= dk .AND. dk <= wdo)
      SKIP
      LOOP
   ENDIF

   wzad = wzad + Round(ZAD,2)
   wraz = wraz + Round(RAZ,2)
   wizndin = wizndin + Round(IZNDIN,2)

   SKIP
ENDDO

@ 1,1 TO 20,70
@ 11, 9 SAY "IZNOS DINARA"
@ 13, 9 SAY "ZADUZENJE   "
@ 13,22 SAY wzad PICTURE "999,999,999,999,999.99"
@ 14, 9 SAY "RAZDUZENJE  "
@ 14,22 SAY wraz PICTURE "999,999,999,999,999.99"
@ 16, 9 SAY "UPLACENO NA TEKUCI RACUN"
@ 17, 9 SAY "IZNOS DINARA"
@ 17,22 SAY wizndin PICTURE "999,999,999,999,999.99"
WAIT " "

CLOSE DATABASES
RETURN
