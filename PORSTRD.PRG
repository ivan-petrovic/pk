* - nije pregledano - *
CLEAR SCREEN
SET DATE GERMAN
USE PRITAR INDEX PRITIN
SET FILTER TO SK1 = 0
GO TOP
DO WHILE .T.
   *GO TOP
   ESCKEY()
   DAT1 = DATE()
   DAT2 = DATE()
   RED = 2
   PRERAC = VAL("00.000")
   S1 = VAL("00000000000000.00")
   S2 = VAL("00000000000000.00")
   SS1 = VAL("00000000000000.00")
   SS2 = VAL("00000000000000.00")
   P1 = VAL("00000000000000.00")
   P2 = VAL("00000000000000.00")
   PP1 = VAL("00000000000000.00")
   PP2 = VAL("00000000000000.00")
   PORR = VAL("00000000000000.00")
   PORZ = VAL("00000000000000.00")
   PORT = VAL("00000000000000.00")
   WPORR = VAL("00000000000000.00")
   WPORZ = VAL("00000000000000.00")
   WPORT = VAL("00000000000000.00")
   @ 10,10 SAY "UKUPNI PRIHOD I POREZ PO TARIFAMA NA DAN" GET DAT1
   *@ 10,56 SAY "DO DATUMA" GET DAT2
   READ
*
   IF Lastkey() = 27
      CLEAR SCREEN
      USE
      RETURN
   ENDIF
   CLEAR SCREEN
   @ RED,12 SAY "PRIHOD I POREZ PO TARIFAMA I STOPAMA NA DAN"
   *SET COLO TO /W
   @ RED,59 SAY DAT1
   *SET COLO TO
   RED = RED + 2
   @ RED,3 SAY "TARIFA"
   @ RED,15 SAY "PRIHOD  "
   @ RED,27 SAY "POREZ  "
   @ RED,42 SAY "REPUBLICKI"
   @ RED,55 SAY "ZELEZNICA"
   @ RED,68 SAY "TAKSA 3 %"
   RED = RED + 1
   @ RED,3 SAY REPLI("-",76)
   RED =RED + 1
DO WHILE .T.
   IF Eof()
      EXIT
   ENDIF
   IF DTOS(DPH) = DTOS(DAT1) && PREKINUTO .AND. DTOS(DPH) <= DTOS(DAT2)
      POMTAR = TPH
      POMSTOP = SPH
      PRERAC = ROUND((POMSTOP * 100) / (POMSTOP + 100),2)
      S1 = S1 + Z1
      S2 = S2 + Z2
      SS1 = SS1 + Z1
      SS2 = SS2 + Z2
      P1 = P1 + ROUND(Z1 * PRERAC / 100,2)
      DO CASE
         CASE POMSTOP = 29
              P2 = P2 + ROUND(Z2 * 0.0909,2)       && 0.0654
         CASE POMSTOP = 26
              P2 = P2 + ROUND(Z2 * 0.0654,2)       && 0.0654
      ENDCASE
      PP1 = PP1 + ROUND(Z1 * PRERAC / 100,2)
      PP2 = PP2 + ROUND(Z2 * PRERAC / 100,2)
      SKIP
        IF POMTAR = TPH .AND. POMSTOP = SPH .AND. DTOS(DAT1) = DTOS(DPH)
          LOOP
        ELSE
          ************ U ZAVISNOSTI OD POMSTOP RAZBITI POREZ
          DO CASE
             CASE POMSTOP = 26
                  PORR = ROUND(P1 * 0.76923,2)
                  PORZ = ROUND(P1 * 0.11538,2)
                  PORT = ROUND(P1 * 0.11538,2)
                  WPORR = ROUND(WPORR + PORR,2)
                  WPORZ = ROUND(WPORZ + PORZ,2)
                  WPORT = ROUND(WPORT + PORT,2)
             CASE POMSTOP = 15
                  PORR = ROUND(P1 * 0.60000,2)
                  PORZ = ROUND(P1 * 0.20000,2)
                  PORT = ROUND(P1 * 0.20000,2)
                  WPORR = ROUND(WPORR + PORR,2)
                  WPORZ = ROUND(WPORZ + PORZ,2)
                  WPORT = ROUND(WPORT + PORT,2)
             CASE POMSTOP = 16
                  PORR = ROUND(P1 * 0.62500,2)
                  PORZ = ROUND(P1 * 0.18750,2)
                  PORT = ROUND(P1 * 0.18750,2)
                  WPORR = ROUND(WPORR + PORR,2)
                  WPORZ = ROUND(WPORZ + PORZ,2)
                  WPORT = ROUND(WPORT + PORT,2)
             CASE POMSTOP = 23
                  PORR = ROUND(P1 * 0.86956,2)
                  PORZ = ROUND(P1 * 0.13043,2)
                  PORT = ROUND(P1 * 0.00000,2)
                  WPORR = ROUND(WPORR + PORR,2)
                  WPORZ = ROUND(WPORZ + PORZ,2)
                  WPORT = ROUND(WPORT + PORT,2)
             CASE POMSTOP = 12
                  PORR = ROUND(P1 * 0.75000,2)
                  PORZ = ROUND(P1 * 0.25000,2)
                  PORT = ROUND(P1 * 0.00000,2)
                  WPORR = ROUND(WPORR + PORR,2)
                  WPORZ = ROUND(WPORZ + PORZ,2)
                  WPORT = ROUND(WPORT + PORT,2)
             CASE POMSTOP = 13
                  PORR = ROUND(P1 * 0.76923,2)
                  PORZ = ROUND(P1 * 0.23076,2)
                  PORT = ROUND(P1 * 0.00000,2)
                  WPORR = ROUND(WPORR + PORR,2)
                  WPORZ = ROUND(WPORZ + PORZ,2)
                  WPORT = ROUND(WPORT + PORT,2)
          ENDCASE
          ************ KRAJ RAZBIJANJA POREZA
          @ RED,3 SAY POMTAR
      *   @ RED,15 SAY POMSTOP
          @ RED,12 SAY S1 PICTURE "999,999,999.99"
       *   @ RED,27 SAY P1 PICTURE "999,999,999.99"
          @ RED,27 SAY ROUND(PORR + PORZ + PORT,2) PICTURE "999,999,999.99"
          @ RED,42 SAY PORR PICTURE "9,999,999.99"      && republika
          @ RED,55 SAY PORZ PICTURE "9,999,999.99"      && zeleznica
          @ RED,68 SAY PORT PICTURE "9,999,999.99"      && taksa
          RED = RED + 1
          @ RED,3 SAY REPLI("-",76)
          RED = RED + 1
          S1 = 0
          S2 = 0
          P1 = 0
          PORR = 0
          PORZ = 0
          PORT = 0
          P2 = 0
          LOOP
        ENDIF
   ENDIF
   SKIP
ENDDO
*RED = RED + 1
*@ RED,5 SAY REPLI("-",73)
*RED = RED + 1
@ RED,3 SAY "UKUPNO :"
@ RED,12 SAY SS1 PICTURE "999,999,999.99"
@ RED,27 SAY ROUND(WPORR + WPORZ + WPORT,2) PICTURE "999,999,999.99"
@ RED,42 SAY WPORR PICTURE "9,999,999.99"      && republika
@ RED,55 SAY WPORZ PICTURE "9,999,999.99"      && zeleznica
@ RED,68 SAY WPORT PICTURE "9,999,999.99"      && taksa
WAIT " "
CLEAR SCREEN
SET FILTER TO
USE
RETURN
ENDDO

