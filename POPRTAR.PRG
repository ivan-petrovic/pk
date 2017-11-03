* - nije pregledano - *
******* upit popisa po tarifama ******
poruka = "Otkucajte neku tipku za dalje..."
set date german
set confirm on
IF file("tempor.dbf")
   erase tempor.dbf
   erase temptar.ntx
ENDIF
create radna
store "ptar      c8  " to polje1
store "pstv      n182" to polje2
store "pnv       n182" to polje3
store "praz      n182" to polje4
for i = 1 to 4
  broj = str(i,1)
  p1 = "polje" + broj
  append blank
  replace field_name with substr(&p1,1,10)
  replace field_type with substr(&p1,11,1)
  replace field_len with val(substr(&p1,12,2))
  replace field_dec with val(substr(&p1,14,1))
next i
create tempor from radna
index on ptar to temptar
use
erase radna.dbf
*
select 1
use tempor index temptar
select 2
use artpane index apinsif
select 3
use popdat index popindat 
DO WHILE .t.
    store 0  to wbroj
    store ctod("  .  .  ") to wdat
    CLEAR SCREEN
    @ 1,0 SAY "ESC - izlaz"
    @ 1,30 SAY "POPIS PO TARIFAMA"
    store 0 to wstv,wnv,wraz,wustv,wunv,wuraz
    @ 4,1 SAY "Broj popisa: " GET wbroj PICTURE "9999999999" VALID ! Empty(wbroj)
    @ 6,1 SAY "Datum popisa:" GET wdat VALID ! Empty(wdat)
    READ
    IF Lastkey() = 27
        EXIT
    ENDIF
    kljuc = str(wbroj) + dtos(wdat)
    select 3
    seek kljuc
    IF ! Found()
      @ 19,1 SAY "Takav popis nije registrovan !!"
      ? " "
      wait poruka
      LOOP
    ENDIF
   DO WHILE wbroj = popbroj .and. popdat = wdat
        store 0 to wssv,wsnv,wsraz
        wssv = popsc * popst
        wsnv = popnc * popst
        wsraz = wsnv - wssv
        wart = 0
        wtar = Space(8)
        wart = popart
        select 2
        seek wart
        IF ! Found()
          @ 19,1 SAY "Nema maticnih podataka o artiklu :"
          ?? wart
          ? " "
          wait poruka
          select 3
          SKIP
          LOOP
        ENDIF
        wtar = arttar
        select 1
        seek wtar
        IF ! Found()
           append blank
           replace ptar with wtar
           replace pstv with wssv
           replace pnv with wsnv
           replace praz with wsraz
        else
           replace pstv with (pstv + wssv)
           replace pnv with (pnv + wsnv)
           replace praz with (praz + wsraz)
        ENDIF
        select 3
        SKIP
   ENDDO
  select 1
  go top
  red = 0
  set procedure to ona
  do ona
  DO WHILE ! Eof()
    red = red + 1
    IF red > 18
        @ 21,0 SAY " "
        wait poruka
        IF Lastkey() = 27
           EXIT
        ENDIF
        set procedure to ona
        do ona
     ENDIF 
     IF ! (pstv = 0 .and. pnv = 0 .and. praz = 0)
     @ red,1 SAY ptar
     @ red,10 SAY pstv PICTURE "999,999,999,999,999.99"
     @ red,33 SAY pnv PICTURE "999,999,999,999,999.99"
     @ red,56 SAY praz PICTURE "999,999,999,999,999.99"
     ENDIF
     wustv = wustv + pstv
     wunv = wunv + pnv
     wuraz = wuraz + praz
     SKIP
  ENDDO
  IF red > 17
     @ 21,1 SAY " "
     wait poruka
     set procedure to ona
     do ona
  ENDIF
  red = red + 1
  @ red,1 SAY "Ukupno:"
  @ red,10 SAY wustv PICTURE "999,999,999,999,999.99"
  @ red,33 SAY wunv PICTURE "999,999,999,999,999.99"
  @ red,56 SAY wuraz PICTURE "999,999,999,999,999.99"
  @ 22,1 SAY " "
  wait poruka
ENDDO
*
close databases
*release al
CLEAR SCREEN
return
proc ona
CLEAR SCREEN
@ 1,30 SAY "REKAPITULACIJA POPISA"
@ 4,5 SAY "POPIS   :" GET wbroj
@ 6,5 SAY "DATUM   :" GET wdat
clear gets
@ 8,1 SAY "TARIFA       STARA VREDNOST       NOVA VREDNOST             RAZLIKA      "        
@ 9,1 SAY "-------------------------------------------------------------------------"
red = 10
return

