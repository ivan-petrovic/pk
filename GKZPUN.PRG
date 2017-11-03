SELECT 0
USE GKZIRO
INDEX ON Str(BANK,3)+DtoS(BDIZ) TO GKZIPOM
CLOSE GKZIRO

SELECT 0
USE GKZIRO INDEX GKZIPOM, GKZINBB, GKZINPB

WRB = VAL("000")
WBDIZ = DATE()
V = 0
DN = " "
WOPIS = Space(30)
WDP = DATE()
WUPL = VAL("0000000.00")
WISPL = VAL("0000000.00")
WSALDO = VAL("0000000.00")
WWUPL = VAL("0000000.00")
WWISPL = VAL("0000000.00")
WWSALDO = VAL("0000000.00")
WZIRPP = VAL("000000")
WDMPDOB = VAL("000000")
WSIFBANK = VAL("000")
WZIRPPNAZ = Space(30)
windik = val("0")    && 0 placa se porez, 7 oslobodjeno, 9 oslobodjeno
mIzlaz = VAL("0")

CLEAR SCREEN
D = 1
DO WHILE D = 1

   @ 2,20 SAY "UNOS MATICNIH PODATAKA U KNJIGU ZIRO RACUNA"
   DO WHILE .T.
      @ 4,13 SAY "SIFRA BANKE             :" GET WSIFBANK;
             PICTURE "999" VALID PROVBANK(WSIFBANK)
      READ

      IF Lastkey() = 27
         mIzlaz = 1
         EXIT
      ENDIF

      * ovde uzeti saldo i sledeci broj naloga te banke
      SELECT GKZIRO
      GO TOP
      DO WHILE ! Eof()
         IF wsifbank = BANK
            wwsaldo = Round(wwsaldo + Round(upl - ispl,2),2)
            wrb = rb + 1
         ENDIF
         SKIP
      ENDDO
      * kraj uzimanja salda

      @ 19,13 SAY "STANJE NA ZIRO RACUNU   :"
      @ 19,39 SAY  WWSALDO PICTURE "9999999.99"
      EXIT
   ENDDO

   IF mIzlaz = 1
      EXIT
   ENDIF

   DO WHILE .T.      && OD UPISA STAVKE KADA JE PROSAO BANKU
      @ 6 ,13 SAY "RED.BROJ IZVODA         :" GET WRB PICTURE "999"
      @ 8 ,13 SAY "DATUM IZVODA            :" GET WBDIZ
      @ 10,13 SAY "OPIS                    :" GET WOPIS
      @ 12,13 SAY "POSLOVNI PARTNER        :" GET WDMPDOB;
              PICTURE "999999" VALID PROVDOBB(WDMPDOB)
      @ 14,13 SAY "       PROMET            "
      @ 16,13 SAY "UPLATA U KORIST RACUNA  :" GET WUPL PICTURE "9999999.99"
      @ 16,60 SAY "0 BEZ OZNAKE    "
      @ 17,13 SAY "ISPLATA NA TERET RACUNA :" GET WISPL PICTURE "9999999.99"
      @ 17,53 GET WSALDO PICTURE "9" VALID(WSALDO = 0 .OR. WSALDO = 1 .OR. WSALDO = 2)
      @ 17,60 SAY "1 PLACA SE PDV     "
      @ 18,60 SAY "2 PLACA SE PROVIZI."
      @ 19,13 SAY "STANJE NA ZIRO RACUNU   :"
      READ

      IF Lastkey() = 27
         V = 1
         EXIT
      ENDIF

      D = 0
      SELECT GKZIRO
      @ 23,24 SAY "UPIS   D/N?  " GET DN PICTURE "!" VALID(DN $ "DN")
      READ

      IF Lastkey() = 27
         V = 1
         EXIT
      ENDIF

      IF DN = "N"
         WDMPDOB = 0
         WUPL = 0
         WISPL = 0
         @ 12,48 SAY "                                "
         @ 23,24 SAY "                                        "
         @ 19,39 SAY  WWSALDO PICTURE "9999999.99"
         LOOP
      ENDIF

      APPEND BLANK
      REPLACE RB WITH WRB
      REPLACE BDIZ WITH WBDIZ
      REPLACE OPIS WITH WOPIS
      REPLACE UPL WITH WUPL
      REPLACE ISPL WITH WISPL
      REPLACE SALDO WITH WSALDO
      REPLACE BANK WITH WSIFBANK
      REPLACE PPIZVOD WITH WDMPDOB

      WWSALDO = round(wwsaldo + ROUND(WUPL - WISPL,2),2)
      WDMPDOB = 0
      WUPL = 0
      WISPL = 0
      @ 12,48 SAY "                                "
      @ 23,24 SAY "                                        "
      @ 19,39 SAY  WWSALDO PICTURE "9999999.99"
    ENDDO  && OD VRCENJA UPISA STAVKE

    IF V = 1
       EXIT
    ENDIF

ENDDO    && OD D

CLOSE DATABASES
RETURN

*******************************************************
FUNCTION ProvDobB(SifDob)
LOCAL SelSav:=SELECT(),buttons:={"  Novi  "," Lista  "}

#IFDEF PREDUZECE
   USE (ProgDir+"ppdat") INDEX (ProgDir+"ppinsif"),;
                               (ProgDir+"ppinnaz"),;
                               (ProgDir+"ppinmes"),;
                               (ProgDir+"ppinzir") NEW
#ELSE
   USE ppdat INDEX ppinsif,ppinnaz,ppinmes,ppinzir NEW
#ENDIF

IF (DBSEEK(SifDob))
   @ 12,48 SAY SUBSTR(ppnaz,1,30)
   CLOSE PpDat
   SELECT(SelSav)
   RETURN(.T.)
ELSE
   izb = al_box("Niste upisali sifru DOBAVLJACA",2,buttons,2,6,25,12,59)
   DO CASE
      CASE izb = 1
         IF (PPUnos1(1))
            @ 12,48 SAY SUBSTR(ppnaz,1,30)
            CLOSE PpDat
            SELECT(SelSav)
            RETURN(.T.)
         END IF
         CLOSE PpDat
         SELECT(SelSav)
         RETURN(.F.)
      CASE izb = 2
         IF (ListDobavljac())
            @ 12,48 SAY SUBSTR(ppnaz,1,30)
            CLOSE PpDat
            SELECT(SelSav)
            RETURN(.T.)
         END IF
         CLOSE PpDat
         SELECT(SelSav)
         RETURN(.F.)
      END CASE
END IF
***********************************************************

***********************************************************
FUNCTION ProvBank(Sifbank)
LOCAL SelSav:=SELECT(),buttons:={"  Novi  "," Lista  "}

#IFDEF PREDUZECE
   USE (ProgDir+"bankdat") INDEX (ProgDir+"binsif") NEW
#ELSE
   USE bankdat INDEX binsif NEW
#ENDIF

IF (DBSEEK(Sifbank))
   @ 04,46 SAY SUBSTR(nazbank,1,30)
   CLOSE BANKDAT
   SELECT(SelSav)
   RETURN(.T.)
ELSE
   izb = al_box("Niste upisali sifru BANKE",2,buttons,2,6,25,12,59)
   DO CASE
      CASE izb = 1
         IF (BANKUN1(1))
           @ 04,46 SAY SUBSTR(NAZBANK,1,30)
           CLOSE BANKDAT
           SELECT(SelSav)
           RETURN(.T.)
         END IF
         CLOSE BANKDAT
         SELECT(SelSav)
         RETURN(.F.)
      CASE izb = 2
         IF (ListBanke())
            @ 04,46 SAY SUBSTR(nazbank,1,30)
            CLOSE BANKDAT
            SELECT(SelSav)
            RETURN(.T.)
         END IF
         CLOSE BANKDAT
         SELECT(SelSav)
         RETURN(.F.)
   END CASE
END IF
***********************************************************
