* - nije pregledano - *
CLEAR SCREEN
set date german
IF FILE ("KONTKPR.DBF")
   ERASE KONTKPR.DBF
ENDIF

 *                kreira kontrolnu datoteku
 *
     IF ! FILE ("KONTKPR.DBF")
       CREATE RADNA
       STORE "DATK      D8  " TO POLJE1
       STORE "BKAL      C10 " TO POLJE2
       STORE "BRAC      C10 " TO POLJE3
       STORE "DRAC      D8  " TO POLJE4
       STORE "PPDV      N152" TO POLJE5
       FOR I = 1 TO 5
        STORE STR(I,1) TO BROJ
         STORE "POLJE" + BROJ TO P1
          APPEND BLANK
          REPLACE FIELD_NAME WITH SUBSTR(&P1,1,10)
          REPLACE FIELD_TYPE WITH SUBSTR(&P1,11,1)
          REPLACE FIELD_LEN WITH VAL(SUBSTR(&P1,12,2))
          REPLACE FIELD_DEC WITH VAL(SUBSTR(&P1,14,1))
        NEXT I
        CREATE KONTKPR FROM RADNA
        USE
        ERASE RADNA.DBF
     ENDIF
 *
*
 *
select 0    && 1
use KPR index KPRBRACK
SELECT 0
use kontKPR
zap
go top
select KPR
wpred = Space(10)
*wod = ctod("01.01" + substr(str(year(date()),4,0),2,2)
wod = date()
wdo = date()
  wwukppd1 = val("000000000.00")  && kalkulacije
  wwukppd2 = val("000000000.00")  && rashod
  wwukppd3 = val("000000000.00")  && porez
  wwukppd4 = val("000000000.00")  && kpr
@ 10,10 SAY "OD DATUMA" GET wod
@ 10,32 SAY "DO DATUMA" GET wdo
READ
IF Lastkey() = 27
   close databases
   CLEAR SCREEN
   return
ENDIF
DO WHILE ! Eof()
   IF DKKPR < wod .or. DKKPR > wdo
      SKIP
      LOOP
   ENDIF
   * KONTROLA DATUMA
   IF DRACKPR < WOD .OR. DRACKPR > WDO
      SELECT KONTKPR
      APPEND BLANK
      REPLACE DATK WITH KPR->DKKPR
      REPLACE BKAL WITH KPR->BRKAL
      REPLACE BRAC WITH KPR->BRACKPR
      REPLACE DRAC WITH KPR->DRACKPR
      REPLACE PPDV WITH KPR->UKPPDV
      SELECT KPR
      WWUKPPD4 = ROUND(WWUKPPD4 + UKPPDV,2)
      SKIP
   ELSE
      SKIP
   ENDIF
ENDDO
SELECT KONTKPR
APPEND BLANK
APPEND BLANK
APPEND BLANK
REPLACE PPDV WITH WWUKPPD4
close databases
CLEAR SCREEN
* ubaciti ono sto treba da se vidi datoteka kontrola
*local ekran:=savescreen(0,0,24,79), kursor:=SETCURSOR(1),oblast:=SELECT()
@ 0,0 clear
*esckey()
@ 0,22 SAY "LISTANJA KPR RAZLICITI DATUMI        "
@ 3,2 SAY "ENTER - izmena polja(zapamtite prethodnu vrednost)"
@ 4,2 SAY "DELETE - brisanje cele stavke"
@ 5,2 SAY "ALT/N - unos nove stavke"

 do listbaza with 8,5,22,75,"kontkpr"    && ,"rashind"

*select(oblast)
*restscreen(0,0,24,79,ekran)
*setcursor(kursor)
@ 0,0 clear
return


