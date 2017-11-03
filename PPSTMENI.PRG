*******************************************
* Stampa podataka o poslovnim partnerima
*******************************************
LOCAL ppIzbor, nPredhIzbor

nPredhIzbor = 1
DO WHILE .T.

	MainMask("STAMPA PODATAKA O POSLOVNIM PARTNERIMA")
	@ 5,9 TO 9,42
	
	ppIzbor = nPredhIzbor
	@ 6,10 PROMPT "STAMPA JEDNOG POSLOVNOG PARTNERA"
	@ 8,10 PROMPT "STAMPA SVIH POSLOVNIH PARTNERA  "

	MENU TO ppIzbor
	nPredhIzbor = ppIzbor
	
	DO CASE
		CASE Lastkey() = 27
			EXIT
		CASE ppIzbor = 1
			DO PPSTAM
		CASE ppIzbor = 2
			DO PPSTSV
	ENDCASE

ENDDO

RETURN
