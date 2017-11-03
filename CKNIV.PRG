* - nije pregledano - *
PORUKA = "Otkucajte neku tipku za dalje..."
select 1
use artpane index apinsif
select 2
use popdat index popindat
set date german
DO WHILE .t.
    CLEAR SCREEN
    WPOPDAT = ctod("  .  .  ")
    WPOPBROJ = 0
    do esck
    @ 1,23 SAY "AZURIRANJE CENA I KOLICINA POPISOM"
    @ 10,10 SAY "DATUM POPISA:" GET WPOPDAT VALID ! Empty(WPOPDAT)
    @ 10,50 SAY "BROJ POPISA:" GET WPOPBROJ PICTURE "9999999999" VALID ! Empty(WPOPBROJ)
    READ
    IF Lastkey() = 27
       EXIT
    ENDIF
    KLJUC = STR(WPOPBROJ) + DTOS(WPOPDAT)
    SEEK KLJUC
    IF ! Found()
       @ 19,1 SAY "NE POSTOJI TAKAV POPIS !!"
       ?  " "
       WAIT PORUKA
       LOOP
    ENDIF
DO WHILE ! Eof()
     WSC = VAL("000000000000.00")
     WNC = VAL("000000000000.00")
     WPOPART = VAL("0000000000000")
     WPOPART = POPART
     WPOPST = POPST
     WSC = POPSC
     WNC = POPNC
     KLJUC = WPOPART
     SELECT 1
     SEEK KLJUC
     IF ! Found()
        @ 19,10 SAY "NEMA ARTIKLA SA SIFROM :"
        ?? WPOPART
        ?? " U BAZI ARTIKALA"
        ? " "
        WAIT PORUKA
        SELECT 2
        SKIP
        LOOP
     ENDIF
     REPLACE ARTKOL WITH WPOPST
     REPLACE ARTCEN WITH WNC
     SELECT 2
     SKIP
ENDDO
ENDDO
*
close databases
*release al
CLEAR SCREEN
return
