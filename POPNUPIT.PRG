* - nije pregledano - *
SET DATE GERMAN
POR = "Otkucajte neku tipku za dalje..."
SELECT 1
USE POPDAT INDEX POPINART
SELECT 2
USE ARTPANE INDEX APINSIF
WPOPBROJ = 0
WPOPART = VAL("0000000000000")
WPOPDAT = CTOD("  .  .  ")
DO WHILE .T.
      STORE 0 TO WSC,WNC,WRC,WSV,WNV,WRV,WPROC,WST
      WPOPNAZ = Space(30)
      CLEAR SCREEN
      DO ESCK
      @ 1,30 SAY "UPIT ZA ARTIKAL"
      @ 3,5 SAY "DATUM POPISA:" GET WPOPDAT VALID ! Empty(WPOPDAT)
      @ 3,30 SAY "BROJ POPISA:" GET WPOPBROJ PICTURE "9999999999" VALID ! Empty(WPOPBROJ)
      @ 3,55 SAY "ARTIKAL:" GET WPOPART PICTURE "9999999999999" VALID ! Empty(WPOPART)
      READ
      IF Lastkey() = 27
         EXIT
      ENDIF
      SELECT 2
      SEEK WPOPART
      IF ! Found()
         WPOPNAZ = Space(30)
      ELSE
         WPOPNAZ = ARTNAZ
      ENDIF
      @ 4,45 SAY WPOPNAZ
      SELECT 1
      KLJUC = STR(WPOPBROJ) + DTOS(WPOPDAT) + STR(WPOPART)
      SEEK KLJUC
      IF ! Found()
         @ 19,1 SAY "TRAZENI ARTIKAL NIJE OBUHVACEN OVIM POPISOM !"
         ? " "
         WAIT POR
         LOOP
      ENDIF
      WSC = POPSC
      WNC = POPNC
      WST = POPST
      WPROC = POPPROC
      IF WNC = 0
         WNC = WSC + (WPROC / 100) * WSC
      ENDIF
      RED = 6
      @ RED,1 SAY "STANJE PO POPISU             : "
      @ RED,34 SAY POPST PICTURE "99,999,999,999.999"
      RED = 8
      @ RED,1 SAY "STARA CENA ROBE              : "
      @ RED,34 SAY WSC PICTURE "999,999,999,999.99"
      RED = 10
      @ RED,1 SAY "NOVA CENA ROBE               : "
      @ RED,34 SAY WNC PICTURE "999,999,999,999.99"
      RED = 12
      @ RED,1 SAY "RAZLIKA U CENI               : "
      WRC = WNC - WSC
      @ RED,34 SAY WRC PICTURE "999,999,999,999.99"
      WPROC = (WRC / WSC) * 100
      RED = 14
      IF WSC > WNC
         TEKST = "UMANJENJA "
         TEKST1 = "UMANJENJE "
      ELSE
         TEKST1 = "POVECANJE "
         TEKST = "POVECANJA "
      ENDIF
      @ RED,1 SAY "PROCENAT "
      ?? TEKST
      ?? "CENE"
      ?? "      :"
      @ RED,45 SAY ROUND(WPROC,2) PICTURE "9999.99"
      ?? " %"
      RED = 16
      @ RED,1 SAY "STARA VREDNOST               : "
      @ RED,34 SAY WSC * WST PICTURE "999,999,999,999.99"
      RED = 18
      @ RED,1 SAY "NOVA VREDNOST                : "
      @ RED,34 SAY WNC * WST PICTURE "999,999,999,999.99"
      RED = 20
      @ RED,1 SAY TEKST1
      ?? "VREDNOSTI"
      ?? "          :"
      WNV = WNC * WST
      WSV = WSC * WST
      IF WNV > WSC
         WRV = WNV - WSV
      ELSE
         WRV = WSV - WNV
      ENDIF
      @ RED,34 SAY WRV PICTURE "999,999,999,999.99"
      @ 21,1 SAY " "
      WAIT POR
ENDDO
*
CLOSE DATABASES
RELEASE ALL
CLEAR SCREEN
RETURN
