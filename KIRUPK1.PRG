* Azuriranje PK1 iz KIR-a
* Jednom je trebalo za Veru, pa sam ga dodao privremeno ovde;
* Trenutno je neaktivan, tj. ne poziva se ni iz jednog menija
zbir   = Val("000000000000.00")
zbir18 = Val("000000000000.00")
zbir8  = Val("000000000000.00")
wpre = CtoD("  .  .  ")
dat1 = Date()
dat2 = Date()

CLEAR SCREEN
@ 4,8 SAY "AZURIRANJE PK1 IZ KIRA OD DATUMA: " GET DAT1
@ 5,8 SAY "DO DATUMA: " GET DAT2
READ

IF Lastkey() =  27
   RETURN
ENDIF

SELECT 0
USE KIR INDEX KIRDK
SELECT 0
USE RASHODN INDEX RASHINDN,RASHINKN

SELECT KIR
DO WHILE ! Eof()
   IF DATKKIR < dat1 .OR. DATKKIR > dat2
      SKIP
      LOOP
   ENDIF

   wpre = DATKKIR

   DO WHILE wpre = DATKKIR
      IF OSN18 <> 0
         zbir18 = Round(zbir18 + Round(OSN18 + IZN18,2),2)
      ENDIF
      IF OSN8 <> 0
         zbir8 = Round(zbir8 + Round(OSN8 + IZN8,2),2)
      ENDIF
      SKIP
   ENDDO
   zbir = Round(zbir18 + zbir8,2)

   SELECT RASHODN
*   SEEK DtoS(wpre)
*   IF Found()
*      DO WHILE wpre = RDK
*         IF (RPV+RPN+RSVEP) <> 0 .OR. RSVEP = ZBIR .OR. SUBSTR(ROPIS,1,3) = "PAZ"
*            REPLACE RPV   WITH zbir18
*            REPLACE RPN   WITH zbir8
*            REPLACE RSVEP WITH ROUND(zbir,2)
*            EXIT
*         ENDIF
*         SKIP
*      ENDDO
*   ELSE
      APPEND BLANK
      REPLACE RRB     WITH 100
      REPLACE RDK     WITH WPRE
      REPLACE RBR     WITH ("5/" + ALLTRIM(STR(RRB,4,0)))
      REPLACE RDATDOK WITH WPRE
      REPLACE ROPIS   WITH "PAZAR STR"
      REPLACE RPV     WITH zbir18
      REPLACE RPN     WITH zbir8
      REPLACE RSVEP   WITH ROUND(zbir,2)
*   ENDIF

   zbir18 = 0
   zbir8 = 0
   zbir = 0

   SELECT KIR
ENDDO

CLOSE DATABASES
RETURN
