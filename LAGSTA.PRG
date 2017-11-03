LOCAL DN, Nivo, wSiOp, indd, ind, wBr, SumaM, SumaD, pom, pom1

SELECT 1
USE ARTPANE INDEX APINSIF

DO WHILE .T.

	SumaM = Val("0000000000.00")
	SumaD = Val("0000000000000000.00")
	Nivo = Val("0")
	indd = 0
	wSiOp = Val("00")
	DN = " "

	MainMask("VREDNOST LAGERA PO MALOPRODAJNIM CENAMA")
	@ 10,15 SAY "TRENUTNO STANJE LAGERA  (D/N)? " GET DN PICTURE "!" VALID(DN $ "DdNn")
	READ

	IF Lastkey() = 27
	   EXIT
	ENDIF

	IF DN = "N"
		EXIT
	ENDIF
	
	@ 12,15 SAY "UNESITE NIVO LAGERA (BROJ PRODAVNICE) " GET Nivo PICTURE "9" RANGE 0,9
	@ 14,15 SAY "UNESITE GRUPU U OKVIRU LAGERA         " GET wSiOp PICTURE "99" RANGE 0,99
	READ

	IF Lastkey() = 27
   	EXIT
	ENDIF

	IF Nivo = 0 .and. wSiOp = 0
   	indd = 1
	ENDIF
	IF Nivo = 0 .and. wSiOp > 0
   	indd = 4
	ENDIF
	IF Nivo > 0 .and. wSiOp = 0
   	indd = 2
	ENDIF
	IF Nivo > 0 .and. wSiOp > 0
   	indd = 3
	ENDIF

	wBr = Val("0000000")
	ind = 0

	DO WHILE .T.
		IF Eof()
			ind = 1
			EXIT
		ENDIF

		IF ARTKOL = 0
			SKIP
			LOOP
		ENDIF

		IF indd = 1
			SumaM = SumaM + (ARTCEN * ARTKOL)
			SumaD = SumaD + (ARTCEN * gnBod * ARTKOL)
			wBr = wBr + 1
		ENDIF

		IF indd = 4
			IF wSiOp = SIOP
				SumaM = SumaM + (ARTCEN * ARTKOL)
				SumaD = SumaD + (ARTCEN * gnBod * ARTKOL)
				wBr = wBr + 1
			ENDIF
		ENDIF

		IF indd = 2
			pom = Str(ARTSIF,13,0)
			pom1 = Ltrim(pom)
			pom1 = Substr(pom1,1,1)
			IF Val(pom1) = Nivo
				SumaM = SumaM + (ARTCEN * ARTKOL)
				SumaD = SumaD + (ARTCEN * gnBod * ARTKOL)
				wBr = wBr + 1
			ENDIF
		ENDIF

		IF indd = 3
			pom = Str(ARTSIF,13,0)
			pom1 = Ltrim(pom)
			pom1 = Substr(pom1,1,1)
			IF Val(pom1) = Nivo .and. SIOP = wSiOp
				SumaM = SumaM + (ARTCEN * ARTKOL)
				SumaD = SumaD + (ARTCEN * gnBod * ARTKOL)
				wBr = wBr + 1
			ENDIF
		ENDIF

		SKIP
   ENDDO

	IF ind = 1
		MainMask("TRENUTNO STANJE VASEG LAGERA JE SLEDECE")
		@ 10,15 SAY "DAN"
		@ 10,35 SAY Date()
		@ 12,15 SAY "VREME"
		@ 12,35 SAY Time()
		@ 14,15 SAY "BROJ ARTIKAL"
		@ 14,35 SAY wBr PICTURE "9999999"
		@ 16,15 SAY "VREDNOST U MARKAMA"
		@ 16,35 SAY SumaM PICTURE "9,999,999,999.99"
		@ 18,15 SAY "VREDNOST U DINARIMA"
		@ 18,35 SAY SumaD PICTURE "999,999,999,999,999.99"
		@ 23,30 SAY "Bilo sta za nastavak ..."
		WAIT " "
		@ 23,20 SAY Replicate(" ",48)
		EXIT
	ENDIF

ENDDO

CLOSE DATABASES

RETURN
