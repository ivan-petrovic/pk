* - nije pregledano - *
*LOCAL ekran:=SAVESCREEN(0,0,24,79),kursor:=SETCURSOR(1)
@ 0,0 CLEAR
set date german

SELECT 0
USE GKZIRO INDEX GKzINDP
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
   @ 6,10 SAY "STAMPA PORESKE PRIJAVE  OD DATUMA" GET DAT1
   @ 6,57 SAY "DO DATUMA" GET DAT2
   READ
*
   IF Lastkey() = 27
      EXIT
   ENDIF
  *
   set softseek on
   seek dat1
   IF dat2 < bdiz .or. Eof()
      @ 20,10 SAY "NEMA PROMENA U TOM INTERVALU ! ENTER za nastavak !!!"
      wait " "
      set softseek off
      LOOP
   ENDIF
   SET CONSOLE OFF
   SET DEVICE TO PRINT
  * SET PRINT TO Lpt1
   SET PRINT TO LISTA.dat
   SET PRINT ON
*   IF !ISPRINTER()
*      Greska(2)
*      SET PRINTER OFF
*      SET DEVICE TO SCREEN
*      SET CONSOLE ON
*      Msg("Stampac nije spreman za rad",5)
*      EXIT
*   ENDIF
*   set printer to "lista.prn"

   brst=1
    lLev1izIR()    && slov1()
   * PRIVREMENI IZLAZAK ZA TEST
/*
   CLOSE DATABASES
  * EJECT
   SET PRINTER OFF
   set print to
   SET DEVICE TO SCREEN
   SET CONSOLE ON
   CLEAR SCREEN
   RETURN
*/
   * KRAJ PRIVREMENOG IZLASKA
   *LevoZa1()     && glavlje1()
   DO WHILE ! Eof()    && WSIF = SIFART
      wz1 = 0
      wz2 = 0
      wz3 = 0
      wz7 = 0
     *IF bdiz < dat2
     *   EXIT
     *ENDIF
     FOR WPRE = DAT1 TO DAT1 +14 STEP 1
         wz1 = 0
         wz2 = 0
         wz3 = 0
         wz7 = 0
     * wpre = dat1
      DO WHILE wpre = bdiz
         do case
            case indik = 0
                 wz1 = round(wz1 + ispl,2)
            case indik = 7
                 wz2 = round(wz2 + ispl,2)
            case indik = 9
                 wz3 = round(wz3 + ispl,2)
         endcase
         *wz4 = round(wz4 + niza,2)
         *wz5 = round(wz5 + nula,2)
         *wz9 = round(wz9 + nula06,2)
          SKIP
      ENDDO           &&  kraj od jednog datuma
      * ide ispis jednog datuma
      wz4 = wz4 + wz1
      wz5 = wz5 + wz2
      wz6 = wz6 + wz3
      wz7 = round(wz1 * 0.0022,2)   && drzi porez
      wz8 = wz8 + wz7   && drzi zbir poreza za 15 dana
      wz9 = round(wz1+wz2+wz3,2)   && drzi ukupan dnevni promet
      wz10 = wz10+wz9
      *do case
      *   case day(bdiz) <= 15
               llev1izir1()
      *   case day(bdiz) > 15 .and. wind = 0    && da odstampa presek za 15 dana
      *        wind = 1
      *        * stampa zbira za 15 dana
      *   case day(bdiz) .and. wind = 1
      *        levizir1()
      *endcase
         wz1 = 0
         wz2 = 0
         wz3 = 0
         wz7 = 0

     NEXT WPRE
  * ENDDO
   lLev1ifFu1()  && ter1()
   lLev1izir2()  && ter1()
   lLev1iFu2()  && ter1()
   lLev1iFu3()  && ter1()
   lLev1iFu4()  && ter1()
   ***** idemo od 16 pa na dalje
   * anulirati polja
   wz1 = 0
   wz2 = 0
   wz3 = 0
   wz4 = 0
   wz5 = 0
   wz6 = 0
   wz7 = 0
   wz8 = 0
   wz9 = 0
   wz10 = 0
   * utvrditi koliko mesec ima dana
   wm = val("00")
   do case
      case day(dat2) = 31
           wm = 30
      case day(dat2) = 30
           wm = 29
      case day(dat2) = 29
           wm = 28
      case day(dat2) = 28
           wm = 27
   endcase
   * kraj utvrdjivanja koliko mesec ima dana
     FOR WPRE = DAT1+15 TO DAT1+wm STEP 1
         wz1 = 0
         wz2 = 0
         wz3 = 0
         wz7 = 0
     * wpre = dat1
      DO WHILE wpre = bdiz
         do case
            case indik = 0
                 wz1 = round(wz1 + ispl,2)
            case indik = 7
                 wz2 = round(wz2 + ispl,2)
            case indik = 9
                 wz3 = round(wz3 + ispl,2)
         endcase
         *wz4 = round(wz4 + niza,2)
         *wz5 = round(wz5 + nula,2)
         *wz9 = round(wz9 + nula06,2)
          SKIP
      ENDDO           &&  kraj od jednog datuma
      * ide ispis jednog datuma
      wz4 = wz4 + wz1
      wz5 = wz5 + wz2
      wz6 = wz6 + wz3
      wz7 = round(wz1 * 0.0022,2)   && drzi porez
      wz8 = wz8 + wz7   && drzi zbir poreza za 15 dana
      wz9 = round(wz1+wz2+wz3,2)   && drzi ukupan dnevni promet
      wz10 = wz10+wz9
      *do case
      *   case day(bdiz) <= 15
               llev1izir1()
      *   case day(bdiz) > 15 .and. wind = 0    && da odstampa presek za 15 dana
      *        wind = 1
      *        * stampa zbira za 15 dana
      *   case day(bdiz) .and. wind = 1
      *        levizir1()
      *endcase
         wz1 = 0
         wz2 = 0
         wz3 = 0
         wz7 = 0

     NEXT WPRE
  * ENDDO
   lLev1ifFu1()  && ter1()
   lL2ev1izir2()  && ter1()
   lLev1iFu2()  && ter1()
   lL2ev1iFu3()  && ter1()
   lL2ev1iFu4()  && ter1()
   EXIT
 ENDDO     && od kraja baze
 ? "U Obrenovcu                                               ------------------- "
 ? dtoc(date()) + "                                                   Obveznik"
*     ubaceno za stampu zbira
* KRAJ STAMPE ZBIROVA
   EJECT
   SET PRINTER OFF
   set print to
   SET DEVICE TO SCREEN
   SET CONSOLE ON
   EXIT
ENDDO

close gkziro

   * set device to screen
   * set printer off
   * SET PRINT TO
    * ubacen deo za pregled
    izmenio:= .t.
    DO WHILE izmenio
       izmenio = m_type("lista.dat",140)
    ENDDO
    * kraj ubacenog dela
    set cursor on
*RESTSCREEN(0,0,24,79,ekran)
*SETCURSOR(kursor)
RETURN

***************************
PROC lLev1iZIR  && aslov1
? "      Republika Srbija"
?? "                    Nadlezna organizaciona jedinica"
? "MINISTARSTVO FINANSIJA I EKONOMIJE"
?? "        Poreska uprava odeljenje Obrenovac"
? "      PORESKA UPRAVA"
?? "                            Mesto : OBRENOVAC"
*? "   Nadlezna organizaciona jedinica"
*? " Poreska uprava odeljenje Obrenovac"
*? " Mesto : OBRENOVAC"
? "                           PORESKA PRIJAVA"
?" o izvrsenim finansijskim transakcijama i obracunatom i placenom porezu na"
? " finansijske transakcije od "
?? dat1
?? " do "
?? dat2
?? ". godine"
*? " "
? "                      I. PODACI O OBVEZNIKU POREZA"
? "旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�"
? "�"
?? "  "
??  gcNazRad   && vlasnik
??  " " + gcPrez   && ime vlasnika
??  " " + gcIme   && ime vlasnika
?? "    �"
? "�               obveznik poreza (pravno lice,preduzetnik)                 �"
*? "�                                                                         �"
? "�"
?? gcMesto+" "+gcAdresa  + "            �"
? "�"
?? "  mesto sedista            ulica          broj                           �"
*? "�                                                                         �"
? "�"
?? gcBrRad +"                                                     "
?? gcPIB + " �"
? "�"
?? "    broj resenja iz registra upisa                                PIB    �"
? "읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�"
*? " "
? "       II. IZVRSENE FINANSIJSKE TRANSAKCIJE I OBRACUNAT I PLACEN POREZ"
*? "            "
? "旼컴컴컴컴컫컴컴컴컴컴컴쩡컴컴컴컴컴컫컴컴컴컴컴컴쩡컴컴컴컴컴컫컴컴컴컴컴컴�"
? "�  Datum   쿢kupno izvr-쿔znos finan-쿔znos finans쿚snovica za 쿚bracunati  �"
? "�          퀂ene finans-퀂ijskih tra-쿶jskih trans쿽bracun por-쿾orez na fi-�"
? "�          쿶jske trans-쿻sakcija os-쿪kcija izuz-쿮za         쿻ansijske   �"
? "�          쿪kcije      쿹obodjen po-쿮t od opore-�(2 - 3  - 4)퀃ransakcije �"
? "�          �            퀁eza        퀊ivanja     �            �            �"
? "�          �            �(clan 7.Zak)�(clan 9.Zak)�            �            �"
? "쳐컴컴컴컴컵컴컴컴컴컴컴탠컴컴컴컴컴컵컴컴컴컴컴컴탠컴컴컴컴컴컵컴컴컴컴컴컴�"
? "�    1     �     2      �     3      �     4      �     5      �      6     �"
? "쳐컴컴컴컴컵컴컴컴컴컴컴탠컴컴컴컴컴컵컴컴컴컴컴컴탠컴컴컴컴컴컵컴컴컴컴컴컴�"

RETURN
************ **** **********
PROC lLev1izir1  && ekst1

 ? "�"+DTOC(WPRE)
?? "�"+STR(WZ9,12,2)
?? "�"+STR(WZ2,12,2)
?? "�"+STR(WZ3,12,2)
?? "�"+STR(WZ1,12,2)
?? "�"+STR(WZ7,12,2)+"�"



RETURN
************ **** **********
PROC lLev1izir2  && ekst1

* ? "�"+"Svega od  "
*?? "�"+"            "
*?? "�"+"            "
*?? "�"+"            "
*?? "�"+"            "
*?? "�"+"            "+"�"

 ? "�"+"1. do 15. "
?? "�"+STR(WZ10,12,2)
?? "�"+STR(WZ5,12,2)
?? "�"+STR(WZ6,12,2)
?? "�"+STR(WZ4,12,2)
?? "�"+STR(WZ8,12,2)+"�"


RETURN
**** ***********************8
PROC lL2ev1izir2  && ekst1

* ? "�"+"Sve od 16."
*?? "�"+"            "
*?? "�"+"            "
*?? "�"+"            "
*?? "�"+"            "
*?? "�"+"            "+"�"

 ? "�"+"16.kr.mes."
?? "�"+STR(WZ10,12,2)
?? "�"+STR(WZ5,12,2)
?? "�"+STR(WZ6,12,2)
?? "�"+STR(WZ4,12,2)
?? "�"+STR(WZ8,12,2)+"�"


RETURN
**** ***********************8
PROC lLev1ifFu1  && uter1

? "쳐컴컴컴컴컵컴컴컴컴컴컴탠컴컴컴컴컴컵컴컴컴컴컴컴탠컴컴컴컴컴컵컴컴컴컴컴컴�"

RETURN
PROC lLev1iFu2  && uter1

? "쳐컴컴컴컴컨컴컴컴컴컴컴좔컴컴컴컴컴컨컴컴컴컴컴컴좔컴컴컴컴컴컨컴컴컴컴컴컴�"

RETURN

proc lLev1ifu3
? "쿔zn. plac. por. za period od 1. do 15.      "
*?? str(mont(dat1),2,0) + "."+" "+str(year(dat1),4,0)+"  Ukupno:              �"
?? "        "+"    Ukupno:            �"

 return
PROC lLev1iFu4  && uter1

? "쳐컴컴컴컴컫컴컴컴컴컴컴쩡컴컴컴컴컴컫컴컴컴컴컴컴쩡컴컴컴컴컴컫컴컴컴컴컴컴�"

RETURN
proc lL2ev1ifu3
? "쿔zn.plac.por. za period od 16. do kr.pr.me."
*?? str(mont(dat1),2,0) + "."+" "+str(year(dat1),4,0)+"  Ukupno:            �"
?? "         "+"    Ukupno:            �"

 return
PROC lL2ev1iFu4  && uter1

? "읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�"

RETURN
******************************

