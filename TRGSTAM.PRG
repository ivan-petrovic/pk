SELECT 0
USE TRG
INDEX ON DK TO TRGDK
CLOSE TRG

SELECT 0
USE TRG INDEX TRGDK

wdonzad = val("000000000000000.00")    && donos sa predhodne strane - zaduzenje
wdonraz = val("000000000000000.00")    && donos sa predhodne strane - razduzenje
cZavrsni = "N"

nBrRedova = 0     && ukupan broj stavki za stampu
nUkBrStr = 0      && ukupan broj strana
nBrStrane = 1     && broj tekuce strane
nRedPoStr = 30    && broj redova po strani

wod = ctod("01.01." + Str(YEAR(DATE())))
wdo = DATE()

MainMask("STAMPANJE TRGOVACKE KNJIGE")

@  7,10 SAY "STAMPANJE KEP KNJIGE"
@  8,10 SAY "OD DATUMA:     " GET wod VALID ! Empty(wod)
@  9,10 SAY "DO DATUMA:     " GET wdo VALID(wdo >= wod)
@ 10,10 SAY "ZAVRSNI (D/N): " GET cZavrsni PICTURE "!" VALID(cZavrsni $ "DN")
READ

IF Lastkey() = 27
   CLOSE DATABASES
   RETURN
ENDIF

SET CONSOLE OFF
SET ALTERNATE TO c:\PK\kepknj.htm
SET ALTERNATE ON
header("Stampa knjige primljenih racuna","kepknj.css")
makeHeader(Alltrim(gcNazRad) + " - KEP KNJIGA")

* ukupan broj stavki za stampu, mora unapred da se odredi
* da bi moglo da se vidi kada se stampa poslednja strana
* koja se stampa razlicito u slucaju zavrsne stampe (cZavrsni = D)
GO TOP
DO WHILE ! Eof()
   IF ! (wod <= DK .AND. DK <= wdo)
      SKIP
      LOOP
   ENDIF
   nBrRedova = nBrRedova + 1
   SKIP
ENDDO
nUkBrStr = Int(nBrRedova / nRedPoStr) + 1

* Stampaj sadrzaj tabele
GO TOP
DO WHILE ! Eof()
   IF ! (wod <= DK .AND. DK <= wdo)
      SKIP
      LOOP
   ENDIF
   
   ? General_El('<div class="trg-strana">',12)
   TrgZag()    && odstampaj zaglavlje strane
   
   ? TR_El_open("", 12)
      ? General_El('<td></td>',12)
      ? General_El('<td></td>',12)
      ? General_El('<td><b>DONOS</b></td>',12)
      ? General_El('<td class="desno"><b>' + Formatiraj(wdonzad,14,2) + '</b></td>',12)
      ? General_El('<td class="desno"><b>' + Formatiraj(wdonraz,14,2) + '</b></td>',12)
   ? TR_El_close("", 12)

   n := 1
   DO WHILE n <= nRedPoStr .AND. .NOT. Eof()
      IF ! (wod <= DK .AND. DK <= wdo)
         SKIP
         LOOP
      ENDIF
    
      ? TR_El_open("", 12)
         * ? TD_El_Str(Str(rb,3,0) + " " + Alltrim(BRKAL), 12)
         ? TD_El_Str(Str(rb,3,0), 12)
         ? TD_El_Str(substr(dtoc(DK),1,6), 12)
         ? TD_El_Str(Alltrim(BRKAL) + " " + Alltrim(OPK) + " od " + dtoc(DK) + ".", 12)
         ? General_El('<td class="desno">' + Formatiraj(ZAD,14,2) + '</td>',12)
         ? General_El('<td class="desno">' + Formatiraj(RAZ,14,2) + '</td>',12)
      ? TR_El_close("", 12)

      wdonzad = wdonzad + Round(ZAD,2)
      wdonraz = wdonraz + Round(RAZ,2)
       
      n = n + 1
      SKIP
   ENDDO 

   IF cZavrsni = "D" .AND. nUkBrStr = nBrStrane
      * ako je zavrsna stampa, a radi se o poslednjoj strani 
      ? TR_El_open("", 12)
         ? General_El('<td></td>',12)
         ? General_El('<td></td>',12)
         ? General_El('<td></td>',12)
         ? General_El('<td class="desno"><b>' + Formatiraj(wdonzad,14,2) + '</b></td>',12)
         ? General_El('<td class="desno"><b>' + Formatiraj(wdonraz,14,2) + '</b></td>',12)
      ? TR_El_close("", 12)
      
      ? TR_El_open("", 12)
         ? General_El('<td></td>',12)
         ? General_El('<td></td>',12)
         ? General_El('<td><b>ZALIHE</b></td>',12)
         IF wdonraz < wdonzad
            ? General_El('<td class="desno"><b>-' + Formatiraj(wdonzad - wdonraz,14,2) + '</b></td>',12)
         ELSE
            ? General_El('<td class="desno"><b>' + Formatiraj(wdonraz - wdonzad,14,2) + '</b></td>',12)
         ENDIF
         ? General_El('<td></td>',12)
      ? TR_El_close("", 12)

      ? TR_El_open("", 12)
         ? General_El('<td></td>',12)
         ? General_El('<td></td>',12)
         ? General_El('<td><b>UKUPNO</b></td>',12)
         ? General_El('<td class="desno"><b>' + Formatiraj(wdonraz,14,2) + '</b></td>',12)
         ? General_El('<td class="desno"><b>' + Formatiraj(wdonraz,14,2) + '</b></td>',12)
      ? TR_El_close("", 12)
      
   ELSE
      * cZavrsni="N", ili cZavrsni="D" ali nije poslednja strana 
      ? TR_El_open("", 12)
         ? General_El('<td></td>',12)
         ? General_El('<td></td>',12)
         ? General_El('<td><b>SVEGA ZA PRENOS</b></td>',12)
         ? General_El('<td class="desno"><b>' + Formatiraj(wdonzad,14,2) + '</b></td>',12)
         ? General_El('<td class="desno"><b>' + Formatiraj(wdonraz,14,2) + '</b></td>',12)
      ? TR_El_close("", 12)
   ENDIF

   TrgFuter()
   ? General_El('</div> <!-- trg-strana -->',12)
   
   nBrStrane = nBrStrane + 1
ENDDO

DO futer

SET ALTERNATE TO
SET ALTERNATE OFF
SET CONSOLE ON

CLOSE DATABASES
RETURN

***************************************************************
* Zaglavlje na svakoj strani kep knjige
*************************************************************** 
PROCEDURE TrgZag

   ? General_El('<p class="br-strane">Strana: ' + Str(nBrStrane,3) + '</p>',12)

   * Podaci o trgovcu
   ? TBL_El_open("trg-zaglavlje", 9)
      ? TR_El_open("", 12)
         ? General_El('<td><b>Obrazac KEP</b></td>',12)
         ? TD_El_Str("", 12)
      ? TR_El_close("", 12)

      ? TR_El_open("", 12)
         ? TD_El_Str("TRGOVAC: ", 12)
         ? TD_El_Str(Alltrim(gcNazRad), 12)
      ? TR_El_close("", 12)

      ? TR_El_open("", 12)
         ? TD_El_Str("OBJEKAT-PRODAJNO MESTO: ", 12)
         ? TD_El_Str(Alltrim(gcAdresa), 12)
      ? TR_El_close("", 12)

      ? TR_El_open("", 12)
         ? TD_El_Str("MESTO: ", 12)
         ? TD_El_Str(Alltrim(gcMesto), 12)
      ? TR_El_close("", 12)
   ? TBL_El_close("trg-zaglavlje", 9)

   * Naslov KEP knjige
   ? General_El('<h3>KNJIGA EVIDENCIJE PROMETA ZA ' + Str(YEAR(wod)) + '. GODINU</h3>',12)

   * Otvori tabelu za stavke knjige i formiraj zaglavlje tabele
   ? TBL_El_open("trg-tabela", 9)
      ? TR_El_open("", 12)
         ? General_El('<th rowspan="2">Red. broj</th>',12)
         ? General_El('<th rowspan="2">Datum evidencije <BR/> (dan i mesec)</th>',12)
         ? General_El('<th rowspan="2">Opis evidentirane promene <BR/> (naziv, broj i datum dokumenta)</th>',12)
         ? General_El('<th colspan="2">Iznos dinara</th>',12)
      ? TR_El_close("", 12)
      
      ? TR_El_open("", 12)
         ? TH_El_Str("zaduzenje", 12)
         ? TH_El_Str("razduzenje", 12)
      ? TR_El_close("", 12)
      
      ? TR_El_open("", 12)
         ? TH_El_Str("1", 12)
         ? TH_El_Str("2", 12)
         ? TH_El_Str("3", 12)
         ? TH_El_Str("4", 12)
         ? TH_El_Str("5", 12)                           
      ? TR_El_close("", 12)
   * ? TBL_El_close("trg-tabela", 9) u TrgFuter proceduri 

RETURN


***************************************************************
* Futer na svakoj strani kep knjige
***************************************************************
PROCEDURE TrgFuter

   * Zatvori tabelu
   ? TBL_El_close("trg-tabela", 9)

   ? TBL_El_open("trg-futer", 9)
      ? TR_El_open("", 12)
         ? General_El('<td rowspan="2"></td>',12)
         ? General_El('<td rowspan="2">M.P.</td>',12)
         ? TD_El_Str("ODGOVORNO LICE", 12)
      ? TR_El_close("", 12)
      
      ? TR_El_open("", 12)
         ? General_El('<td class="potpis">' + gcPrez_Ime + '</td>',12)
      ? TR_El_close("", 12)
   ? TBL_El_close("trg-futer", 9)

RETURN
***************************************************************
