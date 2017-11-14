LOCAL wDug, wwDug, wwPot, wwUpl, wPpsif, zez, lExit := .T.
LOCAL wBrKal, wDatKal, wBrOt, wDatOt, Izmenio, brojPolja

PRIVATE wPpnaz, Strana, Red, wOd, wDo

IF FILE("Kartadob.DBF")
   SELECT 0
   USE KARTADOB
   brojPolja = FCount()
   * MessageBox(Str(brojPolja))
   CLOSE KARTADOB
   * U staroj verziji ove stampe KARTADOB je imala 8 polja
   * Dodata su dva UPL i OPIS
   IF brojPolja = 8
      * MessageBox("Brisem KARTADOB.DBF")
      ERASE KARTADOB.DBF
   ENDIF
ENDIF

IF ! FILE("Kartadob.DBF")
	CREATE RADNA
	STORE "BRKAL     C10 " TO POLJE1
	STORE "DATKAL    D8  " TO POLJE2
	STORE "BROT      C10 " TO POLJE3
	STORE "DATOT     D8  " TO POLJE4
	STORE "DUG       N122" TO POLJE5
	STORE "POT       N122" TO POLJE6
	STORE "UPL       N122" TO POLJE7
	STORE "BANKA     N 3 " TO POLJE8
	STORE "IZVOD     N 3 " TO POLJE9
	STORE "OPIS      C10 " TO POLJE10
	FOR I = 1 TO 10
		IF I < 10
			STORE  STR(I,1) TO BROJ
		ELSE
			STORE  STR(I,2) TO BROJ
		ENDIF
		P1 = "POLJE" + BROJ
		APPEND BLANK
		REPLACE FIELD_NAME WITH SUBSTR(&P1,1,10)
		REPLACE FIELD_TYPE WITH SUBSTR(&P1,11,1)
		REPLACE FIELD_LEN WITH VAL(SUBSTR(&P1,12,2))
		REPLACE FIELD_DEC WITH VAL(SUBSTR(&P1,14,1))
	NEXT I
	CREATE KARTADOB FROM RADNA
	INDEX ON DTOS(DATKAL) TO KARTADAT
	USE
	ERASE RADNA.DBF
ENDIF

SELECT 0
USE GKZIRO
INDEX ON STR(PPIZVOD)+DTOS(BDIZ) TO GKZINPD
CLOSE GKZIRO

SELECT 1 
USE DMPDAT INDEX DMPINBRO
SELECT 2
USE PPDAT INDEX PPINSIF
SELECT 3
USE RASHODN INDEX RASHINDN     && PO DATUMU 
SELECT 4
USE KARTADOB INDEX KARTADAT    && PO DATUMU PROMENE
ZAP
SELECT 5
USE BANKDAT INDEX BINSIF
SELECT 6
USE GKZIRO INDEX GKZINPD

DO WHILE .T.

   wDug   = Val("000000000000.00")
   wwDug  = Val("000000000000.00")
   wwPot  = Val("000000000000.00")
   wwUpl  = Val("000000000000.00")
   wPpsif = Val("000000")
   wOd = CtoD("  .  .  ")
   wDo = CtoD("  .  .  ")
   Red    = 0
   Strana = 1

   MainMask("STAMPANJE KARTICE DOBAVLJACA")
   
   @ 5,10 SAY "SIFRA DOBAVLJACA: " GET wPpsif VALID ! Empty(wPpsif)
   READ

	IF Lastkey() = 27
		EXIT
	ENDIF

   SELECT 2	
   SEEK wPpsif
   IF Found()
      wPpnaz = PPNAZ
      @ 5,35 SAY wPpnaz
   ELSE
      MessageBox("NEMA TOG POSLOVNOG PARTNERA!")
      LOOP
   ENDIF

   @ 7,10 SAY "OD DATUMA: " GET wOd VALID ! Empty(wOd)
   @ 8,10 SAY "DO DATUMA: " GET wDo VALID(wDo >= wOd)
   READ

   IF Lastkey() = 27
      EXIT
   ENDIF
	lExit = .F.

   SELECT 1    && dmpdat
	DO WHILE ! Eof()

		IF DMPDAT < wOd .OR. DMPDAT > wDo
			SKIP
			LOOP
		ENDIF

		IF DMPDOB = wPpsif
			wBrKal  = DMPBRO
			wDatKal = DMPDAT
			wBrOt   = DMPFAK
			wDatOt  = DMPDFAK
			zez     = DMPBRO

			DO WHILE zez = DMPBRO
				IF VRSTA = " "
					wDug = Round(DMPKOL * DMPNC,2) + wDug
				ELSE
					wDug = Round(wDug + DMPNC,2)
				ENDIF
				SKIP
			ENDDO

			* ovde upisati dogadjaje u bazu karatadob
			SELECT 4
			APPEND BLANK
			REPLACE BRKAL  WITH wBrKal
			REPLACE DATKAL WITH wDatKal
			REPLACE BROT   WITH wBrOt
			REPLACE DATOT  WITH wDatOt
			REPLACE DUG    WITH wDug

			SELECT 1
			wDug    = 0
			wBrKal  = Space(10)
         wDatKal = CtoD("  .  .  ")
			wBrOt   = Space(10)
			wDatOt  = CtoD("  .  .  ")
		ELSE
			SKIP
		ENDIF
	ENDDO

	SELECT 6		&& gkziro
	DO WHILE ! Eof()
		IF BDIZ < wOd .OR. BDIZ > wDo
			SKIP
			LOOP
		ENDIF

		IF PPIZVOD = wPpsif
			* ovde upisati dogadjaje u bazu karatadob
			SELECT 4
			APPEND BLANK
			REPLACE BRKAL  WITH Alltrim(Str(F->RB,10))
			REPLACE DATKAL WITH F->BDIZ
			REPLACE BROT   WITH Alltrim(str(F->BANK,10))
			REPLACE POT    WITH F->ISPL
			REPLACE UPL    WITH F->UPL
			REPLACE OPIS   WITH SubStr(F->OPIS,1,10)

			SELECT 6
		ENDIF

		SKIP
	ENDDO

	SELECT 3		&& rashodn
	DO WHILE ! Eof()
		IF RDATDOK < wOd .OR. RDATDOK > wDo
			SKIP
			LOOP
		ENDIF

		IF PP = wPpsif
			* ovde upisati dogadjaje u bazu karatadob
			SELECT 4
			APPEND BLANK
			REPLACE BRKAL  WITH C->RBR
			REPLACE DATKAL WITH C->RDATDOK
			REPLACE DUG    WITH Round(C->RPBEZ2 + C->RMIN,2)

			SELECT 3
		ENDIF

		SKIP
	ENDDO

	EXIT
ENDDO

CLOSE DATABASES

IF lExit
	RETURN
ENDIF

* otvoriti kartadob i odstampati stavke
SELECT 1
USE KARTADOB INDEX KARTADAT

SET DEVICE TO PRINTER
SET PRINT TO LISTA.DAT
SET PRINT ON

Nasmam1()
DO WHILE ! Eof()
	IF Red > 60
		Red = Red + 1
		Nasmam1()
	ENDIF
		StamRed1()
		wwDug = wwDug + DUG
		wwPot = wwPot + POT
		wwUpl = wwUpl + UPL
		Red = Red + 1
	SKIP
ENDDO

@ Red,0 SAY Replicate("-",102)

Red = Red + 1
@ Red,46 SAY wwDug PICTURE "999,999,999.99"
@ Red,61 SAY wwPot PICTURE "999,999,999.99"
@ Red,76 SAY wwUpl PICTURE "999,999,999.99"

Red = Red + 1
IF wwDug > wwPot
   @ Red,35 SAY "SALDO :"
   @ Red,46 SAY Round(wwDug - wwPot,2) PICTURE "999,999,999.99"
ELSE
   @ Red,35 SAY "SALDO :"
   @ Red,61 SAY Round(wwPot - wwDug,2) PICTURE "999,999,999.99"
ENDIF
@ Red,0 SAY " "

IF lLaser
   ? Chr(27)+ Chr(69)         && kondenz Off za laserski
ELSE
   ? Chr(18)                  && kondenz Off za matricni
ENDIF

EJECT
CLOSE DATABASES
SET DEVICE TO SCREEN
SET PRINT OFF
SET PRINT TO

* ubacen deo za pregled
Izmenio:= .T.
DO WHILE Izmenio
   Izmenio = m_type("lista.dat",102)
ENDDO
* kraj ubacenog dela

SET CURSOR ON

RETURN

**********************************************
PROCEDURE Nasmam1
   LOCAL control_str

   IF lLaser
      control_str = Chr(27) + '(s15H' + Chr(27) + '&18C'
      @ 0,0 SAY control_str              && kondenz On za laserski
   ELSE
      @ 0,0 SAY Chr(15)                  && kondenz On za matricni
   ENDIF

   @ 1,1  SAY gcNazRad
   @ 2,15 SAY "KARTICA DOBAVLJACA"
   @ 2,35 SAY wPpnaz
   @ 2,71 SAY "STR."
   @ 2,76 SAY Strana PICTURE "999"
   @ 3,21 SAY "OD DATUMA"
   @ 3,32 SAY wOd
   @ 3,43 SAY "DO DATUMA"
   @ 3,54 SAY wDo
   @ 4,0  SAY Replicate("-",102)
   @ 5,2  SAY "BR.FAKTURE"
   @ 5,13 SAY "DAT.FAKTUR"
   @ 5,24 SAY "BR.OTPREMN"
   @ 5,35 SAY "DAT.OTPREM"
   @ 5,46 SAY "DUG DOBAVLJACU"
   @ 5,61 SAY "PLACENO DOBAV."
   @ 5,76 SAY "  UPL.NA RACUN"
   @ 5,91 SAY "   OPIS   "

   @ 6,2  SAY "BR.IZVODA "
   @ 6,13 SAY "DAT.IZVODA"
   @ 6,24 SAY "SIF.BANKE "

   @ 7,0 SAY Replicate("-",102)
   Red = 8

RETURN

**********************************************
PROCEDURE StamRed1

	@ Red, 2 SAY BRKAL
	@ Red,13 SAY DATKAL

	IF POT <> 0
	   @ Red,24 SAY Substr(BROT, 1, 3)
	ELSE
	   @ Red,24 SAY BROT
	ENDIF

	IF POT <> 0
	   SELECT 0
   	USE BANKDAT INDEX BINSIF
   	SEEK Val(Substr(KARTADOB->BROT, 1, 3))
   	IF Found()
      	@ Red,28 SAY Substr(BANKDAT->NAZBANK, 1, 17)
      	CLOSE BANKDAT
      	SELECT KARTADOB
   	ENDIF
	ELSE
   	@ Red,35 SAY DATOT
	ENDIF

@ Red,46 SAY DUG PICTURE "999,999,999.99"
@ Red,61 SAY POT PICTURE "999,999,999.99"
@ Red,76 SAY UPL PICTURE "999,999,999.99"
@ Red,91 SAY OPIS

RETURN

**********************************************
