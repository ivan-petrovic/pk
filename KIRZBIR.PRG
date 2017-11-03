SELECT 0
USE KIR INDEX KIRDK

DO WHILE .T.

	WRBkir    = Val("0000")
	Wdatkkir  = Date()
	wbrrack   = Space(10)
	WdATrack  = Date()
	Wkupkir   = Val("000000")
	wpib      = Space(13)
	wuknakkir = Val("000000000.00")
	wosaod    = Val("000000000.00")
	wobezod   = Val("000000000.00")
	wosaodi   = Val("000000000.00")
	wobezodi  = Val("000000000.00")
	wosn18    = Val("000000000.00")
	wizn18    = Val("000000000.00")
	wosn8     = Val("000000000.00")
	wizn8     = Val("000000000.00")
	wuksib    = Val("000000000.00")
	wuks      = Val("000000000.00")
	dat1      = Date()
	dat2      = Date()

	CLEAR SCREEN
	@ 0,0 TO 24,79 DOUBLE
	@ 1,1 SAY Centriraj("ZBIROVI KNJIGE RASHODA", 78)
	
   @ 4,10 SAY "OD DATUMA: " GET DAT1
   @ 5,10 SAY "DO DATUMA: " GET DAT2
   READ

   IF Lastkey() =  27
      EXIT
   ENDIF

	* OVDE IZRACUNATI ZBIROVE
	SELECT KIR
	DO WHILE ! Eof()
		IF DATKKIR >= dat1 .AND. DATKKIR <= dat2
			wuknakkir = Round(wuknakkir + uknakkir,2)
			wosaod    = Round(wosaod + osaod,2)
			wobezod   = Round(wobezod + obezod,2)
			wosaodi   = Round(wosaodi + osaodi,2)
			wobezodi  = Round(wobezodi + obezodi,2)
			wosn18    = Round(wosn18 + osn18,2)
			wizn18    = Round(wizn18 + izn18,2)
			wosn8     = Round(wosn8 + osn8,2)
			wizn8     = Round(wizn8 + izn8,2)
			wuksib    = Round(wuksib + uksib,2)
			wuks      = Round(wuks + uks,2)
		ENDIF
		SKIP
	ENDDO
	*   KRAJ IZRACUNAVANJA ZBIROVA

	@ 8 , 5 SAY "UKUPNA NAKNADA SA PDV        "
	@ 8 ,35 SAY WUKNAKKIR PICTURE "999999999.99"
	@ 9 , 5 SAY "OSLOBODJEN PROMETA SA PRAVOM "
	@ 10, 5 SAY "ODBITKA PRED.POREZA (24. T.7)"
	@ 10,35 SAY WOSAOD PICTURE "999999999.99"
	@ 12, 5 SAY "OSLOBODJEN PROMETA BEZ PRAVA "
	@ 13, 5 SAY "ODBITKA PRED.POREZA (23. T.9)"
	@ 13,35 SAY WOBEZOD PICTURE "999999999.99"
	@ 15, 5 SAY "INOS. POS.PRAVO. NA PRED.PDV "
	@ 15,35 SAY WOSAODI PICTURE "999999999.99"
	@ 16, 5 SAY "INOS.NE PRAVO NA PREDHOD.PDV "
	@ 16,35 SAY WOBEZODI PICTURE "999999999.99"
	@ 17, 5 SAY "OSNOVICA PO STOPI OD 18 %    "
	@ 17,35 SAY WOSN18 PICTURE "999999999.99"
	@ 18, 5 SAY "IZNOS PDV PO STOPI OD 18 %   "
	@ 18,35 SAY WIZN18 PICTURE "999999999.99"
	@ 19, 5 SAY "OSNOVICA PO STOPI OD  8 %    "
	@ 19,35 SAY WOSN8 PICTURE "999999999.99"
	@ 20, 5 SAY "IZNOS PDV PO STOPI OD  8 %   "
	@ 20,35 SAY WIZN8 PICTURE "999999999.99"
	@ 21, 5 SAY "UK.PROMET DOB.I US.SA P. I BP"
	@ 21,35 SAY WUKSIB PICTURE "999999999.99"
	@ 22, 5 SAY "UK.PROMET SA PRAVOM NA ODBIT."
	@ 22,35 SAY WUKS PICTURE "999999999.99"
	WAIT " "

	EXIT

ENDDO

CLOSE DATABASES

RETURN
