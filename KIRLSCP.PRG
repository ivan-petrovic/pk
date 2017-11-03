* Isto kao KIR11, samo stampa landscape
* SETPRC(0,0)
LOCAL red_po_str := 43

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
   * SET PRINT TO LPT1
   SET PRINT TO KIRPRN
   SET PRINT ON

   * Landscape ON
   ? Chr(27)+ Chr(69) + Chr(27) + "&l1o0e66f9D" + Chr(27) + "&a0l132M" + Chr(27)+ "(s13H"

	brst=1
	LevikirNaslov()
	LevokirZaglavlje()
	DO WHILE ! Eof()
		IF DTOS(datkkir) >= DTOS(DAT1) .AND. DTOS(datkkir) <= DTOS(DAT2)
			IF PROW() = red_po_str
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
			IF PROW() = red_po_str
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
	EJECT

   * Landscape OFF
   ? Chr(27)+ Chr(69)

	SET PRINTER OFF
	SET PRINT TO
	SET DEVICE TO SCREEN
	SET CONSOLE ON

ENDDO

SELECT KIR
CLOSE KIR
SELECT PPDAT
CLOSE PPDAT

RUN prntxt.bat kirprn.prn

RETURN

*************************************************
