LOCAL zbir, zbir18, zbir8, zbirn, mPor18, mPor8, wpre, wprer, Dat1, Dat2

zbir   = Val("000000000000.00")
zbir18 = Val("000000000000.00")
zbir8  = Val("000000000000.00")
zbirn  = Val("000000000000.00")     && bez PDV-a
mPor18 = Val("000000000000.00")
mPor8  = Val("000000000000.00")
wpre   = CtoD("  .  .  ")
wprer  = Space(10)
Dat1   = Date()
Dat2   = Date()

MainMask("AZURIRANJE TRG_a IZ KNJIGE PRIHOD-RASHOD")
@ 4,8 SAY "OD DATUMA: " GET Dat1
@ 5,8 SAY "DO DATUMA: " GET Dat2
READ

IF Lastkey() =  27
   RETURN
ENDIF

SELECT 0
USE TRG INDEX TINOR,TRGKAL
SELECT 0
USE RASHODN INDEX RASHINDN

DO WHILE ! Eof()
   IF RDK < Dat1 .OR. RDK > Dat2
      SKIP
      LOOP
   ENDIF

   wpre = RDK

   DO WHILE wpre = RDK
      IF RPV <> 0 .OR. RPN <> 0 .OR. RPBEZ <> 0
         wpre  = RDK
         wprer = RBR
      ENDIF

      zbir18 = Round(zbir18 + RPV, 2)
      zbir8  = Round(zbir8 + RPN, 2)
      zbirn  = Round(zbirn + RPBEZ, 2)
      zbir   = Round(zbir18 + zbir8 + zbirn, 2)

      SKIP
   ENDDO

   IF zbir = 0
      LOOP
   ENDIF

   SELECT TRG
   APPEND BLANK
   REPLACE BRKAL WITH wprer
   REPLACE DK    WITH wpre
   REPLACE OPK   WITH "PAZAR"
   REPLACE RAZ   WITH zbir

   zbir18 = 0
   zbir8  = 0
   zbirn  = 0
   zbir   = 0
   mpor18 = 0
   mpor8  = 0

   SELECT RASHODN
ENDDO

CLOSE DATABASES
RETURN
