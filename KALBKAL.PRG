* - nije pregledano - *
     set date german
     set confirm on
     por = "Otkucajte neku tipku za dalje..."
     select 3
     use artpane index apinsif
     select 2
     use ppdat index ppinsif
     select 1
     use dmpdat index dmpinbro,dmpinbs
     DO WHILE .t.
        select 1
        CLEAR SCREEN
        do esck
        @ 2,30 SAY "BRISANJE KALKULACIJE"
        dn = " "
        wdmpbro = Space(10)
        wdmppp = val("000000")
        wdmpdat = ctod("00.00.00")
        @ 5,1 SAY "Broj kalkulacije:" GET wdmpbro PICTURE "@!" VALID ! Empty(wdmpbro)
        READ
        IF Lastkey() = 27
           EXIT
        ENDIF
        seek wdmpbro
        IF ! Found()
           @ 19,1 SAY "Ne postoji takva kalkulacija ! "
           ? " "
           wait por
           LOOP
        ENDIF
        wdmppp = dmpdob
        wdmpdat = dmpdat
        select 2
        seek wdmppp
        IF Found()
          @ 6,1 SAY "Poslovni partner:"
          ?? wdmppp
          ?? "    "
          ?? ppnaz
        ENDIF
        @ 5,40 SAY "Datum:"
        ?? wdmpdat
        @ 15,1 SAY "Brisanje:" GET dn PICTURE "!" VALID (dn $ "DN")
        READ
        IF Lastkey() = 27
           EXIT
        ENDIF
        IF dn = "N"
           LOOP
        ENDIF
        IF dn = "D"
           select 1
           DO WHILE dmpbro = wdmpbro
              wdmpart = dmpsif
              select 3
              seek wdmpart
              IF Found()
                   replace artkol with round(artkol - A->dmpkol,3)
              else
                  @ 17,2 SAY "NISAM U BAZI ARTIKALA NASAO SIFRU "
                  @ 17,37 SAY wdmpart PICTURE "9999999999999"
                  wait " "
                  @ 17,2 SAY repli(" ",60)
              ENDIF
              select 1
              delete
              SKIP
           ENDDO
           pack
           select 4
       *   use rashod index rashink,rashind
           use rashodn index rashinkn,rashindn
           seek wdmpbro
              IF Found()
                 delete
                 pack
              else
                 @ 20,0 SAY "NISAM NASAO KALKULACIJU U DATOTECI PRIHOD - RASHOD !  ZVATI DARKA 8720036"
                 WAIT " "
              ENDIF
           DO BKN
           * brisanje u trgovackoj knjizi
           select 5
           use trg index trgkal,tinor
           seek wdmpbro
              IF Found()
                 delete
                 pack
              else
                 @ 20,0 SAY "NISAM NASAO KALKULACIJU U TRGOVACKOJ KNJIZI !  ZVATI DARKA 8720036"
                 WAIT " "
              ENDIF
        ENDIF
     ENDDO
 *
     close databases
     *release al
     CLEAR SCREEN
     return
