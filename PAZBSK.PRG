* - nije pregledano - *
SET DATE GERMAN
set delete on
SET CONFIRM ON
set proc to funkcije
*USE PAZDAT && INDEX PAZINDAT
*index on dtos(pazdat) + str(pazart) to pazinda
*use
select 1
use pazdat index pazinda,pazindat
*select 2
*use artpane index apinsif
*select 3
*use revers index revart
select 3
use rashodn index rashindn,rashinkn
select 4
use porezn index poreznd,poreznb,poreznbb
select 5
use pritar index pritin,pritsd,dddin
pakuj = 0
brsk = 0   && 0 brise str , 1 brise komision
DO WHILE .T.      && glavna petlja
   select 1
   CLEAR SCREEN
   ESCKEY()
   ind = 0
   DN = " "
   ska = " "
   WART = VAL("0000000000000")
   mPorez = VAL("0000000000.00")
   mPrih2 = VAL("0000000000.00")
  * WART = Space(13)
   WDAT = DATE()
   @ 8,10 SAY "STR / KOMISION" GET ska PICTURE "!" VALID(ska $ "SsKk")
   @ 10,10 SAY "UNESITE DATUM PAZARA KOJI BRISETE" GET WDAT
   @ 12,10 SAY "UNESITE SIFRU ARTIKLA            " GET WART PICTURE "9999999999999" VALID ! Empty(wart)   &&  PICTURE "9999999999999"
   READ
   IF Lastkey() = 27
      EXIT
   ENDIF
   IF ska = "S"
      select 2
      use artpane index apinsif
   else
      select 2
      use revers index revart
   ENDIF
   select 1
   KLJUC = DTOS(WDAT) + STR(WART)
   SEEK KLJUC
   IF ! Found()
      @ 20,20 SAY "TOGA DANA NISTE PRODALI TAJ ARTIKAL"
      WAIT " "
      @ 20,20 SAY REPLI(" ",58)
     * SELECT 2
     * USE
     * LOOP
     EXIT
   ENDIF
   select 2
   seek wart
   IF Found()
     IF ska = "S"
        wnaz = artnaz
        wtar = arttar
     else
        wnaz = rnaz
        wtar = rtar
     ENDIF
   else
     @ 20,10 SAY "NEPOZNAT ARTIKAL.VEROVATNO JE U PITANJU KOMISION, A SIFRA STR_a"
     @ 21,10 SAY "ILI OBRNUTO !"
     wait " "
     ind = 1
    * select 2
    * use
    * LOOP
      EXIT
   ENDIF
   select 1
   CLEAR SCREEN
   @ 10,2 SAY "sif.artikla          naziv  artikla      prodato      cena      ukupno"
  * @ 12,2 SAY pazart PICTURE "9999999999999"
   @ 12,2 SAY pazart
   @ 12,16 SAY wnaz
   @ 12,47 SAY pazkol PICTURE "999.99"
   @ 12,54 SAY pazcdin PICTURE "9,999.99"
   @ 12,63 SAY round(pazkol * pazcdin,2) PICTURE "999,999,999.99"
   @ 20,10 SAY "BRISANJE OVE STAVKE   D/N  " GET DN PICTURE "!" VALID(dn $ "DdNn")
   READ
   IF Lastkey() = 27
      EXIT
   ENDIF
   IF dn = "N"
     * select 2
     * use
     * LOOP
     EXIT
   ENDIF
   select 2     && da vratim na stanje
   IF ind = 0
      IF ska = "S"
        replace artkol with (artkol + A->pazkol)
      else
        replace rkol with (rkol + A->pazkol)
      ENDIF
   ENDIF      && kraj vratio na stanje
   ***********  NAJVAZNIJI DEO BRISANJE IZ PRITARA
   select 5
   kljuc1 = dtos(wdat) + wtar
   seek kljuc1
   IF Found()  && nasao taj datum i tarifu
     DO WHILE wdat = dph .and. tph = wtar
        IF ska = "S".and. sk1 = 0 .and. z1 = A->pazkol * A->pazcdin 
           delete
           EXIT
        ENDIF
        IF ska = "K" .and. sk1 = 1 .and. z1 = A->pazkol * A->pazcdin
           delete
           EXIT
        ENDIF
        SKIP
     ENDDO
   else        && nije nasao odgovarajucu stavku u pritar_u
      @ 18,1 SAY "U PRITAR DATOTECI NEMA ARTIKLA"
      @ 18,33 SAY wart PICTURE "9999999999999"
      @ 18,50 SAY "ENTER za nastavak"
      wait " "
      @ 18,1 SAY repli(" ",78)
   ENDIF
*************************************************
 IF ska = "S"
    brsk = 0
 else
    brsk = 1
 ENDIF
* umanjenje pazara za obrisani deo u rashodima
* pocetak
 select 3
 seek dtos(wdat)
 IF Found()
    DO WHILE wdat = rdk
       IF rsvep <> 0 .and. brsk = Rsk .and. rpbez06 <> 0  && nasao stavku
          replace rsvep with round(rsvep - A->pazkol * A->pazcdin ,2)
          IF rsk = 0
             replace rpbez06 with round(rpbez06 - A->pazkol * A->pazcdin,2)
          else
             mPorez = round(A->pazcdin * 16.67 / 100,2)
             mPrih2 = round((A->pazcdin - mPorez) * 0.2 * A->pazkol,2)
             replace rpbez06 with round(rpbez06 - (A->pazkol * A->pazcdin - mPrih2),2)
             replace rusp with round(rusp - mPrih2 ,2)
          ENDIF
          EXIT
       ENDIF
       SKIP
    ENDDO
 ENDIF
* kraj
* umanjenje pazara za obrisani deo u porezima
* pocetak
 select 4
 seek wdat
 IF Found()
    DO WHILE wdat = datk
       IF pazar <> 0
          replace pazar with round(pazar - A->pazkol * A->pazcdin,2)
          EXIT
       ENDIF
       SKIP
    ENDDO
 ENDIF
* kraj
*************************************************
* zatvara select 2 jer ce mozda promeniti str - komision
 * select 2
 * use
* kraj od zatvaranja select 2
  select 1
  delete
  EXIT
ENDDO  && glavna petlja
select 1
PACK
select 5
pack
IF pakuj = 1
   select 4
   pack
   select 3
   pack
ENDIF
close databases
RELEASE ALL
CLEAR SCREEN
RETURN

