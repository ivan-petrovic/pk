* - nije pregledano - *
*****************************************
*GKZIMAS
* maska za izmenu podataka o ZIRO RACUNIMA 
*****************************************
*
SET CONFIRM ON
SET DATE GERMAN
CLEAR SCREEN
ESCKEY()
@ 1,0 TO 24,79 DOUBLE
D = 1
DO WHILE D = 1
@ 1,20 SAY "IZMENA MATICNIH PODATAKA U KNJIZI ZIRO RACUNA"
*
@ 4,13 SAY "RED.BROJ                 :"
@ 4,43 SAY WRB
@ 6,13 SAY "DATUM IZVODA             :"
@ 6,40 SAY WBDIZ
@ 8,13 SAY "OPIS                     :"
@ 8,40 SAY WOPIS
*@ 10,13 SAY "POSLOVNI PARTNER         :"
*@ 10,40 SAY WZIRPP PICTURE "999999"
@ 12,13 SAY "       PROMET             "
@ 14,13 SAY "UPLATA U KORIST RACUNA   :"
@ 14,40 SAY WUPL PICTURE "9999999.99"
*
   @ 15,60 SAY "0 PLACA SE POREZ"
*


@ 16,13 SAY "ISPLATA NA TERET RACUNA  :"
@ 16,40 SAY WISPL PICTURE "9999999.99"
   @ 16,53 SAY WINDIK PICTURE "9"
   @ 16,60 SAY "7 NE PLACA SE POREZ"
   @ 17,60 SAY "9 NE PLACA SE POREZ"
@ 18,13 SAY "STANJE NA ZIRO RACUNU    :"
@ 18,40 SAY WSALDO PICTURE "9999999.99"
*
@ 20,10 SAY "P - predhodna  N - naredna  I - izmena  " GET wodl PICTURE "!" VALID(wodl $ "NnPpIi")
READ
do case
   case Lastkey() = 27
        v = 1
        return
   case wodl = "N"
        v = 2
        return
   case wodl = "P"
        v = 3
        return
   case wodl = "I"
        @ 4,13 SAY "RED.BROJ                 :"
        @ 4,43 SAY WRB
        @ 6,13 SAY "DATUM IZVODA             :" GET WBDIZ
        @ 8,13 SAY "OPIS                     :" GET WOPIS
       *@ 10,13 SAY "POSLOVNI PARTNER         :" GET WZIRPP PICTURE "999999"
        @ 12,13 SAY "       PROMET             "
        @ 14,13 SAY "UPLATA U KORIST RACUNA   :" GET WUPL PICTURE "9999999.99"
        *
        @ 15,60 SAY "0 PLACA SE POREZ"
        *


       * @ 16,13 SAY "ISPLATA NA TERET RACUNA  :"
       * @ 16,40 SAY WISPL PICTURE "9999999.99"
        @ 16,13 SAY "ISPLATA NA TERET RACUNA  :" GET WISPL PICTURE "9999999.99"
        @ 16,53 GET WINDIK PICTURE "9" VALID(WINDIK=0 .OR. WINDIK=7 .OR. WINDIK=9)
        @ 16,60 SAY "7 NE PLACA SE POREZ"
        @ 17,60 SAY "9 NE PLACA SE POREZ"


       * @ 16,13 SAY "ISPLATA NA TERET RACUNA  :" GET WISPL PICTURE "9999999.99"
        @ 18,13 SAY "STANJE NA ZIRO RACUNU    :" GET WSALDO PICTURE "9999999.99"
*
        READ
        IF Lastkey() = 27
            V = 1
            RETURN
        ENDIF
        v = 4
        return
endcase
 IF Lastkey() = 27
    V = 1
    RETURN
 ENDIF
D = 0
*
ENDDO D
*
RETURN
