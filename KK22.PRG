* - nije pregledano - *
*LOCAL ekran:=SAVESCREEN(0,0,24,79),kursor:=SETCURSOR(1)
@ 0,0 CLEAR
set date german

SETPRC(0,0)

SELECT 0
USE POREZN INDEX POREZND
DO WHILE .T.
   @ 0,0 clear
   GO TOP
  *
  * ESCKEY()
   DAT1 = DATE()   && -30
   DAT2 = DATE()
   WPRAZNO = VAL("00000000.00")
   wsif = val("0000000000000")
   wz1 = val("00000000.00")
   store wz1 to wz2,wz3,wz4,wz5,wz6,wz7,wz8,wz9,wz10,wz11,wz12    && wz9 je zbir nize 12 %
   wUKUPNO = VAL("000000000000.00")
*  @ 3,10 SAY "SIFRA ARTIKLA" GET wsif PICTURE "9999999999999"
*  READ
*  IF Lastkey() = 27
*     EXIT
*  ENDIF
*  kljuc = str(wsif) + dtos(ctod("  .  .  "))
*  set softseek on
*  seek kljuc
*  IF Eof() .or. ! wsif = sifart
*     MSG("NISAM USPEO DA NADJEM TAKAV ARTIKAL ! ",5)
*     LOOP
*  ENDIF
*  set softseek off
*  @ 3,25 SAY nazart
   @ 6,10 SAY "STAMPA KNJIGU POREZA  OD DATUMA" GET DAT1
   @ 6,57 SAY "DO DATUMA" GET DAT2
   READ
*
   IF Lastkey() = 27
      EXIT
   ENDIF

   SET CONSOLE OFF
   SET DEVICE TO PRINT
   SET PRINT TO Lpt1
   *SET PRINT TO LISTA
   SET PRINT ON
   IF lLaser
      ? Chr(27) + '(s17.5H'      && kondenz On za laserski
   ELSE
      ? Chr(15)                  && kondenz On za matricni
   ENDIF

   brst=1
   LeviNa1()    && slov1()
   LevoZa1()     && glavlje1()
   DO WHILE ! Eof()    && WSIF = SIFART
      IF DTOS(DATK) >= DTOS(DAT1) .AND. DTOS(DATK) <= DTOS(DAT2)
         IF PROW() = 62
            IF !brst=0
               LeviFu1()  && ter1()
               EJECT
            ENDIF
            brst = brst + 1
            LevoZa1()   && glavlje1()
         ENDIF
         LeviTe1()   && kst1()
          wz1 = round(wz1 + taks,2)
          wz2 = round(wz2 + visakpc,2)
          wz3 = round(wz3 + visa,2)
          wz4 = round(wz4 + niza,2)
          wz5 = round(wz5 + nula,2)
          wz9 = round(wz9 + nula06,2)
      ENDIF
      SKIP
   ENDDO
   LeviFu1()  && ter1()
*     ubaceno za stampu zbira
 ? " "+"        "  &&  DTOC(DATK)
?? " "+"    "  && STR(RBPK1,4,0)
?? " "+"                      "  && SUBSTR(BROJ,1,7) +" "+SUBSTR(OPIS,1,12)
?? " "+STR(WZ1,11,2)
?? " "+STR(WPRAZNO,11,2)
?? " "+STR(WZ2,11,2)
?? " "+STR(WPRAZNO,11,2)
?? " "+STR(WZ9,11,2)
?? " "+STR(WPRAZNO,11,2)
?? " "+STR(WZ4,11,2)
?? " "+STR(WZ5,11,2)

*     kraj stampe zbira
   EJECT
  * kljuc = str(wsif) + dtos(ctod("  .  .  "))
  * set softseek on
  * seek kljuc
  * IF Eof() .or. ! wsif = sifart
  *    MSG("NISAM USPEO DA NADJEM TAKAV ARTIKAL ! ",5)
  *    LOOP
  * ENDIF
  * set softseek off
  *
    brst=1
   DesniN1()   && aslov1()
   DesnoZ1()   && **aglavlje1()
   GO TOP
   DO WHILE ! Eof()   && WSIF = SIFART
      IF DTOS(DATK) >= DTOS(DAT1) .AND. DTOS(DATK) <= DTOS(DAT2)
         IF PROW() = 62
            IF !brst=0
               DesniF1()  && uter1()
               EJECT
            ENDIF
            brst = brst + 1
            DesnoZ1()  && aglavlje1()
         ENDIF
       * DesniTekst()
          wz6 = round(wz6 + vrrobe,2)
          wz7 = round(wz7 + pazar,2)
          wz8 = round(wz8 + zalihe,2)
          wz9 = round(wz9 + nula06,2)
          wz10 = round(wz10 + nula2,2)
          wz11 = round(wz11 + nula4,2)
          wz12 = round(wz12 + nIZA1,2)
         DesniT1()   &&  ekst1()
      ENDIF
      SKIP
   ENDDO
   DesniF1()   &&  uter1()
* STAMPA ZBIROVA
 ? " "+ STR(WZ6,11,2)
?? " "+ STR(WZ7,11,2)
*?? "³"+ STR(ZALIHE,11,2)+"³"
?? " "+ STR((WZ6 - WZ7),11,2)
?? " " +STR(WZ3,11,2)
?? " " +STR(WZ10,11,2)
?? " " +STR(WZ11,11,2)
?? " " +STR(WZ12,11,2)
* KRAJ STAMPE ZBIROVA
   IF lLaser
      ? Chr(27) + '&k0S' + Chr(27) + '(s10.5H'  && kondenz Off za laserski
   ELSE
      ? Chr(18)                                 && kondenz Off za matricni
   ENDIF
   EJECT
   SET PRINTER OFF
   set print to
   SET DEVICE TO SCREEN
   SET CONSOLE ON
ENDDO

USE
RETURN

***************************
PROC LeviNa1  && aslov1
? "                                          KNJIGA  P O R E Z A    OD  "  + DTOC(DAT1) + "  DO  " + DTOC(DAT2)
? "Poreski obveznik: "+ gcPrez_Ime   && vlasnik
? "Mesto: "+RTRIM(gcMesto)+" "+ gcAdresa
? "Naziv radnje   : " + gcNazRad
RETURN


****************************
PROC LevoZa1   && aglavlje1
? "                                                                                                                         strana " + str(brst,3,0)
? "ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿"
? "³          ³    ³                    ³           ³  PRODAJNA VREDNOST SA P.P. (OSNOVICA ZA OBRACUN POREZA)               ³           ³"
? "³          ³redn³                    ³           ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´prodajna   ³"
? "³          ³ br ³                    ³           ³    OPSTA STOPA        ³     OPSTA STOPA       ³      NIZA STOPA       ³vrednost   ³"
? "³ datum    ³ iz ³    O P I S         ³           ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´                       ³bez        ³"
? "³          ³posl³                    ³ Posebna   ³duvan,prer.alk.pica.kaf³   ostali proizvodi    ³                       ³ukalkulis. ³"
? "³          ³ovne³(naziv,broj i datum ³           ÃÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ´   p.p.    ³"
? "³knjize    ³knji³   za knjizenje)    ³ taksa     ³ propisana ³preracunata³ propisana ³preracunata³ propisana ³preracunata³           ³"
? "³  nja     ³ge  ³                    ³           ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄ´(oslobodje ³"
? "³          ³    ³                    ³           ³    20     ³  16.6667  ³    20     ³ 16.6667   ³           ³           ³  nja)     ³"
? "³          ³PK1 ³                    ³           ³           ³           ³           ³           ³           ³           ³           ³"
? "³          ³    ³                    ³           ³           ³           ³           ³           ³           ³           ³           ³"
? "ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄ´"
? "³   1      ³ 2  ³         3          ³     4     ³           5           ³           5a          ³           6           ³     7     ³"
? "ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄ´"

RETURN
************ **** **********
PROC LeviTe1  && ekst1

 ? "³"+DTOC(DATK)
?? "³"+STR(RBPK1,4,0)
?? "³"+SUBSTR(BROJ,1,7) +" "+SUBSTR(OPIS,1,12)
?? "³"+STR(TAKS,11,2)
?? "³"+STR(WPRAZNO,11,2)
?? "³"+STR(VISAKPC,11,2)
?? "³"+STR(WPRAZNO,11,2)
?? "³"+STR(NULA06,11,2)
?? "³"+STR(WPRAZNO,11,2)
?? "³"+STR(NIZA,11,2)
?? "³"+STR(NULA,11,2)+"³"



RETURN
****************************8
PROC LeviFu1  && uter1

? "ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÙ"

RETURN



******************************
PROC DesniN1   && aslov1
? "   "   &&
? "   "   &&                                                   Obrazac KRMZ "
? "   "   &&                                                    strana "+str(brst,2,0)
? "   "   &&                Naziv materijala: "+ ALLTRIM(nazart)
RETURN

******************************
PROC DesnoZ1  &&  aglavlje1
? "                         strana "+str(brst,3,0)
? "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿"
? "³                       ³           ³           ³           ³           ³           ³"
? "³    U K U P N O        ³           ³           ³           ³           ³           ³"
? "ÃÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ´           ³ S t o p a ³ S t o p a ³ S t o p a ³ S t o p a ³"
? "³prodajna   ³ vrednost  ³           ³           ³           ³           ³           ³"
? "³vrednost   ³ prodate   ³           ³           ³           ³           ³           ³"
? "³nabavljene ³  robe     ³  Stanje   ³           ³           ³           ³           ³"
? "³robe sa    ³   sa      ³           ³           ³           ³           ³           ³"
? "³porezom na ³porezom na ³           ³           ³           ³           ³           ³"
? "³promet     ³  promet   ³  zaliha   ³           ³           ³           ³           ³"
? "³           ³           ³           ³           ³           ³           ³           ³"
? "³(5+6+7)    ³ (pazar)   ³           ³           ³           ³           ³           ³"
? "ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄ´"
? "³    8      ³     9     ³    10     ³    11     ³    12     ³    13     ³    14     ³"
? "ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄ´"

RETURN

*******************************
PROC DesniF1  &&  **uter1

? "ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÙ"

RETURN

******************************
PROC DesniT1   && ekst1

 ? "³"+ STR(VRROBE,11,2)
?? "³"+ STR(PAZAR,11,2)
*?? "³"+ STR(ZALIHE,11,2)+"³"
?? "³"+ STR((WZ6 - WZ7),11,2)    &&  +"³"

*?? "³"+ STR((NULA06),11,2)  &&  +"³"
*?? "³"+ STR((NULA2),11,2)  &&  +"³"
*?? "³"+ STR((NULA4),11,2) && +"³"
*?? "³"+ STR((NIZA1),11,2) +"³"

RETURN


