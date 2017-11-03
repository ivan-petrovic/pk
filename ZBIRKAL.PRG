* - nije pregledano - *
clear screen
set date german
IF FILE ("KONTROLA.DBF")
   ERASE KONTROLA.DBF
ENDIF

 *                kreira kontrolnu datoteku
 *
     IF ! FILE ("KONTROLA.DBF")
       CREATE RADNA
       STORE "KBR       C10 " TO POLJE1
       STORE "KDAT      D8  " TO POLJE2
       STORE "KKAL      N152" TO POLJE3
       STORE "KRAS      N152" TO POLJE4
       STORE "KPOR      N152" TO POLJE5
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
        CREATE KONTROLA FROM RADNA
        USE
        ERASE RADNA.DBF
     ENDIF
 *
*
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
use kontrola
zap
go top
select DMPDAT
wpred = space(10)
*wod = ctod("01.01" + substr(str(year(date()),4,0),2,2)
wod = date()
wdo = date()
@ 10,10 say "OD DATUMA" get wod
@ 10,32 say "DO DATUMA" get wdo
read
if lastkey() = 27
   close databases
   clear screen
   return
endif
  wzbsvekk = val("000000000000.00")
do while ! eof()
   if dmpdat < wod .or. dmpdat > wdo
      skip
      loop
   endif
   neg = 0
   wpred = space(10)
   wpred = dmpbro
   wdat = dmpdat
   wzbv = val("000000000000.00")
   wzbn = val("000000000000.00")
   wzbn1 = val("000000000000.00")
   wzbbez = val("000000000000.00")
   wzbsvek = val("000000000000.00")
   wzbsver = val("000000000000.00")
   wzbsvep = val("000000000000.00")
   do while wpred = dmpbro
    *  do case
    *     case dmppor = 26 .or. dmppor = 29
    *          wzbv = round(wzbv + round(dmpkol * dmpmsp,2),2)
    *     case dmppor = 15
    *          wzbn = round(wzbn + round(dmpkol * dmpmsp,2),2)
    *     case dmppor = 12
    *          wzbn1 = round(wzbn1 + round(dmpkol * dmpmsp,2),2)
    *     case dmppor = 0
    *          wzbbez = round(wzbbez + round(dmpkol * dmpmsp,2),2)
    *  endcase
    *  wzbsvek = round(wzbsvek + round(dmpkol * dmpmsp,2),2)   && nabavna u dmpdat
      if vrsta = " " .and. dmpfak = "         0"
         wzbsvek = round(wzbsvek - dmpvsp,2)   && prodajna
      else
         wzbsvek = round(wzbsvek + dmpvsp,2)   && prodajna
      endif
      skip
   enddo
   select RASHODN
   seek wpred
   if found()
      wzbsver = rprodv
   else
      wzbsver = 0
   endif
   *
   select POREZN
   seek wpred
   if found()
      wzbsvep = vrrobe
   else
      wzbsvep = 0
   endif
   *
   select KPR
   seek wpred
   if found()
      wzbsveKp = UKSPDV
   else
      wzbsveKp = 0
   endif
   *
   wzbsver = 0
   wzbsvep = 0
   wzbsvekp = 0
   wzbsvekk = round(wzbsvekk + wzbsvek,2)
   *   idemo na upis ako sva tri zbira nisu ista po apsolutnoj vrednosti
   if abs(wzbsvek) <> abs(wzbsver) .or. abs(wzbsvek) <> abs(wzbsvep) .or. abs(wzbsver) <> abs(wzbsvep)
      select KONTROLA
      append blank
      replace kbr with wpred
      replace kdat with wdat
      replace kkal with wzbsvek
      replace kras with wzbsver
      replace kpor  with wzbsvep
      replace kKPR  with wzbsveKp
   endif
   select DMPDAT
enddo
select kontrola
append blank
append blank
replace kkal with wzbsvekk
close databases
clear screen
* ubaciti ono sto treba da se vidi datoteka kontrola
*local ekran:=savescreen(0,0,24,79), kursor:=SETCURSOR(1),oblast:=SELECT()
@ 0,0 clear
*esckey()
@ 0,22 say "LISTANJA ZBIROVA KALKULACIJA ,RASHODA,POREZA "
@ 3,2 say "ENTER - izmena polja(zapamtite prethodnu vrednost)"
@ 4,2 say "DELETE - brisanje cele stavke"
@ 5,2 say "ALT/N - unos nove stavke"

 do listbaza with 8,5,22,75,"kontrola"    && ,"rashind"

*select(oblast)
*restscreen(0,0,24,79,ekran)
*setcursor(kursor)
@ 0,0 clear
return


