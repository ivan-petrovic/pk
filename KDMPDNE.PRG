* - nije pregledano - *
      set date german
      set confirm on
      store 0 to indik,indik1,indik2
      por = "Otkucajte neku tipku za dalje..."
   *  use dmpdat
   *  index on val(rtrim(dmpbro)) to dmpinbk
   *  use
      select 1
      use dmpdat index dmpinbro
      select 2
      use ppdat index ppinsif
      select 1
      DO WHILE .t.
          set filter to
          CLEAR SCREEN
          do esck
          wd1 = ctod("00.00.00")
          wd2 = ctod("00.00.00")
          @ 1,30 SAY "DNEVNIK KALKULACIJA"
          @ 5,1 SAY "U periodu  od:" GET wd1
          @ 5,40 SAY "do:" GET wd2
          READ
          IF Lastkey() = 27
             EXIT
          ENDIF
          IF wd1 > wd2
            @ 19,1 SAY "Datum  -od-  veci od datuma  -do-"
            ? " "
            wait por
            LOOP
          ENDIF
          set filter to (! dmpdat < wd1) .and. (! dmpdat > wd2)
          go top
          IF Eof()
            @ 19,1 SAY "Nema kalkulacija u tom periodu !"
            ? " "
            wait por
            LOOP
          ENDIF
          red = 6
          DO WHILE ! Eof() 
             wdob = dmpdob
             select 2
             seek wdob
             IF ! Found()
                wnaz = Space(30)
             else
                wnaz = ppnaz
             ENDIF
             select 1
             IF indik = 0
                indik = 1
                wb = dmpbro
                wd = dmpdat
                wime = wnaz   
             ENDIF
             IF red = 6
                CLEAR SCREEN
                do esck
                @ 1,30 SAY "DNEVNIK KALKULACIJA"
                @ 3,1 SAY "OD:"    
                ?? wd1
                @ 3,40 SAY "DO:"     
                ?? wd2
                @ 4,0 SAY Replicate("*",79)
                @ 5,1 SAY "BROJ KALK."
                @ 5,20 SAY "DATUM KALK."
                @ 5,50 SAY "DOBAVLJAC"
                @ 6,0 SAY Replicate("*",79)
             ENDIF
             IF ! wb = dmpbro
               red = red + 1
               @ red,1 SAY wb     
               @ red,18 SAY wd    
               @ red,40 SAY wime
               IF red > 15
                  red = 6
                  @ 19,1 SAY " "
                  WAIT POR
                  IF Lastkey() = 27
                     EXIT
                  ENDIF
               ENDIF
             ENDIF
               wb = dmpbro
               wd = dmpdat
               wime = wnaz   
               SKIP
          ENDDO
          red = red + 1
          @ red,1 SAY wb
          @ red,18 SAY wd
          @ red,40 SAY wime
          @ 19,1 SAY "Zavrseno listanje dnevnika"
          ? " "
          wait por
          set filter to
      ENDDO
 *
      close databases
 *    erase dmpinbk.ntx
      *release al
      CLEAR SCREEN
      return

