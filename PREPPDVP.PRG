* - nije pregledano - *
  *IF FILE("KPR.DBF")
  *  * @ 10,10 SAY "sada brisem kprr.dbf"
  *  * wait " "
  *   ERASE KPR.DBF
  *ENDIF
   IF FILE("KPRR.DBF")
     * @ 10,10 SAY "sada brisem kprr.dbf"
     * wait " "
      ERASE KPRR.DBF
   ENDIF
*
   IF FILE("KPRO.DBF")
     * @ 12,10 SAY "sada brisem kpro.dbf"
     * wait " "
      ERASE KPRO.DBF
   ENDIF
*
   IF ! FILE("KPR.DBF")
      CREATE RADNA
      STORE "RBKPR     N 4 " TO POLJE1
      STORE "DKKPR     D8  " TO POLJE2
      STORE "DPPVDKPR  D8  " TO POLJE3
      STORE "BRKAL     C10 " TO POLJE4
      STORE "BRACKPR   C10 " TO POLJE5
      STORE "DRACKPR   D8  " TO POLJE6
      STORE "KUPKPR    N 6 " TO POLJE7
      STORE "PIBKPR    C13 " TO POLJE8
      STORE "UKSPDV    N122" TO POLJE9
      STORE "UKSPDV1   N122" TO POLJE10
      STORE "OSLPDV    N122" TO POLJE11
      STORE "UVOZN     N122" TO POLJE12
      STORE "NPDV      N122" TO POLJE13
      STORE "UKPPDV    N122" TO POLJE14
      STORE "ODPDV     N122" TO POLJE15
      STORE "NEODPDV   N122" TO POLJE16
      STORE "VBEZPDVU  N122" TO POLJE17
      STORE "IZNPDVU   N122" TO POLJE18
      STORE "VDU       N122" TO POLJE19
      STORE "IZNN5     N122" TO POLJE20
      FOR I = 1 TO 20
         IF I < 10
            STORE  STR(I,1) TO BROJ
         ELSE
            STORE  STR(I,2) TO BROJ
         ENDIF
         P1 = "POLJE" + BROJ
      APPEND BLANK
      REPLACE FIELD_NAME WITH SUBSTR(&P1,1,10)
      REPLACE FIELD_TYPE WITH SUBSTR(&P1,11,1)
      REPLACE FIELD_LEN WITH VAL(SUBSTR(&P1,12,2))
      REPLACE FIELD_DEC WITH VAL(SUBSTR(&P1,14,1))
      NEXT I
      CREATE KPR FROM RADNA
      INDEX ON DTOS(DKKPR) TO KPRDK
      INDEX ON brkal+BRACKPR TO KPRBRACk
      INDEX ON BRACKPR TO KPRBRAC
      USE
      ERASE RADNA.DBF
    ENDIF
*
*
   IF ! FILE("KPRR.DBF")
     * @ 14,10 SAY "sada kreiram kprr.dbf"
     * wait " "
      CREATE RADNA
      STORE "RBKPR     N 4 " TO POLJE1
      STORE "DKKPR     D8  " TO POLJE2
      STORE "DPPVDKPR  D8  " TO POLJE3
      STORE "BRKAL     C10 " TO POLJE4
      STORE "BRACKPR   C10 " TO POLJE5
      STORE "DRACKPR   D8  " TO POLJE6
      STORE "KUPKPR    N 6 " TO POLJE7
      STORE "PIBKPR    C13 " TO POLJE8
      STORE "UKSPDV    N122" TO POLJE9
      STORE "UKSPDV1   N122" TO POLJE10
      STORE "OSLPDV    N122" TO POLJE11
      STORE "UVOZN     N122" TO POLJE12
      STORE "NPDV      N122" TO POLJE13
      STORE "UKPPDV    N122" TO POLJE14
      STORE "ODPDV     N122" TO POLJE15
      STORE "NEODPDV   N122" TO POLJE16
      STORE "VBEZPDVU  N122" TO POLJE17
      STORE "IZNPDVU   N122" TO POLJE18
      STORE "VDU       N122" TO POLJE19
      STORE "IZNN5     N122" TO POLJE20
      FOR I = 1 TO 20
         IF I < 10
            STORE  STR(I,1) TO BROJ
         ELSE
            STORE  STR(I,2) TO BROJ
         ENDIF
         P1 = "POLJE" + BROJ
      APPEND BLANK
      REPLACE FIELD_NAME WITH SUBSTR(&P1,1,10)
      REPLACE FIELD_TYPE WITH SUBSTR(&P1,11,1)
      REPLACE FIELD_LEN WITH VAL(SUBSTR(&P1,12,2))
      REPLACE FIELD_DEC WITH VAL(SUBSTR(&P1,14,1))
      NEXT I
      CREATE KPRR FROM RADNA
      *INDEX ON DTOS(DKKPR) TO KPRDK
      *INDEX ON BRACKPR TO KPRBRAC
      USE
      ERASE RADNA.DBF
   * ENDIF
     *
     * PREPISATI IZ KPR U KPRR
     select 0
     USE kprr
     select 0
     USE kpr
     DO WHILE ! Eof()
        select kprr
        append blank
        replace RBKPR     with kpr->RBKPR
        replace DKKPR     with kpr->DKKPR
        replace DPPVDKPR  with kpr->DPPVDKPR
        replace BRKAL     with kpr->BRKAL
        replace BRACKPR   with kpr->BRACKPR
        replace DRACKPR   with kpr->DRACKPR
        replace KUPKPR    with kpr->KUPKPR
        replace PIBKPR    with kpr->PIBKPR
        replace UKSPDV    with kpr->UKSPDV
        replace UKSPDV1   with kpr->UKSPDV1
        replace OSLPDV    with kpr->OSLPDV
        replace UVOZN     with kpr->UVOZN
        replace NPDV      with kpr->NPDV
        replace UKPPDV    with kpr->UKPPDV
        replace ODPDV     with kpr->ODPDV
        replace NEODPDV   with kpr->NEODPDV
        replace VBEZPDVU  with kpr->VBEZPDVU
        replace IZNPDVU   with kpr->IZNPDVU
        replace VDU       with kpr->VDU
        replace IZNN5     with kpr->IZNN5
        select kpr
        SKIP
     ENDDO
     select kpr
     close kpr
     select kprr
     close kprr
     ! ren kpr.dbf kprO.dbf
     ! ren kprr.dbf kpr.dbf
     ! copy kpr.dbf kprr.dbf > NUL
  ENDIF
* KRAJ PREPISA I PREIMENOVANJA

CLEAR SCREEN
set confirm on
wpre = Space(10)
wukppk = val("000000000.00")
wukppd = val("000000000.00")
wuknab = val("000000000.00")
*
SELECT 0
USE KPR
INDEX ON DKKPR TO KPRDK
INDEX ON brkal+BRACKPR TO KPRBRACk
INDEX ON BRACKPR TO KPRBRAC
CLOSE KPR
*
select 0
use KPR index KPRBRACk,KPRDK,KPRBRAC,RBKPRIN
select 0
use dmpdat index dmpinbro
*
dat1 = date()
dat2 = date()
   @ 4,8 SAY "AZURIRANJE KNJIGE KPR IZ KALKULACIJA OD " GET DAT1
   @ 4,55 SAY "DO DATUMA" GET DAT2
   READ
   IF Lastkey() =  27
      CLEAR SCREEN
      CLOSE DATABASES
      RETURN
   ENDIF
DO WHILE ! Eof()
   IF DMPDAT < DAT1 .OR. DMPDAT > DAT2
      SKIP
      IF Eof()
         EXIT
      ELSE
         LOOP
      ENDIF
   ENDIF
   * sa se preskoce nivelacije
   IF dmpsif = 0 .and. dmpjm = "-  "
      SKIP
      LOOP
   ENDIF
   * kraj preskakanja nivelacija
   * sa se preskoce dostavnice
   IF dmpfak = "         0"
      SKIP
      LOOP
   ENDIF
   * kraj preskakanja dostavnice
   wpre = dmpbro
   wbrackpr = dmpfak
   DO WHILE wpre = dmpbro
      wdkkpr = dmpdat
      wbrackpr = dmpfak
      wdrackpr = dmpdfak
      wkupkpr = dmpdob
      IF VRSTA = " "
         wuknab = round(wuknab + round(dmpnc * dmpkol,2),2)
      ELSE
         wuknab = round(wuknab + dmpnc,2)
      ENDIF
      wukppd = round(wukppd + dmpppd,2)
      wukppk = round(wukppk + dmpppk,2)
      SKIP
   ENDDO
   select KPR
   kljuc = wpre+wbrackpr
   seek kljuc
   IF Found()
     * @ 20,10 SAY " NASAO "
     * WAIT " "
      REPLACE BRKAL WITH WPRE
      * DA UPISE U POM POLJE AKO NIJE OBVEZNIK PDV
      IF WUKPPD = 0
         replace ukspdv1 with ROUND(wuknab,2)
      ELSE
         replace ukspdv with ROUND(wuknab,2)
      ENDIF
      IF WUKPPD = 0
         replace NPDV WITH 0
      ELSE
         replace NPDV with ROUND(wuknab - WUKPPD,2)
      ENDIF
    *  replace ukppdv with wukppk
      replace ukppdv with wukppd
      replace odpdv with wukppd
   else
      append blank
      replace dkkpr with wdkkpr
      REPLACE BRKAL WITH WPRE
      replace brackpr with wbrackpr
      replace drackpr with wdrackpr
      replace kupkpr with wkupkpr
      IF WUKPPD = 0
         replace ukspdv1 with ROUND(wuknab,2)
      ELSE
         replace ukspdv with ROUND(wuknab,2)
      ENDIF
     * replace ukspdv with ROUND(wuknab,2)
      IF WUKPPD = 0
         replace NPDV WITH 0
      ELSE
         replace NPDV with ROUND(wuknab - WUKPPD,2)
      ENDIF
     * replace ukppdv with wukppk
      replace ukppdv with wukppd
      replace odpdv with wukppd
   ENDIF
   wukppd = 0
   wukppk = 0
   wuknab = 0
   select dmpdat
ENDDO
close databases

* sada da popunimo PIB ili JMBG
select 0
use ppdat index ppinsif
select 0
use kpr
DO WHILE ! Eof()
   select ppdat
   seek kpr->kupkpr
   IF Found()
      select kpr
      replace pibkpr with ppdat->pppib
      SKIP
   else
      select kpr
      SKIP
   ENDIF
ENDDO
*
close databases
CLEAR SCREEN
return
