SETPRC(0,0)

SELECT 0
USE PPDAT INDEX PPINSIF

SELECT 0
USE KIR INDEX KIRDK

DO WHILE .T.

   GO TOP
   DAT1 = Date()
   DAT2 = Date()
   wsif = Val("0000000000000")
   wz1  = Val("00000000.00")
   STORE wz1 TO wz20,wz21,wz22,wz23,wz111
   STORE wz1 TO wz2,wz3,wz4,wz5,wz6,wz7,wz8,wz9,wz10,wz11,wz12,wz13,wz14,wz15,wz16,wz17,wz18,wz19
   wUKUPNO = Val("000000000000.00")

	CLEAR SCREEN
	@ 0,0 TO 24,79 DOUBLE
	@ 1,1 SAY Centriraj("STAMPA KNJIGU KIR", 78)

   @ 6,10 SAY "OD DATUMA: " GET DAT1
   @ 7,10 SAY "DO DATUMA: " GET DAT2
   READ

   IF Lastkey() = 27
      EXIT
   ENDIF

   SET CONSOLE OFF
   SET DEVICE TO PRINT
   SET PRINT TO LPT1
   SET PRINT ON

   IF lLaser
      @ 0,0 SAY Chr(27) + '(s17.5H'      && kondenz On za laserski
   ELSE
      @ 0,0 SAY Chr(15)                  && kondenz On za matricni
   ENDIF
   SetPrc(0,0)

	brst=1
	LevikirNaslov()
	LevokirZaglavlje()
	DO WHILE ! Eof()
		IF DTOS(datkkir) >= DTOS(DAT1) .AND. DTOS(datkkir) <= DTOS(DAT2)
			IF PROW() = 65
				IF !brst=0
					LevikirFuter()
					EJECT
				ENDIF
				brst = brst + 1
				LevokirZaglavlje()
			ENDIF
			* UBACENO ZA PPDAT (IME I SEDISTE)
			SELECT PPDAT
			SEEK KIR->KUPKIR
			IF Found()
				mImepp = PPNAZ
				msedi  = PPMES
			ELSE
				mImepp = Space(16)
				msedi  = Space(17)
			ENDIF
			SELECT KIR
			* KRAJ UBACENOG ZA PPDAT 8IME I SEDISTE)
			LevikirTekst()
			wz1 = Round(wz1 + uknakkir,2)
			wz2 = Round(wz2 + osaod,2)
			wz3 = Round(wz3 + obezod,2)
		ENDIF
		SKIP
	ENDDO

   LevikirFuter()
	* stampa zbirova
	 ? " "+Space(84)
	?? " "+STR(WZ1,11,2)
	?? " "+STR(WZ2,11,2)
	?? " "+STR(WZ3,11,2)
	* kraj stampe zbirova
   EJECT

	brst=1
	DesnikirNaslov()
	DesnokirZaglavlje()
	GO TOP
	DO WHILE ! Eof()
		IF DTOS(datkkir) >= DTOS(DAT1) .AND. DTOS(datkkir) <= DTOS(DAT2)
			IF PROW() = 65
				IF !brst=0
					DesnikirFuter()
					EJECT
				ENDIF
				brst = brst + 1
				DesnokirZaglavlje()
			ENDIF
			
			DesnikirTekst()
			wz10 = Round(wz10 + osaodi,2)
			wz11 = Round(wz11 + obezodi,2)
			wz12 = Round(wz12 + osn18,2)
			wz13 = Round(wz13 + izn18,2)
			wz14 = Round(wz14 + osn8,2)
			wz15 = Round(wz15 + izn8,2)
			wz16 = Round(wz16 + uksib,2)
			wz17 = Round(wz17 + uks,2)
		ENDIF
		SKIP
	ENDDO

   DesnikirFuter()
	* STAMPA ZBIROVA
	 ? " "+ STR(WZ10,11,2)
	?? " "+ STR(WZ11,11,2)
	?? " "+ STR(WZ12,11,2)
	?? " "+ STR(WZ13,11,2)
	?? " "+ STR(WZ14,11,2)
	?? " "+ STR(WZ15,11,2)
	?? " "+ STR(WZ16,11,2)
	?? " "+ STR(WZ17,10,2)

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

SELECT KIR
CLOSE KIR
SELECT PPDAT
CLOSE PPDAT

RETURN

*************************************************
PROCEDURE LevikirNaslov

? Space(40) + "KNJIGA  K I R    OD  " + DTOC(DAT1) + "  DO  " + DTOC(DAT2)+ "                          strana" + STR(BRST,3,0)
? "Poreski obveznik: "+gcPrez_Ime     && vlasnik
? "Mesto: "+RTRIM(gcMesto)+" "+gcAdresa
? "Naziv radnje : "+gcNazRad

RETURN


*************************************************
PROCEDURE LevokirZaglavlje

? Space(88) + "                         strana" + STR(BRST,3,0)
? "旼컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴커"
? "�    �          �                    RACUNI ILI DRUGI DOKUMENT                                   �  OSLOBODJENI PROMET   �"
? "�    �          쳐컴컴컴컫컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컵컴컴컴컴컴컫컴컴컴컴컴캑"
? "쿝ED � DATUM    �        � DATUM    �                 KUPAC                          �           쿚slobodjen 쿚slobodjen �"
? "� BR.� KNJIZENJA� BROJ   쿔ZDAVANJA 쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴캑           쿾romet sa  쿾romet bez �"
? "�    �          � RACUNA 쿝ACUNA ILI�  NAZIV ( IME I SEDISTE )         �  PIB  ILI   쿢KUPNA NAK 쿾ravom na  쿾rava na   �"
? "�    �          �        쿏RUGOG DO-�                                  �    JMBG     쿙ADA  SA   쿽dbitak pre쿽dbitak pr.�"
? "�    �          �        쿖UMENTA   �                                  �             �  PDV      퀃hodnog po.쿬l.25.Zak. �"
? "�    �          �        �          �                                  �             �           쿶 dr.os.pr.� tac. 9    �"
? "�    �          �        �          �                                  �             �           �           �           �"
? "�    �          �        �          �                                  �             �           �           �           �"
? "�    �          �        �          �                                  �             �           �           �           �"
? "�    �          �        �          �                                  �             �           �           �           �"
? "쳐컴컵컴컴컴컴컴탠컴컴컴컵컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컵컴컴컴컴컴컴컵컴컴컴컴컴컵컴컴컴컴컴컵컴컴컴컴컴캑"
? "�  1 �   2      �    3   �    4     �                5                 �      6      �     7     �     8     �     9     �"
? "쳐컴컵컴컴컴컴컴탠컴컴컴컵컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컵컴컴컴컴컴컴컵컴컴컴컴컴컵컴컴컴컴컴컵컴컴컴컴컴캑"

RETURN

*************************************************
PROCEDURE LevikirTekst

 ? "�"+STR(rbkir,4,0)
?? "�"+DTOC(datkkir)
?? "�"+SUBSTR(BRRACKiR,1,8)
?? "�"+DTOC(datrackir)
?? "�"+SUBSTR(mImepp,1,16) +" "+SUBSTR(mSedi,1,17)
?? "�"+SUBSTR(PIBjmbgKiR,1,13)
?? "�"+STR(uknakkir,11,2)
?? "�"+STR(osaod,11,2)
?? "�"+STR(obezod,11,2)+"�"

RETURN

*************************************************
PROCEDURE LevikirFuter

? "읕컴컨컴컴컴컴컴좔컴컴컴컨컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컨컴컴컴컴컴컨컴컴컴컴컴컨컴컴컴컴컴켸"

RETURN

*************************************************
PROCEDURE DesnikirNaslov

? Space(40) + "KNJIGA KIR  OD  " + DTOC(DAT1) + "  DO  " + DTOC(DAT2)+ "                                  strana" + STR(BRST,3,0)
? "Poreski obveznik: " + gcPrez_Ime
? "Mesto: "+RTRIM(gcMesto) + " " + gcAdresa
? "Naziv radnje : " + gcNazRad

RETURN

*************************************************
PROCEDURE DesnokirZaglavlje

? Space(88) + "strana" + STR(BRST,3,0)
? "컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴쩡컴컴컴컴컴�"
? "� OSLOBODJENI PROMET    �            OPOREZIVI  PROMET                  쿢kupan     쿢kupan     �"
? "旼컴컴컴컴컴컴컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴큣romet dob-쿾romet dob-�"
? "쿛ROMET U INOSTRANSTVU  �  PO STOPI OD 18 %     �  PO STOPI OD 8 %      쿪ra i uslu-쿪ra i uslu-�"
? "쳐컴컴컴컴컴쩡컴컴컴컴컴탠컴컴컴컴컴쩡컴컴컴컴컴탠컴컴컴컴컴쩡컴컴컴컴컴큙a sa prav-쿲a sa prav-�"
? "쿩a koji bi 쿩a koji ne �           �           �           �           쿽m i bez   쿽m na odbi-�"
? "쿾ostojlo   쿫i postoja.�           �           �           �           쿾rava na   퀃ak pretho-�"
? "쿾ravo na   쿾ravo na   쿚snovica   � Iznos     �  Osnovica �  Iznos    쿽dbitak pre쿭nog poreza�"
? "쿾rethodni  쿾rethodni  � tac. 3    �  PDV      �  tac. 4   �   PDV     퀃hodnog por쿫ez PDV    �"
? "쿾orez da je쿾orez da je�           � tac. 5    �           �  tac. 6   쿮za bez PDV�           �"
? "쿾romet izv-쿾romet izv-�           �           �           �           �(8 do 11   �(8 + 10 +  �"
? "퀁sen u zem.퀁sen u zem.�           �           �           �           �+ 12 + 14) �+ 12 + 14) �"
? "퀃ac. 8     퀃ac. 10    �           �           �           �           �           �           �"
? "쳐컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴�"
? "�    10     �    11     �    12     �     13    �    14     �    15     �   16      �    17     �"
? "쳐컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴탠컴컴컴컴컴�"

RETURN

*************************************************
PROCEDURE DesnikirFuter

? "읕컴컴컴컴컴좔컴컴컴컴컴좔컴컴컴컴컴좔컴컴컴컴컴좔컴컴컴컴컴좔컴컴컴컴컴좔컴컴컴컴컴좔컴컴컴컴컴�"

RETURN

*************************************************
PROCEDURE DesnikirTekst

 ? "�"+ STR(osaodi,11,2)
?? "�"+ STR(obezodi,11,2)
?? "�"+ STR(osn18,11,2)
?? "�"+ STR(izn18,11,2)
?? "�"+ STR(osn8,11,2)
?? "�"+ STR(izn8,11,2)
?? "�"+ STR(uksib,11,2)
?? "�"+ STR(uks,11,2)+"�"

RETURN

*************************************************
PROCEDURE kir3ciNaslov

? Space(40) + "KNJIGA PRIHOD-RASHOD  OD  " + DTOC(DAT1) + "  DO  " + DTOC(DAT2)+ "                          strana  " + STR(BRST,3,0)
? "Poreski obveznik: "+gcPrez_Ime     && vlasnik
? "Mesto: "+RTRIM(gcMesto)+" "+gcAdresa
? "Naziv radnje : "+gcNazRad

RETURN

*************************************************
PROCEDURE kir3ceZaglavlje

? Space(88) + "                                  strana  " + STR(BRST,3,0)
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
PROCEDURE kir3ciFuter

? "읕컴컴컴컴컴컴컴컴컴컴컴읕컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴�"

RETURN

*************************************************
PROCEDURE kir3ciTekst

?  "�"+ STR(RPbez06,11,2)+"            "
?? "�"+ STR(RPbez2,11,2)+"            "
?? "�"+ STR(RPbez4,11,2)+"            "
?? "�"+ STR(RPn1,11,2)+"            �"

RETURN

*************************************************
