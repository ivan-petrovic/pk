USE KPCPAZ
INDEX ON DtoS(PAZDAT) + Str(PAZART) TO KPCINDA
USE

SELECT 1
USE KPCPAZ INDEX KPCINDA,KPCPAZD

SELECT 4
USE KPCPRI INDEX KPCPRIDK,KPCPRIR

SELECT 5
USE KPCTAR INDEX KPCTAR1,KPCTAR2,KPCTAR3

DO WHILE .T.      && glavna petlja
   SELECT 1
   CLEAR SCREEN
   ESCKEY()
   
   ind = 0
   pakuj = 0
   DN = " "
   ska = "S"
   WART = VAL("0000000000000")     
   WDAT = DATE()

   @ 10,10 SAY "UNESITE DATUM PAZARA KOJI BRISETE" GET WDAT
   @ 12,10 SAY "UNESITE SIFRU ARTIKLA            " GET WART PICTURE "9999999999999"
   READ

   IF Lastkey() = 27 ; EXIT ; ENDIF

   IF ska = "S"
      SELECT 2
      USE ARTPANE INDEX APINSIF
   ELSE
      SELECT 2
      USE REVERS INDEX REVART
   ENDIF

   SELECT 1
   KLJUC = DTOS(WDAT) + STR(WART)
   SEEK KLJUC
   IF ! Found()
     Messagebox("TOGA DANA NISTE PRODALI TAJ ARTIKAL")
     SELECT 2
     USE
     LOOP
   ENDIF

   SELECT 2
   SEEK WART
   IF Found()
      IF ska = "S"
         wnaz = ARTNAZ
         wtar = ARTTAR
      ELSE
         wnaz = RNAZ
         wtar = RTAR
     ENDIF
   ELSE
      @ 20,10 SAY "NEPOZNAT ARTIKAL.VEROVATNO JE U PITANJU KOMISION, A SIFRA STR_a"
      @ 21,10 SAY "ILI OBRNUTO !"
      WAIT " "
      ind = 1
      LOOP
   ENDIF

   SELECT 1
   CLEAR SCREEN
   @ 10, 2 SAY "sif.artikla          naziv  artikla      prodato      cena      ukupno"
   @ 12, 2 SAY PAZART PICTURE "9999999999999"
   @ 12,16 SAY wnaz
   @ 12,47 SAY PAZKOL PICTURE "999.99"
   @ 12,54 SAY PAZCDIN PICTURE "9,999.99"
   @ 12,63 SAY Round(PAZKOL * PAZCDIN,2) PICTURE "999,999,999.99"
   @ 20,10 SAY "BRISANJE OVE STAVKE   D/N  " GET DN PICTURE "!" VALID(dn $ "DdNn")
   READ

   IF Lastkey() = 27 ; EXIT ; ENDIF

   IF dn = "N"
      LOOP
   ENDIF  

   SELECT 2
   IF ind = 0
      IF ska = "S"
         REPLACE ARTKOL WITH (ARTKOL + A->PAZKOL)
      ELSE
         REPLACE RKOL WITH (RKOL + A->PAZKOL)
      ENDIF
   ENDIF

   SELECT 5
   kljuc1 = DtoS(wdat) + wtar
   SEEK kljuc1
   IF Found()
      DO WHILE wdat = dph .and. tph = wtar
         IF ska = "S".and. sk1 = 0 .and. z1 = A->pazkol * A->pazcdin 
            DELETE
            EXIT
         ENDIF
         IF ska = "K" .and. sk1 = 1 .and. z1 = a->pazkol * A->pazcdin
            DELETE
            EXIT
         ENDIF
         SKIP
      ENDDO
   ELSE
      @ 18, 1 SAY "U PRITAR DATOTECI NEMA ARTIKLA"
      @ 18,33 SAY wart PICTURE "9999999999999"
      @ 18,50 SAY "ENTER za nastavak"
      WAIT " "
      @ 18,1 SAY Replicate(" ",78)
   ENDIF

   ***********************************************
   * UMANJENJE U KNJIZI PRIHODA ZA OBRISAN ARTIKAL
   SELECT 4
   SEEK wdat
   IF Found()
      REPLACE PRIH WITH Round(PRIH - A->PAZKOL * A->PAZCDIN,2)
      IF PRIH <= 0
         pakuj = 1
         DELETE
      ENDIF
   ELSE
      @ 18, 1 SAY "U KPCPRI DATOTECI NEMA ARTIKLA"
      @ 18,33 SAY wart PICTURE "9999999999999"
      @ 18,50 SAY "ENTER za nastavak"
      wait " "
      @ 18,1 SAY Replicate(" ",78)
   ENDIF
   * KRAJ ZA KNJIGU PRIHODA
   ***********************************************

   SELECT 1
   DELETE
ENDDO       && glavna petlja

SELECT 1
PACK
SELECT 5
PACK
IF pakuj = 1
   SELECT 4
   PACK
ENDIF

CLOSE DATABASES
RELEASE ALL
RETURN
