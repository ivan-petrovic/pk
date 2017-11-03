*******************************************
* Upiti o poslovnim partnerima
*******************************************
LOCAL ppIzbor, nPredhIzbor

nPredhIzbor = 1
DO WHILE .T.

	MainMask("UPITI O POSLOVNIM PARTNERIMA")
	@ 5,9 TO 13,29
	@ 14,9 TO 22,29

   ppIzbor = nPredhIzbor
   @ 6,10  PROMPT "UPIT PO SIFRI"
   @ 8,10  PROMPT "UPIT PO MESTU"
   @ 10,10 PROMPT "UPIT PO ZIRO-RACUNU"
   @ 12,10 PROMPT "UPIT PO NAZIVU"
   @ 15,10 PROMPT "POMOCNI PROGRAM"
   @ 17,10 PROMPT "POMOCNI PROGRAM"
   @ 19,10 PROMPT "POMOCNI PROGRAM"
   @ 21,10 PROMPT "POMOCNI PROGRAM"

   MENU TO ppIzbor
   nPredhIzbor = ppIzbor

	DO CASE
		CASE Lastkey() = 27
			EXIT
		CASE ppIzbor = 1
			DO PPUPSIF
		CASE ppIzbor = 2
			DO PPUPMES
		CASE ppIzbor = 3
			DO PPUPZIR
		CASE ppIzbor = 4
			DO PPUPNAZ
		CASE ppIzbor = 5
			* DO PPUNOS1
			MessageBox("PPUNOS1")			
		CASE ppIzbor = 6
			* DO ARTUNOS1
			MessageBox("ARTUNOS1")			
		CASE ppIzbor = 7
			* DO TARUNOS1
			MessageBox("TARUNOS1")			
		CASE ppIzbor = 8
			* DO BANKUN1
			MessageBox("BANKUN1")			
	ENDCASE

ENDDO

RETURN
