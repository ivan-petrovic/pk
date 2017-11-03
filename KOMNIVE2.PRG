* - nije pregledano - *
set  confirm on
kom = "PageDN  tipka za prelazak na novu sifru bez upisa tekuce"
poruka1 = "Pritisnite bilo koju tipku za nastavak ..."
indik = 2
   wpopindik = val("0")
   wpopniv = val("0")
   wpopst = val("00000000000.000")
   wpopsc = val("000000000000.00")
   wpopnc = val("000000000000.00")
   wpopart = val("0000000000000")
    DO WHILE .t.
   CLEAR SCREEN
   esckey()
   @ 2,15 SAY "NIVELACIJA ARTIKALA - POJEDINACNA"
*   DO WHILE .t.
       store 0 to wpopindik,wpopniv
       store 0 to wpopst,wpopsc,wpopnc
       wpopart = val("0000000000000")
       @ 13,10 SAY "Sifra artikla:" GET wpopart PICTURE "9999999999999" VALID ! Empty(wpopart)
       READ
       IF Lastkey() = 27
         in = 1
         EXIT
       ENDIF
       select 2
       seek wpopart
       IF ! Found()
          @ 22,15 SAY "Ne postoji artikal sa tom sifrom !!"
          ? " "
          wait poruka1
          @ 22,0 SAY Space(80)
          @ 24,0 SAY Space(80)
          LOOP
       ENDIF
       wpopart = artsif
       wpopnaz = artnaz
       wpopst = artkol
       wpopsc = artcen
       wpopjm = artjm
       select 1
       kljuc = str(wpopbroj) + dtos(wpopdat) + str(wpopart)
       seek kljuc
       IF Found()
          @ 19,10 SAY "VEC STE UNELI OVAJ ARTIKAL PO OVOM POPISU !"
          ? " "
          WAIT poruka1
          @ 19,1 SAY Space(79)
          @ 21,0 SAY Space(80)
          select 2
          LOOP
       ENDIF
       select 2
       @ 12,8 to 20,75
       @ 13,10 SAY "Sifra artikla:"
       @ 13,25 SAY  wpopart
       @ 13,42 SAY wpopnaz
       @ 15,10 SAY "Cena u racun.:" GET wpopsc
       @ 17,43 SAY wpopjm
       @ 17,10 SAY "Stanje       :" GET wpopst PICTURE "99999999999.999" VALID !Empty(wpopst)
       READ
       IF Lastkey() = 27
          in = 1
          EXIT
       ENDIF
        @ 19,10 SAY "Nova cena    :" GET wpopnc PICTURE "999999999999.99"
       READ
       IF Lastkey() = 27
          in = 1
          EXIT
       ENDIF
 ***   
 ***   
       dn = " "
       @ 23,35 SAY "Upis ? " GET dn PICTURE "!" VALID (dn $ "DNdn+")
       READ
       IF Lastkey() = 27 .or. dn = "N"
          @ 13,42 SAY Space(32)
          @ 13,25 SAY Space(40)
          @ 17,43 SAY Space(20)
          @ 19,40 SAY Space(32)
          @ 23,25 SAY Space(40)
          LOOP
       ENDIF
       replace artcen with wpopnc
       select 1
       append blank
       replace popproc with wpopproc
       replace popniv with wpopniv
       replace popbroj with wpopbroj
       replace popdat with wpopdat
       replace popart with wpopart
       replace popsc with (wpopsc * novbod)
       replace popst with wpopst
       replace popnc with (wpopnc * novbod)
       replace popindik with indik
       @ 13,42 SAY Space(32)
       @ 13,25 SAY Space(40)
       @ 17,43 SAY Space(20)
       @ 19,40 SAY Space(32)
       @ 23,25 SAY Space(40)
*       clear gets
       select 2
   ENDDO
*
close databases
*release al
CLEAR SCREEN
return
