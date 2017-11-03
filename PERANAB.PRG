* - nije pregledano - *
CLEAR SCREEN
set date german
IF FILE ("KONTROLp.DBF")
   ERASE KONTROLp.DBF
ENDIF

 *                kreira kontrolnu datoteku
 *
     IF ! FILE ("KONTROLP.DBF")
       CREATE RADNA
       STORE "KBR       C10 " TO POLJE1
       STORE "KDAT      D8  " TO POLJE2
       STORE "KKAL      N152" TO POLJE3
       STORE "KRAS      N152" TO POLJE4
       STORE "KRAS1     N152" TO POLJE5
       STORE "KKPR      N152" TO POLJE6
       FOR I = 1 TO 6
        STORE STR(I,1) TO BROJ
         STORE "POLJE" + BROJ TO P1
          APPEND BLANK
          REPLACE FIELD_NAME WITH SUBSTR(&P1,1,10)
          REPLACE FIELD_TYPE WITH SUBSTR(&P1,11,1)
          REPLACE FIELD_LEN WITH VAL(SUBSTR(&P1,12,2))
          REPLACE FIELD_DEC WITH VAL(SUBSTR(&P1,14,1))
        NEXT I
        CREATE KONTROLP FROM RADNA
        USE
        ERASE RADNA.DBF
     ENDIF
 *
*
select 0
 USE POREZN
 index on broj to poreznbb
 use
 *
select 0    && 1
use KPR index KPRBRACK
select 0    && 1
use dmpdat index dmpinbro
SELECT 0    && 2
use rashodn index rashinkn
select 0    && 3
use porezn index poreznbb
select 0     && 4
use kontrolp
zap
go top
select rashodn
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
   IF rnvrrr = 0
      SKIP
      LOOP
   ENDIF
   neg = 0
   wpred = Space(10)
   wpred = rbr
   *wdat = dmpdat
   wzbv = val("000000000000.00")
   wzbn = val("000000000000.00")
   wzbn1 = val("000000000000.00")
   wzbbez = val("000000000000.00")
   wzbsvek = val("000000000000.00")
   wzbsver = val("000000000000.00")
   wzbsvep = val("000000000000.00")
   *
   wukppk1 = val("000000000.00")  && kalkulacije
   wukppk2 = val("000000000.00")  && rashod
   wukppk3 = val("000000000.00")  && porez
   wukppk4 = val("000000000.00")  && kpr
   wukppd1 = val("000000000.00")  && kalkulacije
   wukppd2 = val("000000000.00")  && rashod
   wukppd3 = val("000000000.00")  && porez
   wukppd4 = val("000000000.00")  && kpr
/*
   wpre = dmpbro
   DO WHILE wpre = dmpbro
      wukppd1 = round(wukppd1 + dmpppd,2)
      wukppk1 = round(wukppk1 + dmpppk,2)
      SKIP
   ENDDO
   select rashodn
   seek wpre
   IF Found()
     * @ 20,10 SAY " NASAO "
     * WAIT " "
      wukppk2 = rpbez06
      wukppk3 = robpor
      wukppd2 = rpbez2
   ENDIF
   *
  * select POREZN
  * seek wpred
  * IF Found()
  *    wzbsvep = vrrobe
  * else
  *    wzbsvep = 0
  * ENDIF
   *
*/
   wukppd2 = rnvrrr + rpbez2
   select KPR
   seek wpred
   IF Found()
      wukppd4 = ukspdv
   else
      wUKPPD4 = 0
   ENDIF
   *   idemo na upis ako sva tri zbira nisu ista po apsolutnoj vrednosti
   IF round(wukppd2,2) <> round(wukppd4,2)
      select KONtrolp
      append blank
      replace kbr with wpred
     * replace kdat with wdat
     * replace kkal with wukppd1
      replace kras with wukppd2
     * replace kRAS1 with wukppd3
      replace kKPR  with wukppd4
   ENDIF
      * zbirovi
      wwukppd1 =   wwukppd1 + wukppd1
      wwukppd2 =   wwukppd2 + wukppd2
      wwukppd3 =   wwukppd3 + wukppd3
       wwukppd4 =   wwukppd4 + wukppd4

   select rashodn
   SKIP
ENDDO
      select KONtrolp
      append blank
      append blank
      append blank
     * replace kbr with wpred
     * replace kdat with wdat
      replace kkal with wwukppd1
      replace kras with wwukppd2
      replace kRAS1 with wwukppd3
      replace kKPR  with wwukppd4
close databases
CLEAR SCREEN
* ubaciti ono sto treba da se vidi datoteka kontrola
*local ekran:=savescreen(0,0,24,79), kursor:=SETCURSOR(1),oblast:=SELECT()
@ 0,0 clear
*esckey()
@ 0,22 SAY "LISTANJA ZBIROVA KALKULACIJA ,RASHODA,POREZA "
@ 3,2 SAY "ENTER - izmena polja(zapamtite prethodnu vrednost)"
@ 4,2 SAY "DELETE - brisanje cele stavke"
@ 5,2 SAY "ALT/N - unos nove stavke"

 do listbaza with 8,5,22,75,"kontrolp"    && ,"rashind"

*select(oblast)
*restscreen(0,0,24,79,ekran)
*setcursor(kursor)
@ 0,0 clear
return


