LOCAL nPDV_Koef := 0.0, nPDV_KNiza := 0.0

SELECT 0
USE RASHODN

B = LASTREC()
B = B + 1
wimaras = 0
mpor18  = Val("0000000000.00")
mpor18u = Val("0000000000.00")
mpor8   = Val("0000000000.00")

DO WHILE ! Eof()
	* ubaceno da sredi porez
	mpor18  = 0
	mpor18u = 0
	mpor8   = 0
   nPDV_Koef = KoefPDV(RDK)
	mpor18  = Round(RPV * nPDV_Koef,2)
	mpor18u = Round(RUSP * nPDV_Koef,2)
	nPDV_KNiza = KoefPDVNiza(RDK)
	mpor8   = Round(RPN * nPDV_KNiza,2)
	* kraj sredjivanja poreza
	REPLACE RPBEZ06 WITH Round(mpor18+mpor8+mpor18u,2)
	SKIP
ENDDO

CLOSE RASHODN

RETURN
