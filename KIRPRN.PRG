LOCAL control_str, nMaxRow := 92, lPrviProlaz := .T.
LOCAL nBrojStr :=0, nStrOd := 0, nStrDo := 99999, nTekRed := 0

SELECT 0
USE PPDAT INDEX PPINSIF
SELECT 0
USE KIR INDEX KIRDK

DO WHILE .T.

   GO TOP

   wz1  = Val("00000000.00")
   STORE wz1 TO wz2,wz3,wz10,wz11,wz12,wz13,wz14,wz15,wz16,wz17

   IF lPrviProlaz
      Dat1 = Date()
      Dat2 = Date()

   	MainMask("STAMPA KNJIGE KIR")
      @ 6,10 SAY "Od datuma: " GET DAT1
      @ 7,10 SAY "Do datuma: " GET DAT2
      READ

      IF Lastkey() = 27 ; EXIT ; ENDIF
   ELSE
   	MainMask("STAMPA KNJIGE KIR")
   	@ 5,10 SAY "Strana 1 - " + Str(nBrojStr)
      @ 6,10 SAY "Od strane: " GET nStrOd PICTURE "99999"
      @ 7,10 SAY "Do strane: " GET nStrDo PICTURE "99999"
      READ

      IF Lastkey() = 27 ; EXIT ; ENDIF
   ENDIF

   SET CONSOLE OFF
   SET DEVICE TO PRINT

   IF lPrviProlaz
      SET PRINT TO LISTA
   ELSE
      SET PRINT TO LPT1
   ENDIF

   SET PRINT ON
   IF lLaser
      control_str = Chr(27) + '(s17H' + Chr(27) + '&l5C'
      @ 0,0 SAY control_str              && kondenz On za laserski
   ELSE
      @ 0,0 SAY Chr(15)                  && kondenz On za matricni
   ENDIF
   SetPrc(0,0)

	brst=1
	nTekRed = 1
	
   IF brst >= nStrOd .AND. brst <= nStrDo
   	LevikirNaslov()
   	LevokirZaglavlje()
   ENDIF
   nTekRed = 22
	DO WHILE ! Eof()
		IF DtoS(DATKKIR) >= DtoS(DAT1) .AND. DtoS(DATKKIR) <= DtoS(DAT2)
			IF nTekRed = nMaxRow
				IF !brst=0
               IF brst >= nStrOd .AND. brst <= nStrDo
                  LevikirFuter()
                  EJECT
               ENDIF
               nTekRed = 1
				ENDIF
				brst = brst + 1
				IF brst >= nStrOd .AND. brst <= nStrDo
               LevokirZaglavlje()
            ENDIF
            nTekRed = 18
			ENDIF

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
         IF brst >= nStrOd .AND. brst <= nStrDo
			   LevikirTekst()
         ENDIF
         nTekRed = nTekRed + 1
			wz1 = Round(wz1 + uknakkir,2)
			wz2 = Round(wz2 + osaod,2)
			wz3 = Round(wz3 + obezod,2)
		ENDIF
		SKIP
	ENDDO
   LevikirFuter()

	 ? " " + Space(84)
	?? " " + Str(WZ1,11,2)
	?? " " + Str(WZ2,11,2)
	?? " " + Str(WZ3,11,2)

   EJECT

	brst=1
	nTekRed = 1
	
	IF brst >= nStrOd .AND. brst <= nStrDo
      DesnikirNaslov()
      DesnokirZaglavlje()
   ENDIF
   nTekRed = 22
	GO TOP
	DO WHILE ! Eof()
		IF DtoS(DATKKIR) >= DtoS(DAT1) .AND. DtoS(DATKKIR) <= DtoS(DAT2)
			IF nTekRed = nMaxRow
				IF !brst=0
               IF brst >= nStrOd .AND. brst <= nStrDo
                  DesnikirFuter()
                  EJECT
               ENDIF
               nTekRed = 1
				ENDIF
				brst = brst + 1
				IF brst >= nStrOd .AND. brst <= nStrDo
               DesnokirZaglavlje()
            ENDIF
            nTekRed = 18
			ENDIF

         IF brst >= nStrOd .AND. brst <= nStrDo
            DesnikirTekst()
			ENDIF
			nTekRed = nTekRed + 1
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

	 ? " "+ Str(WZ10,11,2)
	?? " "+ Str(WZ11,11,2)
	?? " "+ Str(WZ12,11,2)
	?? " "+ Str(WZ13,11,2)
	?? " "+ Str(WZ14,11,2)
	?? " "+ Str(WZ15,11,2)
	?? " "+ Str(WZ16,11,2)
	?? " "+ Str(WZ17,10,2)

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

   IF lPrviProlaz
      nBrojStr = brst
      lPrviProlaz = .F.
      LOOP
   ELSE
      lPrviProlaz = .T.
   ENDIF

ENDDO

CLOSE DATABASES
RETURN
