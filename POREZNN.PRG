*********************************************
* Glavni meni za izbor posla poreza na promet
*********************************************
LOCAL Izbor, nPredhIzbor

nPredhIzbor = 1
DO WHILE .T.

	MainWnd("K NJ I G A  P O R E Z A")

	Izbor = nPredhIzbor
	@ 6 ,27 PROMPT "UNOS STAVKE POREZA        " MESSAGE "PO POPISU ILI NIVELACIJI"
	@ 8 ,27 PROMPT "IZMENA STAVKE POREZA      " MESSAGE "PO BROJU KALKULACIJE,POPISA,NIVELACIJE"
	@ 10,27 PROMPT "BRISANJE POREZA PO KALK.  " MESSAGE "BRISANJE STAVKE IZ RACUNARA"
	@ 12,27 PROMPT "LISTANJE KNJIGE POREZA    " MESSAGE "LISTANJE STAVKA PO STAVKA (SVE VIDLJIVO)"
	@ 14,27 PROMPT "LISTANJE KNJIGE POREZA    " MESSAGE "LISTANJE POLJA PO STAVKAMA"
	@ 16,27 PROMPT "UPIT U ZBIROVE OSNOVICA   " MESSAGE "ZBIROVI OD DATUMA DO DATUMA"
	@ 18,27 PROMPT "STAMPA KNJIGE POREZA      " MESSAGE "STAMPA OD DATUMA DO DATUMA"

	CLEAR TYPEAHEAD
	MENU TO Izbor
	* nPredhIzbor = Izbor

	DO CASE
		CASE Lastkey() = 27
			EXIT
		CASE Izbor = 1
			DO POREUNN
		CASE Izbor = 2
			DO PORIZNN
		CASE Izbor = 3
			DO BRISPNN
		CASE Izbor = 4
			DO PORLKOSO
		CASE Izbor = 5
			DO PORLNNN
		CASE Izbor = 6
			DO PORUPTNN
		CASE Izbor = 7
			DO KK22
	ENDCASE
	
ENDDO

RETURN
