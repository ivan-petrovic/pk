* Isto kao KPR11, samo stampa landscape
LOCAL red_po_str := 43
USE KPR
INDEX ON DRACKPR TO KPRDRAC
USE

* SETPRC(0,0)
SELECT 0
USE PPDAT INDEX PPINSIF
SELECT 0
USE KPR INDEX KPRDRAC
* USE kpr INDEX kprdk

DO WHILE .T.
   GO TOP

   DAT1 = Date()
   DAT2 = Date()
   wsif = Val("0000000000000")
   wz1  = Val("00000000.00")
   STORE wz1 TO wz20,wz21,wz22,wz23,wz111
   STORE wz1 TO wz2,wz3,wz4,wz5,wz6,wz7,wz8,wz9,wz10,wz11,wz12,wz13,wz14,wz15,wz16,wz17,wz18,wz19
   wUkupno = VAL("000000000000.00")

   CLEAR SCREEN
   @ 6,10 SAY "STAMPA KNJIGU KPR OD DATUMA" GET DAT1
   @ 6,57 SAY "DO DATUMA" GET DAT2
   READ

   IF Lastkey() = 27
      EXIT
   ENDIF

   SET CONSOLE OFF
   SET DEVICE TO PRINT
   * SET PRINT TO LPT1
   SET PRINT TO KPRPRN
   SET PRINT ON

   * Landscape ON
   ? Chr(27)+ Chr(69) + Chr(27) + "&l1o0e66f9D" + Chr(27) + "&a0l132M" + Chr(27)+ "(s13H"

   brst=1
   LevikprNaslov()
   LevokprZaglavlje()
   DO WHILE ! Eof()
      IF DTOS(DRACKPR) >= DTOS(DAT1) .AND. DTOS(DRACKPR) <= DTOS(DAT2)
         IF PROW() = red_po_str
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
         ELSE
            mImepp = Space(16)
            msedi  = Space(17)
         ENDIF

         SELECT KPR
         LevikprTekst()
         wz1 = Round(wz1 + ukspdv,2)
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
         IF PROW() = red_po_str
            IF !brst=0
               DesnikprFuter()
               EJECT
            ENDIF
            brst = brst + 1
            DesnokprZaglavlje()
         ENDIF
         DesnikprTekst()

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
   DesnikprFuter()

	* stampa zbirova
	? " " + STR(WZ8,11,2)
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
   EJECT

   * Landscape OFF
   ? Chr(27)+ Chr(69)

   SET PRINTER OFF
   SET PRINT TO
   SET DEVICE TO SCREEN
   SET CONSOLE ON
ENDDO

SELECT KPR
CLOSE KPR
SELECT PPDAT
CLOSE PPDAT

RUN prntxt.bat kprprn.prn

RETURN

*************************************************
