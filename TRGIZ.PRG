LOCAL dn, worgj, wbrkal, wrb, wdk, wopk
LOCAL wzad, wraz, wdatupl, wizndin

SELECT 0
USE TRG INDEX TRGKAL,TINOR

DO WHILE .T.

   dn  = " "
   worgj  = Space(4)
   wbrkal = Space(10)
   wrb = Val("0000")
   wdk = Date()
   wopk = Space(55)
   wzad = Val("000000000000000.00")
   wraz = Val("000000000000000.00")
   wdatupl = Date()
   wizndin = Val("000000000000000.00")

   MainMask("IZMENE  U TRGOVACKOJ KNJIZI")

   @ 4,6 SAY "BROJ KALKULACIJE: " GET wbrkal
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

   REPLACE ORGJ   WITH worgj
   REPLACE RB     WITH wrb
   REPLACE DK     WITH wdk
   REPLACE OPK    WITH wopk
   REPLACE ZAD    WITH wzad
   REPLACE RAZ    WITH wraz
   REPLACE DATUPL WITH wdatupl
   REPLACE IZNDIN WITH wizndin
ENDDO

CLOSE DATABASES
RETURN
