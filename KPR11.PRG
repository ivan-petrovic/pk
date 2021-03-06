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
*************************************************

*************************************************
PROCEDURE LevikprTekst

 ? "�"+STR(rbkpr,4,0)
?? "�"+DTOC(DKKPR)
?? "�"+DTOC(dppvdkpr)
?? "�"+SUBSTR(BRKAL,1,10)
?? "�"+SUBSTR(BRACKPR,1,10)
?? "�"+DTOC(drackpr)
?? "�"+SUBSTR(mImepp,1,16) +" "+SUBSTR(mSedi,1,17)
?? "�"+SUBSTR(PIBKPR,1,13)
?? "�"+STR(ukspdv,16,2)+"�"

RETURN
*************************************************

*************************************************
PROCEDURE LevikprFuter

? "읕컴컨컴컴컴컴컴좔컴컴컴컴컨컴컴컴컴컴좔컴컴컴컴컨컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴�"

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
*************************************************

*************************************************
PROCEDURE DesnikprFuter

? "읕컴컴컴컴컴좔컴컴컴컴컴좔컴컴컴컴컴좔컴컴컴컴컴좔컴컴컴컴컴좔컴컴컴컴컴좔컴컴컴컴컴좔컴컴컴컴컨컴컴컴컴컴좔컴컴컴컴컨컴컴컴컴컴�"

RETURN
*************************************************

*************************************************
PROCEDURE DesnikprTekst

 ? "�"+ STR(UKSPDV1,11,2)
?? "�"+ STR(OSLPDV,11,2)
?? "�"+ STR(UVOZN,11,2)
?? "�"+ STR(NPDV,11,2)
?? "�"+ STR(UKPPDV,11,2)
?? "�"+ STR(ODPDV,11,2)
?? "�"+ STR(NEODPDV,11,2)
?? "�"+ STR(VBEZPDVU,10,2)
?? "�"+ STR(IZNPDVU,10,2)
?? "�"+ STR(VDU,10,2)
?? "�"+ STR(IZNN5,10,2)+"�"

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
*************************************************

*************************************************
PROCEDURE kpr3ciFuter

? "읕컴컴컴컴컴컴컴컴컴컴컴읕컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴�"

RETURN
*************************************************

*************************************************
PROCEDURE kpr3ciTekst

? "�"+ STR(RPbez06,11,2)+"            "
?? "�"+ STR(RPbez2,11,2)+"            "
?? "�"+ STR(RPbez4,11,2)+"            "
?? "�"+ STR(RPn1,11,2)+"            �"

RETURN
*************************************************
