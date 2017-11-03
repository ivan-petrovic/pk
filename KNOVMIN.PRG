IF ! File("poreznbb.ntx")
	USE POREZN
	INDEX ON BROJ TO POREZNBB
	USE
ENDIF

SELECT 9
USE POREZN INDEX POREZNBB,POREZNB,POREZND

kljuc = wdmpbk
SEEK kljuc
IF ! Found()
	APPEND BLANK
	REPLACE DATK  WITH wdmpdat
	REPLACE RBPK1 WITH WKRRB
	REPLACE BROJ  WITH wdmpbk
	REPLACE OPIS  WITH "POVRACAJ ROBE IZ STR-a"
	REPLACE TAKS  WITH Round(mtaksa * wdmpkol * (-1),2)

	DO CASE
		CASE (wtarzbir = 18 .OR. wtarzbir = 20) .AND. kpc = 1
			REPLACE VISAKPC WITH (wdmpvsp * (-1))
		CASE (wtarzbir = 18 .OR. wtarzbir = 20) .AND. kpc = 0
			REPLACE VISA WITH (wdmpvsp * (-1))
		CASE (wtarzbir = 8 .OR. wtarzbir = 15) .AND. KPC = 0
			REPLACE NIZA WITH (wdmpvsp * (-1))
		CASE (wtarzbir = 8 .OR. wtarzbir = 15) .AND. KPC = 1
			REPLACE NIZA WITH (wdmpvsp * (-1))
		CASE wtarzbir = 16 .OR. wtarzbir = 21
			REPLACE NIZA1 WITH (wdmpvsp * (-1))
		* CASE wtarzbir = 20
		* 	 REPLACE NULA06 WITH (wdmpvsp * (-1))
		CASE wtarzbir = 28
			REPLACE NULA2 WITH (wdmpvsp * (-1))
		CASE wtarzbir = 12
			REPLACE NULA4 WITH (wdmpvsp * (-1))
		CASE wtarzbir = 3
			REPLACE NULA3 WITH (wdmpvsp * (-1))
		CASE wtarzbir = 1
			REPLACE NULA1 WITH (wdmpvsp * (-1))
		CASE wtarzbir = 0
			REPLACE NULA WITH (wdmpvsp * (-1))
	ENDCASE
   REPLACE VRROBE WITH (wdmpvsp * (-1))
ELSE
   REPLACE TAKS WITH (taks + round(mtaksa * wdmpkol * (-1),2))
	DO CASE
		CASE (wtarzbir = 18 .OR. wtarzbir = 20) .and. kpc = 1
			REPLACE VISAKPC WITH Round(visakpc + (wdmpvsp * (-1)),2)
		CASE (wtarzbir = 18 .OR. wtarzbir = 20) .and. kpc = 0
			REPLACE VISA WITH Round(visa + (wdmpvsp * (-1)),2)
		CASE (wtarzbir = 8 .OR. wtarzbir = 15) .AND. KPC = 0
			REPLACE NIZA WITH Round(niza + (wdmpvsp * (-1)),2)
		CASE (wtarzbir = 8 .OR. wtarzbir = 15) .AND. KPC = 1
			REPLACE NIZA WITH Round(niza + (wdmpvsp * (-1)),2)
		CASE wtarzbir = 16 .OR. wtarzbir = 21
			REPLACE NIZA1 WITH Round(niza1 + (wdmpvsp * (-1)),2)
		* CASE wtarzbir = 20
		* 	 REPLACE NULA06 WITH Round(nula06 + (wdmpvsp * (-1)),2)
		CASE wtarzbir = 28
			REPLACE NULA2 WITH Round(nula2 + (wdmpvsp * (-1)),2)
		CASE wtarzbir = 12
			REPLACE NULA4 WITH Round(nula4 + (wdmpvsp * (-1)),2)
		CASE wtarzbir = 3
			REPLACE NULA3 WITH Round(nula3 + (wdmpvsp * (-1)),2)
		CASE wtarzbir = 1
			REPLACE NULA1 WITH Round(nula1 + (wdmpvsp * (-1)),2)
		CASE wtarzbir = 0
			REPLACE NULA WITH Round(nula + (wdmpvsp * (-1)),2)
	ENDCASE
   REPLACE VRROBE WITH Round(vrrobe + (wdmpvsp * (-1)),2)
ENDIF

USE
RETURN
