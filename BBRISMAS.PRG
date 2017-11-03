* - nije pregledano - *
*****************************************
*BBRISMAS
* maska za brisanje podataka o bankama     
*****************************************
*
SET CONFIRM ON
SET DATE GERMAN
PRAZNO = REPLI(" ",80)
D = 1
DO WHILE D = 1
   @ 0,23 SAY "BRISANJE MATICNIH PODATAKA O BANKAMA"
   *
   @ 10,16 SAY "NAZIV BANKE :"
   *SET COLOR TO /W
   @ 10,30 SAY WNAZBANK
   *SET COLOR TO
   @ 12,16 SAY "ADRESA BANKE:"
   *SET COLOR TO /W
   @ 12,30 SAY WADRBANK
   *SET COLOR TO
   @ 14,16 SAY "MESTO BANKE :"
   *SET COLOR TO /W
   @ 14,30 SAY WMESBANK
   *SET COLOR TO
   @ 16,16 SAY "ZIRORACUN BANKE :"
   *SET COLOR TO /W
   @ 16,34 SAY WZIRBANK
   *SET COLOR TO
D = 0
*
ENDDO D
*
RETURN
