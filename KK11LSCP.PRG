* Isto kao KK11, samo stampa landscape
SELECT 0
USE RASHODN INDEX RASHINDN

DO WHILE .T.

   DAT1 = DATE()
   DAT2 = DATE()
   wsif = val("0000000000000")
   wz1 = val("00000000.00")
   store wz1 to wz20,wz21,wz22,wz23,wz111,wz24
   store wz1 to wz2,wz3,wz4,wz5,wz6,wz7,wz8,wz9,wz10,wz11,wz12,wz13,wz14,wz15,wz16,wz17,wz18,wz19
   wUkupno = VAL("000000000000.00")

   CLEAR SCREEN
   @ 6,10 SAY "STAMPA KNJIGU PRIHOD-RASHOD OD DATUMA" GET DAT1
   @ 6,57 SAY "DO DATUMA" GET DAT2
   READ

   IF Lastkey() = 27
      EXIT
   ENDIF

   SET CONSOLE OFF
   SET DEVICE TO PRINT
   SET PRINT TO LPT1
   * SET PRINT TO PRNKPR
   SET PRINT ON

   * SETPRC(0,0)
   * Landscape ON
   ? Chr(27)+ Chr(69) + Chr(27) + "&l1o0e66f9D" + Chr(27) + "&a0l132M" + Chr(27)+ "(s13H"

   brst = 1
   LeviNaslov()
   LevoZaglavlje()
   GO TOP
   DO WHILE ! Eof()
      IF DTOS(RDK) >= DTOS(DAT1) .AND. DTOS(RDK) <= DTOS(DAT2)
         IF PROW() = 40
            IF !brst=0
               LeviFuter()
               EJECT
            ENDIF
            brst = brst + 1
            LevoZaglavlje()
         ENDIF
         LeviTekst()
         wz1 = Round(wz1 + rpv,2)
         wz2 = Round(wz2 + rpn,2)
         wz3 = Round(wz3 + rpbez,2)
         wz4 = Round(wz4 + rusp,2)
         wz5 = Round(wz5 + rusbezp,2)
         wz6 = Round(wz6 + rplacp,2)
         wz7 = Round(wz7 + rsvep,2)
      ENDIF
      SKIP
   ENDDO
   LeviFuter()

   * stampa zbirova
    ? " "+"    "
   ?? " "+"        "
   ?? " "+"                           "
   ?? " "+STR(WZ1,11,2)
   ?? " "+STR(WZ2,11,2)
   ?? " "+STR(WZ3,11,2)
   ?? " "+STR(WZ4,11,2)
   ?? " "+STR(WZ5,11,2)
   ?? " "+STR(WZ6,11,2)
   ?? " "+STR(WZ7,11,2)
   * kraj stampe zbirova

   EJECT

   brst=1
   DesniNaslov()
   DesnoZaglavlje()
   GO TOP
   DO WHILE ! Eof()
      IF DTOS(RDK) >= DTOS(DAT1) .AND. DTOS(RDK) <= DTOS(DAT2)
         IF PROW() = 40
            IF !brst=0
               DesniFuter()
               EJECT
            ENDIF
            brst = brst + 1
            DesnoZaglavlje()
         ENDIF
         DesniTekst()
         wz8 = Round(wz8 + rnvrrr,2)
         wz9 = Round(wz9 + rvsp,2)
         wz10 = Round(wz10 + rrucp,2)
         wz11 = Round(wz11 + robpor,2)
         wz111 = Round(wz111 + robporU,2)
         wz12 = Round(wz12 + rprodv,2)
         wz13 = Round(wz13 + rmin,2)
         wz14 = Round(wz14 + rdop,2)
         wz15 = Round(wz15 + rrasf,2)
         wz16 = Round(wz16 + rrasuk,2)
         wz17 = Round(wz17 + rziru,2)
         wz18 = Round(wz18 + rziri,2)
      ENDIF
      SKIP
   ENDDO
   DesniFuter()

   * stampa zbirova
    ? " "+ STR(WZ8,11,2)
   ?? " "+ STR(WZ9,11,2)
   ?? " "+ STR(WZ10,11,2)
   ?? " "+ STR(WZ11,11,2)
   ?? " "+ STR(WZ12,11,2)
   ?? " "+ STR(WZ13,11,2)
   ?? " "+ STR(WZ14,11,2)
   ?? " "+ STR(WZ15,11,2)
   ?? " "+ STR(WZ16,11,2)
   ?? " "+ STR(WZ17,11,2)
   ?? " "+ STR(WZ18,11,2)
   * kraj stampe zbirova

   EJECT

   * dodata treca strana
   brst=1
   TreciNaslov()
   TreceZaglavlje()
   GO TOP
   DO WHILE ! Eof()   && WSIF = SIFART
      IF DTOS(RDK) >= DTOS(DAT1) .AND. DTOS(RDK) <= DTOS(DAT2)
         IF PROW() = 40
            IF !brst=0
               TreciFuter()
               EJECT
            ENDIF
            brst = brst + 1
            TreceZaglavlje()
         ENDIF
         TreciTekst()
         wz20 = Round(wz20 + rpbez06,2)  && obracunati PDV
         wz21 = Round(wz21 + rpbez2,2)   && preneti PDV
         wz22 = Round(wz22 + rpbez4,2)   && placen PDV
      ENDIF
      SKIP
   ENDDO
   TreciFuter()

   * stampa zbirova
   ? " " + STR(WZ20,11,2)+ "            "
   ?? " "+ STR(wz21,11,2)+ "            "
   ?? " "+ STR(wz22,11,2)+ "             "
   * kraj stampe zbirova

   EJECT

   * Landscape OFF
   ? Chr(27)+ Chr(69)

   SET PRINTER OFF
   SET PRINT TO
   SET DEVICE TO SCREEN
   SET CONSOLE ON
ENDDO

USE

RETURN
