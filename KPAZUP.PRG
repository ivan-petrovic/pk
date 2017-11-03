* - nije pregledano - *
     set date german
     set confirm on
     select 1
 *   use artpane index apinsif,apinart
     use revers index revart
     select 2
     use pazdat index pazindat
     set filter to sk = 1
     go top
     por = "Otkucajte neku tipku za dalje..."
     store 0 to indik,indik2,indik3,indik4
     DO WHILE .t.
        CLEAR SCREEN
  *     *set colo to w/b
        wbrr = "0000000000000"
  *      wartsif = val(wbrr)
         wartsif = val("0000000000000")
        zbir = val("000000000000.00")
        wdat = date()
        do esck
        @ 2,28 SAY "LISTANJE DNEVNOG PAZARA"
        @ 5,10 SAY "Unesite datum za koji zelite pregled" GET wdat
    *    @ 6,33 SAY "(ENTER - od pocetka do kraja)"
    *    @ 6,15 GET wartsif PICTURE "9999999999999"
        READ
        IF Lastkey() = 27
           EXIT
        ENDIF
     *   IF Empty(wartsif)
     *     go top
     *   else
         kljuc = dtos(wdat)
     *     seek wartsif
          seek kljuc
          IF ! Found()
            @ 19,10 SAY "Ne postoji pazar za taj dan !"
            ? " "
            wait por
            LOOP
          ENDIF
     *    ENDIF
         DO WHILE wdat = pazdat
            zbir = zbir + (pazcdin * pazkol)
            SKIP
         ENDDO
         seek kljuc
         red = 5
  DO WHILE .t.     
       IF pazdat = wdat                     &&   ! Eof()
        IF red = 5 
           CLEAR SCREEN
           do esck
           @ 2,28 SAY "LISTANJE DNEVNOG PAZARA"
           @ 3,1 SAY Replicate("*",78)
           @ 4,4 SAY "SIFRA"  
           @ 4,22 SAY "NAZIV ARTIKLA"
           @ 4,44 SAY "KOLICINA"
           @ 4,56 SAY "CENA"
           @ 4,70 SAY "DINARA"
           @ 5,1 SAY Replicate("*",78)
         ENDIF
         select 1
         seek B->pazart
         select 2
         red = red + 1
         @ red,0 SAY A->rsif
         @ red,14 SAY A->rnaz
         @ red,44 SAY pazkol PICTURE "999.99"
         @ red,51 SAY pazcdin PICTURE "999,999.99"
         @ red,63 SAY round(pazcdin * pazkol,2) PICTURE "9999,999,999.99"
         @ 18,38 SAY "Ukupni dnevni zbir :"
         @ 18,60 SAY zbir PICTURE "999,999,999,999.99"
      IF red > 15
            red = 5
            izbor = 1
            @ 22,1 prompt "DALJE"
            @ 22,30 prompt "PRETHODNI EKRAN"
            @ 22,55 prompt "OD POCETKA"
            menu to izbor
            do case
              case Lastkey() = 27
                indik = 1
                EXIT
              case izbor = 2
                   IF recno() > 22
                      SKIP -22
                   else 
                      go top
                   ENDIF
                LOOP
              case izbor = 3
                 go top
                 LOOP
              case izbor = 1
            endcase
      ENDIF  && od IF red > 15
        SKIP
        LOOP
 ENDIF   && od IF ! Eof()
        @ 19,1 SAY "Zavrseno listanje!!"
        izbor = 1
        @ 22,1 prompt "PRETHODNI EKRAN"
        @ 22,30 prompt "OD POCETKA"
        menu to izbor
        do case
           case Lastkey() = 27
             indik = 1
             EXIT
           case izbor = 1
             IF recno() > 22
                 broj = red + 11 - 5
                 SKIP -broj
                 red = 5
                 LOOP
             else
                go top
                red = 5
                LOOP
             ENDIF
           case izbor = 2
              go top
              red = 5
              LOOP
           otherwise
              indik = 1
              EXIT
        endcase
       EXIT
 ENDDO  && *** od DO WHILE ! Eof()
        IF indik = 1
          indik = 0
          LOOP
        ENDIF
     ENDDO
 *   set filter to
     close databases
     CLEAR SCREEN
     *release al
     return

