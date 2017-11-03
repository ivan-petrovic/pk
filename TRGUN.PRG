LOCAL wrb, worgj, wbrkal, wdk, wopk, dn
LOCAL wzad, wraz, wdatupl, wizndin

SELECT 0
USE TRG
INDEX ON RB TO TINOR
INDEX ON BRKAL TO TRGKAL
CLOSE TRG

wrb = Val("0000")
SELECT 0
USE TRG INDEX TINOR,TRGKAL
GO BOTTOM
wrb = RB
GO TOP

DO WHILE .T.

   MainMask("UNOS U TRGOVACKU KNJIGU")

   dn = " "
   worgj  = Space(4)
   wbrkal = Space(10)
   wrb = wrb + 1
   wdk = Date()
   wopk = Space(55)
   wzad = Val("000000000000000.00")
   wraz = Val("000000000000000.00")
   wdatupl = Date()
   wizndin = Val("000000000000000.00")

   DO WHILE .T.
      @ 4,6 SAY "REDNI BROJ: " GET wrb PICTURE "9999"
      READ

      IF Lastkey() = 27
         CLOSE DATABASES
         RETURN
      ENDIF

      SEEK wrb
      IF Found()
         MessageBox("VEC STE KNJIZILI POD TIM BROJEM.")
         wrb = 0
         LOOP
      ELSE
         EXIT
      ENDIF
   ENDDO

   @  6,1 SAY "BROJ KALKULACIJE: " GET wbrkal
   @  7,1 SAY "DATUM KNJIZENJA:  " GET wdk
   @  8,1 SAY "OPIS KNJIZENJA:   " GET wopk
   @ 10,1 SAY "IZNOS DINARA"
   @ 12,1 SAY "ZADUZENJE:        " GET wzad PICTURE "999999999999999.99"
   @ 13,1 SAY "RAZDUZENJE:       " GET wraz PICTURE "999999999999999.99"
   @ 15,1 SAY "UPLACENO NA TEKUCI RACUN"
   @ 17,1 SAY "DATUM KNJIZENJA:  " GET wdatupl
   @ 18,1 SAY "IZNOS DINARA:     " GET wizndin PICTURE "999999999999999.99"
   READ

   IF Lastkey() = 27
      EXIT
   ENDIF

   @ 22,10 SAY "UPIS (D/N) " GET dn PICTURE "!" VALID(dn $ "DdNn")
   READ

   IF Lastkey() = 27
      EXIT
   ENDIF

   IF dn = "N"
      LOOP
   ENDIF

   APPEND BLANK
   REPLACE ORGJ   WITH worgj
   REPLACE RB     WITH wrb
   REPLACE BRKAL  WITH wbrkal
   REPLACE DK     WITH wdk
   REPLACE OPK    WITH wopk
   REPLACE ZAD    WITH wzad
   REPLACE RAZ    WITH wraz
   REPLACE DATUPL WITH wdatupl
   REPLACE IZNDIN WITH wizndin
ENDDO    

CLOSE DATABASES
RETURN
