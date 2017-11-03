LOCAL control_str, nMaxRow := 92

SELECT 0
USE RASHODN INDEX RASHINDN

DO WHILE .T.

   Dat1 = Date()
   Dat2 = Date()
   wz1 = Val("00000000.00")
   store wz1 to wz20,wz21,wz22,wz111
   store wz1 to wz2,wz3,wz4,wz5,wz6,wz7,wz8,wz9,wz10,wz11,wz12,wz13,wz14,wz15,wz16,wz17,wz18

   MainMask("STAMPA KNJIGE PRIHODA-RASHODA")
   @ 6,10 SAY "Od datuma: " GET Dat1
   @ 7,10 SAY "Do datuma: " GET Dat2
   READ

   IF Lastkey() = 27 ; EXIT ; ENDIF

   SET CONSOLE OFF
   SET DEVICE TO PRINT
   * SET PRINT TO LPT1
   SET PRINT TO LISTA
   SET PRINT ON

   * SETPRC(0,0)
   IF lLaser
      control_str = Chr(27) + '(s17H' + Chr(27) + '&l5C'
      @ 0,0 SAY control_str              && kondenz On za laserski
   ELSE
      @ 0,0 SAY Chr(15)                  && kondenz On za matricni
   ENDIF

   brst = 1
   LeviNaslov()
   LevoZaglavlje()
   GO TOP
   DO WHILE ! Eof()
      IF DTOS(RDK) >= DTOS(DAT1) .AND. DTOS(RDK) <= DTOS(DAT2)
         IF PROW() = nMaxRow
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
    ? " " + "    "
   ?? " " + "        "
   ?? " " + "                           "
   ?? " " + Str(WZ1,11,2)
   ?? " " + Str(WZ2,11,2)
   ?? " " + Str(WZ3,11,2)
   ?? " " + Str(WZ4,11,2)
   ?? " " + Str(WZ5,11,2)
   ?? " " + Str(WZ6,11,2)
   ?? " " + Str(WZ7,11,2)

   EJECT

   brst=1
   DesniNaslov()
   DesnoZaglavlje()
   GO TOP
   DO WHILE ! Eof()
      IF DTOS(RDK) >= DTOS(DAT1) .AND. DTOS(RDK) <= DTOS(DAT2)
         IF PROW() = nMaxRow
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
    ? " "+ Str(WZ8,11,2)
   ?? " "+ Str(WZ9,11,2)
   ?? " "+ Str(WZ10,11,2)
   ?? " "+ Str(WZ11,11,2)
   ?? " "+ Str(WZ12,11,2)
   ?? " "+ Str(WZ13,11,2)
   ?? " "+ Str(WZ14,11,2)
   ?? " "+ Str(WZ15,11,2)
   ?? " "+ Str(WZ16,11,2)
   ?? " "+ Str(WZ17,11,2)
   ?? " "+ Str(WZ18,11,2)

   EJECT

   * dodata treca strana
   brst=1
   TreciNaslov()
   TreceZaglavlje()
   GO TOP
   DO WHILE ! Eof()
      IF DTOS(RDK) >= DTOS(DAT1) .AND. DTOS(RDK) <= DTOS(DAT2)
         IF PROW() = 65
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
   ? " "  + Str(WZ20,11,2) + "            "
   ?? " " + Str(wz21,11,2) + "            "
   ?? " " + Str(wz22,11,2) + "             "

   IF lLaser
      ? Chr(27)+ Chr(69)         && kondenz Off za laserski
   ELSE
      ? Chr(18)                  && kondenz Off za matricni
   ENDIF

   EJECT
   SET PRINTER OFF
   SET PRINT TO
   SET DEVICE TO SCREEN
   SET CONSOLE ON
ENDDO

USE

RETURN

*************************************************
