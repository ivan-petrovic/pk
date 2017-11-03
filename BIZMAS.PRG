* - nije pregledano - *
*****************************************
*BIZMAS
* maska za izmenu podataka o CEKOVIMA    
*****************************************
*
SET CONFIRM ON
SET DATE GERMAN
PRAZNO = REPLI(" ",80)
D = 1
DO WHILE D = 1
@ 0,25 SAY "IZMENA MATICNIH PODATAKA O BANKAMA"
*
@ 10,16 SAY "NAZIV BANKE :" GET WNAZBANK
@ 12,16 SAY "ADRESA BANKE:" GET WADRBANK
@ 14,16 SAY "MESTO BANKE :" GET WMESBANK
@ 16,16 SAY "ZIRORACUN BANKE :" GET WZIRBANK
READ
*
 IF Lastkey() = 27
 V = 1
 RETURN
 ENDIF
D = 0
*
ENDDO D
*
RETURN
