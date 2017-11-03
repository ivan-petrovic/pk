* - nije pregledano - *
* ali je ubaceno jer sadrzi f-ju ocisti
* a onda sam morao da dodam i fajl kompopun.prg
* je ga poziva kompop.prg
* mogao sam i da samo prebacim f-ju ocisti
* u fajl koji je poziva, ali otom potom
popmod = 0
poruka = "Otkucajte neku tipku za dalje..."
set date german
CLEAR SCREEN
IF ! file("popdat.dbf")
    create radna
    store "popdat    d8  " to polje1
    store "popart    n13 " to polje2
    store "popsc     n152" to polje3
    store "popst     n153" to polje4
    store "popnc     n152" to polje5
    store "popindik  n1  " to polje6     && 1 - popis svih , 2 - popis nekih
    store "popbroj   n10 " to polje7
    store "popproc   n8 2" to polje8
    store "popniv    n1  " to polje9
    for i = 1 to 9
       broj = str(i,1)
       p1 = "polje" + broj
       append blank
       replace field_name with substr(&p1,1,10)
       replace field_type with substr(&p1,11,1)
       replace field_len with val(substr(&p1,12,2))
       replace field_dec with val(substr(&p1,14,1))
    next i
    create popdat from radna
    index on str(popbroj) + dtos(popdat) to popindat
    index on str(popbroj) + dtos(popdat) + str(popart) to popinart
    use
    erase radna.dbf
ENDIF
*
DO WHILE .t.
     CLEAR SCREEN
     @ 15,10 SAY " "
     text
       N A P O M E N A : Ako zelite popis SVIH artikala sa ili bez nivelacije
                          izaberite prvu opciju !

                         Ako zelite popis POJEDINIH artikala sa ili bez
                          nivelacije izaberite drugu opciju !
     endtext
     izbor = 0
     @ 10,10 prompt "POPIS SVIH ARTIKALA"
     @ 12,10 prompt "POPIS POJEDINIH ARTIKALA"
     @ 9,9 TO 13,35
     MENU TO IZBOR
     DO CASE
         CASE Lastkey() = 27
            EXIT
         CASE izbor = 1
           popmod = 1
           do kompopun
         case izbor = 2
           popmod = 2
           do kompopun
     ENDCASE
ENDDO
*
*release al
CLEAR SCREEN
return
function ocisti
 for i = 11 to 24
   @ i,0 SAY Space(80)
 next i
return (" ")
