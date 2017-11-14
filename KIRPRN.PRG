SELECT 0
USE PPDAT INDEX PPINSIF
SELECT 0
USE KIR INDEX KIRDK
GO TOP

wz1  = Val("00000000.00")
STORE wz1 TO wz2,wz3,wz10,wz11,wz12,wz13,wz14,wz15,wz16,wz17

Dat1 = Date()
Dat2 = Date()

MainMask("STAMPA KNJIGE KIR")
@ 6,10 SAY "Od datuma: " GET DAT1
@ 7,10 SAY "Do datuma: " GET DAT2
READ

IF Lastkey() = 27
   CLOSE DATABASES
   RETURN
ENDIF

SET CONSOLE OFF
SET ALTERNATE TO c:\PK\kir.html
SET ALTERNATE ON
header("Stampa knjige izlaznih racuna","kir.css")
makeHeader(Alltrim(gcNazRad) + " - KIR")

KIRNaslov()

DO WHILE ! Eof()
	IF DtoS(DATKKIR) >= DtoS(DAT1) .AND. DtoS(DATKKIR) <= DtoS(DAT2)

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
      KIRTekst()

		wz1 = Round(wz1 + uknakkir,2)
		wz2 = Round(wz2 + osaod,2)
		wz3 = Round(wz3 + obezod,2)
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

* stampa zbirova
? TR_El_open("", 12)
   ? General_El('<td colspan="6"><b>UKUPNO</b></td>',12)
   ? TD_El_Str('<b>' + Str(WZ1,11,2) + '</b>', 12)
   ? TD_El_Str('<b>' + Str(WZ2,11,2) + '</b>', 12)
   ? TD_El_Str('<b>' + Str(WZ3,11,2) + '</b>', 12)
   ? TD_El_Str('<b>' + Str(WZ10,11,2) + '</b>', 12)
   ? TD_El_Str('<b>' + Str(WZ11,11,2) + '</b>', 12)   
   ? TD_El_Str('<b>' + Str(WZ12,11,2) + '</b>', 12)
   ? TD_El_Str('<b>' + Str(WZ13,11,2) + '</b>', 12)
   ? TD_El_Str('<b>' + Str(WZ14,11,2) + '</b>', 12)
   ? TD_El_Str('<b>' + Str(WZ15,11,2) + '</b>', 12)
   ? TD_El_Str('<b>' + Str(WZ16,11,2) + '</b>', 12)
   ? TD_El_Str('<b>' + Str(WZ17,11,2) + '</b>', 12)
? TR_El_close("", 12)
? TBL_El_close("kir-table", 9)

DO futer

SET ALTERNATE TO
SET ALTERNATE OFF
SET CONSOLE ON

CLOSE DATABASES
RETURN

***************************************************************
PROCEDURE KIRNaslov
LOCAL cNaslov

cNaslov = "KNJIGA KIR OD " + DTOC(DAT1) + " DO " + DTOC(DAT2)

? TBL_El_open("kir-zaglavlje", 9)
   ? TR_El_open("", 12)
      ? General_El('<th colspan="2">' + cNaslov +'</th>',12)
   ? TR_El_close("", 12)
   
   ? TR_El_open("", 12)
      ? TD_El_Str("Poreski obveznik:", 12)
      ? TD_El_Str(gcPrez_Ime, 12)
   ? TR_El_close("", 12)
   
   ? TR_El_open("", 12)
      ? TD_El_Str("Mesto:", 12)
      ? TD_El_Str(RTRIM(gcMesto)+" "+gcAdresa, 12)
   ? TR_El_close("", 12)
   
   ? TR_El_open("", 12)
      ? TD_El_Str("Naziv radnje:", 12)
      ? TD_El_Str(gcNazRad, 12)
   ? TR_El_close("", 12)
? TBL_El_close("kir-zaglavlje", 9)

? TBL_El_open("kir-table", 9)

? General_El("<thead>",9)
   ? TR_El_open("", 12)
      ? General_El('<th rowspan="3">RBR</th>',12)
      ? General_El('<th rowspan="3">DATUM<br/>KNJIZENJA</th>',12)
      ? General_El('<th colspan="5">RACUNI ILI DRUGI DOKUMENT</th>',12)
      ? General_El('<th colspan="4">OSLOBODJENI PROMET</th>',12)
      ? General_El('<th colspan="4">OPOREZIVI PROMET</th>',12)
      ? General_El('<th rowspan="3">UKUPAN PROMET<br/>DOBARA I USLUGA<br/>SA PRAVOM I BEZ PRAVA<br/>NA ODBITAK<br/>PREDHODNOG POREZA<br/>BEZ PDV (8 DO 11+12+14)</th>',12)
      ? General_El('<th rowspan="3">UKUPAN PROMET<br/>DOBARA I USLUGA<br/>SA PRAVOM NA ODBITAK<br/>PREDHODNOG POREZA<br/>BEZ PDV (8+10+12+14)</th>',12)
   ? TR_El_close("", 12)
   
   ? TR_El_open("", 12)
      ? General_El('<th rowspan="2">BROJ<br/>RACUNA</th>',12)
      ? General_El('<th rowspan="2">DATUM<br/>IZDAVANJA<br/>RACUNA ILI<br/>DRUGOG<br/>DOKUMENTA</th>',12)
      ? General_El('<th colspan="2">KUPAC</th>',12)
      ? General_El('<th rowspan="2">UKUPNA<br/>NAKNADA<br/>SA PDV-OM</th>',12)
      ? General_El('<th rowspan="2">OSLOBODJEN<br/>PROMET SA<br/>PRAVOM NA<br/>ODBITAK<br/>PREDHODNOG<br/>PO. I DR.OS.PR.</th>',12)
      ? General_El('<th rowspan="2">OSLOBODJEN<br/>PROMET BEZ<br/>PRAVA NA<br/>ODBITAK<br/>PR.CL.25.ZAKONA<br/>TACKA 9</th>',12)
      ? General_El('<th colspan="2">PROMET U INOSTRANSTVU</th>',12)
      ? General_El('<th colspan="2">PO STOPI OD 18%</th>',12)
      ? General_El('<th colspan="2">PO STOPI OD 8%</th>',12)
   ? TR_El_close("", 12)
   
   ? TR_El_open("", 12)
      ? TH_El_Str("NAZIV (IME I SEDISTE)", 12)
      ? TH_El_Str("PIB ILI JMBG", 12)
      ? TH_El_Str("ZA KOJI BI POSTOJALO<br/>PRAVO NA PREDHODNI<br/>POREZ DA JE PROMET<br/>IZVRSEN U ZEM. TAC. 8", 12)
      ? TH_El_Str("ZA KOJI NE BI POSTOJALO<br/>PRAVO NA PREDHODNI<br/>POREZ DA JE PROMET<br/>IZVRSEN U ZEM. TAC. 10", 12)
      ? TH_El_Str("OSNOVICA<br/>TAC. 3", 12)
      ? TH_El_Str("IZNOS PDV<br/>TAC. 5", 12)
      ? TH_El_Str("OSNOVICA<br/>TAC. 4", 12)
      ? TH_El_Str("IZNOS PDV<BR/>TAC. 6", 12)
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
      ? TH_El_Str("14", 12)
      ? TH_El_Str("15", 12)
      ? TH_El_Str("16", 12)
      ? TH_El_Str("17", 12)
   ? TR_El_close("", 12)
? General_El("</thead>",9)

RETURN
***************************************************************


***************************************************************
PROCEDURE KIRTekst

   ? TR_El_open("", 12)
      ? TD_El_Str(STR(RBKIR,4,0), 12)
      ? TD_El_Str(DTOC(DATKKIR), 12)
      ? TD_El_Str(SUBSTR(BRRACKIR,1,8), 12)   
      ? TD_El_Str(DTOC(DATRACKIR), 12)
      ? TD_El_Str(SUBSTR(mImepp,1,16) +" "+SUBSTR(mSedi,1,17), 12)
      ? TD_El_Str(SUBSTR(PIBJMBGKIR,1,13), 12)
      ? TD_El_Str(STR(UKNAKKIR,11,2), 12)
      ? TD_El_Str(STR(OSAOD,11,2), 12)
      ? TD_El_Str(STR(OBEZOD,11,2), 12)

      ? TD_El_Str(STR(OSAODI,11,2), 12)
      ? TD_El_Str(STR(OBEZODI,11,2), 12)
      ? TD_El_Str(STR(OSN18,11,2), 12)
      ? TD_El_Str(STR(IZN18,11,2), 12)
      ? TD_El_Str(STR(OSN8,11,2), 12)
      ? TD_El_Str(STR(IZN8,11,2), 12)
      ? TD_El_Str(STR(UKSIB,11,2), 12)
      ? TD_El_Str(STR(UKS,11,2), 12)
   ? TR_El_close("", 12)

RETURN
***************************************************************
