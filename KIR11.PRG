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
? "ÚÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
? "³    ³          ³                    RACUNI ILI DRUGI DOKUMENT                                   ³  OSLOBODJENI PROMET   ³"
? "³    ³          ÃÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ´"
? "³RED ³ DATUM    ³        ³ DATUM    ³                 KUPAC                          ³           ³Oslobodjen ³Oslobodjen ³"
? "³ BR.³ KNJIZENJA³ BROJ   ³IZDAVANJA ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ´           ³promet sa  ³promet bez ³"
? "³    ³          ³ RACUNA ³RACUNA ILI³  NAZIV ( IME I SEDISTE )         ³  PIB  ILI   ³UKUPNA NAK ³pravom na  ³prava na   ³"
? "³    ³          ³        ³DRUGOG DO-³                                  ³    JMBG     ³NADA  SA   ³odbitak pre³odbitak pr.³"
? "³    ³          ³        ³KUMENTA   ³                                  ³             ³  PDV      ³thodnog po.³cl.25.Zak. ³"
? "³    ³          ³        ³          ³                                  ³             ³           ³i dr.os.pr.³ tac. 9    ³"
? "³    ³          ³        ³          ³                                  ³             ³           ³           ³           ³"
? "³    ³          ³        ³          ³                                  ³             ³           ³           ³           ³"
? "³    ³          ³        ³          ³                                  ³             ³           ³           ³           ³"
? "³    ³          ³        ³          ³                                  ³             ³           ³           ³           ³"
? "ÃÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄ´"
? "³  1 ³   2      ³    3   ³    4     ³                5                 ³      6      ³     7     ³     8     ³     9     ³"
? "ÃÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄ´"

RETURN

*************************************************
PROCEDURE LevikirTekst

 ? "³"+STR(rbkir,4,0)
?? "³"+DTOC(datkkir)
?? "³"+SUBSTR(BRRACKiR,1,8)
?? "³"+DTOC(datrackir)
?? "³"+SUBSTR(mImepp,1,16) +" "+SUBSTR(mSedi,1,17)
?? "³"+SUBSTR(PIBjmbgKiR,1,13)
?? "³"+STR(uknakkir,11,2)
?? "³"+STR(osaod,11,2)
?? "³"+STR(obezod,11,2)+"³"

RETURN

*************************************************
PROCEDURE LevikirFuter

? "ÀÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÙ"

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
? "ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿"
? "³ OSLOBODJENI PROMET    ³            OPOREZIVI  PROMET                  ³Ukupan     ³Ukupan     ³"
? "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´promet dob-³promet dob-³"
? "³PROMET U INOSTRANSTVU  ³  PO STOPI OD 18 %     ³  PO STOPI OD 8 %      ³ara i uslu-³ara i uslu-³"
? "ÃÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ´ga sa prav-³ga sa prav-³"
? "³Za koji bi ³Za koji ne ³           ³           ³           ³           ³om i bez   ³om na odbi-³"
? "³postojlo   ³bi postoja.³           ³           ³           ³           ³prava na   ³tak pretho-³"
? "³pravo na   ³pravo na   ³Osnovica   ³ Iznos     ³  Osnovica ³  Iznos    ³odbitak pre³dnog poreza³"
? "³prethodni  ³prethodni  ³ tac. 3    ³  PDV      ³  tac. 4   ³   PDV     ³thodnog por³bez PDV    ³"
? "³porez da je³porez da je³           ³ tac. 5    ³           ³  tac. 6   ³eza bez PDV³           ³"
? "³promet izv-³promet izv-³           ³           ³           ³           ³(8 do 11   ³(8 + 10 +  ³"
? "³rsen u zem.³rsen u zem.³           ³           ³           ³           ³+ 12 + 14) ³+ 12 + 14) ³"
? "³tac. 8     ³tac. 10    ³           ³           ³           ³           ³           ³           ³"
? "ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄ´"
? "³    10     ³    11     ³    12     ³     13    ³    14     ³    15     ³   16      ³    17     ³"
? "ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄ´"

RETURN

*************************************************
PROCEDURE DesnikirFuter

? "ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÙ"

RETURN

*************************************************
PROCEDURE DesnikirTekst

 ? "³"+ STR(osaodi,11,2)
?? "³"+ STR(obezodi,11,2)
?? "³"+ STR(osn18,11,2)
?? "³"+ STR(izn18,11,2)
?? "³"+ STR(osn8,11,2)
?? "³"+ STR(izn8,11,2)
?? "³"+ STR(uksib,11,2)
?? "³"+ STR(uks,11,2)+"³"

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
PROCEDURE kir3ciFuter

? "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

RETURN

*************************************************
PROCEDURE kir3ciTekst

?  "³"+ STR(RPbez06,11,2)+"            "
?? "³"+ STR(RPbez2,11,2)+"            "
?? "³"+ STR(RPbez4,11,2)+"            "
?? "³"+ STR(RPn1,11,2)+"            ³"

RETURN

*************************************************
