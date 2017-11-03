* - nije pregledano - *

kom = "PageDN tipka za prelazak na novu sifru bez upisa tekuce"
indik = 2

SELECT 1
USE POPDAT INDEX POPINART,POPINDAT
GO BOTTOM
wpopproc = 0
IF Eof()
  r = 1
ELSE
  r = popbroj
  r = r + 1
ENDIF

SELECT 2
USE ARTPANE INDEX APINSIF

DO WHILE .T.
   CLEAR SCREEN
   DO esck
   wpopdat = ctod("  .  .  ")
   wart = 0
   wpopniv = 0
   STORE 0 TO wpopst,wpopsc,wpopnc
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

   SELECT 1
   SET ORDER TO 2
   kljuc = str(wpopbroj) + dtos(wpopdat)
   SEEK kljuc
   IF Found()
      @ 8,30 SAY "***  NASTAVAK POPISA ****"
   ENDIF

   SET ORDER TO 1
   SELECT 2
   GO TOP
   KKK = 0
   pop = 0
   IF popmod = 1
      dn = " "
      @ 5,10 SAY "Da li zelite povecanje cena SVIH artikala za ISTI  % ? " GET dn PICTURE "!" VALID (dn $ "DN+")
      READ
      IF Lastkey() = 27
         LOOP
      ENDIF
      IF dn = "N"
         pop = 0
      ELSE
         @ 7,10 SAY "Procenat : " GET wpopproc PICTURE "9999.99" VALID ! Empty(wpopproc)
         READ
         IF Lastkey() = 27
            LOOP
         ENDIF
         pop = 1
      ENDIF
   ENDIF
   DO WHILE .T.
      in = 0
      IF popmod = 1
         IF pop = 1
            SELECT 2
            DO WHILE ! Eof()
               SELECT 1
               APPEND BLANK
               replace popproc with wpopproc
               replace popniv with wpopniv
               replace popbroj with wpopbroj
               replace popdat with wpopdat
               replace popart with B->artsif
               replace popsc with B->artcen
               replace popst with B->artkol
               replace popnc with round(B->artcen + (wpopproc / 100) * B->artcen,2)
               replace popindik with indik
               SELECT 2
               SKIP
            ENDDO
            CLOSE DATABASES
            RETURN
         ENDIF
         kom = Space(60)
         SELECT 2
         KKK = 1
         IF Eof()
            EXIT
         ENDIF
         wpopart = artsif
         wpopnaz = artnaz
         wpopjm = artjm
         wpopst = artkol
         kljuc = str(wpopbroj) + dtos(wpopdat) + str(wpopart)
         SELECT 1
         SEEK kljuc
         IF Found()
            select 2
            SKIP
            LOOP
         ENDIF
         SELECT 2
      ELSE
         wpopart = val("0000000000000")
         @ 13,10 SAY "Sifra artikla:" GET wpopart PICTURE "9999999999999" VALID ! Empty(wpopart)
         READ
         IF Lastkey() = 27
            in = 1
            EXIT
         ENDIF
         SEEK wpopart
         IF ! Found()
            @ 22,1 SAY "Ne postoji artikal sa tom sifrom !!"
            ? " "
            wait poruka
            @ 22,0 SAY Space(80)
            @ 24,0 SAY Space(80)
            LOOP
         ENDIF

         SELECT 1
         kljuc = str(wpopbroj) + dtos(wpopdat) + str(wpopart)
         ocisti()
         SEEK kljuc
         IF Found()
            @ 19,10 SAY "VEC STE UNELI OVAJ ARTIKAL PO OVOM POPISU !"
            ? " "
            WAIT poruka
            @ 19,1 SAY Space(79)
            @ 21,0 SAY Space(80)
            SELECT 2
            LOOP
         ENDIF

         SELECT 2
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
      wpopnaz = artnaz
      wpopsc = artcen
      wpopst = artkol
      wpopjm = artjm

      @ 12,8 to 20,75
      @ 13,10 SAY "Sifra artikla:"
      @ 13,25 SAY  wpopart
      @ 13,42 SAY wpopnaz
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
         SELECT 2
         SKIP
         @ 13,42 SAY Space(32)
         @ 13,25 SAY Space(40)
         @ 15,25 SAY "             .  "
         @ 17,25 SAY "           .   "
         @ 17,43 SAY Space(20)
         CLEAR GETS
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
      ELSE
         @ 19,10 SAY "Nova cena    :" GET wpopnc PICTURE "999999999999.99"
         READ
         IF Lastkey() = 27
            in = 1
            EXIT
         ENDIF
         IF Lastkey() = 3
            SELECT 2
            SKIP
            @ 13,42 SAY Space(32)
            @ 13,25 SAY Space(40)
            @ 17,43 SAY Space(20)
            CLEAR GETS
            LOOP
         ENDIF

         IF ! Lastkey() = 13
            ocisti()
            LOOP
         ENDIF
   
         IF wpopnc = 0
            @ 19,41 SAY "Procenat povecanja :" GET wpopproc PICTURE "9999.99"
            READ
            IF Lastkey() = 27
               in = 1
               EXIT
            ENDIF
            IF Lastkey() = 3
               CLEAR GETS
               @ 13,42 SAY Space(32)
               @ 13,25 SAY Space(40)
               @ 17,43 SAY Space(20)
               @ 19,40 SAY Space(32)
               SELECT 2
               SKIP
               LOOP
            ENDIF
            IF ! Lastkey() = 13
               ocisti()
               LOOP
            ENDIF
            wpopnc = wpopsc + (wpopproc / 100) * wpopsc
            @ 19,25 GET wpopnc PICTURE "999999999999.99"
            CLEAR GETS
         ENDIF
         dn = " "
      ENDIF

      @ 23,35 SAY "Upis ? " GET dn PICTURE "!" VALID (dn $ "DN+")
      READ
      IF Lastkey() = 27 .OR. dn = "N"
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

      SELECT 1
      APPEND BLANK
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

      SELECT 2

      SKIP
   ENDDO
   IF in = 1
      in = 0
      LOOP
   ENDIF
   CLEAR SCREEN
ENDDO

CLOSE DATABASES
RETURN
