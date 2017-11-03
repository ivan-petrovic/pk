* - nije pregledano - *
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
SELECT KPR
*
dat1 = date()
dat2 = date()
   @ 4,8 SAY "BRISE STAVKE KALKULACIJE IZ KPR OD " GET DAT1
   @ 4,55 SAY "DO DATUMA" GET DAT2
   READ
   IF Lastkey() =  27
      CLEAR SCREEN
      CLOSE DATABASES
      RETURN
   ENDIF
DO WHILE ! Eof()
   IF DKKPR < DAT1 .OR. DKKPR > DAT2
      SKIP
      IF Eof()
         EXIT
      ELSE
         LOOP
      ENDIF
   ENDIF
   * DA se preskoce STAVKE KOJE NISU KALKULACIJA
   SELECT DMPDAT
   SEEK KPR->BRKAL
   IF Found()
      SELECT KPR
      DELETE
      SKIP
   ELSE
      SELECT KPR
      SKIP
   ENDIF
ENDDO
SELECT KPR
PACK
close databases
*
CLEAR SCREEN
return
