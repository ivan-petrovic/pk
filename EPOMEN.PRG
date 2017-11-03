*******************************************
* Glavni meni za pausalno oporezovane
*******************************************
LOCAL Izbor, nPredhIzbor

nPredhIzbor = 1
DO WHILE .T.

	MainWnd("KNJIGA O OSTVARENOM PROMETU PAUSALNO OPOREZOVANIH OBVEZNIKA")

	Izbor = nPredhIzbor
	@ 6 ,27 PROMPT " UNOS                 " MESSAGE "UNOS STAVKI"
	@ 8 ,27 PROMPT " IZMENA               " MESSAGE "IZMENA STAVKE"
	@ 10,27 PROMPT " BRISANJE             " MESSAGE "BRISANJE"
	@ 12,27 PROMPT " LISTANJE             " MESSAGE "LISTANJE"
	@ 14,27 PROMPT " LISTANJE PO DATUMIMA " MESSAGE "LISTANJE OD DATUMA DO DATUMA"
	@ 16,27 PROMPT " ZBIROVI              " MESSAGE "ZBIROVI"
	@ 18,27 PROMPT " STAMPA               " MESSAGE "STAMPANJE KNJIGE"

	CLEAR TYPEAHEAD
	MENU TO Izbor
	* nPredhIzbor = Izbor

	DO CASE
		CASE Lastkey() = 27
			EXIT
		CASE Izbor = 1
			DO EPOU
		CASE Izbor = 2
			DO EPOI
		CASE Izbor = 3
			DO EPOBR
		CASE Izbor = 4
			DO EPOLI
		CASE Izbor = 5
			DO EPOLINNN
		CASE Izbor = 6
			DO EPOZB
		CASE Izbor = 7
			DO EPOST
	ENDCASE

ENDDO

RETURN
