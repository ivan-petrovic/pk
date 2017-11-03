por = "Otkucajte neku tipku za dalje..."

DO WHILE .T.   && main

	wdmpdob = val("000000")
	wnaz = Space(30)
	indik9 = 0
	indik13 = 0

	@ 4,1 SAY "(Page Down -pomoc-)"
	@ 3,1 SAY "Posl.partner:" GET wdmpdob PICTURE "999999" 
   READ
   
	IF Lastkey() = 27
   	uspeh = 0
      EXIT
   ENDIF
   
	IF Lastkey() = 3		&& PageDown
   	@ 19,1 SAY "Unesite deo naziva poslovnog partnera:" GET wnaz ;
		       PICTURE "@!" VALID ! Empty(wnaz)
		READ
      
		IF Lastkey() = 27
      	LOOP
      ENDIF
      
		SELECT 7
      USE PPDAT INDEX PPINSIF
      SET FILTER TO ! At(Alltrim(wnaz),PPNAZ) = 0
      GO TOP
      
		IF Eof()
      	MessageBox("Ne postoji PP sa takvim delom naziva!")
         SET FILTER TO
         USE
         @ 20,0 SAY Space(80)
         @ 21,0 SAY Space(80)
         @ 19,0 SAY Space(80)
         @ 22,0 SAY Space(80)
         LOOP
      ENDIF
      
		indik11 = 0
      indik12 = 0
      
		DO WHILE ! Eof()
      	dn = " "
         @ 19,0 SAY Space(80)
         @ 19,0 SAY PPSIF
         ?? "  "
         ?? ppnaz
         ?? "   "
         ?? ppmes
         @ 22,10 SAY "Da li ste mislili na ovog PP (D/N) ? " GET dn ;
			        PICTURE "!" VALID (dn $ "DN")
         READ
         
			IF Lastkey() = 27
         	USE
            SET FILTER TO
            FOR I = 19 TO 24
            	@ i,0 SAY Space(80)
            NEXT I
            indik11 = 1
            uspeh = 0
            EXIT
         ENDIF
         
			IF dn = "N"
         	SKIP
            LOOP
         ENDIF
         
			IF dn = "D"
         	@ 4,0 SAY Space(80)
				wdmpdob = ppsif
				psif =  ppsif
				pmesto = ppmes
				pime = ppnaz
				@ 3,15 SAY ppsif
				@ 3,25 SAY ppnaz
				FOR I = 19 TO 24
					@ i,0 SAY Space(80)
				NEXT I
            indik12 = 1
				USE
				SET FILTER TO
            uspeh = 1
            EXIT
         ENDIF
      ENDDO
      
		IF indik11 = 1
      	indik11 = 0
         LOOP
      ENDIF
      
		IF indik12 = 0
      	@ 22,1 SAY Space(80)
         MessageBox("Nema vise poslovnih partnera sa tim delom naziva!")
         SET FILTER TO
         USE
         FOR I = 19 TO 24
         	@ i,0 SAY Space(80)
         NEXT I
         LOOP
      ENDIF
      indik13 = 1
   ENDIF  && od Helpa
   
	IF indik13 = 0
   	@ 4,0 SAY Space(80)
      SELECT 7
      USE PPDAT INDEX PPINSIF
      SEEK wdmpdob
      IF ! Found()
         USE
         MessageBox("Ne postoji taj PP!")
         @ 19,1 SAY Replicate(" ",78)
			@ 20,0 SAY Replicate(" ",78)
			@ 21,0 SAY Replicate(" ",78)
			LOOP
      ENDIF
      
		wposp  = ppnaz
      pime   = ppnaz
      psif   = wdmpdob
      pmesto = ppmes
      @ 3,40 SAY wposp
      USE
      uspeh = 1
      EXIT
   ENDIF

   indik13 = 0

	IF indik12 = 1
		indik12 = 0
		EXIT
	ENDIF

ENDDO   && *** main

RETURN
