*************************************************
* DPU - List dnevnog prometa ugostitelja
*************************************************

LOCAL lIzmenio := .T.

PRIVATE wDat1

IF File("DMPINSIF.NTX")
	Erase DMPINSIF.NTX
ENDIF

SELECT 0
USE DMPDAT
INDEX ON Str(DMPSIF,13,0) TO DMPINSIF
CLOSE DMPDAT

IF File("PAZINSIF.NTX")
	Erase PAZINSIF.NTX
ENDIF

SELECT 0
USE PAZDAT
INDEX ON Str(PAZART,13,0) TO PAZINSIF
CLOSE PAZDAT

SELECT 0
USE DMPDAT INDEX DMPINSIF
SELECT 0
USE PAZDAT INDEX PAZINSIF
SELECT 0
USE ARTPANE INDEX APINSIF,APINART

wDat1  = Date()

MainMask("LISTA DNEVNOG PROMETA UGOSTITELJA")

@ 5,10 SAY "LISTA DPU ZA DAN: " GET wDat1
READ

IF Lastkey() = 27
	CLOSE DATABASES
	RETURN
ENDIF

Formiraj_LDPU(.T.)

SET KEY -9 TO F10_DPU_Print

DO WHILE lIzmenio
   lIzmenio = m_type("ldpu.prn",132)
ENDDO

SET KEY -9 TO

CLOSE DATABASES
RETURN

*************************************************
PROCEDURE F10_DPU_Print

	Formiraj_LDPU(.F.)

RETURN

*************************************************
PROCEDURE Formiraj_LDPU(lToFile)
	LOCAL wPre, wArtCena, nArtKol, wZbirN, wZbirP, Red
	LOCAL nRBr, nPrenKol, nNabKol, nProdKol, lPrvaStr
	LOCAL nZbir11, nZbir12, nZbir13, control_str
	LOCAL nMaxRed

	lPrvaStr = .T.
	nRBr = 1
	Red  = 1
	nZbir11 = 0
	nZbir12 = 0
	nZbir13 = 0

	SET DEVICE TO PRINT
	IF(lToFile)
		SET PRINT TO LDPU
	ELSE
		SET PRINT TO LPT1
	ENDIF
	SET PRINT ON

	IF(.NOT. lToFile)
   	IF lLaser
         control_str = Chr(27) + '(s17H' + Chr(27) + '&l5C'
         @ 0,0 SAY control_str      && kondenz On za laserski
      ELSE
         ? Chr(15)                  && kondenz On za matricni
      ENDIF
	ENDIF

	IF lLaser
      nMaxRed = 80
   ELSE
      nMaxRed = 55
   ENDIF

	LDPU_Obveznik()
	LDPU_Zaglavlje()

	SELECT ARTPANE
	GO TOP
	DO WHILE ! Eof()	&& ARTPANE idemo slog po slog
		wPre     = ARTSIF
		wArtCena = ARTCEN
		nArtKol  = ARTKOL
		wZbirN   = 0
		wZbirP   = 0
		nPrenKol = 0
		nNabKol  = 0
		nProdKol = 0

		* tekuci artikal u DMPDAT - nabavke za tekuci artikal
		SELECT DMPDAT
		SEEK STR(ARTPANE->ARTSIF,13,0)
		IF Found()
			DO WHILE wPre = DMPSIF
				IF wDat1 = DMPDAT
					nNabKol = Round(nNabKol + DMPKOL, 3)
				ENDIF
				IF DMPDAT >= wDat1
					wZbirN = Round(wZbirN + DMPKOL, 3)
				ENDIF
				SKIP
			ENDDO
		ENDIF

		* tekuci artikal u PAZDAT - prodaja za tekuci artikal
		SELECT PAZDAT
		SEEK STR(ARTPANE->ARTSIF,13,0)
		IF Found()
			DO WHILE wPre = PAZART
				IF wDat1 = PAZDAT
					nProdKol = Round(nProdKol + PAZKOL, 3)
				ENDIF
				IF PAZDAT >= wDat1
					wZbirP = Round(wZbirP + PAZKOL, 3)
				ENDIF
				SKIP
			ENDDO
		ENDIF

		nPrenKol = nArtKol  - (wZbirN - wZbirP)
		
		* Jedan red izvestaja
		IF lPrvaStr
			IF Red > nMaxRed - 7
				EJECT
				LDPU_Zaglavlje()
				Red = 1
				lPrvaStr = .F.
			ENDIF
		ELSE
			IF Red > nMaxRed
				EJECT
				LDPU_Zaglavlje()
				Red = 1
			ENDIF
		ENDIF
		
		SELECT ARTPANE
		? Str(nRBr,3)+ Space(1)
		* ?? ARTSIF + Space(1)
		?? SubStr(ARTNAZ,1,25) + Space(1)
		?? SubStr(ARTTAR,1,4) + Space(1)
		?? ARTJM + Space(1)
		?? Str(nPrenKol,8,2)
		?? Str(nNabKol,8,2)
		?? Str(nPrenKol + nNabKol,8,2)
		?? Str((nPrenKol + nNabKol) - nProdKol,8,2)
		?? Str(nProdKol,8,2)
		?? Str(ARTCEN,10,2)
		IF SIOP == 1   && Pice
			?? Str(nProdKol * ARTCEN,12,2)
			?? Space(12)
			nZbir11 = nZbir11 + (nProdKol * ARTCEN)
		ENDIF           
		IF SIOP == 2	&& 'Rana
		   ?? Space(12)
			?? Str(nProdKol * ARTCEN,12,2)
			nZbir12 = nZbir12 + (nProdKol * ARTCEN)
		ENDIF
		?? Str(nNabKol * ARTCEN,12,2)
		nZbir13 = nZbir13 + (nNabKol * ARTCEN)

		nRBr = nRBr + 1
		Red = Red + 1
		SKIP
	ENDDO
	
	LDPU_Futer(nZbir11, nZbir12, nZbir13)
	EJECT

	IF(.NOT. lToFile)
      IF lLaser
         ? Chr(27)+ Chr(69)         && kondenz Off za laserski
      ELSE
         ? Chr(18)                  && kondenz Off za matricni
      ENDIF
	ENDIF

	SET DEVICE TO SCREEN
	SET PRINT OFF

RETURN
*************************************************

*************************************************
PROCEDURE LDPU_Obveznik
	LOCAL cTmp
 	? "PIB " + gcPIB + Space(81) + "Obrazac DPU"
 	cTmp = "Obveznik " + RTrim(gcIme) + Space(1) + RTrim(gcPrez)
	? cTmp + Space(95 - Len(cTmp)) + "Red. br. iz PK - 1 ___________"
	? "Firma - radnje " + gcNazRad
	? "Sediste " + gcAdresa
	? "Sifra poreskog obveznika _________  Sifra delatnosti " + gcSifDel
	?
RETURN
*************************************************

*************************************************
PROCEDURE LDPU_Zaglavlje
	? Space(47) + "LIST DNEVNOG PROMETA UGOSTITELJA"
	? Space(51) + "za dan "
	?? wDat1
	?? " godine"
	?
	? "------------------------------------------------------------------------------------------------------------------------------"
	? "Red.| Naziv jela i pica   |Stopa|Jed.|Preneta |Nabav.  | UKUPNO|Zalihe  |Utrosena |Prodajna |Ostvareni promet    |Prod. vredn."
	? "br. | za konzumaciju      | PDV |mere|kolicina|kolicina| (5+6) |na kraju|kol.u to-|cena po  |od usluga (9 x 10)  |jela i pica"
	? "    | na licu mesta       |     |    |        |        |       |dana    |ku dana  |JM sa PDV| od pica  | od jela | (6 x 10)"
	? "------------------------------------------------------------------------------------------------------------------------------"
	? " 1  |          2          |  3  |  4 |    5   |    6   |    7  |    8   |    9    |   10    |     11   |    12   |     13    |"
	? "------------------------------------------------------------------------------------------------------------------------------"
RETURN
*************************************************

*************************************************
PROCEDURE LDPU_Futer(z11, z12, z13)
	? "------------------------------------------------------------------------------------------------------------------------------"
	? Space(83) + "Svega:" + Str(z11,12,2)+ Str(z12,12,2)+ Str(z13,12,2)
	?
	?
	? Space(15) + "Sastavio" + Space(25) + "Odgovorno lice"
	?
	?
	? Space(10) + "____________________" + Space(15) + "____________________"
RETURN
*************************************************
