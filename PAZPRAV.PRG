* - nije pregledano - *
set date german

SELECT 1
USE ARTPANE INDEX APINSIF

SELECT 2
USE PAZDAT INDEX PAZINDAT
SET FILTER TO SK = 0

por = "Otkucajte neku tipku za dalje..."
DO WHILE .t.
    CLEAR SCREEN
 *   *set colo to w/b
    wdat = date()
    nivo = val("0")
    indd = 0
    @ 1,0 SAY "ESC - izlaz"
    @ 1,60 SAY "Datum:"
    @ 1,67 SAY date()
    @ 6,10 SAY "STAMPA PAZARA ZA DATUM:" GET wdat
    @ 8,10 SAY "UNESITE NIVO LAGERA (BROJ PRODAVNICE)" GET nivo PICTURE "9" rang 0,9
    READ
    IF Lastkey() = 27
       EXIT
    ENDIF
    IF nivo = 0
       indd = 0
    else
       indd = 1
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
    set printer to lpt1
    set print on
    set console off
*   set printer to lista
   IF lLaser
      ? Chr(27) + '(s17.5H'      && kondenz On za laserski
   ELSE
      ? Chr(15)                  && kondenz On za matricni
   ENDIF

    DO WHILE wdat = pazdat
        IF red > 60
          set procedure to nova_str
          do nova_str
        ENDIF
        IF indd = 1
           pom = str(pazart,13,0)
           pom1 = ltrim(pom)
           pom1 = substr(pom1,1,1)
           IF val(pom1) = nivo
               red = red + 1
               wart = 0
               wnaz = Space(30)
               wart = pazart
               select 1
               seek wart
                 IF ! Found()
                     wnaz = Space(30)
                 else
                     wnaz = artnaz
                 ENDIF
               select 2
               @ red,1 SAY wart
               @ red,15 SAY wnaz
               @ red,47 SAY pazkol PICTURE "999999.99"
         *     @ red,66 SAY pazcmark PICTURE "99999999999999.99"
               @ red,85 SAY pazcdin PICTURE "99999999999.99"
               @ red,104 SAY round(pazkol * pazcdin,2) PICTURE "99999999999.99"
               wukdin = wukdin + round(pazcdin * pazkol,2)
              wukmar = wukmar + pazkol * pazcmark
          *else
          *   SKIP
          *   LOOP
           ENDIF
        else
           red = red + 1
           wart = 0
           wnaz = Space(30)
           wart = pazart
           select 1
           seek wart
            IF ! Found()
               wnaz = Space(30)
            else
               wnaz = artnaz
            ENDIF
          select 2
          @ red,1 SAY wart
          @ red,15 SAY wnaz
          @ red,47 SAY pazkol PICTURE "999999.99"
    *     @ red,66 SAY pazcmark PICTURE "99999999999999.99"
          @ red,85 SAY pazcdin PICTURE "99999999999.99"
          @ red,104 SAY round(pazkol * pazcdin,2) PICTURE "99999999999.99"
         wukdin = wukdin + round(pazcdin * pazkol,2)
         wukmar = wukmar + pazkol * pazcmark
     ENDIF
     SKIP
   ENDDO
    red = red + 2
    @ red,1 SAY Replicate("-",136)
    red = red + 1
    @ red,80 SAY "Ukupno     dinara  :"
    @ red,104 SAY wukdin PICTURE "99999999999.99"
    red = red + 1
    @ red,0 SAY " "

   IF lLaser
      ? Chr(27) + '&k0S' + Chr(27) + '(s10.5H'  && kondenz Off za laserski
   ELSE
      ? Chr(18)                                 && kondenz Off za matricni
   ENDIF

    set device to screen
    set print off
    set print to
    set console on
ENDDO
*
SET FILTER TO
close databases
*release al
CLEAR SCREEN
return
procedure nova_str
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
