LOCAL control_str, nMaxRow := 92
* SETPRC(0,0)

SELECT 0
USE PPDAT
INDEX ON PPPIB TO PPINPIB
CLOSE PPDAT

SELECT 0
USE PPDAT INDEX PPINPIB
SELECT 0
USE KPR INDEX KPRDK

DO WHILE .T.

   GO TOP

   Dat1 = Date()
   Dat2 = Date()
   wz1  = Val("00000000.00")
   store wz1 to wz8,wz9,wz10,wz11,wz12,wz13,wz14,wz15,wz16,wz17,wz18,wz19

   MainMask("STAMPA KNJIGE KPR OD DATUMA DO DATUMA")
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
      @ 0,0 SAY control_str      && kondenz On za laserski
   ELSE
      ? Chr(15)                  && kondenz On za matricni
   ENDIF
   SetPrc(0,0)

   brst=1
   LesvikprNaslov()
   LesvokprZaglavlje()
   DO WHILE ! Eof()
      IF DtoS(DKKPR) >= DtoS(Dat1) .AND. DtoS(DKKPR) <= DTOS(Dat2)
         IF Prow() = nMaxRow
            IF !brst=0
               LevikprFuter()
               EJECT
            ENDIF
            brst = brst + 1
            LesvokprZaglavlje()
         ENDIF

         SELECT PPDAT
         SEEK KPR->PIBKPR
         IF Found()
            mImepp = PPNAZ
            msedi = PPMES
         ELSE
            mImepp = Space(16)
            msedi = Space(17)
         ENDIF
         SELECT KPR

         LesvikprTekst()
         wz1 = Round(wz1 + ukspdv,2)
      ENDIF
      SKIP
   ENDDO
   LesvikprFuter()
   ? Space(110) + Str(WZ1,16,2)

   EJECT
   brst=1
   DessnikprNaslov()
   DessnokprZaglavlje()
   GO TOP
   DO WHILE ! Eof()
      IF DtoS(DKKPR) >= DtoS(Dat1) .AND. DtoS(DKKPR) <= DtoS(Dat2)
         IF Prow() = nMaxRow
            IF !brst=0
               DessnikprFuter()
               EJECT
            ENDIF
            brst = brst + 1
            DessnokprZaglavlje()
         ENDIF
         DessnikprTekst()
         wz8  = Round(wz8 + UKSPDV1,2)
         wz9  = Round(wz9 + OSLPDV,2)
         wz10 = Round(wz10 + NPDV,2)
         wz11 = Round(wz11 + UVOZN,2)
         wz12 = Round(wz12 + UKPPDV,2)
         wz13 = Round(wz13 + ODPDV,2)
         wz14 = Round(wz14 + NEODPDV,2)
         wz15 = Round(wz15 + VBEZPDVU,2)
         wz16 = Round(wz16 + IZNPDVU,2)
         wz17 = Round(wz17 + VDU,2)
         wz18 = Round(wz18 + IZNN5,2)
      ENDIF
      SKIP
   ENDDO
   DessnikprFuter()
    ? " "+ Str(WZ8,11,2)
   ?? " "+ Str(WZ9,11,2)
   ?? " "+ Str(WZ10,11,2)
   ?? " "+ Str(WZ11,11,2)
   ?? " "+ Str(WZ12,11,2)
   ?? " "+ Str(WZ13,11,2)
   ?? " "+ Str(WZ14,11,2)
   ?? " "+ Str(WZ15,10,2)
   ?? " "+ Str(WZ16,10,2)
   ?? " "+ Str(WZ17,10,2)
   ?? " "+ Str(WZ18,10,2)

   IF lLaser
      ? Chr(27)+ Chr(69)      && kondenz Off za laserski
   ELSE
      ? Chr(18)               && kondenz Off za matricni
   ENDIF

   EJECT
   SET PRINTER OFF
   SET PRINT TO
   SET DEVICE TO SCREEN
   SET CONSOLE ON
ENDDO

CLOSE DATABASES

RETURN

****************************************************************
PROCEDURE LesvikprNaslov

? "                                        KNJIGA  K P R    OD  " + DTOC(DAT1) + "  DO  " + DTOC(DAT2)+ "                          strana  " + Str(BRST,3,0)
? "Poreski obveznik: " + gcPrez_Ime
? "Mesto: "+RTRIM(gcMesto)+" "+gcAdresa
? "Naziv radnje : "+gcNazRad

RETURN

****************************************************************
PROCEDURE LesvokprZaglavlje

? "                                                                  " + "        " + "      " + "        "+ "                          strana  " + Str(BRST,3,0)
? "ÚÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
? "³    ³    D A T U M        ³                        RACUN ILI DRUGI DOKUMENT                                                  ³"
? "³    ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
? "³RED ³ KNJIZENJA³ PRIJEMA  ³BROJ      ³  BROJ    ³ DATUM    ³     DOBAVLJAC                                  ³                ³"
? "³ BR.³          ³          ³KALKULAC. ³ RACUNA   ³RAC.DOKUM.ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ´                ³"
? "³    ³          ³          ³          ³          ³          ³  NAZIV ( IME I SEDISTE )         ³  PIB  ILI   ³UKUPNA NAKNADA  ³"
? "³    ³          ³          ³          ³          ³          ³                                  ³    JMBG     ³SA PDV (TAC.16) ³"
? "³    ³          ³          ³          ³          ³          ³                                  ³             ³                ³"
? "³    ³          ³          ³          ³          ³          ³                                  ³             ³                ³"
? "ÃÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
? "³  1 ³   2      ³    3     ³    4a    ³    4     ³    5     ³                6                 ³      7      ³        8       ³"
? "ÃÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"

RETURN

****************************************************************
PROCEDURE LesvikprTekst

 ? "³"+Str(rbkpr,4,0)
?? "³"+DTOC(DKkpr)
?? "³"+DTOC(dppvdkpr)
?? "³"+SUBSTR(BRKAL,1,10)
?? "³"+SUBSTR(BRACKPR,1,10)
?? "³"+DTOC(drackpr)
?? "³"+SUBSTR(mImepp,1,16) +" "+SUBSTR(mSedi,1,17)
?? "³"+SUBSTR(PIBKPR,1,13)
?? "³"+Str(ukspdv,16,2)+"³"

RETURN

****************************************************************
PROCEDURE LesvikprFuter

? "ÀÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

RETURN

****************************************************************
PROCEDURE DessnikprNaslov

? "                                        KNJIGA KPR  OD  " + DTOC(DAT1) + "  DO  " + DTOC(DAT2)+ "                                  strana  " + Str(BRST,3,0)
? "Poreski obveznik: "+gcPrez_Ime     && vlasnik
? "Mesto: "+RTRIM(gcMesto)+" "+gcAdresa
? "Naziv radnje : "+gcNazRad

RETURN

****************************************************************
PROCEDURE DessnokprZaglavlje

? "                                                                  " + "        " + "      " + "        "+ "                          strana  " + Str(BRST,3,0)
? "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
? "³                                               ³           ³           ³           ³       U V O Z       ³NAKNADA POLJOPRIVRED.³"
? "ÃÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ´UKUPAN     ³IZNOS      ³IZNOS      ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´"
? "³UKUPNA     ³OSLOBODJENE³NAKNADA ZA ³NAKNADA BEZ³IZNOS OBRA-³PRETHODNOG ³PRETHODNOG ³          ³          ³VREDNOST  ³IZNOS     ³"
? "³NAKNADA SA ³NABAVKE I  ³UVEZENA    ³PDV(na koju³CUNATOG    ³PDV KOJI SE³PDV KOJI SE³VREDNOST  ³  IZNOS   ³PRIMLJENIH³NAKNADE   ³"
? "³PDV        ³NABAVKE OD ³DOBRA NA KO³je obracun.³PRETHODNOG ³MOZE ODBITI³NE MOZE    ³BEZ PDV   ³   PDV    ³DOBARA I  ³OD 5 %    ³"
? "³TAC. 16    ³LICA KOJA  ³JA SE NE PL³PDV koji se³PDV TAC. 17³           ³ODBITI     ³TAC. 21   ³ TAC. 23  ³USLUGA    ³ TAC. 24  ³"
? "³           ³NISU OBVEZ.³ACA PDV    ³moze odbiti³           ³           ³           ³          ³          ³ TAC. 25  ³          ³"
? "³           ³PDV t.15,18³ TAC. 22   ³           ³           ³           ³           ³          ³          ³          ³          ³"
? "ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ´"
? "³    8b     ³     9     ³    10     ³     11    ³    12     ³    13     ³   14      ³          ³          ³          ³          ³"
? "ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ´"


RETURN

****************************************************************
PROCEDURE DessnikprFuter

? "ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ"

RETURN

****************************************************************
PROCEDURE DessnikprTekst

 ? "³"+ Str(UKSPDV1,11,2)
?? "³"+ Str(OSLPDV,11,2)
?? "³"+ Str(UVOZN,11,2)
?? "³"+ Str(NPDV,11,2)
?? "³"+ Str(UKPPDV,11,2)
?? "³"+ Str(ODPDV,11,2)
?? "³"+ Str(NEODPDV,11,2)
?? "³"+ Str(VBEZPDVU,10,2)
?? "³"+ Str(IZNPDVU,10,2)
?? "³"+ Str(VDU,10,2)
?? "³"+ Str(IZNN5,10,2)+"³"

RETURN

****************************************************************
PROCEDURE TrseciNaslov

? "                                        KNJIGA PRIHOD-RASHOD  OD  " + DTOC(DAT1) + "  DO  " + DTOC(DAT2)+ "                          strana  " + Str(BRST,3,0)
? "Poreski obveznik: " + gcPrez_Ime
? "Mesto: "+RTRIM(gcMesto)+" "+gcAdresa
? "Naziv radnje : "+gcNazRad

RETURN

****************************************************************
PROCEDURE TrseceZaglavlje

? "                                                                  " + "        " + "      " + "        "+ "                                  strana  " + Str(BRST,3,0)
? "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
? "³                       ³                       ³                       ³                       ³"
? "³ Od prodaje proizvoda  ³ Od prodaje proizvoda  ³ Od prodaje proizvoda  ³ Od prodaje proizvoda  ³"
? "³                       ³                       ³                       ³                       ³"
? "³   roba i materijala   ³   roba i materijala   ³   roba i materijala   ³   roba i materijala   ³"
? "³                       ³                       ³                       ³                       ³"
? "³       19  %           ³       0.6 %           ³        11 %           ³        20 %           ³"
? "³                       ³                       ³                       ³                       ³"
? "³                       ³                       ³                       ³                       ³"
? "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
? "³          20           ³          21           ³          22           ³          23           ³"
? "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"

RETURN

****************************************************************
PROCEDURE TrseciFuter

? "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

RETURN

****************************************************************
PROCEDURE TrseciTekst

? "³"+ Str(RPbez06,11,2)+"            "
?? "³"+ Str(RPbez2,11,2)+"            "
?? "³"+ Str(RPbez4,11,2)+"            "
?? "³"+ Str(RPn1,11,2)+"            ³"

RETURN
****************************************************************
