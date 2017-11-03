* - nije pregledano - *
set date german
set  confirm on
kom = "PageDN  tipka za prelazak na novu sifru bez upisa tekuce"
indik = 2
starbod = val("0000000000.00")
novbod = val("0000000000.00")
*select 3
*use cndat 
*index on cnart to cninsif
*use
* select 3
* use bod index bodind
* go bottom
* novbod = bodic
* SKIP -1
* starbod = bodic
novbod = gnBod
starbod = gnBod

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
use artpane index apinsif
DO WHILE .t.
   CLEAR SCREEN
   do esck
   wpopdat = ctod("  .  .  ")
   wart = 0
   store 0 to wpopst,wpopsc,wpopnc
   wartnaz = Space(30)
   wartjm = Space(3)
   wtar = Space(8)
   wfak = val("0000.0000000")
   in = 0
   wpopbroj  = r
   @ 1,30 SAY "UNOS POPISA"
   @ 10,10 SAY "Datum popisa:" GET wpopdat VALID ! Empty(wpopdat)
   @ 10,50 SAY "Broj popisa: " GET wpopbroj PICTURE "9999999999" VALID ! Empty(wpopbroj)
   @ 12,10 SAY "Tarifa :" GET wtar VALID ! Empty(wtar)
   @ 14,10 SAY "Korektivni faktor :" GET wfak PICTURE "9999.9999999" 
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
*  IF popmod = 1
*     dn = " "
*     @ 5,10 SAY "Da li zelite povecanje cena SVIH artikala  ? " GET dn PICTURE "!" VALID (dn $ "DN")
*     READ
*     IF Lastkey() = 27
*        LOOP
*     ENDIF
*     IF dn = "N"
*        pop = 0
*        do komnive2
*        CLEAR SCREEN
*        close databases
*        return
*     ENDIF
*     else
*        @ 7,10 SAY "Procenat : " GET wpopproc PICTURE "9999.99" VALID ! Empty(wpopproc)
*        READ
*        IF Lastkey() = 27
*           LOOP
*        ENDIF
*        pop = 1
*     ENDIF
*   ENDIF
   DO WHILE .t.
          KKK = 1
          IF Eof()
            in = 1
            EXIT
          ENDIF
          IF ! arttar = wtar
             SKIP
             LOOP
          ENDIF
          wpopart = artsif 
          wpopnaz = artnaz   
          wpopjm = artjm   
          wpopniv = 1
          wpopst = artkol
          popindik = 1
          wpopsc = artcen   && * starbod
          wpopnc = round(artcen * wfak,2)
          wpopproc = 0
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
       select 2
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