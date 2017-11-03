* - nije pregledano - *
SET DELETE ON

wpre   = Space(10)
wukppk = Val("000000000.00")
wukppd = Val("000000000.00")
wnc    = Val("000000000.00")
wpv    = Val("000000000.00")
wruc   = Val("000000000.00")

SELECT 0
USE RASHODN INDEX RASHINKN,RASHINDN
SELECT 0
USE DMPDAT INDEX DMPINBRO

DO WHILE ! Eof()
   wpre     = dmpbro
   wdmpdat  = dmpdat
   wdmpdfak = dmpdfak
   wdmpfak  = dmpfak
   wdmpdob  = dmpdob

   DO WHILE wpre = dmpbro
      wukppd = Round(wukppd + dmpppd,2)
      wukppk = Round(wukppk + dmpppk,2)
      wnc = Round(wnc + dmpnc,2)
      wpv = Round(wpv + dmpvsp,2)
      SKIP
   ENDDO

   SELECT RASHODN
   SEEK wpre
   IF Found()
      REPLACE rpbez06 WITH wukppk
      REPLACE rpbez2  WITH wukppd
   ELSE
      APPEND BLANK

      REPLACE rdk WITH wdmpdat   && wkrdatk
      REPLACE ropis WITH str(wdmpdob,6) + "  "+ wdmpfak
      REPLACE rbr WITH wpre
      * REPLACE krbof WITH wkrbof
      REPLACE rdatdok WITH wdmpdfak

      * ubacen upis zbirova za PDV
      REPLACE rpbez06 WITH wukppk
      REPLACE rpbez2 WITH wukppd
      * kraj ubacenih zbirova za PDV

      * REPLACE rnvrrr WITH Round(wnc - wukppd,2)
      REPLACE rnvrrr WITH wnc
      * REPLACE rrucp WITH Round(wpv - wukppk - wnc + wukppd,2)   &&  izbaceno -s6
      REPLACE rrucp WITH Round(wpv - wukppk - wnc,2)   &&  izbaceno -s6
      REPLACE robpor WITH wukppk
      REPLACE rprodv WITH wpv
      REPLACE rrasuk WITH wnc
   ENDIF

   wukppd = 0
   wukppk = 0
   wnc = 0
   wpv = 0

   SELECT DMPDAT
ENDDO

CLOSE DATABASES

RETURN
