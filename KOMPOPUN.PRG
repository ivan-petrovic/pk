* - nije pregledano - *
set  confirm on
kom = "PageDN  tipka za prelazak na novu sifru bez upisa tekuce"
indik = 2
select 1
use popdat index popinart,popindat
go bottom
wpopproc = 0
IF Eof()
  r = 1
else
  r = popbroj
  r = r + 1
ENDIF
select 2
use revers index revart,revbr
DO WHILE .t.
   CLEAR SCREEN
   do esck
   wpopdat = ctod("  .  .  ")
   wart = 0
   wpopniv = 0
   store 0 to wpopst,wpopsc,wpopnc
   wartnaz = Space(30)
   wartjm = Space(3)
   wpopbroj  = r
   @ 1,30 SAY "UNOS POPISA"
   @ 10,10 SAY "Datum popisa:" GET wpopdat VALID ! Empty(wpopdat)
   @ 10,50 SAY "Broj popisa: " GET wpopbroj PICTURE "9999999999" VALID ! Empty(wpopbroj)
   READ
   IF Lastkey() = 27
      EXIT
   ENDIF
   select 1
   set order to 2
   kljuc = str(wpopbroj) + dtos(wpopdat)
   seek kljuc
   IF Found()
      @ 8,30 SAY "***  NASTAVAK POPISA ****"
   ENDIF
   set order to 1
   select 2
   go top
   KKK = 0
   pop = 0
   IF popmod = 1
      dn = " "
      @ 5,10 SAY "Da li zelite povecanje cena SVIH artikala za ISTI  % ? " GET dn PICTURE "!" VALID (dn $ "DN")
      READ
      IF Lastkey() = 27
         LOOP
      ENDIF
      IF dn = "N"
         pop = 0
      else
         @ 7,10 SAY "Procenat : " GET wpopproc PICTURE "9999.99" VALID ! Empty(wpopproc)
         READ
         IF Lastkey() = 27
            LOOP
         ENDIF
         pop = 1
      ENDIF
    ENDIF
   DO WHILE .t.
       in = 0
       IF popmod = 1
          IF pop = 1
              select 2
                 DO WHILE ! Eof()
                    select 2
                    IF rkol = 0
                       SKIP
                       LOOP
                    ENDIF
                    select 1
                     append blank
                       replace popproc with wpopproc
                       replace popniv with wpopniv
                       replace popbroj with wpopbroj
                       replace popdat with wpopdat
                       replace popart with B->rsif
                       replace popsc with B->rnc
                       replace popst with B->rkol
                       replace popnc with round(B->rnc + (wpopproc / 100) * B->rnc,2)
                       replace popindik with indik
                       select 2
                       SKIP
                 ENDDO
                 close databases
                 *release al
                 CLEAR SCREEN
                 return
          ENDIF
          kom = Space(60)
          select 2
  *      IF KKK = 1
  *       SKIP
  *      ENDIF
          KKK = 1
          IF Eof()
            EXIT
          ENDIF
          wpopart = rsif
          wpopnaz = rnaz
          wpopjm = rjm
          wpopst = rkol
          kljuc = str(wpopbroj) + dtos(wpopdat) + str(wpopart)
          select 1
          seek kljuc
          IF Found()
            select 2
            SKIP
            LOOP
          ENDIF
          select 2
        else
       wpopart = val("0000000000000")
       @ 13,10 SAY "Sifra artikla:" GET wpopart PICTURE "9999999999999" VALID ! Empty(wpopart)
       READ
       IF Lastkey() = 27
         in = 1
         EXIT
       ENDIF
       seek wpopart
       IF ! Found()
          @ 22,1 SAY "Ne postoji artikal sa tom sifrom !!"
          ? " "
          wait poruka
          @ 22,0 SAY Space(80)
          @ 24,0 SAY Space(80)
          LOOP
       ENDIF
  *    wpopart = artsif
       select 1
       kljuc = str(wpopbroj) + dtos(wpopdat) + str(wpopart)
       ocisti()
       seek kljuc
       IF Found()
          @ 19,10 SAY "VEC STE UNELI OVAJ ARTIKAL PO OVOM POPISU !"
          ? " "
          WAIT poruka
          @ 19,1 SAY Space(79)
          @ 21,0 SAY Space(80)
          select 2
          LOOP
       ENDIF
*         select 2
*         SKIP
*         LOOP
*      ENDIF
       select 2
 *     wpopart = Space(13)
       wpopnaz = Space(30)
      ENDIF
       wpopsc = 0
       wpopst = 0
       wpopjm = Space(3)
      IF pop = 0
       wpopnc = 0
       wpopproc = 0
      ENDIF
       wpopniv = 0
 *     wpopart = artsif
       wpopnaz = rnaz
       wpopsc = rnc
       wpopst = rkol
       wpopjm = rjm
  *    ocisti()
       @ 12,8 to 20,75
       @ 13,10 SAY "Sifra artikla:"
       @ 13,25 SAY  wpopart
       @ 13,42 SAY wpopnaz
   *   select 3
   *   seek wpopart
   *   wpopsc = cnnmc
   *   select 2
       @ 21,9 SAY kom
       @ 15,10 SAY "Cena u racun.:" GET wpopsc
       @ 17,43 SAY wpopjm
       @ 17,10 SAY "Stanje       :" GET wpopst PICTURE "99999999999.999" VALID !Empty(wpopst)
       READ
       IF Lastkey() = 27
          in = 1
          EXIT
       ENDIF
       IF Lastkey() = 3
           select 2
           SKIP
           @ 13,42 SAY Space(32)
           @ 13,25 SAY Space(40)
           *set colo to /w
           @ 15,25 SAY "             .  "
           @ 17,25 SAY "           .   "
           *set colo to
           @ 17,43 SAY Space(20)
           clear gets
           LOOP
       ENDIF
       IF ! Lastkey() = 13
          ocisti()
          LOOP
       ENDIF
       IF pop = 1
          wpopnc = wpopsc + (wpopproc /  100) * wpopsc
          @ 19,10 SAY "Nova cena    :" 
          @ 19,24 SAY wpopnc PICTURE "9999999999999.99"
          @ 19,41 SAY "Procenat povecanja :"
          @ 19,61 SAY wpopproc PICTURE "9999.99"
       else
        @ 19,10 SAY "Nova cena    :" GET wpopnc PICTURE "999999999999.99"
       READ
       IF Lastkey() = 27
          in = 1
          EXIT
       ENDIF
       IF Lastkey() = 3
           select 2
           SKIP
           @ 13,42 SAY Space(32)
           @ 13,25 SAY Space(40)
           @ 17,43 SAY Space(20)
           clear gets
           LOOP
       ENDIF
 ***   
       IF ! Lastkey() = 13
           ocisti()
           LOOP
       ENDIF
 ***   
       IF wpopnc = 0
          @ 19,41 SAY "Procenat povecanja :" GET wpopproc PICTURE "9999.99"
          READ
          IF Lastkey() = 27
            in = 1
            EXIT
          ENDIF
          IF Lastkey() = 3
            clear gets
            @ 13,42 SAY Space(32)
            @ 13,25 SAY Space(40)
            @ 17,43 SAY Space(20)
            @ 19,40 SAY Space(32)
            select 2
            SKIP
            LOOP
          ENDIF
          IF ! Lastkey() = 13
             ocisti()
             LOOP
          ENDIF
          wpopnc = wpopsc + (wpopproc / 100) * wpopsc
          @ 19,25 GET wpopnc PICTURE "999999999999.99"
          clear gets
        ENDIF
       dn = " "
      ENDIF
       @ 23,35 SAY "Upis ? " GET dn PICTURE "!" VALID (dn $ "DN")
       READ
       IF Lastkey() = 27 .or. dn = "N"
          IF popmod = 1
             KKK = 0
          ENDIF
          ocisti()
          @ 13,42 SAY Space(32)
          @ 13,25 SAY Space(40)
          @ 17,43 SAY Space(20)
          @ 19,40 SAY Space(32)
          LOOP
       ENDIF
       select 1
       append blank
       replace popproc with wpopproc
       replace popniv with wpopniv
       replace popbroj with wpopbroj
       replace popdat with wpopdat
       replace popart with wpopart
       replace popsc with wpopsc
       replace popst with wpopst
       replace popnc with wpopnc
       replace popindik with indik
       @ 13,42 SAY Space(32)
       @ 13,25 SAY Space(40)
       @ 17,43 SAY Space(20)
       @ 19,40 SAY Space(32)
        ocisti()
*       clear gets
       select 2
*      replace artinpop with 1
       SKIP
   ENDDO
     IF in = 1
        in = 0
        LOOP
     ENDIF
    CLEAR SCREEN
ENDDO
*
close databases
*release al
CLEAR SCREEN
return
