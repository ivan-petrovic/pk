LOCAL lIzmenio := .T.

DO WHILE .T.
   DAT1 = DATE()
   DAT2 = DATE()
   cNaEkran = "D"
   STR = 0
   BRSTAVKE = 0
   RED = 0
   UKUPNOM = VAL("000000000000.00")
   UKUPNO = VAL("000000000000.00")
   WPREOP = SPACE(30)
   
   MainMask("STAMPA RASHODA PERA")
   @ 08,10 SAY "NA EKRAN (D/N): " GET cNaEkran PICTURE "!" VALID(cNaEkran $ "DN")
   @ 10,10 SAY "KNJIGA RASHODA OD DATUMA: " GET DAT1 VALID !EMPTY(DAT1)
   @ 10,48 SAY "DO DATUMA:" GET DAT2 VALID !EMPTY(DAT2)
   READ
   
   IF LASTKEY() = 27
      RETURN
   ENDIF
   
   IF DAT1 > DAT2
      MessageBox("POCETNI DATUM VECI OD KRAJNJEG")
      LOOP
   ENDIF
   
   EXIT
ENDDO

SELECT 0
USE RASHODN
INDEX ON ROPIS TO RASOP
CLOSE RASHODN

SELECT 0
USE RASHODN INDEX RASOP
GO TOP

SET DEVICE TO PRINT
IF cNaEkran = 'D'
   SET PRINTER TO LISTA
ELSE
   SET PRINT TO LPT1
ENDIF
SET PRINT ON
SET CONSOLE OFF

SET PROCEDURE TO PERA1
DO PERA1

DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF RMIN = 0
      SKIP
      LOOP
   ENDIF
   WPREOP = ROPIS
   
   DO WHILE WPREOP = ROPIS
      IF RMIN = 0
         SKIP
         LOOP
      ENDIF
      IF DTOS(RDK) >= DTOS(DAT1) .AND. DTOS(RDK) <= DTOS(DAT2)
         @ RED,0 SAY RBR
         @ RED,11 SAY RDK
         @ RED,22 SAY ROPIS
         @ RED,55 SAY RMIN PICT "99,999,999.99"
         UKUPNOM = ROUND(UKUPNOM + RMIN,2)
         UKUPNO = ROUND(UKUPNO + RMIN,2)
         RED = RED + 1
         IF RED > 62
            RED = 0
            DO pera1
         ENDIF
      ELSE
         SKIP
         LOOP
      ENDIF
      SKIP
   ENDDO
   
   * ispis medjuzbira
   @ RED,0 SAY Replicate("*",80)
   RED = RED + 1
   @ RED,55 SAY UKUPNOM PICT "99,999,999.99"
   UKUPNOM = 0
   RED = RED + 1
ENDDO

RED = RED + 1
@ RED,0 SAY Replicate("*",80)
RED = RED + 1
@ RED,55 SAY UKUPNO PICT "99,999,999.99"

SET PRINT OFF
SET CONSOLE ON
SET DEVICE TO SCREEN
CLOSE RASHODN

IF cNaEkran = 'D'
   DO WHILE lIzmenio
      lIzmenio = m_type("lista.prn",80)
   ENDDO
ENDIF

RETURN

***********************************************************
PROCEDURE PERA1
   STR = STR + 1
   RED = RED + 2
   @ RED,1 SAY gcNazRad
   @ RED,35 SAY "STAMPANJE KNJIGE RASHODA"
   @ RED,70 SAY "STR:"
   @ RED,76 SAY STR PICT "9999"
   RED = RED + 1
   @ RED,5 SAY "OD:"
   @ RED,9 SAY DAT1
   @ RED,66 SAY "DO:"
   @ RED,70 SAY DAT2
   RED = RED + 1
   @ RED,0 SAY Replicate("*",80)
   RED = RED + 1
   @ RED,0 SAY "BROJ RACU."
   @ RED,11 SAY "DAT RACUN."
   @ RED,22 SAY "           OPIS               "
   @ RED,55 SAY "MAT.I NEMAT.TROS."
   RED = RED + 1
RETURN
***********************************************************
