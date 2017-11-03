* - nije pregledano - *
local ekran:=savescreen(0,0,24,79), kursor:=SETCURSOR(1),oblast:=SELECT()
@ 0,0 clear
*esckey()
@ 0,11 SAY "LISTANJA i BRISANJA PRERACUNATIH STOPA KAFA,PICE,CIGARE"
@ 3,2 SAY "ENTER - izmena polja(zapamtite prethodnu vrednost)"
@ 4,2 SAY "DELETE - brisanje cele stavke"
@ 5,2 SAY "ALT/N - unos nove stavke"

 do listbaz1 with 8,5,22,75,"KSTALKPC"    && ,"rashind"

select(oblast)
restscreen(0,0,24,79,ekran)
setcursor(kursor)
return
