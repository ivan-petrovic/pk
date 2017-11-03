LOCAL dn, wbrkal, wdk, wopk, wzad, wraz, wdatupl, wizndin

SELECT 0
USE TRG INDEX TRGKAL,TINOR

DO WHILE .T.

   dn  = " "
   wbrkal = Space(10)
   wdk = Date()
   wopk = Space(55)
   wzad = Val("000000000000000.00")
   wraz = Val("000000000000000.00")
   wdatupl = Date()
   wizndin = Val("000000000000000.00")

   MainMask("BRISANJE  U TRGOVACKOJ KNJIZI")

   @ 6,1 SAY "BROJ KALKULACIJE :" GET wbrkal
   READ

   IF Lastkey() = 27
      EXIT
   ENDIF

   SEEK wbrkal
   IF Found()
      wdk  = DK
      wopk = OPK
      wzad = ZAD
      wraz = RAZ
      wdatupl = DATUPL
      wizndin = IZNDIN
   ELSE
      MessageBox("NIJE PROKNJIZENA TAKVA STAVKA.")
      LOOP
   ENDIF

   @  7, 1 SAY "DATUM KNJIZENJA :"
   @  7,19 SAY wdk
   @  8, 1 SAY "OPIS KNJIZENJA  :"
   @  8,19 SAY wopk
   @ 10, 1 SAY "IZNOS DINARA"
   @ 12, 1 SAY "ZADUZENJE      :"
   @ 12,19 SAY wzad PICTURE "999999999999999.99"
   @ 13, 1 SAY "RAZDUZENJE     :"
   @ 13,19 SAY wraz PICTURE "999999999999999.99"
   @ 15, 1 SAY "UPLACENO NA TEKUCI RACUN"
   @ 17, 1 SAY "DATUM KNJIZENJA :"
   @ 17,19 SAY wdatupl
   @ 18, 1 SAY "IZNOS DINARA    :"
   @ 18,19 SAY wizndin PICTURE "999999999999999.99"

   @ 22,10 SAY "BRISANJE (D/N) " GET dn PICTURE "!" VALID(dn $ "DdNn")
   READ

   IF Lastkey() = 27
      EXIT
   ENDIF

   IF dn = "N"
      LOOP
   ENDIF

   DELETE
ENDDO    

PACK
CLOSE DATABASES
RETURN
