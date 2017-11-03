* - nije pregledano - *
CLEAR SCREEN
mOdl = " "
mOdl = "T"
@ 2,10 SAY "NUMERISEM KNJIGU PRIMLJENIH RACUNA"
@ 4,10 SAY "MESECNO / TROMESECNO  M/T " GET mOdl PICTURE "!" VALID(mOdl $ "MmTt")
READ
IF Lastkey() = 27
    CLEAR SCREEN
    return
ENDIF
select 0
use KPR index KPRDK
wrrb = val("0000")
wrrb = 1
*DO WHILE ! Eof()
   do case
      case mOdl = "M"
           DO WHILE ! Eof()
              wprem = mont(dkkpr)
              DO WHILE wprem = mont(dkkpr)      &&  vrti jedan mesec
                 replace rbkpr with wrrb
                 wrrb = wrrb + 1
                 SKIP
                 IF Eof()
                    EXIT
                 ENDIF
              ENDDO                             &&  kraj vrcenja jednog meseca
              wrrb = 1
           ENDDO
      case mOdl = "T"
           DO WHILE ! Eof()
              wprem = mont(dkkpr)
              DO WHILE mont(dkkpr) < 4     &&  vrti prvo tromesecje
                 replace rbkpr with wrrb
                 wrrb = wrrb + 1
                 SKIP
                 IF Eof()
                    EXIT
                 ENDIF
              ENDDO                        &&  kraj vrcenja prvog tromesecja
              wrrb = 1
              *
              DO WHILE mont(dkkpr) > 3 .and. mont(dkkpr) < 7     &&  vrti drugo tromesecje
                 replace rbkpr with wrrb
                 wrrb = wrrb + 1
                 SKIP
                 IF Eof()
                    EXIT
                 ENDIF
              ENDDO                        &&  kraj vrcenja drugog tromesecja
              wrrb = 1
              *
              DO WHILE mont(dkkpr) > 6 .and. mont(dkkpr) < 10    &&  vrti trece tromesecje
                 replace rbkpr with wrrb
                 wrrb = wrrb + 1
                 SKIP
                 IF Eof()
                    EXIT
                 ENDIF
              ENDDO                        &&  kraj vrcenja treceg tromesecja
              wrrb = 1
              *
              DO WHILE mont(dkkpr) > 9 .and. mont(dkkpr) <= 12   &&  vrti cetvrto tromesecje
                 replace rbkpr with wrrb
                 wrrb = wrrb + 1
                 SKIP
                 IF Eof()
                    EXIT
                 ENDIF
              ENDDO                        &&  kraj vrcenja cetvrtog tromesecja
              wrrb = 1
           ENDDO
   endcase
*ENDDO
close databases
CLEAR SCREEN
return
