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
? "旼컴컫컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�"
? "�    �    D A T U M        �                        RACUN ILI DRUGI DOKUMENT                                                  �"
? "�    쳐컴컴컴컴컫컴컴컴컴컴탠컴컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴캑"
? "쿝ED � KNJIZENJA� PRIJEMA  쿍ROJ      �  BROJ    � DATUM    �     DOBAVLJAC                                  �                �"
? "� BR.�          �          쿖ALKULAC. � RACUNA   쿝AC.DOKUM.쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴캑                �"
? "�    �          �          �          �          �          �  NAZIV ( IME I SEDISTE )         �  PIB  ILI   쿢KUPNA NAKNADA  �"
? "�    �          �          �          �          �          �                                  �    JMBG     쿞A PDV (TAC.16) �"
? "�    �          �          �          �          �          �                                  �             �                �"
? "�    �          �          �          �          �          �                                  �             �                �"
? "쳐컴컵컴컴컴컴컴탠컴컴컴컴컵컴컴컴컴컴탠컴컴컴컴컵컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컵컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴�"
? "�  1 �   2      �    3     �    4a    �    4     �    5     �                6                 �      7      �        8       �"
? "쳐컴컵컴컴컴컴컴탠컴컴컴컴컵컴컴컴컴컴탠컴컴컴컴컵컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컵컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴�"

RETURN

****************************************************************
PROCEDURE LesvikprTekst

 ? "�"+Str(rbkpr,4,0)
?? "�"+DTOC(DKkpr)
?? "�"+DTOC(dppvdkpr)
?? "�"+SUBSTR(BRKAL,1,10)
?? "�"+SUBSTR(BRACKPR,1,10)
?? "�"+DTOC(drackpr)
?? "�"+SUBSTR(mImepp,1,16) +" "+SUBSTR(mSedi,1,17)
?? "�"+SUBSTR(PIBKPR,1,13)
?? "�"+Str(ukspdv,16,2)+"�"

RETURN

****************************************************************
PROCEDURE LesvikprFuter

? "읕컴컨컴컴컴컴컴좔컴컴컴컴컨컴컴컴컴컴좔컴컴컴컴컨컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴�"

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
? "旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴쩡컴컴컴컴컴쩡컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴�"
? "�                                               �           �           �           �       U V O Z       쿙AKNADA POLJOPRIVRED.�"
? "쳐컴컴컴컴컴쩡컴컴컴컴컴쩡컴컴컴컴컴쩡컴컴컴컴컴큊KUPAN     쿔ZNOS      쿔ZNOS      쳐컴컴컴컴컫컴컴컴컴컴탠컴컴컴컴컫컴컴컴컴컴�"
? "쿢KUPNA     쿚SLOBODJENE쿙AKNADA ZA 쿙AKNADA BEZ쿔ZNOS OBRA-쿛RETHODNOG 쿛RETHODNOG �          �          쿣REDNOST  쿔ZNOS     �"
? "쿙AKNADA SA 쿙ABAVKE I  쿢VEZENA    쿛DV(na koju쿎UNATOG    쿛DV KOJI SE쿛DV KOJI SE쿣REDNOST  �  IZNOS   쿛RIMLJENIH쿙AKNADE   �"
? "쿛DV        쿙ABAVKE OD 쿏OBRA NA KO쿷e obracun.쿛RETHODNOG 쿘OZE ODBITI쿙E MOZE    쿍EZ PDV   �   PDV    쿏OBARA I  쿚D 5 %    �"
? "쿟AC. 16    쿗ICA KOJA  쿕A SE NE PL쿛DV koji se쿛DV TAC. 17�           쿚DBITI     쿟AC. 21   � TAC. 23  쿢SLUGA    � TAC. 24  �"
? "�           쿙ISU OBVEZ.쿌CA PDV    쿺oze odbiti�           �           �           �          �          � TAC. 25  �          �"
? "�           쿛DV t.15,18� TAC. 22   �           �           �           �           �          �          �          �          �"
? "쳐컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컵컴컴컴컴컴탠컴컴컴컴컵컴컴컴컴컴�"
? "�    8b     �     9     �    10     �     11    �    12     �    13     �   14      �          �          �          �          �"
? "쳐컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컵컴컴컴컴컴탠컴컴컴컴컵컴컴컴컴컴�"


RETURN

****************************************************************
PROCEDURE DessnikprFuter

? "읕컴컴컴컴컴좔컴컴컴컴컴좔컴컴컴컴컴좔컴컴컴컴컴좔컴컴컴컴컴좔컴컴컴컴컴좔컴컴컴컴컴좔컴컴컴컴컨컴컴컴컴컴좔컴컴컴컴컨컴컴컴컴컴�"

RETURN

****************************************************************
PROCEDURE DessnikprTekst

 ? "�"+ Str(UKSPDV1,11,2)
?? "�"+ Str(OSLPDV,11,2)
?? "�"+ Str(UVOZN,11,2)
?? "�"+ Str(NPDV,11,2)
?? "�"+ Str(UKPPDV,11,2)
?? "�"+ Str(ODPDV,11,2)
?? "�"+ Str(NEODPDV,11,2)
?? "�"+ Str(VBEZPDVU,10,2)
?? "�"+ Str(IZNPDVU,10,2)
?? "�"+ Str(VDU,10,2)
?? "�"+ Str(IZNN5,10,2)+"�"

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
? "旼컴컴컴컴컴컴컴컴컴컴컴旼컴컴컴컴컴컴컴컴컴컴컴旼컴컴컴컴컴컴컴컴컴컴컴旼컴컴컴컴컴컴컴컴컴컴컴�"
? "�                       �                       �                       �                       �"
? "� Od prodaje proizvoda  � Od prodaje proizvoda  � Od prodaje proizvoda  � Od prodaje proizvoda  �"
? "�                       �                       �                       �                       �"
? "�   roba i materijala   �   roba i materijala   �   roba i materijala   �   roba i materijala   �"
? "�                       �                       �                       �                       �"
? "�       19  %           �       0.6 %           �        11 %           �        20 %           �"
? "�                       �                       �                       �                       �"
? "�                       �                       �                       �                       �"
? "쳐컴컴컴컴컴컴컴컴컴컴컴쳐컴컴컴컴컴컴컴컴컴컴컴쳐컴컴컴컴컴컴컴컴컴컴컴쳐컴컴컴컴컴컴컴컴컴컴컴�"
? "�          20           �          21           �          22           �          23           �"
? "쳐컴컴컴컴컴컴컴컴컴컴컴쳐컴컴컴컴컴컴컴컴컴컴컴쳐컴컴컴컴컴컴컴컴컴컴컴쳐컴컴컴컴컴컴컴컴컴컴컴�"

RETURN

****************************************************************
PROCEDURE TrseciFuter

? "읕컴컴컴컴컴컴컴컴컴컴컴읕컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴�"

RETURN

****************************************************************
PROCEDURE TrseciTekst

? "�"+ Str(RPbez06,11,2)+"            "
?? "�"+ Str(RPbez2,11,2)+"            "
?? "�"+ Str(RPbez4,11,2)+"            "
?? "�"+ Str(RPn1,11,2)+"            �"

RETURN
****************************************************************
