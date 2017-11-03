* Upit poreza po tarifi - zbirno  za odredjeni period
SELECT 1
USE POREZPIC INDEX PORPICKT

DO WHILE .T.
   wtar = Space(8)
   mNivo = " "
   mNivo1 = "  "
   store 0 to wstop,wosn,wpor,woddob,wzakup,wraz,wzel,wbzel
   indik = 0
   wd1 = ctod("  .  .  ")
   wd2 = ctod("  .  .  ")
   prer = val("00.00")

   MainMask("Upit poreza po tarifi - zbirno  za odredjeni period")
   @ 3,05 SAY "Tarifa:        " GET wtar VALID ! Empty(wtar)
   @ 3,40 SAY "Nivo Prodavnice: " GET mNivo VALID ! Empty(mNivo)
   READ
   IF Lastkey() = 27
      EXIT
   ENDIF
   mNivo1 = "/" + mNivo

   @ 5,5 SAY "Od datuma:     " GET wd1 VALID ! Empty(wd1)
   @ 7,5 SAY "Do datuma:     " GET wd2 VALID (! wd1 > wd2 .and. ! Empty(wd2))
   READ
   IF Lastkey() = 27
      LOOP
   ENDIF

   * ovde selectovati po nivou prodavnice
   IF mNivo # "1"
      SET FILTER TO right(alltrim(kal),2) = mNivo1
      GO TOP
   ELSE
      SET FILTER TO right(alltrim(kal),2) # "/2" .and. right(alltrim(kal),2) # "/3" .and. right(alltrim(kal),2) # "/4"
      GO TOP
   ENDIF
   GO TOP
   * kraj selectovanja

   DO WHILE ! Eof()
      IF ! wtar = tar
         SKIP
         LOOP
      ENDIF
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

   SET FILTER TO
   IF indik = 0
      @ 19,1 SAY "Nema podataka pod trazenim uslovima !"
      ? " "
      WAIT "Otkucajte neku tipku za dalje..."
      LOOP
   ENDIF

   @ 9,4 to 23,50
   @ 10,5 SAY "Osnovica        "
   @ 10,21 SAY wosn PICTURE "9,999,999,999,999.99"
   @ 12,5 SAY "Ukupan porez    "
   prer = round((wstop * 100) / (wstop + 100),2)
   @ 12,21 SAY wpor PICTURE "9,999,999,999,999.99"
   @ 14,5 SAY "Od dobavljaca   "
   IF woddob < 0.5
      woddob = 0
   ENDIF
   @ 14,21 SAY woddob PICTURE "9,999,999,999,999.99"
   @ 16,5 SAY "Razlika         "
   IF wraz < 0.5
      wraz = 0
   ENDIF
   @ 16,21 SAY wraz PICTURE "9,999,999,999,999.99"
   @ 18,5 SAY "Za kupca       "
   IF wzakup < 0.5
      wzakup = 0
   ENDIF
   @ 18,21 SAY wzakup PICTURE "9,999,999,999,999.99"
   @ 20,5 SAY "Porez bez zelez:"
   @ 20,21 SAY wbzel PICTURE "9,999,999,999,999.99"
   @ 22,5 SAY "Za zeleznicu   "
   @ 22,21 SAY wzel PICTURE "9,999,999,999,999.99"
   @ 23,0 SAY " "
   WAIT "Otkucajte neku tipku za dalje..."
ENDDO

CLOSE DATABASES
RETURN
