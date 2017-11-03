LOCAL wPre, wUkPpk, wUkPpd, wNc, wPv, wUkRuc, mInd

wPre   = Space(10)
wUkPpk = Val("000000000.00")
wUkPpd = Val("000000000.00")
wNc    = Val("000000000.00")
wPv    = Val("000000000.00")
wUkRuc = Val("000000000.00")
mInd   = 0

SELECT 0
USE RASHODN INDEX RASHINKN,RASHINDN
SELECT 0
USE DMPDAT INDEX DMPINBRO

DO WHILE ! Eof()

   wPre = DMPBRO
   DO WHILE wPre = DMPBRO
       IF VRSTA = " " .AND. DMPSIF = 0 .AND. DMPJM = "-  "		&& to je nivel.
          mInd = 1															&& treba znati + ili -
          wUkRuc = Round(wUkRuc + DMPMIZ,2)
          wUkPpk = Round(wUkPpk + (DMPVSP - DMPMIZ),2)
          wPv = Round(wPv + DMPVSP,2)
       ENDIF

       IF mInd = 0
          wUkPpd = Round(wUkPpd + DMPPPD,2)
          wUkPpk = Round(wUkPpk + DMPPPK,2)
          wNc = Round(wNc + DMPNC,2)
          wPv = Round(wPv + DMPVSP,2)
       ENDIF

		SKIP
   ENDDO
   
   SELECT RASHODN
   SEEK wPre
   IF Found()
      IF mInd = 1
         REPLACE RRUCP  WITH wUkRuc
         REPLACE ROBPOR WITH wUkPpk
         REPLACE RPRODV WITH wPv
      ENDIF
      IF mInd = 0
         REPLACE RNVRRR WITH Round(wNc - wUkPpd,2)
         REPLACE RRUCP  WITH Round(wPv - wUkPpk - wNc + wUkPpd,2)
         REPLACE ROBPOR WITH wUkPpk
         REPLACE RPRODV WITH wPv
         * REPLACE RRASUK WITH wNc zamenjeno narednom linijom
         REPLACE RRASUK WITH Round(wNc - wUkPpd,2)
      ENDIF
   ELSE
		* nista
   ENDIF

   wUkRuc = 0
   wUkPpd = 0
   wUkPpk = 0
   wNc  = 0
   wPv  = 0
   mInd = 0

	SELECT DMPDAT
ENDDO

CLOSE DATABASES

RETURN
