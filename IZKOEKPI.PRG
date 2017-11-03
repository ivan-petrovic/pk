* - nije pregledano - *
      IF ! FILE("KOEFKPC.DBF")
        CREATE RADNA
        STORE "POD       D8  " TO POLJE1
        STORE "PDO       D8  " TO POLJE2
        STORE "PTAR      C8  " TO POLJE3
        STORE "PSTOP     N6 2" TO POLJE4
        STORE "POSNOV    N172" TO POLJE5
        STORE "PPOR      N172" TO POLJE6
        FOR I = 1 TO 6
         STORE STR(I,1) TO BROJ
          STORE "POLJE" + BROJ TO P1
           APPEND BLANK
           REPLACE FIELD_NAME WITH SUBSTR(&P1,1,10)
           REPLACE FIELD_TYPE WITH SUBSTR(&P1,11,1)
           REPLACE FIELD_LEN WITH VAL(SUBSTR(&P1,12,2))
           REPLACE FIELD_DEC WITH VAL(SUBSTR(&P1,14,1))
        NEXT I
        CREATE KOEFKPC FROM RADNA
        INDEX ON PTAR TO KOEINKPC
        USE
        ERASE RADNA.DBF
    ELSE
       SELECT 0
       USE KOEFKPC INDEX KOEINKPC
       ZAP
       USE
    ENDIF
*
*
set date german
set confirm on
set delete on
select 0
use porezn
index on dtos(datk) to porind
close porezn
select 0
use porezn index porind
* odluka sve ili nista
* set filter to sk = 0
* go top
* kraj odluke sve ili nista
select 0
use kstalkpc
select 0
use koefkpc index koeinkpc
DO WHILE .t.       &&  main
   select porezn
   @ 0,0 clear
   zez = 0
   wprer = val("000.00")
   wuk = val("000000000000.00")
   wukpor = val("000000000000.00")
   wod = ctod("  .  .  ")
   wdo = ctod("  .  .  ")
   @ 2,20 SAY "IZRACUNAVANJE KOEFICIJENATA"
   @ 10,10 SAY "OD DATUMA" GET wod
   @ 10,30 SAY "DO DATUMA" GET wdo VALID(wod <= wdo)
   READ
   IF Lastkey() = 27
      EXIT
   ENDIF
   set softseek on
   seek wod
   IF Eof() .or. datk > wdo
      @ 20,20 SAY "NISAM NASAO STAVKE U KNJIZI POREZA ZA TAJ PERIOD"
      wait " "
      set softseek off
      LOOP
   ENDIF
   set softseek off
*  izdvajam tarife i njihove osnovice
   DO WHILE datk <= wdo
      select koefkpc
      do case
         * slucaj vise stope za kafa,pice,cigarete
         case porezn->visakpc <> 0
              seek "1/261   "
              IF Found()
                 replace posnov with round(posnov + porezn->visakpc,2)
              else
                 append blank
                 replace pod with wod
                 replace pdo with wdo
                 replace ptar with "1/261   "
                replace pstop with 26
               *  replace pstop with 25
                 replace posnov with porezn->visakpc
              ENDIF
         * kraj slucaja vise stope za kafa,pice,cigarete
         * slucaj vise stope
      *  case porezn->visa <> 0
      *       seek "1/26    "
      *       IF Found()
      *          replace posnov with round(posnov + porezn->visa,2)
      *       else
      *          append blank
      *          replace pod with wod
      *          replace pdo with wdo
      *          replace ptar with "1/26    "
      *          replace pstop with 26
      *          replace posnov with porezn->visa
      *       ENDIF
         * kraj slucaja vise stope
         * slucaj nize stope
      *   case porezn->niza <> 0
      *        seek "2/9     "
      *        IF Found()
      *           replace posnov with round(posnov + porezn->niza,2)
      *        else
      *           append blank
      *           replace pod with wod
      *           replace pdo with wdo
      *           replace ptar with "2/9     "
      *           replace pstop with 9
      *           replace posnov with porezn->niza
      *        ENDIF
         * kraj slucaja nize stope
         * slucaj nula stope
      *   case porezn->visa <> 0
      *        seek "0/0     "
      *        IF Found()
      *           replace posnov with round(posnov + porezn->nula,2)
      *        else
      *           append blank
      *           replace pod with wod
      *           replace pdo with wdo
      *           replace ptar with "0/0     "
      *           replace pstop with 0
      *           replace posnov with porezn->nula
      *        ENDIF
         * kraj slucaja nula stope
      endcase
*    wuk = round(wuk + porezn->visakpc + porezn->visa+ porezn->niza+ porezn->nula,2)   && sve sabrano u osnovicu
     wuk = round(wuk + porezn->vrrobe,2)
      select porezn
      SKIP
      IF Eof()
         EXIT
      ENDIF
   ENDDO
*   zavrsio izdvajanje tarifa i osnovica
*   izracunavanje pripadajucih poreza ,zbirne osnovice i zbirnog poreza
   select koefKpC
   go top
   DO WHILE ! Eof()
      wprer = round((100 * pstop) / (100 + pstop),2)
      replace ppor with round(posnov * wprer / 100,2)
    * wuk = round(wuk + posnov,2)
      wukpor = round(wukpor + ppor,2)
      wprer = 0
      SKIP
   ENDDO
*   zavrsio izracunavanje poreza i zbirova
*   izracunavanje koeficijenata i punjenje datoteke koeficijenata
    select koefkpc
    go top
    DO WHILE ! Eof()
       IF ! ptar = "1/231   "
          SKIP
          LOOP
       ENDIF
       select kstalkpc
       append blank
       replace kod with koefkpc->pod
       replace kdo with koefkpc->pdo
       replace ktar with koefkpc->ptar
       replace kosn with koefkpc->posnov
       replace kpor with koefkpc->ppor
       replace kkoef with round(kpor * 100 / wuk,6)
       replace kjkoef with round(wukpor * 100 / wuk,6)
       select koefkpc
       SKIP
    ENDDO
* zavrsio izracunavanje i pakovanje koeficijenata
   EXIT
ENDDO
* zatvaram datoteke
set filter to
select kstalkpc
use
select porezn
use
select koefkpc
use
@ 0,0 clear
return
