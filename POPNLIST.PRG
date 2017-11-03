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
    @ 1,28 SAY "LISTANJE NIVELACIJE"
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
    RED = 20
    WPOPART = 0
    WPOPNAZ = Space(30)
    STORE 0 TO WSV,WNV,WRAZ
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
 ***  
      IF RED > 15
         IF PP = 1
           @ 19,1 SAY " "
           WAIT POR
           IF Lastkey() = 27
              IN = 1
              EXIT
           ENDIF
         ENDIF
         PP = 1
         DO HEAD_PROC1
      ENDIF
 ***
      RED = RED + 1
      @ RED,5 SAY POPART
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
      @ RED,40 SAY WPOPNAZ
      RED = RED + 1
      @ RED,1 SAY "KOL:"
      @ RED,5 SAY POPST PICTURE "99999999999.999"
      @ RED,20 SAY Space(1)
      @ RED,21 SAY "SC:"
      @ RED,24 SAY POPSC PICTURE "99999999999.99"
      @ RED,39 SAY Space(2)
      @ RED,41 SAY "NC:"
      WNC = POPNC
      WSC = POPSC
      WPROC = POPPROC
      WST = POPST
      IF POPNC = 0
         WNC = WSC + (WPROC / 100) * WSC
      ELSE
         WNC = POPNC
      ENDIF
      @ RED,44 SAY WNC PICTURE "999999999999.99"
      @ RED,59 SAY Space(2)
      @ RED,61 SAY "RAZ:"
      WR = (WNC - WSC) * WST
      @ RED,65 SAY (WNC - WSC) * WST PICTURE "999999999999.99"
      WSV = WSV + WSC * WST
      WNV = WNV + WNC * WST
      WRAZ = WRAZ + WR
      RED = RED + 1
      @ RED,1 SAY Replicate("-",79)
      SKIP
    ENDDO
    IF IN = 1
      IN = 0
      LOOP
    ENDIF
      @ 19,1 SAY " "
      WAIT "Zavrseno listanje ! Otkucajte neku tipku za rekapitulaciju !"
      IF Lastkey() = 27
        LOOP
      ENDIF
      DO HEAD_PROC1
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
      @ 20,1 SAY " "
      WAIT POR
ENDDO
*
CLOSE DATABASES
RELEASE ALL
CLEAR SCREEN
RETURN
PROC HEAD_PROC1
  CLEAR SCREEN
  RED = 2
  @ RED,28 SAY "LISTANJE NIVELACIJE"
  RED = RED + 1
  @ RED,10 SAY "BROJ:"
  ?? WPOPBROJ
  @ RED,50 SAY "DATUM:"
  ?? WPOPDAT
  RED = RED + 1
  @ RED,1 SAY Replicate("*",79)
RETURN
