* - nije pregledano - *
SET DATE GERMAN
POR = "OTKUCAJTE NEKU TIPKU ZA DALJE..."

SELECT 1
USE POPDAT INDEX POPINDAT

SELECT 2
USE ARTPANE INDEX APINSIF

DO WHILE .T.
    CLEAR SCREEN
    DO ESCK
    @ 1,30 SAY "STAMPA NIVELACIJE"
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
       WAIT POR
       LOOP
    ENDIF
    PP = 0
    RED = 80
    STR = 0
    WPOPART = 0
    WPOPNAZ = Space(30)
    STORE 0 TO WSV,WNV,WRAZ
    @ 23,26 SAY ">>  stampanje je u toku   <<"
    SET PRINTER TO Lpt1
    SET DEVICE TO PRINTER
  *  set printer to lista
    SET PRINT ON
    setprc(0,0)
   IF lLaser
      ? Chr(27) + '(s17.5H'      && kondenz On za laserski
   ELSE
      ? Chr(15)                  && kondenz On za matricni
   ENDIF

*******
    DO WHILE ! Eof()
 ***
       STORE 0 TO WST,WNC,WSC,WR,WPROC,IN
 ***
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
 ***
      IF RED > 59
         DO HEAD_PROC3
      ENDIF
 ***
      RED = RED + 1
      @ RED,5 SAY POPART PICTURE "9999999999999"
      WPOPART = POPART
      SELECT 2
      SEEK WPOPART
      IF ! Found()
          WPOPNAZ = Space(30)
      ELSE
          WPOPNAZ = ARTNAZ
      ENDIF
 ***
      SELECT 1
      @ RED,19 SAY WPOPNAZ
  *    RED = RED + 1
      @ RED,50 SAY "KOL:"
      @ RED,55 SAY POPST PICTURE "999999.999"
   *   @ RED,20 SAY Space(1)
      @ RED,66 SAY "SC:"
      @ RED,70 SAY POPSC PICTURE "999,999,999,999.99"
   *   @ RED,39 SAY Space(2)
      @ RED,89 SAY "NC:"
      WNC = POPNC
      WSC = POPSC
      WPROC = POPPROC
      WST = POPST
      IF POPNC = 0
         WNC = WSC + (WPROC / 100) * WSC
      ELSE
         WNC = POPNC
      ENDIF
      @ RED,93 SAY WNC PICTURE "999,999,999,999.99"
  *    @ RED,59 SAY Space(2)
      @ RED,112 SAY "RAZ:"
      WR = (WNC - WSC) * WST
      @ RED,117 SAY (WNC - WSC) * WST PICTURE "999,999,999,999.99"
      WSV = WSV + WSC * WST
      WNV = WNV + WNC * WST
      WRAZ = WRAZ + WR
  *    RED = RED + 1
  *    @ RED,1 SAY Replicate("-",79)
      SKIP
    ENDDO
    IF IN = 1
      IN = 0
      LOOP
    ENDIF
      DO HEAD_PROC3
      RED = 10
      @ RED,20 SAY "REKAPITULACIJA NIVELACIJE"
      RED = 12
      @ RED,1 SAY "STARA VREDNOST ROBE            :"
      @ RED,34 SAY WSV PICTURE "999,999,999,999,999.99"
      RED = 14
      @ RED,1 SAY "NOVA VREDNOST ROBE             :"
      @ RED,34 SAY WNV PICTURE "999,999,999,999,999.99"
      RED = 16
      @ RED,1 SAY "RAZLIKA U VREDNOSTI            :"
      @ RED,34 SAY WRAZ PICTURE "999,999,999,999,999.99"
      RED = 18
      TEKST = Space(10)
      IF WSV > WNV
         TEKST = "UMANJENJE"
      ELSE
         TEKST = "POVECANJE"
      ENDIF
      @ RED,1 SAY "PROSECNO "
      @ RED,10 SAY TEKST
      ?? " CENA"
      WPROC = (WRAZ / WSV) * 100
      @ RED,48 SAY ROUND(WPROC,2) PICTURE "99999.99"
      ?? " %"
      RED = RED + 1
      @ RED,0 SAY " "

      IF lLaser
         ? Chr(27) + '&k0S' + Chr(27) + '(s10.5H'  && kondenz Off za laserski
      ELSE
         ? Chr(18)                                 && kondenz Off za matricni
      ENDIF

      eject
      SET DEVICE TO SCREEN
      SET PRINT OFF
      set print to
ENDDO
*
CLOSE DATABASES
RELEASE ALL
CLEAR SCREEN
RETURN
PROC HEAD_PROC3
  STR = STR + 1
*  CLEAR SCREEN
  RED = 2
  @ RED,2 SAY gcNazRad
  @ RED,55 SAY "STAMPA NIVELACIJE"
  @ RED,123 SAY "STR.:"
  @ RED,129 SAY STR PICTURE "9999"
  RED = RED + 1
  @ RED,10 SAY "BROJ:"
  @ RED,16 SAY WPOPBROJ
  *?? WPOPBROJ
  @ RED,118 SAY "DATUM:"
  *?? WPOPDAT
  @ RED,125 SAY WPOPDAT
  RED = RED + 1
  @ RED,1 SAY Replicate("*",136)
RETURN
