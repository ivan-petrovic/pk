USE KPR
INDEX ON DRACKPR TO KPRDRAC
USE

SELECT 0
USE PPDAT INDEX PPINSIF
SELECT 0
USE KPR INDEX KPRDRAC
GO TOP

wZ1  = Val("00000000.00")
STORE wz1 TO wz8,wz9,wz10,wz11,wz12,wz13,wz14,wz15,wz16,wz17,wz18

Dat1 = Date()
Dat2 = Date()

MainMask("STAMPA KNJIGE KPR")
@ 6,10 SAY "Od datuma: " GET Dat1
@ 7,10 SAY "Do datuma: " GET Dat2
READ

IF Lastkey() = 27
   CLOSE DATABASES
   RETURN
ENDIF

SET CONSOLE OFF
SET ALTERNATE TO c:\PK\kpr.html
SET ALTERNATE ON
header("Stampa knjige primljenih racuna","kpr.css")
makeHeader(Alltrim(gcNazRad) + " - KPR")

KPRNaslov()

DO WHILE ! Eof()
   IF DTOS(DRACKPR) >= DtoS(Dat1) .AND. DtoS(DRACKPR) <= DtoS(Dat2)

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
      KPRTekst()

      wz1 = Round(wz1 + ukspdv,2)
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

* stampa zbirova
? TR_El_open("", 12)
   ? General_El('<td colspan="8"><b>UKUPNO</b></td>',12)
   ? TD_El_Str('<b>' + Str(WZ1,16,2) + '</b>', 12)
   ? TD_El_Str('<b>' + Str(WZ8,11,2) + '</b>', 12)
   ? TD_El_Str('<b>' + Str(WZ9,11,2) + '</b>', 12)
   ? TD_El_Str('<b>' + Str(WZ11,11,2) + '</b>', 12)
   ? TD_El_Str('<b>' + Str(WZ10,11,2) + '</b>', 12)
   ? TD_El_Str('<b>' + Str(WZ12,11,2) + '</b>', 12)
   ? TD_El_Str('<b>' + Str(WZ13,11,2) + '</b>', 12)
   ? TD_El_Str('<b>' + Str(WZ14,11,2) + '</b>', 12)
   ? TD_El_Str('<b>' + Str(WZ15,11,2) + '</b>', 12)
   ? TD_El_Str('<b>' + Str(WZ16,11,2) + '</b>', 12)
   ? TD_El_Str('<b>' + Str(WZ17,11,2) + '</b>', 12)
   ? TD_El_Str('<b>' + Str(WZ18,11,2) + '</b>', 12)
? TR_El_close("", 12)
? TBL_El_close("kpr-table", 9)

DO futer

SET ALTERNATE TO
SET ALTERNATE OFF
SET CONSOLE ON

CLOSE DATABASES
RETURN

***************************************************************
PROCEDURE KPRNaslov
LOCAL cNaslov

cNaslov = "KNJIGA KPR OD " + DTOC(DAT1) + " DO " + DTOC(DAT2)

? TBL_El_open("kpr-zaglavlje", 9)
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
? TBL_El_close("kpr-zaglavlje", 9)

? TBL_El_open("kpr-table", 9)

? General_El("<thead>",9)
   ? TR_El_open("", 12)
      ? General_El('<th rowspan="3">RBR</th>',12)
      ? General_El('<th colspan="2">DATUM</th>',12)
      ? General_El('<th colspan="10">RACUN ILI DRUGI DOKUMENT</th>',12)
      ? General_El('<th rowspan="3">UKUPAN IZNOS<br/>OBRACUNATOG<br/>PREDHODNOG<br/>PDV TAC. 17</th>',12)
      ? General_El('<th rowspan="3">IZNOS<br/>PREDHODNOG<br/>PDV-A KOJI SE<br/>MOZE ODBITI</th>',12)
      ? General_El('<th rowspan="3">IZNOS<br/>PREDHODNOG<br/>PDV-A KOJI SE<br/>NE MOZE ODBITI</th>',12)
      ? General_El('<th colspan="2">UVOZ</th>',12)
      ? General_El('<th colspan="2">NAKNADA POLJOPRIVRED.</th>',12)
   ? TR_El_close("", 12)
   
   ? TR_El_open("", 12)
      ? General_El('<th rowspan="2">KNJIZENJA</th>',12)
      ? General_El('<th rowspan="2">PRIJEMA</th>',12)
      ? General_El('<th rowspan="2">BR.KALKULACIJE</th>',12)
      ? General_El('<th rowspan="2">BR.RACUNA</th>',12)
      ? General_El('<th rowspan="2">DATUM<br/>RAC.DOKUM.</th>',12)
      ? General_El('<th colspan="2">DOBAVLJAC</th>',12)
      ? General_El('<th rowspan="2">UKUPNA NAKNADA<br/>SA PDV (TAC.16)</th>',12)
      ? General_El('<th rowspan="2">UKUPNA<br/>NAKNADA SA<br/>PDV TAC 16.</th>',12)
      ? General_El('<th rowspan="2">OSLOBODJENE<br/>NABAVKE I<br/>NABAVKE OD<br/>LICA KOJA<br/>NISU OBVEZ.<br/>PDV T.15,18</th>',12)
      ? General_El('<th rowspan="2">NAKNADA ZA<br/>UVEZENA DOBRA<br/>NA KOJA SE<br/>NE PLACA PDV<br/>TAC. 22</th>',12)
      ? General_El('<th rowspan="2">NAKNADA BEZ<br/>PDV (NA KOJU<br/>JE OBRACUN.<br/>PDV KOJI SE<br/>MOZE ODBITI</th>',12)
      ? General_El('<th rowspan="2">VREDNOST<br/>BEZ PDV<br/>TAC. 21</th>',12)
      ? General_El('<th rowspan="2">IZNOS<br/>PDV<br/>TAC. 23</th>',12)
      ? General_El('<th rowspan="2">VREDNOST<br/>PRIMLJENIH<br/>DOBARA<br/>I USLUGA<br/>TAC. 25</th>',12)
      ? General_El('<th rowspan="2">IZNOS<br/>NAKNADE<br/>OD 5%<br/>TAC. 24</th>',12)
   ? TR_El_close("", 12)
   
   ? TR_El_open("", 12)
      ? TH_El_Str("NAZIV (IME I SEDISTE)", 12)
      ? TH_El_Str("PIB ILI JMBG", 12)
   ? TR_El_close("", 12)
   
   ? TR_El_open("", 12)
      ? TH_El_Str("1", 12)
      ? TH_El_Str("2", 12)
      ? TH_El_Str("3", 12)
      ? TH_El_Str("4A", 12)
      ? TH_El_Str("4", 12)
      ? TH_El_Str("5", 12)
      ? TH_El_Str("6", 12)
      ? TH_El_Str("7", 12)
      ? TH_El_Str("8", 12)
      ? TH_El_Str("8B", 12)
      ? TH_El_Str("9", 12)
      ? TH_El_Str("10", 12)
      ? TH_El_Str("11", 12)
      ? TH_El_Str("12", 12)
      ? TH_El_Str("13", 12)
      ? TH_El_Str("14", 12)
      ? TH_El_Str("", 12)
      ? TH_El_Str("", 12)
      ? TH_El_Str("", 12)
      ? TH_El_Str("", 12)
   ? TR_El_close("", 12)
? General_El("</thead>",9)

RETURN
***************************************************************


***************************************************************
PROCEDURE KPRTekst

   ? TR_El_open("", 12)
      ? TD_El_Str(STR(rbkpr,4,0), 12)
      ? TD_El_Str(DTOC(DKKPR), 12)
      ? TD_El_Str(DTOC(dppvdkpr), 12)
      ? TD_El_Str(SUBSTR(BRKAL,1,10), 12)
      ? TD_El_Str(SUBSTR(BRACKPR,1,10), 12)
      ? TD_El_Str(DTOC(drackpr), 12)
      ? TD_El_Str(SUBSTR(mImepp,1,16) +" "+SUBSTR(mSedi,1,17), 12)
      ? TD_El_Str(SUBSTR(PIBKPR,1,13), 12)
      ? TD_El_Str(STR(ukspdv,16,2), 12)
      ? TD_El_Str(STR(UKSPDV1,11,2), 12)
      ? TD_El_Str(STR(OSLPDV,11,2), 12)
      ? TD_El_Str(STR(UVOZN,11,2), 12)
      ? TD_El_Str(STR(NPDV,11,2), 12)
      ? TD_El_Str(STR(UKPPDV,11,2), 12)
      ? TD_El_Str(STR(ODPDV,11,2), 12)
      ? TD_El_Str(STR(NEODPDV,11,2), 12)
      ? TD_El_Str(STR(VBEZPDVU,10,2), 12)
      ? TD_El_Str(STR(IZNPDVU,10,2), 12)
      ? TD_El_Str(STR(VDU,10,2), 12)
      ? TD_El_Str(STR(IZNN5,10,2), 12)
   ? TR_El_close("", 12)

RETURN
***************************************************************
