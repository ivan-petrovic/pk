LOCAL control_str, nMaxRow := 92

SELECT 0
USE RASHODN INDEX RASHINDN

DO WHILE .T.

   Dat1 = Date()
   Dat2 = Date()
   wz1 = Val("00000000.00")
   store wz1 to wz20,wz21,wz22,wz111
   store wz1 to wz2,wz3,wz4,wz5,wz6,wz7,wz8,wz9,wz10,wz11,wz12,wz13,wz14,wz15,wz16,wz17,wz18

   MainMask("STAMPA KNJIGE PRIHODA-RASHODA")
   @ 6,10 SAY "Od datuma: " GET Dat1
   @ 7,10 SAY "Do datuma: " GET Dat2
   READ

   IF Lastkey() = 27 ; EXIT ; ENDIF

   SET CONSOLE OFF
   SET DEVICE TO PRINT
   SET PRINT TO LPT1
   * SET PRINT TO LISTA
   SET PRINT ON

   IF lLaser
      control_str = Chr(27) + '(s17H' + Chr(27) + '&l5C'
      @ 0,0 SAY control_str              && kondenz On za laserski
   ELSE
      @ 0,0 SAY Chr(15)                  && kondenz On za matricni
   ENDIF
   SetPrc(0,0)

   brst = 1
   LeviNaslov()
   LevoZaglavlje()
   GO TOP
   DO WHILE ! Eof()
      IF DTOS(RDK) >= DTOS(DAT1) .AND. DTOS(RDK) <= DTOS(DAT2)
         IF PROW() = nMaxRow
            IF !brst=0
               LeviFuter()
               EJECT
            ENDIF
            brst = brst + 1
            LevoZaglavlje()
         ENDIF
         LeviTekst()
         wz1 = Round(wz1 + rpv,2)
         wz2 = Round(wz2 + rpn,2)
         wz3 = Round(wz3 + rpbez,2)
         wz4 = Round(wz4 + rusp,2)
         wz5 = Round(wz5 + rusbezp,2)
         wz6 = Round(wz6 + rplacp,2)
         wz7 = Round(wz7 + rsvep,2)
      ENDIF
      SKIP
   ENDDO

   LeviFuter()
    ? " " + "    "
   ?? " " + "        "
   ?? " " + "                           "
   ?? " " + Str(WZ1,11,2)
   ?? " " + Str(WZ2,11,2)
   ?? " " + Str(WZ3,11,2)
   ?? " " + Str(WZ4,11,2)
   ?? " " + Str(WZ5,11,2)
   ?? " " + Str(WZ6,11,2)
   ?? " " + Str(WZ7,11,2)

   EJECT

   brst=1
   DesniNaslov()
   DesnoZaglavlje()
   GO TOP
   DO WHILE ! Eof()
      IF DTOS(RDK) >= DTOS(DAT1) .AND. DTOS(RDK) <= DTOS(DAT2)
         IF PROW() = nMaxRow
            IF !brst=0
               DesniFuter()
               EJECT
            ENDIF
            brst = brst + 1
            DesnoZaglavlje()
         ENDIF
         DesniTekst()
         wz8 = Round(wz8 + rnvrrr,2)
         wz9 = Round(wz9 + rvsp,2)
         wz10 = Round(wz10 + rrucp,2)
         wz11 = Round(wz11 + robpor,2)
         wz111 = Round(wz111 + robporU,2)
         wz12 = Round(wz12 + rprodv,2)
         wz13 = Round(wz13 + rmin,2)
         wz14 = Round(wz14 + rdop,2)
         wz15 = Round(wz15 + rrasf,2)
         wz16 = Round(wz16 + rrasuk,2)
         wz17 = Round(wz17 + rziru,2)
         wz18 = Round(wz18 + rziri,2)
      ENDIF
      SKIP
   ENDDO

   DesniFuter()
    ? " "+ Str(WZ8,11,2)
   ?? " "+ Str(WZ9,11,2)
   ?? " "+ Str(WZ10,11,2)
   ?? " "+ Str(WZ11,11,2)
   ?? " "+ Str(WZ12,11,2)
   ?? " "+ Str(WZ13,11,2)
   ?? " "+ Str(WZ14,11,2)
   ?? " "+ Str(WZ15,11,2)
   ?? " "+ Str(WZ16,11,2)
   ?? " "+ Str(WZ17,11,2)
   ?? " "+ Str(WZ18,11,2)

   EJECT

   * dodata treca strana
   brst=1
   TreciNaslov()
   TreceZaglavlje()
   GO TOP
   DO WHILE ! Eof()
      IF DTOS(RDK) >= DTOS(DAT1) .AND. DTOS(RDK) <= DTOS(DAT2)
         IF PROW() = nMaxRow
            IF !brst=0
               TreciFuter()
               EJECT
            ENDIF
            brst = brst + 1
            TreceZaglavlje()
         ENDIF
         TreciTekst()
         wz20 = Round(wz20 + rpbez06,2)  && obracunati PDV
         wz21 = Round(wz21 + rpbez2,2)   && preneti PDV
         wz22 = Round(wz22 + rpbez4,2)   && placen PDV
      ENDIF
      SKIP
   ENDDO

   TreciFuter()
   ? " "  + Str(WZ20,11,2) + "            "
   ?? " " + Str(wz21,11,2) + "            "
   ?? " " + Str(wz22,11,2) + "             "

   IF lLaser
      ? Chr(27)+ Chr(69)         && kondenz Off za laserski
   ELSE
      ? Chr(18)                  && kondenz Off za matricni
   ENDIF

   EJECT
   SET PRINTER OFF
   SET PRINT TO
   SET DEVICE TO SCREEN
   SET CONSOLE ON
ENDDO

USE

RETURN

*************************************************
PROCEDURE LeviNaslov

? "                                        KNJIGA PRIHOD-RASHOD  OD  " + DTOC(DAT1) + "  DO  " + DTOC(DAT2)+ "                          strana  " + Str(BRST,3,0)
? "Poreski obveznik: "+gcPrez_Ime     && vlasnik
? "Mesto: "+RTRIM(gcMesto)+" "+gcAdresa
? "Naziv radnje : "+gcNazRad

RETURN

*************************************************
PROCEDURE LevoZaglavlje

? "                                                                  " + "        " + "      " + "        "+ "                          strana  " + Str(BRST,3,0)
? "ÚÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿"
? "³    ³          ³                         ³            PRIHOD OD DELATNOSTI                           ³           ³           ³"
? "³    ³          ³                         ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´           ³           ³"
? "³RED ³ DATUM    ³     O P I S             ³ Od prodaje proizvoda,             ³     Od izvrsenih      ³           ³ SVEGA     ³"
? "³ BR.³KNJIZE-   ³  Naziv, broj i datum    ³    roba i materijala              ³        usluga         ³           ³ PRIHODA   ³"
? "³    ³ NJA      ³dokumenta za knjizenje   ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ´           ³           ³"
? "³    ³          ³                         ³      SA PDV           ³   BEZ     ³    SA     ³    BEZ    ³  ostali   ³(4+5+6+7+8+³"
? "³    ³          ³                         ÃÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ´           ³           ³           ³ prihodi   ³   9)      ³"
? "³    ³          ³                         ³po opst. st³po poseb.st³   PDV     ³   PDV     ³    PDV    ³  (63 - 69)³           ³"
? "ÃÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄ´"
? "³  1 ³   2      ³           3             ³    4      ³     5     ³     6     ³     7     ³     8     ³     9     ³    10     ³"
? "ÃÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄ´"

RETURN

*************************************************
PROCEDURE LeviTekst

 ? "³"+Str(RRB,4,0)
?? "³"+DTOC(RDK)
?? "³"+SUBSTR(RBR,1,7) +" "+SUBSTR(ROPIS,1,17)
?? "³"+Str(RPV,11,2)
?? "³"+Str(RPN,11,2)
?? "³"+Str(RPBEZ,11,2)
?? "³"+Str(RUSP,11,2)
?? "³"+Str(RUSBEZP,11,2)
?? "³"+Str(RPLACP,11,2)
?? "³"+Str(RSVEP,11,2)+"³"

RETURN

*************************************************
PROCEDURE LeviFuter

? "ÀÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÙ"

RETURN

*************************************************
PROCEDURE DesniNaslov

? "                                        KNJIGA PRIHOD-RASHOD  OD  " + DTOC(DAT1) + "  DO  " + DTOC(DAT2)+ "                                  strana  " + Str(BRST,3,0)
? "Poreski obveznik: "+gcPrez_Ime     && vlasnik
? "Mesto: "+RTRIM(gcMesto)+" "+gcAdresa
? "Naziv radnje : "+gcNazRad

RETURN

*************************************************
PROCEDURE DesnoZaglavlje

? "                                                                  " + "        " + "      " + "        "+ "                                  strana  " + Str(BRST,3,0)
? "ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
? "³Nnab.vred. ³vrednost   ³razlika u  ³obracunati ³prodajna   ³tr.zarada ,³tr.us.amo. ³finansijski³  RASHODI  ³     ziro racun        ³"
? "³robe, repro³sopstvenih ³   ceni    ³   PDV     ³vrednost   ³naknada ,  ³i nemateri ³lnostali ra³           ³                       ³"
? "³materijala ³proizvoda  ³ provizija ³           ³robe i proi³os. li. ra.³jalni (53 r³shodi (52) ³(10+15+16+ ³                       ³"
? "³ili rezer. ³           ³           ³           ³zvoda      ³   ( 52 )  ³ 55)       ³           ³   17)     ³                       ³"
? "³  delova   ³           ³           ³           ³(10+12+13) ³           ³           ³           ³           ÃÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ´"
? "³           ³           ³           ³           ³ili (11+13)³           ³           ³           ³           ³  uplaceno ³ isplaceno ³"
? "³           ³           ³           ³           ³           ³           ³           ³           ³           ³           ³           ³"
? "³           ³           ³           ³           ³           ³           ³           ³           ³           ³           ³           ³"
? "ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´"
? "³    11     ³    12     ³    13     ³    14     ³    15     ³    16     ³    17     ³    18     ³    19     ³          20           ³"
? "ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ´"

RETURN

*************************************************
PROCEDURE DesniFuter

? "ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÙ"

RETURN

*************************************************
PROCEDURE DesniTekst

 ? "³"+ Str(RNVRRR,11,2)
?? "³"+ Str(RVSP,11,2)
?? "³"+ Str(RRUCP,11,2)
?? "³"+ Str(Round(ROBPOR + robporu,2),11,2)
?? "³"+ Str(RPRODV,11,2)
?? "³"+ Str(RMIN,11,2)
?? "³"+ Str(RDOP,11,2)
?? "³"+ Str(RRASF,11,2)
?? "³"+ Str(RRASUK,11,2)
?? "³"+ Str(RZIRU,11,2)
?? "³"+ Str(RZIRI,11,2)+"³"

RETURN

*************************************************
PROCEDURE TreciNaslov

? "                                        KNJIGA PRIHOD-RASHOD  OD  " + DTOC(DAT1) + "  DO  " + DTOC(DAT2)+ "                          strana  " + Str(BRST,3,0)
? "Poreski obveznik: "+ gcPrez_Ime     && vlasnik
? "Mesto: "+RTRIM(gcMesto)+" "+gcAdresa
? "Naziv radnje : "+gcNazRad

RETURN

*************************************************
PROCEDURE TreceZaglavlje

? "                                                                  " + "        " + "      " + "        "+ "                                  strana  " + Str(BRST,3,0)
? "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
? "³                       ³                       ³                       ³"
? "³ Obracunati PDV        ³ Prethodni PDV         ³ Uplacen PDV           ³"
? "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
? "³          21           ³          22           ³          23           ³"
? "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"

RETURN

*************************************************
PROCEDURE TreciFuter

? "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

RETURN

*************************************************
PROCEDURE TreciTekst

? "³"+ Str(RPbez06,11,2)+"            "
?? "³"+ Str(RPbez2,11,2)+"            "
?? "³"+ Str(RPbez4,11,2)+"            ³"

RETURN

*************************************************
