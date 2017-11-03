*******************************************
* Glavni meni za Opis grupa artikala
*******************************************
LOCAL Izbor, nPredhIzbor

nPredhIzbor = 1
DO WHILE .T.

	MainWnd("GLAVNI MENI ZA GRUPE ARTIKALA")

	Izbor = nPredhIzbor
	@ 8 ,27 PROMPT " UNOS SIFARA             " MESSAGE "OTVARANJE NOVIH SIFARA GRUPA ARTIKALA"
	@ 10,27 PROMPT " IZMENA SIFARA           " MESSAGE "IZMENA SIFARA GRUPA ARTIKALA"
	@ 12,27 PROMPT " BRISANJE SIFARA         " MESSAGE "BRISANJE SIFARA GRUPA ARTIKALA"
	@ 14,27 PROMPT " LISTANJE SIFARA         " MESSAGE "LISTANJE SIFARA I NAZIVA GRUPA ARTIKALA KOJE PRODAJETE"

	CLEAR TYPEAHEAD
	MENU TO Izbor
	* nPredhIzbor = Izbor

	DO CASE
   	CASE Lastkey() = 27
      	EXIT
      CASE Izbor = 1
      	DO OPISUN
      CASE Izbor = 2
      	DO OPISIZ
		CASE Izbor = 3
      	DO OPISBR
		CASE Izbor = 4
        	DO OPISLI
	ENDCASE

ENDDO

RETURN
