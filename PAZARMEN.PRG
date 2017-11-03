******************************************************
* Glavni meni za izbor posla pazara i obracuna poreza
******************************************************
LOCAL Izbor, nPredhIzbor

nPredhIzbor = 1
DO WHILE .T.

	MainWnd("PAZARI KAFA,PI'E,CIGARTE")

	Izbor = nPredhIzbor
	@ 8,27  PROMPT " LISTANJE DNEVNOG PAZARA   " MESSAGE "LISTA PAZAR ZA UNETI DATUM"
	@ 10,27 PROMPT " STAMPA DNEVNOG PAZARA     " MESSAGE "STAMPA PAZAR ZA UNETI DATUM"
	@ 12,27 PROMPT " BRISANJE STAVKE PAZARA    " MESSAGE "BRISE STAVKU PAZARA ZA UNETI DATUM I SIFRU ARTIKLA"

	CLEAR TYPEAHEAD
	MENU TO Izbor
   * nPredhIzbor = Izbor
   
	DO CASE
		CASE Lastkey() = 27
			EXIT
		CASE Izbor = 1
			DO KPCPUP
		CASE Izbor = 2
			DO KPCPST
		CASE Izbor = 3
			DO KPCBRP
	ENDCASE

ENDDO

RETURN
