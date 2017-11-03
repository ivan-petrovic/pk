USE KPR
INDEX ON DRACKPR TO KPRDRAC
USE

SELECT 0
USE PPDAT INDEX PPINSIF
SELECT 0
USE KPR INDEX KPRDRAC

DO WHILE .T.
   GO TOP

   DAT1 = Date()
   DAT2 = Date()
   wsif = Val("0000000000000")
   wz1  = Val("00000000.00")
   STORE wz1 TO wz20,wz21,wz22,wz23,wz111
   STORE wz1 TO wz2,wz3,wz4,wz5,wz6,wz7,wz8,wz9,wz10,wz11,wz12,wz13,wz14,wz15,wz16,wz17,wz18,wz19
   wUKUPNO = VAL("000000000000.00")

   CLEAR SCREEN
   @ 6,10 SAY "STAMPA KNJIGU KPR OD DATUMA" GET DAT1
   @ 6,57 SAY "DO DATUMA" GET DAT2
   READ

   IF Lastkey() = 27
      EXIT
   ENDIF

   SET CONSOLE OFF
   SET DEVICE TO PRINT
   SET PRINT TO LPT1
   * SET PRINT TO LISTA
   SET PRINT ON
   IF lLaser
      @ 0,0 SAY Chr(27) + '(s17.5H'      && kondenz On za laserski
   ELSE
      @ 0,0 SAY Chr(15)                  && kondenz On za matricni
   ENDIF
   SetPrc(0,0)

   brst=1
   LevikprNaslov()
   LevokprZaglavlje()
   DO WHILE ! Eof()
      IF DTOS(DRACKPR) >= DTOS(DAT1) .AND. DTOS(DRACKPR) <= DTOS(DAT2)
         IF PROW() = 62
            IF !brst=0
               LevikprFuter()
               EJECT
            ENDIF
            brst = brst + 1
            LevokprZaglavlje()
         ENDIF

         * UBACENO ZA PPDAT (IME I SEDISTE)
         SELECT PPDAT
         SEEK kpr->kupkpr
         IF Found()
            mImepp = PPNAZ
            msedi  = PPMES
         else
            mImepp = Space(16)
            msedi  = Space(17)
         ENDIF

         SELECT KPR
         LevikprTekst()
          wz1 = round(wz1 + ukspdv,2)
      ENDIF
      SKIP
   ENDDO
   LevikprFuter()
	
	* stampa zbirova
 	? " "+"                                                                                                            "
	?? " "+STR(WZ1,16,2)
   EJECT

   brst=1
   DesnikprNaslov()
   DesnokprZaglavlje()
   GO TOP
   DO WHILE ! Eof()
      IF DTOS(DRACKPR) >= DTOS(DAT1) .AND. DTOS(DRACKPR) <= DTOS(DAT2)
         IF PROW() = 62
            IF !brst=0
               DesnikprFuter()
               EJECT
            ENDIF
            brst = brst + 1
            DesnokprZaglavlje()
         ENDIF
         DesnikprTekst()

			wz8 = round(wz8 + UKSPDV1,2)
			wz9 = round(wz9 + OSLPDV,2)
			wz10 = round(wz10 + NPDV,2)
			wz11 = round(wz11 + UVOZN,2)
			wz12 = round(wz12 + UKPPDV,2)
			wz13 = round(wz13 + ODPDV,2)
			wz14 = round(wz14 + NEODPDV,2)
			wz15 = round(wz15 + VBEZPDVU,2)
			wz16 = round(wz16 + IZNPDVU,2)
			wz17 = round(wz17 + VDU,2)
			wz18 = round(wz18 + IZNN5,2)
      ENDIF
      SKIP
   ENDDO
   DesnikprFuter()

	* stampa zbirova
	? " "+ STR(WZ8,11,2)
	?? " "+ STR(WZ9,11,2)
	?? " "+ STR(WZ11,11,2)
	?? " "+ STR(WZ10,11,2)
	?? " "+ STR(WZ12,11,2)
	?? " "+ STR(WZ13,11,2)
	?? " "+ STR(WZ14,11,2)
	?? " "+ STR(WZ15,10,2)
	?? " "+ STR(WZ16,10,2)
	?? " "+ STR(WZ17,10,2)
	?? " "+ STR(WZ18,10,2)

   IF lLaser
      ? Chr(27) + '&k0S' + Chr(27) + '(s10.5H'  && kondenz Off za laserski
   ELSE
      ? Chr(18)                                 && kondenz Off za matricni
   ENDIF

   EJECT

   SET PRINTER OFF
   SET PRINT TO
   SET DEVICE TO SCREEN
   SET CONSOLE ON
ENDDO

SELECT KPR
CLOSE KPR
SELECT PPDAT
CLOSE PPDAT

RETURN

*************************************************
PROCEDURE LevikprNaslov

? "                                        KNJIGA  K P R    OD  " + DTOC(DAT1) + "  DO  " + DTOC(DAT2)+ "                          strana  " + STR(BRST,3,0)
? "Poreski obveznik: "+ gcPrez_Ime     && vlasnik
? "Mesto: "+RTRIM(gcMesto)+" "+gcAdresa
? "Naziv radnje : "+gcNazRad

RETURN
*************************************************

*************************************************
PROCEDURE LevokprZaglavlje

? "                                                                  " + "        " + "      " + "        "+ "                          strana  " + STR(BRST,3,0)
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
*************************************************

*************************************************
PROCEDURE LevikprTekst

 ? "³"+STR(rbkpr,4,0)
?? "³"+DTOC(DKKPR)
?? "³"+DTOC(dppvdkpr)
?? "³"+SUBSTR(BRKAL,1,10)
?? "³"+SUBSTR(BRACKPR,1,10)
?? "³"+DTOC(drackpr)
?? "³"+SUBSTR(mImepp,1,16) +" "+SUBSTR(mSedi,1,17)
?? "³"+SUBSTR(PIBKPR,1,13)
?? "³"+STR(ukspdv,16,2)+"³"

RETURN
*************************************************

*************************************************
PROCEDURE LevikprFuter

? "ÀÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

RETURN
*************************************************

*************************************************
PROCEDURE DesnikprNaslov

? "                                        KNJIGA KPR  OD  " + DTOC(DAT1) + "  DO  " + DTOC(DAT2)+ "                                  strana  " + STR(BRST,3,0)
? "Poreski obveznik: "+ gcPrez_Ime     && vlasnik
? "Mesto: "+RTRIM(gcMesto)+" "+gcAdresa
? "Naziv radnje : "+gcNazRad

RETURN
*************************************************

*************************************************
PROCEDURE DesnokprZaglavlje

? "                                                                  " + "        " + "      " + "        "+ "                          strana  " + STR(BRST,3,0)
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
*************************************************

*************************************************
PROCEDURE DesnikprFuter

? "ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÙ"

RETURN
*************************************************

*************************************************
PROCEDURE DesnikprTekst

 ? "³"+ STR(UKSPDV1,11,2)
?? "³"+ STR(OSLPDV,11,2)
?? "³"+ STR(UVOZN,11,2)
?? "³"+ STR(NPDV,11,2)
?? "³"+ STR(UKPPDV,11,2)
?? "³"+ STR(ODPDV,11,2)
?? "³"+ STR(NEODPDV,11,2)
?? "³"+ STR(VBEZPDVU,10,2)
?? "³"+ STR(IZNPDVU,10,2)
?? "³"+ STR(VDU,10,2)
?? "³"+ STR(IZNN5,10,2)+"³"

RETURN
*************************************************

*************************************************
PROCEDURE kpr3ciNaslov

? "                                        KNJIGA PRIHOD-RASHOD  OD  " + DTOC(DAT1) + "  DO  " + DTOC(DAT2)+ "                          strana  " + STR(BRST,3,0)
? "Poreski obveznik: "+ gcPrez_Ime
? "Mesto: "+RTRIM(gcMesto)+" "+gcAdresa
? "Naziv radnje : "+gcNazRad

RETURN
*************************************************

*************************************************
PROCEDURE kpr3ceZaglavlje

? "                                                                  " + "        " + "      " + "        "+ "                                  strana  " + STR(BRST,3,0)
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
*************************************************

*************************************************
PROCEDURE kpr3ciFuter

? "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

RETURN
*************************************************

*************************************************
PROCEDURE kpr3ciTekst

? "³"+ STR(RPbez06,11,2)+"            "
?? "³"+ STR(RPbez2,11,2)+"            "
?? "³"+ STR(RPbez4,11,2)+"            "
?? "³"+ STR(RPn1,11,2)+"            ³"

RETURN
*************************************************
