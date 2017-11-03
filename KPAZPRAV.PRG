* - nije pregledano - *
set date german

SELECT 1
USE REVERS INDEX REVART

SELECT 2
USE PAZDAT INDEX PAZINDAT
SET FILTER TO SK = 1

por = "Otkucajte neku tipku za dalje..."
DO WHILE .t.
    CLEAR SCREEN
    *set colo to w/b
    wdat = date()
    @ 1,0 SAY "ESC - izlaz"
    @ 1,60 SAY "Datum:"
    @ 1,67 SAY date()
    @ 6,10 SAY "Stampa pazara za datum:" GET wdat
    READ
    IF Lastkey() = 27
       EXIT
    ENDIF
    select 2
    kljuc = dtos(wdat)
    seek kljuc
    IF ! Found()
      @ 19,10 SAY "Nema pazara za taj datum !"
      ? " "
      wait por
      LOOP
    ENDIF
    select 2
    red = 65
    wukmar = 0
    wukdin = 0
    set device to printer
    set print to lpt1
    set print on
    set console off
*   set printer to lista
    ? chr(15)
    DO WHILE wdat = pazdat
        IF red > 60
          set procedure to nova_s
          do nova_s
        ENDIF
        red = red + 1
        wart = 0
        wnaz = Space(30)
        wart = pazart
        select 1
        seek wart
        IF ! Found()
             wnaz = Space(30)
        else
           wnaz = rnaz
        ENDIF
        select 2
        @ red,1 SAY wart
        @ red,15 SAY wnaz
        @ red,47 SAY pazkol PICTURE "999999.99"
  *     @ red,66 SAY pazcmark PICTURE "99999999999999.99"
        @ red,85 SAY pazcdin PICTURE "99999999999.99"
        @ red,104 SAY round(pazkol * pazcdin,2) PICTURE "99999999999.99"
       wukdin = wukdin + round(pazcdin * pazkol,2)
       wukmar = wukmar + round(pazkol * pazcmark,2)
     SKIP
   ENDDO
    red = red + 2
    @ red,1 SAY Replicate("-",136)
    red = red + 1
    @ red,80 SAY "Ukupno     dinara  :"
    @ red,104 SAY wukdin PICTURE "99999999999.99"
    red = red + 1
 *  @ red,80 SAY "Vrednost u bodovima:"
 *  @ red,104 SAY wukmar PICTURE "99999999999999.99"
 *  red = red + 1
 *  @ red,80 SAY "Vrednost boda      :"
 *  @ red,104 SAY gnBod PICTURE "99999999999999.99"
 *  red = red + 1
 *  @ red,80 SAY "Vrednost u dinarima:"
 *  @ red,104 SAY wukmar * gnBod PICTURE "99999999999999.99"
    @ red,0 SAY " "
    set device to screen
    set print off
    set print to
    set console on 
ENDDO
*
set filter to
close databases
*release al
CLEAR SCREEN
return
procedure nova_s
  red = 0
*  @ red,0 SAY " "
  red = red + 2
  @ red,5 SAY gcNazRad
  @ red,60 SAY "PREGLED PAZARA ZA DATUM:"
  ?? wdat
  red = red + 1
  @ red,1 SAY Replicate("*",136)
  red = red + 1
  @ red,1 SAY "SIFRA ARTIKLA"
  @ red,20 SAY "NAZIV ARTIKLA"
  @ red,52 SAY "KOLICINA"
*  @ red,70 SAY "CENA U BODOVIMA"
  @ red,86 SAY "POJEDINAC. CENA"
  @ red,110 SAY "VREDNOST U DINARIMA"
  red = red + 1
  @ red,1 SAY Replicate("*",136)
  red = red + 1
return



