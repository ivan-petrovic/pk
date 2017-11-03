* - nije pregledano - *
CLEAR SCREEN
SET DATE GERMAN

SELECT 0
USE ZIRPLAC INDEX ZIRPLAC1,ZIRPLAC
SELECT 0
USE PRITAR INDEX DDDIN
SET FILTER TO SK1 = 0
GO TOP
* kraj ubacenog dela
DO WHILE .T.
   ESCKEY()
   DAT1 = DATE()
   DAT2 = DATE()
   RED = 2
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
   PORTt = VAL("00000000000000.00")
   PORV = VAL("00000000000000.00")
   WPORR = VAL("00000000000000.00")
   WPORZ = VAL("00000000000000.00")
   WPORT = VAL("00000000000000.00")
   WPORTT = VAL("00000000000000.00")
   WPORV = VAL("00000000000000.00")
   PRERAC = VAL("00.000")
   *************************
   mVrep30 =val("000000.00")   && pomocna za punjenje virmana
   mVrep7i9 =val("000000.00")
   mVrep20 =val("000000.00")
   mVvoj30 =val("000000.00")
   mVvoj17 =val("000000.00")
   mVvoj1 =val("000000.00")
   mVvoj3 =val("000000.00")
   mtak10 =val("000000.00")
   *************************
   @ 10,2 SAY "UKUPNI PRIHOD I POREZ PO TARIFAMA OD DATUMA" GET DAT1
   @ 10,56 SAY "DO DATUMA" GET DAT2 VALID(dat2 >= dat1)
   READ
*
   IF Lastkey() = 27
      CLEAR SCREEN
      USE
      RETURN
   ENDIF
   CLEAR SCREEN
   @ RED,10 SAY "PRIHOD I POREZ PO TARIFAMA I STOPAMA OD"
   *SET COLO TO /W
   @ RED,50 SAY DAT1
   *SET COLO TO
   @ RED,60 SAY "DO"
   *SET COLO TO /W
   @ RED,63 SAY DAT2
   *SET COLO TO
   red = red +1
   @ red,1 SAY gcNazRad
   RED = RED + 1
   @ RED,3 SAY "TARIFA"
   @ RED,12 SAY "     PRIHOD"
   @ RED,24 SAY "      POREZ"
   @ RED,36 SAY "REPUBLICKI"
   @ RED,47 SAY " ZELEZNICA"
   @ RED,58 SAY " TAKSA 3 %"
   @ RED,69 SAY "POS.SAVEZN"
   RED = RED + 1
   @ RED,3 SAY REPLI("-",76)
   RED =RED + 1
DO WHILE .T.
   IF Eof()
      EXIT
   ENDIF
   IF DTOS(DPH) >= DTOS(DAT1) .AND. DTOS(DPH) <= DTOS(DAT2)
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
              P2 = P2 + ROUND(Z2 * 0.0909,2)         && 0.0654
         CASE POMSTOP = 26
              P2 = P2 + ROUND(Z2 * 0.0654,2)
      ENDCASE
      PP1 = PP1 + ROUND(Z1 * PRERAC / 100,2)
      DO CASE
         CASE POMSTOP = 29
              PP2 = PP2 + ROUND(Z2 * 0.0909,2)      && 0.0654
         CASE POMSTOP = 26
              PP2 = PP2 + ROUND(Z2 * 0.0654,2)      && 0.0654
      ENDCASE
      SKIP
      L = DTOS(DPH) >= DTOS(DAT1) .AND. DTOS(DPH) <= DTOS(DAT2)
        IF POMTAR = TPH .AND. POMSTOP = SPH .AND. L
          LOOP
        ELSE
          ************ U ZAVISNOSTI OD POMSTOP RAZBITI POREZ
          *IF mVAN = "N"
             DO CASE
                CASE POMSTOP = 8
                     PORR = ROUND(P1 * 1.00000,2)
                     PORZ = ROUND(P1 * 0.00000,2)
                     PORT = ROUND(P1 * 0.00000,2)
                     PORV = ROUND(P1 * 0.00000,2)
                     WPORR = ROUND(WPORR + PORR,2)
                     WPORZ = ROUND(WPORZ + PORZ,2)
                     WPORT = ROUND(WPORT + PORT,2)
                     WPORV = ROUND(WPORV + PORV,2)
                     *
                     mVrep30 = round(mVrep30 + porr,2)
                     mVvoj30 = round(mVvoj30 + porv,2)
                CASE POMSTOP = 21
                     PORR = ROUND(P1 * 0.47619,2)
                     PORZ = ROUND(P1 * 0.14285,2)
                     PORT = ROUND(P1 * 0.14285,2)
                     PORV = ROUND(P1 * 0.23809,2)
                     WPORR = ROUND(WPORR + PORR,2)
                     WPORZ = ROUND(WPORZ + PORZ,2)
                     WPORT = ROUND(WPORT + PORT,2)
                     WPORV = ROUND(WPORV + PORV,2)
                     *
                     mVrep20 = round(mVrep20 + porr,2)
                     mVvoj30 = round(mVvoj30 + porv,2)
                CASE POMSTOP = 20 .and. dat2 <= ctod("31.03.2001")
                     PORR = ROUND(P1 * 0.45000,2)
                     PORZ = ROUND(P1 * 0.15000,2)
                     PORT = ROUND(P1 * 0.15000,2)
                     PORV = ROUND(P1 * 0.25000,2)
                     WPORR = ROUND(WPORR + PORR,2)
                     WPORZ = ROUND(WPORZ + PORZ,2)
                     WPORT = ROUND(WPORT + PORT,2)
                     WPORV = ROUND(WPORV + PORV,2)
                     *
                     mVrep7i9 = round(mVrep7i9 + porr,2)
                     mVvoj30 = round(mVvoj30 + porv,2)
                CASE (POMSTOP = 18 .or. POMSTOP = 20) .and. dat1 >= ctod("31.03.2001")
                     PORR = ROUND(P1 * 1.00000,2)
                     PORZ = ROUND(P1 * 0.00000,2)
                     PORT = ROUND(P1 * 0.00000,2)
                     PORV = ROUND(P1 * 0.00000,2)
                     WPORR = ROUND(WPORR + PORR,2)
                     WPORZ = ROUND(WPORZ + PORZ,2)
                     WPORT = ROUND(WPORT + PORT,2)
                     WPORV = ROUND(WPORV + PORV,2)
                     *
                   * mVrep7i9 = round(mVrep7i9 + porr,2)
                   * mVvoj30 = round(mVvoj30 + porv,2)
                     mVrep20 = round(mVrep20 + porr,2)
                     mVvoj3 = round(mVvoj3 + porv,2)
                CASE POMSTOP = 38
                     PORR = ROUND(P1 * 1.00000,2)
                     PORZ = ROUND(P1 * 0.00000,2)
                     PORT = ROUND(P1 * 0.00000,2)
                     PORV = ROUND(P1 * 0.00000,2)
                     WPORR = ROUND(WPORR + PORR,2)
                     WPORZ = ROUND(WPORZ + PORZ,2)
                     WPORT = ROUND(WPORT + PORT,2)
                     WPORV = ROUND(WPORV + PORV,2)
                     *
                     mVrep7i9 = round(mVrep7i9 + porr,2)
                     mVvoj17 = round(mVvoj17 + porv,2)
                CASE POMSTOP = 1
                     PORR = ROUND(P1 * 0.00000,2)
                     PORZ = ROUND(P1 * 0.00000,2)
                     PORT = ROUND(P1 * 0.00000,2)
                     PORV = ROUND(P1 * 1.00000,2)
                     WPORR = ROUND(WPORR + PORR,2)
                     WPORZ = ROUND(WPORZ + PORZ,2)
                     WPORT = ROUND(WPORT + PORT,2)
                     WPORV = ROUND(WPORV + PORV,2)
                     *
                     mVvoj1 = round(mVvoj1 + porv,2)
                CASE POMSTOP = 28
                     PORR = ROUND(P1 * 0.32143,2)
                     PORZ = ROUND(P1 * 0.10714,2)
                     PORT = ROUND(P1 * 0.10714,2)
                     PORV = ROUND(P1 * 0.10714,2)
                     PORTT = ROUND(P1 * 0.35714,2)
                     WPORR = ROUND(WPORR + PORR,2)
                     WPORZ = ROUND(WPORZ + PORZ,2)
                     WPORT = ROUND(WPORT + PORT,2)
                     WPORV = ROUND(WPORV + PORV,2)
                     WPORTT = ROUND(WPORTT + PORTT,2)
                     *
                     mVrep7i9 = round(mVrep7i9 + porr,2)
                     mVvoj17 = round(mVvoj17 + porv,2)
             ENDCASE
          *ELSE
          *   DO CASE
          *      CASE POMSTOP = 27
          *           PORR = ROUND(P1 * 0.76923,2)
          *           PORZ = ROUND(P1 * 0.11538,2)
          *           PORT = ROUND(P1 * 0.11538,2)
          *           PORV = ROUND(P1 * 0.11538,2)
          *           WPORR = ROUND(WPORR + PORR,2)
          *           WPORZ = ROUND(WPORZ + PORZ,2)
          *           WPORT = ROUND(WPORT + PORT,2)
          *           WPORV = ROUND(WPORV + PORV,2)
          *      CASE POMSTOP = 17
          *           PORR = ROUND(P1 * 0.60000,2)
          *           PORZ = ROUND(P1 * 0.20000,2)
          *           PORT = ROUND(P1 * 0.20000,2)
          *           PORV = ROUND(P1 * 0.20000,2)
          *           WPORR = ROUND(WPORR + PORR,2)
          *           WPORZ = ROUND(WPORZ + PORZ,2)
          *           WPORT = ROUND(WPORT + PORT,2)
          *           WPORV = ROUND(WPORV + PORV,2)
          *      CASE POMSTOP = 16
          *           PORR = ROUND(P1 * 0.62500,2)
          *           PORZ = ROUND(P1 * 0.18750,2)
          *           PORT = ROUND(P1 * 0.18750,2)
          *           PORV = ROUND(P1 * 0.11538,2)
          *           WPORR = ROUND(WPORR + PORR,2)
          *           WPORZ = ROUND(WPORZ + PORZ,2)
          *           WPORT = ROUND(WPORT + PORT,2)
          *           WPORV = ROUND(WPORV + PORV,2)
          *      CASE POMSTOP = 14
          *           PORR = ROUND(P1 * 0.86956,2)
          *           PORZ = ROUND(P1 * 0.13043,2)
          *           PORT = ROUND(P1 * 0.00000,2)
          *           PORV = ROUND(P1 * 0.11538,2)
          *           WPORR = ROUND(WPORR + PORR,2)
          *           WPORZ = ROUND(WPORZ + PORZ,2)
          *           WPORT = ROUND(WPORT + PORT,2)
          *           WPORV = ROUND(WPORV + PORV,2)
          *   ENDCASE
          *
          *ENDIF
          ************ KRAJ RAZBIJANJA POREZA
          @ RED,3 SAY POMTAR
      *   @ RED,15 SAY POMSTOP
          @ RED,12 SAY S1 PICTURE "99999999.99"
          @ RED,24 SAY ROUND(PORR + PORZ + PORT + PORV + PORTT,2) PICTURE "99999999.99"
          @ RED,36 SAY PORR PICTURE "9999999.99"      && republika
          @ RED,47 SAY PORZ PICTURE "9999999.99"      && zeleznica
          @ RED,58 SAY PORT PICTURE "9999999.99"      && taksa
          @ RED,69 SAY PORV PICTURE "9999999.99"      && vojska
          IF pomstop = 28
             red = red + 1
          @ RED,69 SAY PORTT PICTURE "9999999.99"      && dodatna taksa
          ENDIF
          RED = RED + 1
          @ RED,3 SAY REPLI("-",76)
          RED = RED + 1
          S1 = 0
          S2 = 0
          P1 = 0
          P2 = 0
          PORR = 0
          PORZ = 0
          PORT = 0
          PORTT = 0
          PORV = 0
          LOOP
        ENDIF
   ENDIF
   SKIP
ENDDO
*

*
*RED = RED + 1
*@ RED,5 SAY REPLI("-",73)
*RED = RED + 1
@ RED,3 SAY "UKUPNO :"
@ RED,12 SAY SS1 PICTURE "99999999.99"
@ RED,24 SAY ROUND(WPORR + WPORZ + WPORT + WPORV + WPORTT,2) PICTURE "99999999.99"
@ RED,36 SAY WPORR PICTURE "9999999.99"      && republika
@ RED,47 SAY WPORZ PICTURE "9999999.99"      && zeleznica
@ RED,58 SAY WPORT PICTURE "9999999.99"      && taksa
@ RED,69 SAY WPORV PICTURE "9999999.99"      && vojska
red = red + 1
@ RED,69 SAY WPORTT PICTURE "9999999.99"      && posebna naknada

WAIT " "
      * sada ce da upise iznose za virmane
      select zirplac
      DO WHILE ! Eof()
         do case
            case tarifa = "SVE     " .AND. podtar = "Z"
                 replace iznos with wporz
            case tarifa = "SVE     " .AND. podtar = "T"
                 replace iznos with wport
            case tarifa = "1/28    " .AND. podtar = "T"
                 replace iznos with wportt
            case tarifa = "1/8     " .AND. podtar = "R"
                 replace iznos with mVrep30
            case tarifa = "1/18    " .AND. podtar = "R"
                 replace iznos with mVrep20
            case tarifa = "1/30    " .AND. podtar = "V"
                 replace iznos with mVvoj30
            case tarifa = "1/17    " .AND. podtar = "V"
                 replace iznos with mVvoj17
            case tarifa = "1/1     " .AND. podtar = "V"
                 replace iznos with mVvoj1
            case tarifa = "1/3     " .AND. podtar = "V"
                 replace iznos with mVvoj3
         endcase
         SKIP
      ENDDO
      *
CLEAR SCREEN
SET FILTER TO
close databases
RETURN
ENDDO

