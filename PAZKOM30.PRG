* - nije pregledano - *
SET DATE GERMAN
SET CONFIRM ON
*use tardat
*index on tarsif to tarinN
*use
WBR = VAL("0000")
USE RASHODN
GO BOTTOM
WBR = RRB + 1
USE
*
SELECT 1
USE REVERS INDEX REVART,REVBR
SELECT 2
*USE GKPRI INDEX GKPINDK,GKPINPIR
 USE RASHODN INDEX RASHINDN,RASHINKN
*SELECT 6
*use tardat index tarinsif
select 3
USE PRITAR INDEX PRITIN,PRITSD,dddin
SELECT 5
USE PAZDAT INDEX PAZINDAT,pazinda
SELECT 7
USE POREZN INDEX POREZNd,poreznb
ind = 0
INDD = 0
WRAB = VAL("00.00")
wrab = 20
WZ1 = VAL("00000000000000.00")
WZ2 = VAL("00000000000000.00")
WVISA = VAL("00000000000000.00")
WNIZA = VAL("00000000000000.00")
WNIZA1 = VAL("00000000000000.00")
WNULA = VAL("00000000000000.00")
WNULA06 = VAL("00000000000000.00")
WNULA2 = VAL("00000000000000.00")
WNULA4 = VAL("00000000000000.00")
DN = " "
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
*WBR = 0
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
WPIR = "POCST"
WDRP = DATE()
WBRP = VAL("0000")
@ 2,20 SAY "UNOS U KNJIGU PRIHODA-RASHODA - KOMISION"
@ 10,10 SAY "DATUM PAZARA"
@ 10,23 GET WDAT
READ
IF Lastkey() = 27
   EXIT
ENDIF
***********************************************************************
**  UBACEN DEO ZA PAZAR SAMO JEDAN DATUM ZA VISE PRODAJA U TOKU DANA  **
***********************************************************************
SELECT 2
SEEK WDAT
IF Found()
    DO WHILE WDAT = RDK
      IF (RPV > 0 .OR. RPN > 0 .OR. RPN1 > 0 .OR. RPBEZ > 0 .OR. RUSP > 0 .OR. RUSBEZP > 0) .AND. RSK = 1
         INDDAT = 1
         EXIT
      ENDIF
         SKIP
    ENDDO
ENDIF
*
SELECT 7
SEEK WDAT
IF Found()
    DO WHILE WDAT = datk
      IF (PAZAR > 0 .AND. SK = 1)
         INDDAT = 1
         EXIT
      ENDIF
         SKIP
    ENDDO
ENDIF
********  OVDE JE UBACENO ZA RUCNI UNOS  *****
   *   DO WHILE .T.
   *      @ 12,10 SAY "POCETNO STANJE / NORMALNA PRODAJA   P/N   " GET PN PICTURE "!" VALID(PN $ "PpNn")
   *      READ
   *      IF Lastkey() = 27
   *         CLOSE DATABASES
   *         CLEAR SCREEN
   *         RETURN
   *      ENDIF
   *      IF PN = "P"        && POCETAK UNOSA POCETNOG STANJA
   *         CLEAR SCREEN
   *         @ 2,15 SAY "POCETNI UNOS PODATAKA U KNJIGU PRIHODA KOMISIONA"
   *      *
   *         @ 4,26 SAY "RED.BROJ         :"
   *         @ 4,45 SAY WRB
   *         @ 6,26 SAY "DATUM KNJIZENJA  :" &&  GET WDK
   *         *SET COLO TO /W
   *         @ 6,45 SAY WDAT
   *         *SET COLO TO
   *         @ 8,26 SAY "OPIS KNJIZENJA I BROJ DOKUMENTA"
   *         @ 10,26 SAY "POCETNO STANJE  :" GET WPIR PICTURE "AAAAA"
   *         @ 12,26 SAY "DATUM R/P       :" GET WDRP
   *         @ 14,26 SAY "BROJ RAC./PAZAR :" GET WBRP PICTURE "9999"
   *         @ 16,26 SAY "PRIHOD1          "
   *         @ 18,26 SAY "PRIHOD2          "
   *         @ 16,47 GET WPRIH1 PICTURE "99999999999999.99"
   *         @ 18,47 GET WPRIH2 PICTURE "99999999999999.99"
   *      *
   *         READ
   *      *
   *        IF Lastkey() = 27
   *           CLOSE DATABASES
   *           CLEAR SCREEN
   *           RETURN
   *        ENDIF
   *        @ 20,10 SAY "UPIS   D/N  " GET JJ PICTURE "!" VALID(JJ $ "DdNn")
   *          READ
   *          IF Lastkey() = 27
   *            CLEAR SCREEN
   *            CLOSE DATABASES
   *            RETURN
   *          ENDIF
   *          IF JJ = "N"
   *             @ 20,10 SAY REPLI(" ",68)
   *             LOOP
   *         ENDIF
   *         SELECT 2
   *         IF INDDAT = 0
   *            APPEND BLANK
   *            REPLACE RB WITH WBR
   *            REPLACE DK WITH WDAT
   *            REPLACE PIR WITH WPIR
   *            REPLACE DRP WITH WDRP
   *            REPLACE BRP WITH WBRP
   *            REPLACE PRIH WITH 0
   *            REPLACE PRIH1 WITH WPRIH1
   *            REPLACE PRIH2 WITH WPRIH2
   *         ELSE
   *            REPLACE RB WITH WBR
   *            REPLACE DK WITH WDAT
   *            REPLACE PIR WITH WPIR
   *            REPLACE DRP WITH WDRP
   *            REPLACE BRP WITH WBRP
   *            REPLACE PRIH WITH 0
   *            REPLACE PRIH1 WITH (PRIH1 + WPRIH1)
   *            REPLACE PRIH2 WITH (PRIH2 + WPRIH2)
   *         ENDIF
   *   ENDIF
   *   IF PN = "N"
   *         EXIT
   *   ELSE
   *         CLOSE DATABASES
   *         CLEAR SCREEN
   *         RETURN
   *   ENDIF
   *   ENDDO
********  KRAJ UBACENOG ZA RUCNI UNOS    *****

DO WHILE .T.
   indik = 0
   indik3 = 0
   wdmpnaz = Space(30)
   DN = " "
   IND = IND + 1
   WRAB = 20
   WSIFART = VAL("0000000000000")
   WKOL = VAL("00000000000.000")
   @ 14,5 SAY "RABAT :" GET WRAB PICTURE "99.99"
   @ 14,20 SAY "SIF.ARTIKLA "
   @ 14,33 GET WSIFART PICTURE "9999999999999"
   *@ 14,10 SAY "KOLICINA    "
  *@ 14,23 GET WKOL
   READ
  ************ ovde ubaciti za pomoc
          IF Lastkey() = 3
             @ 19,1 SAY "Unesite deo naziva artikla:" GET wdmpnaz PICTURE "@!" VALID ! Empty(wdmpnaz)
             READ
             IF Lastkey() = 27
                LOOP
             ENDIF
             select 1
             set filter to ! at(alltrim(wdmpnaz),rnaz) = 0
             go top
             IF Eof()
                 @ 21,1 SAY "Ne postoji artikal sa takvim delom naziva!!"
                 ? " "
                 wait " "
                 cisttt()
                 set filter to
                 LOOP
             ENDIF
             DO WHILE ! Eof()
                 dn = " "
                 @ 19,1 SAY Space(79)
                 @ 19,1 SAY rsif
                 @ 19,20 SAY rnaz
                 @ 19,51 SAY rkol PICTURE "99999.999"
                 @ 19,61 SAY rnc PICTURE "99999.99"
                 @ 20,70 SAY rtar
        *        ?? "      "
        *        ?? artjm
        *        ?? "   "
        *        ?? arttar
                 @ 21,10 SAY "Da li ste mislili na ovaj artikal ? " GET dn;
                     PICTURE "!" VALID (dn $ "DN")
                 READ
                 IF Lastkey() = 27
                   indik = 1
                   EXIT
                 ENDIF
                 IF dn = "N"
                   SKIP
                   LOOP
                 ENDIF
                 IF dn = "D"
                    indik3 = 1
                    wsifart = rsif
                    wdmpnaz = rnaz
                    wartcen = rnc
                    EXIT
                  ENDIF
                  SKIP
             ENDDO
             set filter to
             go top
             IF indik = 1
                indik = 0
                LOOP
             ENDIF
             IF indik3 = 0
               @ 22,1 SAY "Nema vise artikala sa tim delom naziva!"
               ? " "
               wait " "
               cisttt()
               LOOP
             ENDIF
             cisttt()
             wdmpnaz = rnaz
             @ 14,33 SAY wsifart
           * @ 14,37 SAY wdmpnaz
           * @ 14,72 SAY wARTCEN
             indik3 = 0
             set filter to
          ENDIF  && od IF Lastkey() = 3   (help)
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
  @ 14,47 SAY substr(RNAZ,1,19)
  @ 14,67 SAY "CENA"
  @ 14,72 SAY RNC PICTURE "9,999.99"
  @ 16,10 SAY "KOLICINA   "
  @ 16,23 GET WKOL
  READ
  IF Lastkey() = 27
      EXIT
  ENDIF
  IF WKOL > RKOL
     @ 20,20 SAY "NA LAGERU IMATE"
     @ 20,36 SAY RKOL
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
  REPLACE RKOL WITH (RKOL - WKOL)
  REPLACE RPRO WITH (RPRO + WKOL)
  PRERAC = ROUND((RSTOPA * 100) / (RSTOPA + 100),2)
  POREZ = ROUND(RNC * gnBod * PRERAC / 100,2)
 * WPRIH2 = ROUND((RNC * gnBod - POREZ) * WRAB / 100 * WKOL,2)   && NEMA PDV
  WPRIH2 = 0
  WZ1 = WZ1 + ROUND(RNC * gnBod * WKOL,2)
  WZ2 = WZ2 + WPRIH2
  **************************
  *IF mVAN = "N"
     DO CASE
        CASE RSTOPA = 18 .OR. RSTOPA = 20
             WVISA = ROUND(WVISA + (ROUND(RNC * gnBod * WKOL,2) - WPRIH2),2)
        CASE RSTOPA = 8
             WNIZA = ROUND(WNIZA + (ROUND(RNC * gnBod * WKOL,2) - WPRIH2),2)
        CASE RSTOPA = 21 &&.OR. RSTOPA = 16
             WNIZA1 = ROUND(WNIZA1 + (ROUND(RNC * gnBod * WKOL,2) - WPRIH2),2)
        * CASE RSTOPA = 20
        *      WNULA06 = ROUND(WNULA06 + (ROUND(RNC * gnBod * WKOL,2) - WPRIH2),2)
        CASE RSTOPA = 1
             WNULA2 = ROUND(WNULA2 + (ROUND(RNC * gnBod * WKOL,2) - WPRIH2),2)
        CASE RSTOPA = 12
             WNULA4 = ROUND(WNULA4 + (ROUND(RNC * gnBod * WKOL,2) - WPRIH2),2)
        CASE RSTOPA = 0
             WNULA = ROUND(WNULA + (ROUND(RNC * gnBod * WKOL,2) - WPRIH2),2)
     ENDCASE
  *ELSE
  *   DO CASE
  *      CASE RSTOPA = 27 .or. RSTOPA = 23
  *           WVISA = ROUND(WVISA + (ROUND(RNC * gnBod * WKOL,2) - WPRIH2),2)
  *      CASE RSTOPA = 14 .OR. RSTOPA = 12
  *           WNIZA = ROUND(WNIZA + (ROUND(RNC * gnBod * WKOL,2) - WPRIH2),2)
  *      CASE RSTOPA = 17 .OR. RSTOPA = 13
  *           WNIZA1 = ROUND(WNIZA1 + (ROUND(RNC * gnBod * WKOL,2) - WPRIH2),2)
  *      CASE RSTOPA = 16
  *           WNULA06 = ROUND(WNULA06 + (ROUND(RNC * gnBod * WKOL,2) - WPRIH2),2)
  *      CASE RSTOPA = 0.6
  *           WNULA2 = ROUND(WNULA2 + (ROUND(RNC * gnBod * WKOL,2) - WPRIH2),2)
  *      CASE RSTOPA = 4
  *           WNULA4 = ROUND(WNULA4 + (ROUND(RNC * gnBod * WKOL,2) - WPRIH2),2)
  *      CASE RSTOPA = 0
  *           WNULA = ROUND(WNULA + (ROUND(RNC * gnBod * WKOL,2) - WPRIH2),2)
  *   ENDCASE
  *ENDIF
  **************************
  SELECT 3
  APPEND BLANK
  REPLACE DPH WITH WDAT
  REPLACE TPH WITH A->RTAR
  REPLACE SPH WITH A->RSTOPA
  REPLACE Z1 WITH ROUND(A->RNC * gnBod * WKOL,2)
  REPLACE Z2 WITH WPRIH2
  REPLACE SK1 WITH 1
  SELECT 5
  APPEND BLANK
  REPLACE PAZDAT WITH WDAT
  REPLACE PAZART WITH WSIFART
  REPLACE PAZKOL WITH WKOL
  REPLACE PAZCMARK WITH A->RNC
  REPLACE PAZCDIN WITH  ROUND(A->RNC * gnBod,2)
  REPLACE SK WITH 1
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
         REPLACE RRB WITH WBR
         REPLACE RDK WITH WDAT
         REPLACE RBR WITH ("6/" + ALLTRIM(STR(WBR,4,0)))
         REPLACE ROPIS WITH "PAZAR KOMISIONA"
         REPLACE RDATDOK WITH WDAT
         REPLACE RPV WITH WVISA
         REPLACE RPN WITH WNIZA
         REPLACE RPN1 WITH WNIZA1
         REPLACE RPBEZ WITH WNULA
         REPLACE RPBEZ06 WITH WNULA06
         REPLACE RPBEZ2 WITH WNULA2
         REPLACE RPBEZ4 WITH WNULA4
         REPLACE RUSP WITH WZ2
         REPLACE RSVEP WITH ROUND(WVISA + WNIZA + WNIZA1 + WNULA + WNULA06+ WNULA2+ WNULA4+ WZ2,2)
         REPLACE RSK WITH 1
      SELECT 7
      APPEND BLANK
        REPLACE DATK WITH WDAT
        REPLACE RBPK1 WITH WBR
        REPLACE BROJ WITH ("6/" + ALLTRIM(STR(WBR,4,0)))
        REPLACE OPIS WITH "PAZAR KOMISIONA"
        REPLACE PAZAR WITH ROUND(WVISA + WNIZA + WNIZA1 + WNULA + WNULA06+ WNULA2+ WNULA4+ WZ2,2)
        REPLACE SK WITH 1
   ELSE
     *REPLACE RRB WITH WBR
     *REPLACE RDK WITH WDAT
     *REPLACE ROPIS WITH "PAZAR"
      REPLACE RPV WITH ROUND(RPV + WVISA,2)
      REPLACE RPN WITH ROUND(RPN + WNIZA,2)
      REPLACE RPN1 WITH ROUND(RPN1 + WNIZA1,2)
      REPLACE RPBEZ WITH ROUND(RPBEZ + WNULA,2)
      REPLACE RPBEZ06 WITH ROUND(RPBEZ06 + WNULA06,2)
      REPLACE RPBEZ2 WITH ROUND(RPBEZ2 + WNULA2,2)
      REPLACE RPBEZ4 WITH ROUND(RPBEZ4 + WNULA4,2)
      REPLACE RUSP WITH ROUND(RUSP + WZ2,2)
      REPLACE RSVEP WITH ROUND(RSVEP + ROUND(WVISA + WNIZA + WNIZA1 + WNULA + WNULA06+ WNULA2+ WNULA4+ WZ2,2),2)
      SELECT 7
      REPLACE PAZAR WITH ROUND(PAZAR + ROUND(WVISA + WNIZA + WNIZA1 + WNULA + WNULA06+ WNULA2+ WNULA4+ WZ2,2),2)
   ENDIF
ENDIF
EXIT
ENDDO      && kraj od glavnog
CLOSE DATABASES
RELEASE ALL
CLEAR SCREEN
RETURN

*
function cisttt
  for i = 19 to 24
    @ i,0 SAY repli(" ",80)
  next i
return(" ")

