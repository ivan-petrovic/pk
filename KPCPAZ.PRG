* - nije pregledano - *
SET DATE GERMAN
SET CONFIRM ON
*use tardat
*index on tarsif to tarinsif
*use
SELECT 1
USE ARTPANE INDEX APINSIF,APINART
SELECT 2
USE KPCPRI INDEX KPCPRIDK,KPCPRIR
*SELECT 3
*use tardat index tarinsif
select 3
USE KPCTAR INDEX KPCTAR1,KPCTAR2,KPCTAR3   && dddin

SELECT 5
USE KPCPAZ INDEX KPCPAZD
ind = 0
INDD = 0
WZ1 = VAL("00000000000000.00")
WZ2 = VAL("00000000000000.00")
INDDAT = 0
DO WHILE .T.    && pocetak glavnog
   CLEAR SCREEN
   ind = ind + 1
   *INDDAT = 0
   WDAT = DATE()
   PRERAC = VAL("00.00")
   POREZ = VAL("000000000000.00")
   WSIFART = VAL("0000000000000")
   WKOL = VAL("00000000000.000")
   ESCKEY()
   WBR = 0
   WPRIH = VAL("00000000000000.00")
   WPRIH1 = VAL("00000000000000.00")
   WPRIH2 = VAL("00000000000000.00")
   WDPH = DATE()
   WDK = DATE()
   WTPH = Space(8)
   WSPH = VAL("000.00")
   PN = "N"
   WRB = VAL("00.00")
   JJ = " "
   WPIR = "PAZAR"
   WDRP = DATE()
   WBRP = VAL("0000")
   @ 2,15 SAY "UNOS U KNJIGU PRIHODA - KAFA,PI'E,CIGARETE"
   @ 10,10 SAY "DATUM PAZARA"
   @ 10,23 GET WDAT
   READ
   IF Lastkey() = 27
      EXIT
   ENDIF
***********************************************************************
**  UBACE DEO ZA PAZAR SAMO JEDAN DATUM ZA VISE PRODAJA U TOKU DANA  **
***********************************************************************
   SELECT 2
   SEEK WDAT
   IF Found()
      IF (PRIH > 0 .AND. PRIH1 = 0 .AND. PRIH2 = 0)
         INDDAT = 1
      ELSE
         SKIP
         IF WDAT = DK
            IF (PRIH > 0 .AND. PRIH1 = 0 .AND. PRIH2 = 0)
               INDDAT = 1
            ENDIF
         ENDIF
      ENDIF
   ENDIF
********  OVDE JE UBACENO ZA RUCNI UNOS  *****
       DO WHILE .T.
          @ 12,10 SAY "POCETNO STANJE / NORMALNA PRODAJA   P/N   " GET PN PICTURE "!" VALID(PN $ "PpNn")
          READ
          IF Lastkey() = 27
             CLOSE DATABASES
             CLEAR SCREEN
             RETURN
          ENDIF
          IF PN = "P"        && POCETAK UNOSA POCETNOG STANJA
             CLEAR SCREEN
             @ 2,15 SAY "POCETNI UNOS PODATAKA U KNJIGU PRIHODA KPC"
             *
             @ 4,26 SAY "RED.BROJ         :"
             @ 4,45 SAY WRB
             @ 6,26 SAY "DATUM KNJIZENJA  :" &&  GET WDK
             *SET COLO TO /W
             @ 6,45 SAY WDAT
             *SET COLO TO
             @ 8,26 SAY "OPIS KNJIZENJA I BROJ DOKUMENTA"
             @ 10,26 SAY "POCETNO STANJE  :" GET WPIR PICTURE "AAAAA"
             @ 12,26 SAY "DATUM R/P       :" GET WDRP
             @ 14,26 SAY "BROJ RAC./PAZAR :" GET WBRP PICTURE "9999"
             @ 16,26 SAY "PRIHOD OD PRODATE"
             @ 18,26 SAY "ROBE SA P/P      "
             @ 16,47 GET WPRIH PICTURE "99999999999999.99"
             *  @ 18,47 GET WPRIH2 PICTURE "99999999999999.99"
             *
             READ
             *
             IF Lastkey() = 27
                CLOSE DATABASES
                CLEAR SCREEN
                RETURN
             ENDIF
             @ 20,10 SAY "UPIS   D/N  " GET JJ PICTURE "!" VALID(JJ $ "DdNn")
             READ
             IF Lastkey() = 27
                CLEAR SCREEN
                CLOSE DATABASES
                RETURN
             ENDIF
             IF JJ = "N"
                 @ 20,10 SAY REPLI(" ",68)
                 LOOP
             ENDIF
             SELECT 2
             IF INDDAT = 0
                APPEND BLANK
                REPLACE RB WITH WBR
                REPLACE DK WITH WDAT
                REPLACE PIR WITH WPIR
                REPLACE DRP WITH WDRP
                REPLACE BRP WITH WBRP
                REPLACE PRIH WITH WPRIH
                REPLACE PRIH1 WITH 0     
                REPLACE PRIH2 WITH 0     
             ELSE   
                REPLACE RB WITH WBR
                REPLACE DK WITH WDAT
                REPLACE PIR WITH WPIR
                REPLACE DRP WITH WDRP
                REPLACE BRP WITH WBRP
                REPLACE PRIH WITH (PRIH + WPRIH)
                REPLACE PRIH1 WITH 0
                REPLACE PRIH2 WITH 0
             ENDIF
       ENDIF      
       IF PN = "N"     
             EXIT
       ELSE
             CLOSE DATABASES
             CLEAR SCREEN
             RETURN
       ENDIF
       ENDDO
********  KRAJ UBACENOG ZA RUCNI UNOS    *****
DO WHILE .T.
DN = " "
IND = IND + 1
WSIFART = VAL("0000000000000")
WKOL = VAL("00000000000.000")
*@ 10,40 SAY "RABAT :" GET WRAB PICTURE "99.99"
@ 14,10 SAY "SIF.ARTIKLA "
@ 14,23 GET WSIFART PICTURE "9999999999999"
*@ 14,10 SAY "KOLICINA    "
*@ 14,23 GET WKOL
READ
IF Lastkey() = 27
EXIT
ENDIF
SELECT 1
SEEK WSIFART
IF !Found()
@ 20,20 SAY "NE POSTOJI TA SIFRA ARTIKLA"
WAIT " "
@ 20,20 SAY REPLI(" ",50)
IND = 0
LOOP
ENDIF
@ 14,37 SAY ARTNAZ
@ 14,67 SAY "CENA"
@ 14,72 SAY ROUND(ARTCEN * gnBod,2) PICTURE "9,999.99"
@ 16,10 SAY "KOLICINA   "
@ 16,23 GET WKOL
READ
IF Lastkey() = 27
   EXIT
ENDIF
IF WKOL > ARTKOL
@ 20,20 SAY "NA LAGERU IMATE"
@ 20,36 SAY ARTKOL
WAIT " "
IND = 0
@ 14,37 SAY REPLI(" ",43)
@ 16,10 SAY REPLI(" ",60)
@ 20,20 SAY REPLI(" ",50)
WKOL = 0
LOOP
ENDIF
@ 20,10 SAY " DA LI SU PODACI ISPRAVNI  D/N  " GET DN PICTURE "!" VALID(DN $ "DdNn")
READ
IF Lastkey() = 27
   EXIT
ENDIF
IF DN = "N"
   @ 20,10 SAY REPLI(" ",68)
   @ 14,37 SAY REPLI(" ",43)
   *SET COLO TO /W
   @ 16,23 SAY "              "
   *SET COLO TO
   LOOP
ENDIF
REPLACE ARTKOL WITH (ARTKOL - WKOL)
*REPLACE RPRO WITH (RPRO + WKOL)
PRERAC = ROUND((VAL(RTRIM(SUBSTR(ARTTAR,3,2))) * 100) / (VAL(RTRIM(SUBSTR(ARTTAR,3,2))) + 100),2)
POREZ = ROUND(ARTCEN * gnBod * PRERAC / 100,2)
*WPRIH2 = ROUND((ARTCEN * gnBod - POREZ) * 0.15 * WKOL,2)
WZ1 = WZ1 + ROUND(ARTCEN * gnBod * WKOL,2)
WZ2 = WZ2 + WPRIH2
SELECT 3
APPEND BLANK
REPLACE DPH WITH WDAT
REPLACE TPH WITH A->ARTTAR
REPLACE SPH WITH VAL(SUBSTR(A->ARTTAR,3,2))
REPLACE Z1 WITH ROUND(A->ARTCEN * gnBod * WKOL,2)
REPLACE Z2 WITH 0    &&  WPRIH2 
REPLACE SK1 WITH 0
*select 3
*seek A->arttar
* IF Found()
*    pomstop = tarzbir
* else
*    @ 20,1 SAY "NEMA TARIFE ZA ARTIKAL"
*    @ 20,25 SAY ARTSIF PICTURE "9999999999999"
*    WAIT " "
*    @ 20,1 SAY REPLI(" ",79)
* ENDIF
SELECT 5
APPEND BLANK
REPLACE PAZDAT WITH WDAT
REPLACE PAZART WITH WSIFART
REPLACE PAZKOL WITH WKOL
REPLACE PAZCMARK WITH A->ARTCEN
REPLACE PAZCDIN WITH  ROUND(A->ARTCEN * gnBod,2)
REPLACE SK WITH 0
*replace paztar with A->arttar
*replace pazstop with pomstop
*pomstop = 0
*@ 12,37 SAY REPLI(" ",30)
@ 14,10 SAY REPLI(" ",70)
*SET COLO TO /W
@ 16,23 SAY "              "
*SET COLO TO
@ 20,10 SAY REPLI(" ",68)
INDD = 1
WKOL = 0
WRAB = 0
ENDDO    &&   tekuci artikal
*WDATPR = WDAT
*ENDDO    && kraj od glavnog
IF INDD = 1
   SELECT 2
   IF INDDAT = 0
      APPEND BLANK
      REPLACE RB WITH WBR
      REPLACE DK WITH WDAT
      REPLACE PIR WITH "PAZAR"
      REPLACE DRP WITH WDAT
      REPLACE BRP WITH WBR
      REPLACE PRIH WITH WZ1
      REPLACE PRIH1 WITH 0  
      REPLACE PRIH2 WITH 0  
   ELSE   
      REPLACE RB WITH WBR
      REPLACE DK WITH WDAT
      REPLACE PIR WITH "PAZAR"
      REPLACE DRP WITH WDAT
      REPLACE BRP WITH WBR
      REPLACE PRIH WITH (PRIH + WZ1)
      REPLACE PRIH1 WITH 0            
      REPLACE PRIH2 WITH 0
   ENDIF
ENDIF
EXIT
ENDDO      && kraj od glavnog
CLOSE DATABASES
RELEASE ALL
CLEAR SCREEN
RETURN

