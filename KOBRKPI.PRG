* - nije pregledano - *
set date german
set confirm on
set delete on

use porezpic
index on dtos(dat) to porpicdd
use

select 0
use porezpic index porpicdd

select 0
use kstalkpc

select 0
use rashodn index rashindn
* odluka da li sve ili samo str
* set filter to rsk = 0
* go top
* kraj odluke da li je sve ili samo str
*
DO WHILE .t.
   mpazar = val("000000000000.00")
   od = " "
   store mpazar to wukpor,wukppor
   @ 0,0 clear
   wod = ctod("  .  .  ")
   wdo = ctod("  .  .  ")
   @ 2,14 SAY "OBRACUN POREZA PRERACUNATIM STOPAMA KAFA,PICE,CIGARE"
   @ 6,10 SAY "OD DATUMA" GET wod
   @ 6,30 SAY "DO DATUMA" GET wdo VALID(wod <= wdo)
   READ
   IF Lastkey() = 27
      EXIT
   ENDIF
   set softseek on
   seek dtos(wod)
   IF rdk > wdo .or. Eof()
      @ 20,10 SAY "NEMATE PAZARA U TOM PERIODU"
      wait " "
      set softseek off
      LOOP
   ENDIF
   set softseek off
   DO WHILE rdk <= wdo
      mpazar = round(mpazar + rsvep,2)
      SKIP
      IF Eof()
         EXIT
      ENDIF
   ENDDO
*  da saberemo preneti porez za dati period
   select porezpic
   set softseek on
   seek dtos(wod)
   IF dat > wdo .or. Eof()
      @ 20,10 SAY "NEMATE PRENETOG POREZA U TOM PERIODU"
      wait " "
      set softseek off
      LOOP
   ENDIF
   set softseek off
   DO WHILE dat <= wdo
      wukppor = round(wukppor + oddob,2)
      SKIP
      IF Eof()
         EXIT
      ENDIF
   ENDDO
*  kraj sabiranja prenetog poreza
*  sledi obracun poreza
   select kstalkpc
   IF Eof()
      @ 20,10 SAY "NISAM MOGAO DA PRONADJEM PRERACUNATE KOEFICIJENTE"
      wait " "
      EXIT
   ENDIF
   go bott
   DO WHILE .t.
      wpom = kod
      DO WHILE wpom = kod
          replace kobrpor with round(mpazar * kkoef / 100,2)
          SKIP -1
          IF bof()
             EXIT
          ENDIF
      ENDDO
      EXIT
   ENDDO
   go bott
   @ 18,10 SAY "OBRACUN JE ZAVRSEN ! PRIKAZ EKRAN/STAMPAC  E/S  " GET od PICTURE "!" VALID(od $ "EeSs")
   READ
   IF Lastkey() = 27
      EXIT
   ENDIF
   IF od = "E"
      @ 18,10 SAY repli(" ",68)
      @ 4,5 SAY gcNazRad
      @ 8,0 SAY "TARIFA  "
      @ 8,9 SAY "KOEFICIJENT "
      @ 8,22 SAY "      ZARADA"
      @ 8,35 SAY "OBRAC. POREZ"
      @ 8,48 SAY "PRENET POREZ"
      @ 8,61 SAY "POREZ ZA UPLATU"
      red = 10
      DO WHILE wpom = kod
          @ red,0 SAY ktar
          @ red,10 SAY kkoef PICTURE "9999.999999"
          @ red,22 SAY mpazar PICTURE "999999999.99"
          @ red,35 SAY round(mpazar * kkoef / 100,2) PICTURE "999999999.99"
          @ red,48 SAY wukppor PICTURE "999999999.99"
        *  @ red,61 SAY round(wukpor - wukppor,2) PICTURE "999999999999.99"
          wukpor = round(wukpor + round(mpazar * kkoef / 100,2),2)
          @ red,61 SAY round(wukpor - wukppor,2) PICTURE "999999999999.99"
          SKIP -1
          IF bof()
             EXIT
          ENDIF
          red = red + 1
      ENDDO
      red = red + 1
      @ red,0 SAY repli("-",79)
      red = red + 1
      @ red,26 SAY "UKUPNO POREZA ZA PLACANJE :"
      @ red,61 SAY round(wukpor - wukppor,2) PICTURE "999999999999.99"
        wait " "
   else
      set device to print
      set print on
      @ 2,14 SAY "OBRACUN POREZA PRERACUNATIM STOPAMA KAFA,PICE,CIGARE"
      @ 4,10 SAY gcNazRad
      @ 6,10 SAY "OD DATUMA"
      @ 6,20 SAY wod
      @ 6,30 SAY "DO DATUMA"
      @ 6,40 SAY wdo
      @ 8,0 SAY "TARIFA  "
      @ 8,9 SAY "KOEFICIJENT "
      @ 8,22 SAY "      ZARADA"
      @ 8,35 SAY "OBRAC. POREZ"
      @ 8,48 SAY "PRENET POREZ"
      @ 8,61 SAY "POREZ ZA UPLATU"
      red = 10
      DO WHILE wpom = kod
          @ red,0 SAY ktar
          @ red,10 SAY kkoef PICTURE "9999.999999"
          @ red,22 SAY mpazar PICTURE "999999999.99"
          @ red,35 SAY round(mpazar * kkoef / 100,2) PICTURE "999999999.99"
          @ red,48 SAY wukppor PICTURE "999999999.99"
        *  @ red,61 SAY round(wukpor - wukppor,2) PICTURE "999999999999.99"
          wukpor = round(wukpor + round(mpazar * kkoef / 100,2),2)
          @ red,61 SAY round(wukpor - wukppor,2) PICTURE "999999999999.99"
          SKIP -1
          IF bof()
             EXIT
          ENDIF
          red = red + 1
      ENDDO
      red = red + 1
      @ red,0 SAY repli("-",79)
      red = red + 1
      @ red,26 SAY "UKUPNO POREZA ZA PLACANJE :"
      @ red,61 SAY round(wukpor - wukppor,2) PICTURE "999999999999.99"
      red = red + 1
      @ red,0 SAY " "
      eject
      set device to screen
      set print off
   ENDIF
   EXIT
ENDDO
@ 0,0 clear
select kstalkpc
use
select rashodn
use
select porezpic
use
return
