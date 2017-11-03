LOCAL control_str, nMaxRow := 92, lPrviProlaz := .T.
LOCAL nBrojStr :=0, nStrOd := 0, nStrDo := 99999, nTekRed := 0

USE KPR
INDEX ON DRACKPR TO KPRDRAC
USE

SELECT 0
USE PPDAT INDEX PPINSIF
SELECT 0
USE KPR INDEX KPRDRAC

DO WHILE .T.
   GO TOP

   wZ1  = Val("00000000.00")
   STORE wz1 TO wz8,wz9,wz10,wz11,wz12,wz13,wz14,wz15,wz16,wz17,wz18

   IF lPrviProlaz
      Dat1 = Date()
      Dat2 = Date()

      MainMask("STAMPA KNJIGE KPR")
      @ 6,10 SAY "Od datuma: " GET Dat1
      @ 7,10 SAY "Do datuma: " GET Dat2
      READ

      IF Lastkey() = 27 ; EXIT ; ENDIF
   ELSE
      MainMask("STAMPA KNJIGE KPR")
      @ 5,10 SAY "Stana 1 - " + Str(nBrojStr)
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
      * SET PRINT TO LISTA
   ENDIF

   SET PRINT ON
   IF lLaser
      control_str = Chr(27) + '(s17H' + Chr(27) + '&l5C'
      @ 0,0 SAY control_str              && kondenz On za laserski
   ELSE
      @ 0,0 SAY Chr(15)                  && kondenz On za matricni
   ENDIF
   SetPrc(0,0)

   brst = 1
   nTekRed = 1

   IF brst >= nStrOd .AND. brst <= nStrDo
      LeviKprNaslov()
      LevoKprZaglavlje()
   ENDIF
   nTekRed = 18
   DO WHILE ! Eof()
      IF DTOS(DRACKPR) >= DtoS(Dat1) .AND. DtoS(DRACKPR) <= DtoS(Dat2)
         IF nTekRed = nMaxRow
            IF !brst=0
               IF brst >= nStrOd .AND. brst <= nStrDo
                  LevikprFuter()
                  EJECT
               ENDIF
               nTekRed = 1
            ENDIF
            brst = brst + 1
            IF brst >= nStrOd .AND. brst <= nStrDo
               LevokprZaglavlje()
            ENDIF
            nTekRed = 14
         ENDIF

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
         IF brst >= nStrOd .AND. brst <= nStrDo
            LevikprTekst()
         ENDIF
         nTekRed = nTekRed + 1
         wz1 = Round(wz1 + ukspdv,2)
      ENDIF
      SKIP
   ENDDO
   LeviKprFuter()

 	? Space(110) + Str(WZ1,16,2)      && stampa zbirova
   EJECT

   brst = 1
   nTekRed = 1

   IF brst >= nStrOd .AND. brst <= nStrDo
      DesnikprNaslov()
      DesnokprZaglavlje()
   ENDIF
   nTekRed = 18
   GO TOP
   DO WHILE ! Eof()
      IF DtoS(DRACKPR) >= DtoS(Dat1) .AND. DtoS(DRACKPR) <= DtoS(Dat2)
         IF nTekRed = nMaxRow
            IF !brst=0
               IF brst >= nStrOd .AND. brst <= nStrDo
                  DesnikprFuter()
                  EJECT
               ENDIF
               nTekRed = 1
            ENDIF
            brst = brst + 1
            IF brst >= nStrOd .AND. brst <= nStrDo
               DesnokprZaglavlje()
            ENDIF
            nTekRed = 14
         ENDIF
         
         IF brst >= nStrOd .AND. brst <= nStrDo
            DesnikprTekst()
         ENDIF
         nTekRed = nTekRed + 1

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

	?  " " + Str(WZ8,11,2)       && stampa zbirova
	?? " " + Str(WZ9,11,2)
	?? " " + Str(WZ11,11,2)
	?? " " + Str(WZ10,11,2)
	?? " " + Str(WZ12,11,2)
	?? " " + Str(WZ13,11,2)
	?? " " + Str(WZ14,11,2)
	?? " " + Str(WZ15,10,2)
	?? " " + Str(WZ16,10,2)
	?? " " + Str(WZ17,10,2)
	?? " " + Str(WZ18,10,2)

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
