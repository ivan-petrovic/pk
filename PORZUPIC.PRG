* - nije pregledano - *
****** upit poreza po tarifi - zbirno  za odredjeni period ******
set date german
set wrap on
   select 1
   use porezpic index porpickt   && inkt
   DO WHILE .t.
      CLEAR SCREEN
      wtar = Space(8)
      store 0 to wstop,wosn,wpor,woddob,wzakup,wraz,wzel,wbzel
      store 0 to ratpor
      indik = 0
      @ 1,0 SAY "ESC - izlaz"
      @ 1,60 SAY "Datum:"
      ?? date()
      wd1 = ctod("  .  .  ")
      wd2 = ctod("  .  .  ")
      silik = " "
      mNivo = " "
      mNivo1 = "  "
      pok = val("0")
      zez = val("0")
      @ 1,30 SAY "UPIT POREZA - ZBIRNO"
      @ 3,5 SAY "Nivo Prodavnice: " GET mNivo VALID ! Empty(mNivo)
*     @ 3,40 SAY "STR ili KOMISION    S/K" GET silik PICTURE "!" VALID(silik $ "SsKk")
      READ
      IF Lastkey() = 27
         EXIT
      ENDIF
*     IF silik = "S"
*        pok = 1
*     else
*        pok = 2
*     ENDIF
      @ 5,5 SAY "Od datuma:     " GET wd1 VALID ! Empty(wd1)
      @ 7,5 SAY "Do datuma:     " GET wd2 VALID (! wd1 > wd2 .and. ! Empty(wd2))
      READ
      IF Lastkey() = 27
         EXIT
      ENDIF
      mNivo1 = "/" + mNivo
      *select 1
      * ovde izvrsiti filtriranje
     IF mNivo # "1"
        SET FILTER TO right(alltrim(kal),2) = mNivo1
        GO TOP
     else
        SET FILTER TO right(alltrim(kal),2) # "/2" .and. right(alltrim(kal),2) # "/3" .and. right(alltrim(kal),2) # "/4"
        GO TOP
     ENDIF
      * kraj filtriranja
      *go top
      DO WHILE ! Eof()
 *      IF ! wtar = tar 
 *        SKIP
 *        LOOP
 *      ENDIF
 *   IF oddob = 0
 *      zez = zez + 0
 *   else
 *      IF ! oddob = pok
 *         SKIP
 *         LOOP
 *      ENDIF
 *   ENDIF
        IF dat > wd2
           SKIP
           LOOP
        ENDIF
        IF dat < wd1
           SKIP
           LOOP
        ENDIF
        indik = 1
        wosn = wosn + osn
        wstop = stop
        wpor = wpor + por
        woddob = woddob + oddob
        wraz = wraz + raz
        wzakup = wzakup + zakup
        wzel = wzel + zel
        wbzel = wbzel + bzel
        SKIP
   ENDDO
   set filter to
   IF indik = 0
     @ 19,1 SAY "Nema podataka pod trazenim uslovima !"
     ? " "
     wait "Otkucajte neku tipku za dalje..."
     LOOP
   ENDIF
   @ 9,4 to 23,50
   @ 10,5 SAY "Osnovica        "
*  IF wosn < 0.5
*     wosn = 0
*  ENDIF
   @ 10,21 SAY wosn PICTURE "9,999,999,999,999.99"
   @ 12,5 SAY "Porez (bez pr.) "
*  IF wpor < 0.5
*     wpor = 0
*  ENDIF
   @ 12,21 SAY wpor PICTURE "9,999,999,999,999.99"
   @ 14,5 SAY "Od dobavljaca   "
*  IF woddob < 0.5
*    woddob = 0
*  ENDIF
 * woddob = 0
   @ 14,21 SAY woddob PICTURE "9,999,999,999,999.99"
   @ 16,5 SAY "Razlika         "
*  IF wraz < 0.5
*    wraz = 0
*  ENDIF
   @ 16,21 SAY wraz PICTURE "9,999,999,999,999.99"
   @ 18,5 SAY "Za kupca       "
*  IF wzakup < 0.5
*    wzakup = 0
*  ENDIF
   @ 18,21 SAY wzakup PICTURE "9,999,999,999,999.99"
   @ 20,5 SAY "Porez za uplatu:"
   @ 20,21 SAY wbzel PICTURE "9,999,999,999,999.99"
   @ 22,5 SAY "Za zeleznicu   "
*  IF wzel < 0.5
*    wzel = 0
*  ENDIF
   @ 22,21 SAY wzel PICTURE "9,999,999,999,999.99"
   @ 23,0 SAY " "
   wait "Otkucajte neku tipku za dalje..."
 ENDDO
*
 close databases
 *release al
 CLEAR SCREEN
 return

