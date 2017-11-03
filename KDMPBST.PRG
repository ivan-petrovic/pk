SELECT 1
USE DMPDAT INDEX DMPINBRO,DMPINBS 
SELECT 2
USE ARTPANE INDEX APINSIF

DO WHILE .T.	&&  (1) u algoritmu
	s1 = Val("00000000000000.00")
	s2 = Val("00000000000000.00")
	s3 = Val("00000000000000.00")
	s4 = Val("00000000000000.00")
	s5 = Val("00000000000000.00")
	store 0 to indik,indik1,indik2,indik3,indik4,indik5
	wdmpbro = Space(10)
	wdmdob  = Val("000000")
	wdmpsta = Val("000")
	wvrsta  = " "
	wstopa  = Val("000.00")
	wdmpkol = Val("0000000000.000")
	dn      = " "

	MainMask("BRISANJE STAVKE KALKULACIJE")

   @ 5,1 SAY "Broj kalkulacije:" GET wdmpbro PICTURE "@!" VALID ! Empty(wdmpbro)
   READ
   
	IF Lastkey() = 27
   	EXIT
   ENDIF
   
	SELECT 1
   SEEK wdmpbro
   IF ! Found()
   	MessageBox("Ne postoji ta kalkulacija u sistemu!")
      LOOP
   ENDIF
   
	@ 6,1 SAY "Broj stavke koju zelite da brisete? " GET wdmpsta PICTURE "999" VALID ! Empty(wdmpsta)
   READ
   
	IF Lastkey() = 27
   	LOOP
   ENDIF
   
	SKIP (wdmpsta - 1)
   IF Eof()
   	MessageBox("Nema toliko stavki u kalkulaciji!")
      LOOP
   ENDIF
   
	IF ! wdmpbro = DMPBRO
   	MessageBox("Nema toliko stavki u kalkulaciji!")
      LOOP
   ENDIF
   
	DO WHILE .T.	&& (2) u algoritmu
		s1 = Val("00000000000000.00")
		s2 = Val("00000000000000.00")
		s3 = Val("00000000000000.00")
		s4 = Val("00000000000000.00")
		s5 = Val("00000000000000.00")
		s6 = Val("00000000000000.00")

		nLen = Len(Alltrim(DMPNAZ))
		@ 8 ,1 SAY "Naziv artikla: " + Space(15 - nLen) + Alltrim(DMPNAZ) 
		@ 9 ,1 SAY "Kolicina:      " + Str(DMPKOL,15,3)
		@ 10,1 SAY "Cena:          " + Str(DMPNC,15,2)

      dn = " "
      @ 23,1 SAY Centriraj("Page Up --> Sledeca stavka    Page Down --> Prethodna stavka",78)
      @ 15,1 SAY "Brisanje ove stavke (D/N)? " GET dn 
      READ
      
		IF Lastkey() = 27
         indik = 1
         EXIT
      ENDIF
      
		IF Lastkey() = 3		&& PageUp
      	SKIP -1
         IF Bof()
            MessageBox("Ovo je prva stavka!")
            @ 8,1 CLEAR TO 23,78
            SKIP
            LOOP
      	ENDIF

	      IF ! DMPBRO = wdmpbro
	         MessageBox("Ovo je prva stavka!")
	         @ 8,1 CLEAR TO 23,78
	         SKIP
	         LOOP
	      ENDIF
	      LOOP
   	ENDIF
      
		IF Lastkey() = 18		&& PageDown
      	SKIP
         IF Eof()
            MessageBox("Ovo je poslednja stavka!")
            @ 8,1 CLEAR TO 23,78
            SKIP -1
            LOOP
         ENDIF
         
			IF ! wdmpbro = DMPBRO
            MessageBox("Ovo je poslednja stavka!")
            @ 8,1 CLEAR TO 23,78
            SKIP -1
            LOOP
         ENDIF
         LOOP
      ENDIF
      
		IF Empty(dn)
      	LOOP
      ENDIF

		IF dn = "N" .OR. dn = "n"
      	indik = 1
         EXIT
      ENDIF
      
		IF dn = "D" .OR. dn = "d"
			wdmpart = DMPSIF
			wdmpdob = DMPDOB
			wstopa  = DMPPOR 
			wvrsta  = VRSTA
			wdmpkol = DMPKOL

         * skini sa kolicine
         SELECT 2
         SEEK wdmpart
         IF Found()
         	REPLACE ARTKOL WITH Round(ARTKOL - wdmpkol,3)
         ELSE
				MessageBox("NISAM U ARTIKLIMA NASAO SIFRU " + Str(wdmpart,13))
         ENDIF
         * kraj skidanja sa kolicine
         
			SELECT 1
         prer = Val("00.00") 
         prer = Round((DMPPOR * 100) / (DMPPOR + 100),2)
         s1 = s1 + Round(DMPKOL * DMPNC,2)					&&  nabavna cena
         s2 = s2 + Round(DMPVSP - (Round(DMPMSP * DMPKOL * prer / 100,2) + Round(DMPKOL * DMPNC,2) + DMPZIZ),2)	&& razlika u ceni
         s3 = s3 + Round(DMPMSP * DMPKOL * prer / 100,2)	&& obracunati porez
         s4 = s4 + DMPVSP     									&& maloprodajna vrednost
         s5 = s1
         s6 = s6 + DMPZIZ											&& zavisni troskovi

         SELECT 3
         USE RASHODN INDEX RASHINKN,RASHINDN
         SEEK wdmpbro
         IF Found()
				REPLACE RNVRRR WITH Round(RNVRRR - s1,2)
				REPLACE RRUCP  WITH Round(RRUCP  - s2,2)
				REPLACE ROBPOR WITH Round(ROBPOR - s3,2)
				REPLACE RPRODV WITH Round(RPRODV - s4,2)
				REPLACE RRASUK WITH Round(RRASUK - s5,2)
            IF RNVRRR = 0
            	DELETE
            ENDIF
         ELSE
         	MessageBox("NISAM NASAO KALKULACIJU U KNJIZI RASHODA! ZVATI DARKA 8720-036.")
         ENDIF

         SELECT 5
         USE TRG INDEX TRGKAL,TINOR
         SEEK wdmpbro
         IF Found()
         	REPLACE ZAD WITH Round(ZAD - s4,2)
            IF zad = 0
            	DELETE
            ENDIF
         ELSE
         	MessageBox("NISAM NASAO KALKULACIJU U TRGOVACKOJ KNJIZI")
         ENDIF
         
			DO BS

         SELECT 1
         DELETE

         indik = 0
         EXIT
      ENDIF && od dn = "D" .OR. dn = "d"

   ENDDO		&& (2) u algoritmu

	IF indik = 1
		indik = 0
		LOOP
	ENDIF

ENDDO		&& (1) u algoritmu

SELECT 1
PACK
SELECT 3
PACK
SELECT 5
PACK

CLOSE DATABASES

RETURN
