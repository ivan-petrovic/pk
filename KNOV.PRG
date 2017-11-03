LOCAL kljuc

IF ! File("poreznbb.ntx")
	USE POREZN
	INDEX ON BROJ TO POREZNBB
	USE
ENDIF

SELECT 9
USE POREZN INDEX POREZNBB,POREZNB,POREZND

kljuc = wDmpBk
SEEK kljuc
IF ! Found()
   APPEND BLANK
   REPLACE DATK  WITH wDmpDat
   REPLACE RBPK1 WITH wKrRb
   REPLACE BROJ  WITH wDmpBk
   REPLACE OPIS  WITH (Alltrim(wDmpFak) + " " + Alltrim(wKrOpk))
   REPLACE TAKS  WITH Round(mTaksa * wDmpKol,2)
   
	DO CASE
   	CASE (wTarZbir = 18 .OR. wTarZbir = 20) .AND. KPC = 1
      	REPLACE VISA WITH wDmpVsp
      CASE wTarZbir = 8 .AND. KPC = 1
         REPLACE NIZA WITH wDmpVsp
      CASE wTarZbir = 0
         REPLACE NULA WITH wDmpVsp
   ENDCASE
   
	REPLACE VRROBE WITH wDmpVsp
ELSE
   REPLACE TAKS WITH (TAKS + Round(mTaksa * wDmpKol,2))
   
	DO CASE
   	CASE (wTarZbir = 18 .OR. wTarZbir = 20) .AND. KPC = 1
      	REPLACE VISA WITH Round(VISA + wDmpVsp,2)
      CASE wTarZbir = 8 .AND. KPC = 1
         REPLACE NIZA WITH Round(NIZA + wDmpVsp,2)
      CASE wTarZbir = 0
         REPLACE NULA WITH Round(NULA + wDmpVsp,2)
   ENDCASE
   
	REPLACE VRROBE WITH Round(VRROBE + wDmpVsp,2)
ENDIF

USE

RETURN
