LOCAL wrb, List_Izbor

SELECT 0
USE TRG
INDEX ON DK TO TRGDK
CLOSE TRG

SELECT 0
USE TRG INDEX trgdk,TRGKAL,tinor
GO TOP

wrb = Val("0000")
DO WHILE ! Eof()
   REPLACE RB WITH wrb + 1
   wrb = wrb + 1
   SKIP
ENDDO

GO TOP
DO WHILE .T.
   @ 23,0 TO 24,79 DOUBLE
   ESCKEY()
   @ 1, 0 SAY Replicate("-",80)
   @ 2, 0 SAY " RB "
   @ 2, 5 SAY "BR. KALK. "
   @ 2,16 SAY " DAT.KNJI "
   @ 2,27 SAY "      ZADUZENJE "
   @ 2,45 SAY "       RAZDUZENJE  "
   @ 3,0 SAY Replicate("-",80)

   DISPLAY OFF NEXT 15 RB,BRKAL,DK,ZAD,RAZ
   SKIP

   IF Eof()
   ELSE
      List_Izbor = 1
   ENDIF
   @ 22,25 PROMPT " Dalje " MESSAGE "Sledeca stranica"
   @ 22,32 PROMPT " Nazad " MESSAGE "Predhodna stranica"
   @ 22,39 PROMPT " Pocetak " MESSAGE "Lista od pocetka"

   CLEAR TYPEAHEAD
   MENU TO List_Izbor
   DO CASE
      CASE Lastkey() = 27
         RELEASE ALL
         CLOSE DATABASES
         RETURN
      CASE List_Izbor = 1
         LOOP
      CASE List_Izbor = 2
         SKIP -29
      CASE List_Izbor = 3
         GO TOP
         LOOP
   ENDCASE
ENDDO


CLOSE DATABASES
RETURN
