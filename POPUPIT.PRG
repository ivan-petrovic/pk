* - nije pregledano - *
set date german
select 1
use artpane index apinsif
select 2
use popdat index popinart,popindat
select 3
use revers index revart
poruka = "Otkucajte neku tipku za dalje..."
wpopdat = ctod("  .  .  ")
wpopbroj = 0
sk = " "
DO WHILE .t.
    wpopart = val("0000000000000")
    CLEAR SCREEN
    do esck
     @ 1,30 SAY "UPIT POPISA"
     @ 10,10 SAY "Datum popisa:" GET wpopdat VALID ! Empty(wpopdat)
     @ 10,40 SAY "Broj popisa:" GET wpopbroj PICTURE "9999999999" VALID ! Empty(wpopbroj)
     @ 10,66 SAY "S/K" GET sk PICTURE "!" VALID(sk $ "SsKk")
     READ
     IF Lastkey() = 27
         EXIT
     ENDIF
     select 2
     set order to 2
     kljuc = str(wpopbroj) + dtos(wpopdat)
     seek kljuc
     IF ! Found()
        @ 19,1 SAY "Nije unet takav popis !"
        ? " "
        wait poruka
        LOOP
     ENDIF
    set order to 1
    @ 13,10 SAY "Sifra artikla:" GET wpopart PICTURE "9999999999999" VALID ! Empty(wpopart)
    READ
    IF Lastkey() = 27
       LOOP
    ENDIF
    IF sk = "S"
       select 1
       seek wpopart
            IF ! Found()
                 @ 19,1 SAY "Ne postoji takav artikal !"
                 ? " "
                 wait poruka
                 LOOP
            else
                wartnaz = artnaz
                wartjm = artjm
            ENDIF
    else
       select 3 
       seek wpopart
            IF ! Found()
                 @ 19,1 SAY "Ne postoji takav artikal !"
                 ? " "
                 wait poruka
                 LOOP
            else
                 wartnaz = rnaz
                 wartjm = rjm
            ENDIF
    ENDIF
    store 0 to wpopnc,wpopsc,wpopst,wpopproc
    wpopnaz = wartnaz
    wpopjm = wartjm
    select 2
    set order to 1
    kljuc = str(wpopbroj) + dtos(wpopdat) + str(wpopart)
    seek kljuc
    IF ! Found()
       @ 19,1 SAY "Ne postoji trazeni artikal po navedenom popisu !"
       ? " "
       wait poruka
       LOOP
    ENDIF
    wpopnc = popnc
    wpopsc = popsc
    wpopst = popst
    wpopproc = popproc
    @ 15,10 SAY "Stara cena   :" 
    @ 15,25 SAY wpopsc
    @ 17,43 SAY wpopjm
    @ 17,10 SAY "Stanje       :" 
    @ 17,25 SAY wpopst
    @ 19,10 SAY "Nova cena    :" 
    @ 19,25 SAY wpopnc
    @ 13,10 SAY "Sifra artikla :" 
    @ 13,25 SAY wpopart
    @ 13,42 SAY wpopnaz
    @ 12,8 to 20,75
    wpopproc = popproc
    @ 19,42 SAY "Procenat povecanja :" 
    @ 19,63 SAY wpopproc
    dn = " "
    @ 23,30 SAY "Jos upita ? " GET dn PICTURE "!" VALID (dn $ "DN")
    READ
    IF Lastkey() = 27 .OR. dn = "N"
        EXIT
    ENDIF
    LOOP
ENDDO
*
close databases
*release al
CLEAR SCREEN
return
