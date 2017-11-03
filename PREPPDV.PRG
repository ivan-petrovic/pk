wpre = Space(10)
wukppk = val("000000000.00")
wukppd = val("000000000.00")

SELECT 0
USE RASHODN INDEX RASHINKN

SELECT 0
USE DMPDAT INDEX DMPINBRO

DO WHILE ! Eof()
	wpre = DMPBRO
	DO WHILE wpre = DMPBRO
		wukppd = Round(wukppd + dmpppd,2)
		wukppk = Round(wukppk + dmpppk,2)
		SKIP
	ENDDO

	SELECT RASHODN
	SEEK wpre
	IF Found()
		REPLACE RPBEZ06 WITH wukppk
		REPLACE RPBEZ2  WITH wukppd
	ENDIF

	wukppd = 0
	wukppk = 0
	SELECT DMPDAT
ENDDO

CLOSE DATABASES

RETURN
