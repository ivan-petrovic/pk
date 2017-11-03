SELECT 9
USE POREZN INDEX POREZNBB,POREZNB,POREZND

kljuc = wdmpbro
SEEK kljuc
IF ! Found()
	USE
	RETURN
ENDIF

DO CASE
	CASE wstopa = 23 .AND. wvrsta # " "
		REPLACE taks    WITH Round(taks - A->dmpkol * A->taksa,2)
		REPLACE visakpc WITH Round(visakpc - A->dmpkol * (A->dmpmsp - A->taksa),2)
		REPLACE vrrobe  WITH Round(vrrobe - A->dmpkol * A->dmpmsp,2)

	CASE wstopa = 30 .AND. wvrsta = " "
		REPLACE visa   WITH Round(visa - A->dmpkol * A->dmpmsp,2)
		REPLACE vrrobe WITH Round(vrrobe - A->dmpkol * A->dmpmsp,2)

	CASE wstopa = 17
		REPLACE niza   WITH Round(niza - A->dmpkol * A->dmpmsp,2)
		REPLACE vrrobe WITH Round(vrrobe - A->dmpkol *A->dmpmsp,2)

	CASE wstopa = 26 .AND. wvrsta # " "
		REPLACE taks    WITH Round(taks - A->dmpkol * A->taksa,2)
		REPLACE visakpc WITH Round(visakpc - A->dmpkol * (A->dmpmsp - A->taksa),2)
		REPLACE vrrobe  WITH Round(vrrobe - A->dmpkol * A->dmpmsp,2)

	CASE wstopa = 20
		REPLACE nula06 WITH Round(nula06 - A->dmpkol * A->dmpmsp,2)
		REPLACE vrrobe WITH Round(vrrobe - A->dmpkol * A->dmpmsp,2)

	CASE wstopa = 21
		REPLACE niza1  WITH Round(niza1 - A->dmpkol * A->dmpmsp,2)
		REPLACE vrrobe WITH Round(vrrobe - A->dmpkol *A->dmpmsp,2)

	CASE wstopa = 0
		REPLACE nula   WITH Round(nula - A->dmpkol * A->dmpmsp,2)
		REPLACE vrrobe WITH Round(vrrobe - A->dmpkol * A->dmpmsp,2)
ENDCASE

IF vrrobe = 0  
	DELETE 
	PACK
	USE
	RETURN
ENDIF

USE
RETURN
