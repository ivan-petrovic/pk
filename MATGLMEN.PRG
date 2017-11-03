*******************************************
* Glavni meni za unos podataka o obvezniku
*******************************************
LOCAL Izbor, nPredhIzbor

nPredhIzbor = 1
DO WHILE .T.

	MainWnd("MATICNI PODACI O OBVEZNIKU")

	Izbor = nPredhIzbor
	@ 8,27  PROMPT " UNOS MATICNIH PODATAKA     " MESSAGE "UNOS MATICNIH PODATAK"
	@ 10,27 PROMPT " IZMENA MATICNIH PODATAKA   " MESSAGE "IZMENA MATICNIH PODATAKA"
	@ 12,27 PROMPT " PROSIRENJE MATICNIH PODAT. " MESSAGE "PROSIRENJE MATICNIH PODATAKA ZA SIFRU DELATNOSTI,MAT.BR.RADNJE"

	CLEAR TYPEAHEAD
	MENU TO Izbor
	* nPredhIzbor = Izbor
	
	DO CASE
		CASE Lastkey() = 27
			EXIT
		CASE Izbor = 1
			DO MATUNOS
		CASE Izbor = 2
			DO MATIZME
		CASE Izbor = 3
			DO MATIZMEN
	ENDCASE
ENDDO

RETURN
