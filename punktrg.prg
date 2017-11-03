LOCAL wpre, wnc, wpv, wruc, wrb, wind, wkropk1
LOCAL wdmpdat, wdmpdfak, wdmpfak, wdmpdob, wopk

wpre   = Space(10)
wnc    = Val("000000000.00")
wpv    = Val("000000000.00")
wruc   = Val("000000000.00")
wrb    = Val("0000")
wind   = Val("0")

SELECT 0
USE TRG INDEX TRGKAL,TINOR
ZAP

SELECT 0
USE PPDAT INDEX PPINSIF

SELECT 0
USE DMPDAT INDEX DMPINBRO

DO WHILE ! Eof()

   wind = 0
   wpre     = DMPBRO
   wdmpdat  = DMPDAT
   wdmpdfak = DMPDFAK
   wdmpfak  = DMPFAK
   wdmpdob  = DMPDOB

   IF DMPSIF <> 0 .AND. DMPFAK = "         0"
      wind = 1
   ENDIF

   DO WHILE wpre = DMPBRO
      wnc = Round(wnc + DMPNC,2)
      wpv = Round(wpv + DMPVSP,2)
      SKIP
   ENDDO

   wkropk1 = Space(30)
   SELECT PPDAT
   SEEK wdmpdob
   IF Found()
      wkropk1 = PPNAZ
   ELSE
      wkropk1 = " "
   ENDIF
   SELECT DMPDAT

   wrb = wrb + 1
   wopk = Space(55)
   wopk = Substr((Alltrim(Str(wdmpdob,6))+ " " + Alltrim(wkropk1) + ;
          " " + Alltrim(wpre) + " " + Alltrim(wdmpfak)), 1, 55)

   SELECT TRG
   APPEND BLANK
   REPLACE RB    WITH wrb
   REPLACE BRKAL WITH wpre
   REPLACE DK    WITH wdmpdat
   REPLACE OPK   WITH wopk
   IF wind = 0
      REPLACE ZAD WITH wpv
   ELSE
      REPLACE ZAD WITH wpv*(-1)
   ENDIF
   SELECT DMPDAT

   wnc = 0
   wpv = 0
ENDDO

CLOSE DATABASES
RETURN
