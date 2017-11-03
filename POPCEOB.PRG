* - nije pregledano - *
set date german
select 1
use artpane index apinsif
select 2
use popdat index popindat,popinart
poruka = "Otkucajte neku tipku za dalje..."
wpopdat = ctod("  .  .  ")
wpopbroj = 0
DO WHILE .t.
    wpopart = val("0000000000000")
    wpopdat = ctod("  .  .  ")
    wpopbroj = 0
    CLEAR SCREEN
    do esck
     @ 1,27 SAY "BRISANJE KOMPLETNOG POPISA"
     @ 10,10 SAY "Datum popisa:" GET wpopdat VALID ! Empty(wpopdat)
     @ 10,50 SAY "Broj popisa:" GET wpopbroj PICTURE "9999999999" VALID ! Empty(wpopbroj)
     READ
     IF Lastkey() = 27
         EXIT
     ENDIF
     kljuc = str(wpopbroj) + dtos(wpopdat)
     seek kljuc
     IF ! Found()
        @ 19,1 SAY "Nije unet takav popis !"
        ? " "
        wait poruka
        LOOP
     ENDIF
    dn = " "
    @ 23,30 SAY "Brisanje ? " GET dn PICTURE "!" VALID (dn $ "DN")
    READ
    IF Lastkey() = 27 .OR. dn = "N"
        LOOP
    ENDIF
  DO WHILE wpopbroj = popbroj             &&  .t.
   *seek kljuc
   *IF Found()
       delete
   *   pack
   *else
   *   EXIT
   *ENDIF
   SKIP
  ENDDO
  pack
  @ 20,10 SAY "Brisanje je zavrseno .Pritisnite bilo sta za nastavak ..."
  wait " "
  @ 20,10 SAY " "
  EXIT
ENDDO
*
close databases
*release al
CLEAR SCREEN
return
