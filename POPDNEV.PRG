* - nije pregledano - *
por = "Otkucajte neku tipku za dalje..."
set date german
select 1
use popdat index popindat
DO WHILE .t.
wd1 = ctod("  .  .  ")
wd2 = ctod("  .  .  ")
CLEAR SCREEN
do esck
@ 1,30 SAY "DNEVNIK POPISA"
@ 10,10 SAY "OD datuma: " GET wd1 VALID ! Empty(wd1)
@ 10,40 SAY "DO datuma: " GET wd2 VALID ! Empty(wd2)
READ
IF Lastkey() = 27
   EXIT
ENDIF
IF wd1 > wd2
  @ 19,1 SAY "Datum   -od-  veci od datuma -do- "
  ? " "
  wait por
  LOOP
ENDIF
red = 20
k = 0
pp = 0
select 1
go top
wpopbroj = 0
wpopdat = ctod("  .  .  ")
DO WHILE ! Eof()
     IF popdat > wd2
        SKIP
        LOOP
     ENDIF
     IF popdat < wd1
        SKIP
        LOOP
     ENDIF
     k = 1
     IF red > 17
       IF pp = 1
         @ 19,1 SAY " "
         wait por
         IF Lastkey() = 27
            EXIT
         ENDIF
       else
         wpopbroj = popbroj
         wpopdat = popdat
         pp = 1
       ENDIF
       red = 2
       CLEAR SCREEN
       @ red,30 SAY "DNEVNIK POPISA"
       red = red + 1
       @ red,10 SAY "OD :"
       ?? wd1
       @ red,50 SAY "DO :"
       ?? wd2
       red = red + 2
       @ red,0 SAY Replicate("-",79)
       red = red + 1
       @ red,3 SAY "DATUM POPISA"
       @ red,30 SAY "BROJ POPISA"
       red = red + 1
       @ red,0 SAY Replicate("-",79)
    ENDIF
    IF  wpopbroj = popbroj .and. wpopdat = popdat
         SKIP
         LOOP
    ENDIF
    red = red + 1
    @ red,3 SAY wpopdat
    @ red,30 SAY wpopbroj
    wpopbroj = popbroj
    wpopdat = popdat
    SKIP
ENDDO
  IF k = 0
    @ 19,10 SAY "Nema popisa u datom periodu !"
    ? " "
    wait por
    LOOP
  ENDIF
  red = red + 1
  @ red,3 SAY wpopdat
  @ red,30 SAY wpopbroj
  @ 19,1 SAY "Zavrseno listanje dnevnika !"
  ? " "
  wait por
ENDDO
*
close databases
*release al
CLEAR SCREEN
return
