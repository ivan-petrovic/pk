*************************************************
* Glavni meni za izbor posla preracunatog poreza
*************************************************
LOCAL Izbor, nPredhIzbor

nPredhIzbor = 1
DO WHILE .T.

	MainWnd("P R E R A C U N A T I    P O R E Z")

	Izbor = nPredhIzbor
	@ 10,27 PROMPT " UNOS,IZMENA,BRISANJE UPLATNIH ZIR.RAC. " MESSAGE "UNOS,IZMENA,STAMPANJE UPLATNIH RACUNA ZA VIRMANE"
	@ 12,27 PROMPT " STAMPA VIRMANA                         " MESSAGE "STAMPANJE VIRMANA ZA OBACUNATI POREZ I DOPRINOS"
   * @ 12,27 PROMPT " STAMPA VIRMANA ZA OBRACUNAT POREZ      " MESSAGE "STAMPANJE VIRMANA ZA OBACUNATI POREZ"
	* @ 14,27 PROMPT " STAMPA VIRMANA JMBG                    " MESSAGE "STAMPANJE VIRMANA AKO JE KONTROLNI JMBG"

	CLEAR TYPEAHEAD
	MENU TO Izbor
	* nPredhIzbor = Izbor

	DO CASE
		CASE Lastkey() = 27
			EXIT
		CASE Izbor = 1
			DO ZIRPLACU
		CASE Izbor = 2
			DO VIRM1
			* DO VIRPOROO
      * CASE Izbor = 3
         * DO VIRPORDO
	ENDCASE

ENDDO

RETURN
