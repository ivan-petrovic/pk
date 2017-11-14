SELECT 1
USE POPDAT INDEX POPINDAT

SELECT 2
USE ARTPANE INDEX APINSIF

DO WHILE .T.
   MainMask("STAMPA NIVELACIJE")

   WPOPBROJ = 0
   WPOPDAT = CTOD("  .  .  ")
   @ 10,10 SAY "DATUM POPISA:" GET WPOPDAT VALID ! Empty(WPOPDAT)
   @ 10,40 SAY "BROJ POPISA:" GET WPOPBROJ PICTURE "9999999999" VALID ! Empty(WPOPBROJ)
   READ

   IF Lastkey() = 27
    EXIT
   ENDIF

   SELECT 1
   KLJUC = STR(WPOPBROJ) + DTOS(WPOPDAT)
   SEEK KLJUC
   IF ! Found()
      @ 19,1 SAY "NIJE UNET TAKAV POPIS !"
      ? " "
      WAIT "Otkucajte neku tipku za dalje..."
      LOOP
   ENDIF

   PP = 0
   WPOPART = 0
   WPOPNAZ = Space(30)
   STORE 0 TO WSV, WNV, WRAZ

   SET CONSOLE OFF
   SET ALTERNATE TO c:\PK\nivel.html
   SET ALTERNATE ON
   header("Stampa nivelacije","nivel.css")
   makeHeader(Alltrim(gcNazRad) + " - nivelacija")

   DO HEAD_PROC3
   
   DO WHILE ! Eof()
      STORE 0 TO WST,WNC,WSC,WR,WPROC,IN
 
      IF ! WPOPBROJ = POPBROJ
         EXIT
      ENDIF
      IF ! WPOPDAT = POPDAT
         EXIT
      ENDIF
      IF POPST = 0
         SKIP
         LOOP
      ENDIF

      WPOPART = POPART
      SELECT 2
      SEEK WPOPART
      IF ! Found()
         WPOPNAZ = Space(30)
      ELSE
         WPOPNAZ = ARTNAZ
      ENDIF
 
      SELECT 1

      WNC = POPNC
      WSC = POPSC
      WPROC = POPPROC
      WST = POPST
      IF POPNC = 0
         WNC = WSC + (WPROC / 100) * WSC
      ELSE
         WNC = POPNC
      ENDIF

      WR = (WNC - WSC) * WST
      WSV = WSV + WSC * WST
      WNV = WNV + WNC * WST
      WRAZ = WRAZ + WR

      ? TR_El_open("", 12)
      ? TD_El_Num(POPART, 0, 12)
      ? General_El('<td class="ulevo">' + Alltrim(WPOPNAZ) + '</td>',12)
      ? TD_El_Num(POPST, 3, 12)
      ? TD_El_Num(POPSC, 2, 12)
      ? TD_El_Num(WNC, 2, 12)
      ? TD_El_Num(WR, 2, 12)
      ? TR_El_close("", 12)

      SKIP
   ENDDO

   ? TBL_El_close("nivel-table", 9)
   
   IF IN = 1
      IN = 0
      LOOP
   ENDIF

   WPROC = (WRAZ / WSV) * 100
   
   ? TBL_El_open("nivel-rekap", 9)

   ? TR_EL_open("", 12)
   ? Space(12) + "<th colspan='2'>REKAPITULACIJA NIVELACIJE</th>"
   ? TR_EL_close("", 12)

   ? TR_El_open("", 12)
   ? TD_El_Str("Stara vrednost robe", 12)
   ? TD_El_Num(WSV, 2, 12)
   ? TR_El_close("", 12)

   ? TR_El_open("", 12)
   ? TD_El_Str("Nova vrednost robe", 12)
   ? TD_El_Num(WNV, 2, 12)
   ? TR_El_close("", 12)

   ? TR_El_open("", 12)
   ? TD_El_Str("Razlika u vrednosti", 12)
   ? TD_El_Num(WRAZ, 2, 12)
   ? TR_El_close("", 12)

   ? TR_El_open("", 12)
   ? TD_El_Str("Prosecno " + IIF(WSV > WNV, "umanjenje", "povecanje") + " cena [%]", 12)
   ? TD_El_Num(WPROC, 2, 12)
   ? TR_El_close("", 12)

   ? TBL_El_close("nivel-rekap", 9)

   ? General_El("</div> <!-- nivel -->",6)
   DO futer

   SET ALTERNATE TO
   SET ALTERNATE OFF
   SET CONSOLE ON
ENDDO

CLOSE DATABASES
RELEASE ALL
RETURN

***************************************************************
PROCEDURE HEAD_PROC3

? General_El('<div class="nivel">',6)
? TBL_El_open("nivel-zaglavlje", 9)

? TR_El_open("", 12)
? TD_El_Str(gcNazRad, 12)
? TD_El_Str("STAMPA NIVELACIJE BROJ: " + Alltrim(Str(WPOPBROJ,6)), 12)
? TD_El_Str("Datum: " + DtoC(WPOPDAT), 12)
? TR_El_close("", 12)

? TBL_El_close("nivel-zaglavlje", 9)

? TBL_El_open("nivel-table", 9)

? General_El("<thead>",9)
? TR_El_open("", 12)
? TH_El_Str("Sifra", 12)
? TH_El_Str("Naziv", 12)
? TH_El_Str("Kolicina", 12)
? TH_El_Str("Stara cena", 12)
? TH_El_Str("Nova cena", 12)
? TH_El_Str("Razlika u vrednosti", 12)
? TR_El_close("", 12)
? General_El("</thead>",9)

RETURN
***************************************************************
