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
*?? "�"+ STR(ZALIHE,11,2)+"�"
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
? "������������������������������������������������������������������������������������������������������������������������������������Ŀ"
? "�          �    �                    �           �  PRODAJNA VREDNOST SA P.P. (OSNOVICA ZA OBRACUN POREZA)               �           �"
? "�          �redn�                    �           �����������������������������������������������������������������������Ĵprodajna   �"
? "�          � br �                    �           �    OPSTA STOPA        �     OPSTA STOPA       �      NIZA STOPA       �vrednost   �"
? "� datum    � iz �    O P I S         �           �����������������������������������������������Ĵ                       �bez        �"
? "�          �posl�                    � Posebna   �duvan,prer.alk.pica.kaf�   ostali proizvodi    �                       �ukalkulis. �"
? "�          �ovne�(naziv,broj i datum �           �����������������������������������������������������������������������Ĵ   p.p.    �"
? "�knjize    �knji�   za knjizenje)    � taksa     � propisana �preracunata� propisana �preracunata� propisana �preracunata�           �"
? "�  nja     �ge  �                    �           �����������������������������������������������������������������������Ĵ(oslobodje �"
? "�          �    �                    �           �    20     �  16.6667  �    20     � 16.6667   �           �           �  nja)     �"
? "�          �PK1 �                    �           �           �           �           �           �           �           �           �"
? "�          �    �                    �           �           �           �           �           �           �           �           �"
? "������������������������������������������������������������������������������������������������������������������������������������Ĵ"
? "�   1      � 2  �         3          �     4     �           5           �           5a          �           6           �     7     �"
? "������������������������������������������������������������������������������������������������������������������������������������Ĵ"

RETURN
************ **** **********
PROC LeviTe1  && ekst1

 ? "�"+DTOC(DATK)
?? "�"+STR(RBPK1,4,0)
?? "�"+SUBSTR(BROJ,1,7) +" "+SUBSTR(OPIS,1,12)
?? "�"+STR(TAKS,11,2)
?? "�"+STR(WPRAZNO,11,2)
?? "�"+STR(VISAKPC,11,2)
?? "�"+STR(WPRAZNO,11,2)
?? "�"+STR(NULA06,11,2)
?? "�"+STR(WPRAZNO,11,2)
?? "�"+STR(NIZA,11,2)
?? "�"+STR(NULA,11,2)+"�"



RETURN
****************************8
PROC LeviFu1  && uter1

? "��������������������������������������������������������������������������������������������������������������������������������������"

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
? "�����������������������������������������������������������������������������������Ŀ"
? "�                       �           �           �           �           �           �"
? "�    U K U P N O        �           �           �           �           �           �"
? "�����������������������Ĵ           � S t o p a � S t o p a � S t o p a � S t o p a �"
? "�prodajna   � vrednost  �           �           �           �           �           �"
? "�vrednost   � prodate   �           �           �           �           �           �"
? "�nabavljene �  robe     �  Stanje   �           �           �           �           �"
? "�robe sa    �   sa      �           �           �           �           �           �"
? "�porezom na �porezom na �           �           �           �           �           �"
? "�promet     �  promet   �  zaliha   �           �           �           �           �"
? "�           �           �           �           �           �           �           �"
? "�(5+6+7)    � (pazar)   �           �           �           �           �           �"
? "�����������������������������������������������������������������������������������Ĵ"
? "�    8      �     9     �    10     �    11     �    12     �    13     �    14     �"
? "�����������������������������������������������������������������������������������Ĵ"

RETURN

*******************************
PROC DesniF1  &&  **uter1

? "�������������������������������������������������������������������������������������"

RETURN

******************************
PROC DesniT1   && ekst1

 ? "�"+ STR(VRROBE,11,2)
?? "�"+ STR(PAZAR,11,2)
*?? "�"+ STR(ZALIHE,11,2)+"�"
?? "�"+ STR((WZ6 - WZ7),11,2)    &&  +"�"

*?? "�"+ STR((NULA06),11,2)  &&  +"�"
*?? "�"+ STR((NULA2),11,2)  &&  +"�"
*?? "�"+ STR((NULA4),11,2) && +"�"
*?? "�"+ STR((NIZA1),11,2) +"�"

RETURN


