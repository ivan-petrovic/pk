*************************************************
* DPU - List dnevnog prometa ugostitelja
*************************************************
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

Formiraj_LDPU()

CLOSE DATABASES
RETURN


*************************************************
PROCEDURE Formiraj_LDPU()
	LOCAL wPre, wArtCena, nArtKol, wZbirN, wZbirP
	LOCAL nRBr, nPrenKol, nNabKol, nProdKol, lPrvaStr
	LOCAL nZbir11, nZbir12, nZbir13, control_str

   nRbr = 1
	nZbir11 = 0
	nZbir12 = 0
	nZbir13 = 0

   SET CONSOLE OFF
   SET ALTERNATE TO c:\PK\ldpu.html
   SET ALTERNATE ON
   header("Stampa liste dnevnog prometa ugostitelja","ldpu.css")
   makeHeader(Alltrim(gcNazRad) + " - Lista dnevnog prometa ugostitelja")

   ? General_El_Str('<div class="ldpu">',6)
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
		SELECT ARTPANE

      IF (nNabKol <> 0) .OR. (nProdKol <> 0) .OR. (nPrenKol <> 0)
         ? TR_EL_open("", 12)
            ? TD_EL_Num(nRBr, 0, 12)
            ? TD_EL_Str(ARTNAZ, 12)
            ? TD_EL_Str(ARTTAR, 12)
            ? TD_EL_Str(ARTJM, 12)
            ? TD_EL_Num(nPrenKol, 2, 12)
            ? TD_EL_Num(nNabKol, 2, 12)
            ? TD_EL_Num(nPrenKol + nNabKol, 2, 12)
            ? TD_EL_Num((nPrenKol + nNabKol) - nProdKol, 2, 12)
            ? TD_EL_Num(nProdKol, 2, 12)
            ? TD_EL_Num(ARTCEN, 2, 12)
      		IF SIOP == 1   && Pice
               ? TD_EL_Num(nProdKol * ARTCEN, 2, 12)
               ? TD_EL_Str("", 12)
      			nZbir11 = nZbir11 + (nProdKol * ARTCEN)
      		ENDIF           
      		IF SIOP == 2	&& 'Rana
               ? TD_EL_Str("", 12)
               ? TD_EL_Num(nProdKol * ARTCEN, 2, 12)
      			nZbir12 = nZbir12 + (nProdKol * ARTCEN)
      		ENDIF
            IF SIOP <> 1 .AND. SIOP <> 2	&& nije ni pice ni hrana
               ? TD_EL_Str("", 12)
               ? TD_EL_Str("", 12)
            ENDIF
            ? TD_EL_Num(nNabKol * ARTCEN, 2, 12)
            nZbir13 = nZbir13 + (nNabKol * ARTCEN)
         ? TR_EL_close("", 12)
         
         nRbr = nRbr + 1
      ENDIF
		SKIP
	ENDDO
	
   * Stampa zbirova
   ? TR_El_open("zbir", 12)
      ? General_El_Str('<td colspan="10" class="centriraj">SVEGA:</td>',12)
      ? TD_EL_Num(nZbir11, 2, 12)
      ? TD_EL_Num(nZbir12, 2, 12)
      ? TD_EL_Num(nZbir13, 2, 12)
   ? TR_El_close("zbir", 12)

   ? TBL_El_close("ldpu-table", 6)

   * Mesta za potpis
   ? TBL_El_open("ldpu-potpis", 9)

      ? TR_El_open("", 12)
      ? TD_El_Str("Sastavio", 12)
      ? TD_El_Str("Odgovorno lice", 12)
      ? TR_El_close("", 12)
   
      ? TR_El_open("", 12)
      ? TD_El_Str("________________________", 12)
      ? TD_El_Str("________________________", 12)
      ? TR_El_close("", 12)

   ? TBL_El_close("ldpu-potpis", 9)

   ? General_El_Str("</div> <!-- ldpu -->",6)
   
   DO futer
   
   SET ALTERNATE TO
   SET ALTERNATE OFF
   SET CONSOLE ON

	SET DEVICE TO SCREEN
	SET PRINT OFF

RETURN
*************************************************


*************************************************
PROCEDURE LDPU_Obveznik

   ? General_El_Str('<p class="naziv-obrasca">Obrazac DPU</p>',6)
   ? General_El_Str('<p class="naziv-obrasca">Red. br. iz PK - 1 ___________</p>',6)
   
   ? TBL_El_open("ldpu-naslov", 6)
   
   ? TR_El_open("", 9)
   ? TD_El_Str("PIB:", 9)
   ? TD_El_Str(gcPIB, 9)
   ? TR_El_close("", 9)

   ? TR_El_open("", 9)
   ? TD_El_Str("Obveznik:", 9)
   ? TD_El_Str(RTrim(gcIme) + Space(1) + RTrim(gcPrez), 9)
   ? TR_El_close("", 9)

   ? TR_El_open("", 9)
   ? TD_El_Str("Firma - radnje:", 9)
   ? TD_El_Str(gcNazRad, 9)
   ? TR_El_close("", 9)

   ? TR_El_open("", 9)
   ? TD_El_Str("Sediste:", 9)
   ? TD_El_Str(gcAdresa, 9)
   ? TR_El_close("", 9)

   ? TR_El_open("", 9)
   ? TD_El_Str("Sifra poreskog obveznika:", 9)
   ? TD_El_Str("", 9)
   ? TR_El_close("", 9)

   ? TR_El_open("", 9)
   ? TD_El_Str("Sifra delatnosti:", 9)
   ? TD_El_Str(gcSifDel, 9)
   ? TR_El_close("", 9)
   
   ? TBL_El_close("ldpu-naslov", 6)
RETURN
*************************************************


*************************************************
PROCEDURE LDPU_Zaglavlje

   ? General_El_Str('<p class="naslov-obrasca">LIST DNEVNOG PROMETA UGOSTITELJA ZA DAN ' + DTOC(wDat1) + '. GODINE</p>',6)

   ? TBL_El_open("ldpu-table", 9)
   ? General_El_Str("<thead>",9)
   
   ? TR_El_open("", 12)
      ? General_El_Str('<th rowspan="2">' + "Red.br." + '</th>',12)
      ? General_El_Str('<th rowspan="2">' + "Naziv jela i pica za konzumaciju na licu mesta" + '</th>',12)
      ? General_El_Str('<th rowspan="2">' + "Stopa PDV" + '</th>',12)
      ? General_El_Str('<th rowspan="2">' + "Jed. mere" + '</th>',12)
      ? General_El_Str('<th rowspan="2">' + "Preneta kolicina" + '</th>',12)
      ? General_El_Str('<th rowspan="2">' + "Nabav. kolicina" + '</th>',12)
      ? General_El_Str('<th rowspan="2">' + "UKUPNO (5+6)" + '</th>',12)
      ? General_El_Str('<th rowspan="2">' + "Zalihe na kraju dana" + '</th>',12)
      ? General_El_Str('<th rowspan="2">' + "Utrosena kol. u toku dana" + '</th>',12)
      ? General_El_Str('<th rowspan="2">' + "Prodajna cena po JM sa PDV" + '</th>',12)
      ? General_El_Str('<th colspan="2">' + "Ostvareni promet od usluga (9x10)" + '</th>',12)
      ? General_El_Str('<th rowspan="2">' + "Prod. vredn. jela i pica (6x10)" + '</th>',12)
   ? TR_El_close("", 12)

   ? TR_El_open("", 12)
      ? TH_El_Str("od pica", 12)
      ? TH_El_Str("od jela", 12)
   ? TR_El_close("", 12)
   
   ? TR_El_open("", 12)
      ? TH_El_Str("1", 12)
      ? TH_El_Str("2", 12)
      ? TH_El_Str("3", 12)
      ? TH_El_Str("4", 12)
      ? TH_El_Str("5", 12)
      ? TH_El_Str("6", 12)
      ? TH_El_Str("7", 12)
      ? TH_El_Str("8", 12)
      ? TH_El_Str("9", 12)
      ? TH_El_Str("10", 12)
      ? TH_El_Str("11", 12)
      ? TH_El_Str("12", 12)
      ? TH_El_Str("13", 12)
   ? TR_El_close("", 12)
   
   ? General_El_Str("</thead>",9)

RETURN
*************************************************
