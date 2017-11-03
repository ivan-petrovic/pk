zbir   = Val("000000000000.00")
zbir18 = Val("000000000000.00")
zbir8  = Val("000000000000.00")
wpre = CtoD("  .  .  ")
dat1 = Date()
dat2 = Date()

CLEAR SCREEN
@ 4,8 SAY "AZURIRANJE PK1 IZ PRODATIH ARTIKALA OD " GET DAT1
@ 4,56 SAY "DO DATUMA" GET DAT2
READ

IF Lastkey() =  27
   RETURN
ENDIF

SELECT 0
USE PAZDAT INDEX PAZINDAT
SELECT 0
USE RASHODN INDEX RASHINDN,RASHINKN

SELECT PAZDAT
DO WHILE ! Eof()
   IF PAZDAT < dat1 .OR. PAZDAT > dat2
      SKIP
      LOOP
   ENDIF

   wpre = PAZDAT

   DO WHILE wpre = PAZDAT
      DO CASE
         * bilo je ovako CASE PAZSTOP = 18, ali u 2012 ima stopa 18% i 20%
			CASE PAZSTOP = 18 .OR. PAZSTOP = 20
            zbir18 = Round(zbir18 + Round(PAZKOL * PAZCDIN,2),2)
         * bilo je ovako CASE PAZSTOP = 8, ali od 2014 ima stopa 8% i 10%
         CASE PAZSTOP = 8 .OR. PAZSTOP = 10
            zbir8 = Round(zbir8 + round(PAZKOL * PAZCDIN,2),2)
      ENDCASE
      zbir = Round(zbir18 + zbir8,2)
      SKIP
   ENDDO

   SELECT RASHODN
   SEEK DtoS(wpre)
   IF Found()
      DO WHILE wpre = RDK
         IF (RPV+RPN+RSVEP) <> 0 .OR. RSVEP = ZBIR .OR. SUBSTR(ROPIS,1,3) = "PAZ"
            REPLACE RPV WITH zbir18
            REPLACE RPN WITH zbir8
            REPLACE RSVEP WITH ROUND(zbir,2)
            EXIT
         ENDIF
         SKIP
      ENDDO
   ELSE
      APPEND BLANK
      REPLACE RRB WITH 100
      REPLACE RDK WITH WPRE
      REPLACE RBR WITH ("5/" + ALLTRIM(STR(RRB,4,0)))
      REPLACE RDATDOK WITH WPRE
      REPLACE ROPIS WITH "PAZAR STR"
      REPLACE RPV WITH ZBIR18
      REPLACE RPN WITH ZBIR8
      REPLACE RSVEP WITH ROUND(ZBIR,2)
   ENDIF

   zbir18 = 0
   zbir8 = 0
   zbir = 0

   SELECT PAZDAT
ENDDO

CLOSE DATABASES
RETURN
