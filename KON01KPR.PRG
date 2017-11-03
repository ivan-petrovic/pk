*************************************************
* Kontrola baze KPR - Pera
*************************************************

LOCAL lIzmenio := .T.

DO WHILE .T.
   OdDatum = DATE()
   DoDatum = DATE()
   nUslov = 1 
   
   MainMask("KONTROLA KPR PERA")
   @ 09,10 SAY "Uslov 1: UKSPDV - NPDV - VDU = UKPPDV"
   @ 10,10 SAY "Uslov 2: UKPPDV - ODPDV - NEODPDV = 0"
   @ 12,10 SAY "Uslov (1/2): " GET nUslov PICTURE "9"
   @ 13,10 SAY "OD DATUMA: " GET OdDatum VALID !EMPTY(OdDatum)
   @ 14,10 SAY "DO DATUMA: " GET DoDatum VALID !EMPTY(DoDatum)
   READ
   
   IF LASTKEY() = 27
      RETURN
   ENDIF
   
   IF OdDatum > DoDatum
      MessageBox("POCETNI DATUM VECI OD KRAJNJEG")
      LOOP
   ENDIF
   
   EXIT
ENDDO

SELECT 0
USE KPR INDEX KPRDRAC

Form_KON01(.T.)

SET KEY -9 TO F10_KON01KPR

DO WHILE lIzmenio
   lIzmenio = m_type("kon01kpr.prn",78)
ENDDO

SET KEY -9 TO

CLOSE DATABASES
RETURN

*************************************************
PROCEDURE F10_KON01KPR

	Form_KON01(.F.)

RETURN

*************************************************
PROCEDURE Form_KON01(lToFile)

	SET DEVICE TO PRINT
	IF(lToFile)
		SET PRINT TO kon01kpr
	ELSE
		SET PRINT TO LPT1
	ENDIF
	SET PRINT ON

   cDivLine = Replicate("*",78)
	? cDivLine
   ?
   ? "KONTROLA KPR-a"
   ?
   ? cDivLine
   ?
   IF nUslov = 1
      ? "Uslov 1: UKSPDV - NPDV - VDU = UKPPDV"
   ELSE
      ? "Uslov 2: UKPPDV - ODPDV - NEODPDV = 0"
   ENDIF
   ?
   ? cDivLine   

	GO TOP
	DO WHILE ! Eof()
      IF DTOS(DRACKPR) < DTOS(OdDatum) .OR. DTOS(DRACKPR) > DTOS(DoDatum)
         SKIP
         LOOP
      ENDIF
      
      IF nUslov = 1
         IF Round(UKSPDV - NPDV - VDU - UKPPDV,0) <> 0 
            ? Space(3)
            ?? DRACKPR
            ?? Space(3) + BRACKPR + Space(5)
            ?? UKSPDV - NPDV - VDU - UKPPDV 
         ENDIF
      ELSE      
         IF Round(UKPPDV - ODPDV - NEODPDV,0) <> 0
            ? Space(3)
            ?? DRACKPR
            ?? Space(3) + BRACKPR + Space(5)
            ?? UKPPDV - ODPDV - NEODPDV 
         ENDIF
      ENDIF
		SKIP
	ENDDO

   ?   
   ? cDivLine
	EJECT

	SET DEVICE TO SCREEN
	SET PRINT OFF

RETURN
*************************************************
