   SELECT 0
   USE PLACPNAS

   SELECT 0
   USE PLACP INDEX PLACP
   
   * mcPPKPC03(9), mcPORNDO22(10), mcDOPVL43(11), mcFINTRA50(12), mcPORIM82(13), mcPORSRE66(14), mcPORPAU36(15), mcGGZEM(16)
   SELECT PLACPNAS
   mcPPKPC03  = CPPKPC03
   mcPORNDO22 = CPORNDO22
   mcDOPVL43  = CDOPVL43
   mcFINTRA50 = CFINTRA50
   mcPORIM82  = CPORIM82
   mcPORSRE66 = CPORSRE66
   mcPORPAU36 = CPORPAU36
   mcGGZEM    = CGGZEM

   SELECT PLACP

   WOD  = DATE()
   WDO  = DATE()
   wz1  = Val("00000000.00")
   wz2  = Val("00000000.00")
   wz3  = Val("00000000.00")
   wz4  = Val("00000000.00")
   wz5  = Val("00000000.00")
   wz6  = Val("00000000.00")
   wz7  = Val("00000000.00")
   wz8  = Val("00000000.00")
   wz9  = Val("00000000.00")
   wz10 = Val("00000000.00")
   wz11 = Val("00000000.00")
   wz12 = Val("00000000.00")
   wz13 = Val("00000000.00")
   wz14 = Val("00000000.00")
   wz15 = Val("00000000.00")
   wz16 = Val("00000000.00")
   wz17 = Val("00000000.00")
   wz18 = Val("00000000.00")
   wz19 = Val("00000000.00")
   wz20 = Val("00000000.00")
   wz21 = Val("00000000.00")
   wz22 = Val("00000000.00")
   ZEZ = 0

   MainMask("ZBIROVI STAVKI PLACENOG POREZA PO INTERVALIMA")
   
   @ 1,27 SAY "ZBIROVI STAVKI UPLACENOG POREZA"
   @ 2,10 SAY "OD DATUMA" GET WOD
   @ 2,32 SAY "DO DATUMA" GET WDO
   READ

   IF Lastkey() = 27
      CLOSE PLACP
      CLOSE PLACPNAS
      RETURN
   ENDIF

   * ovde obezbediti sta ima u rezervama po nazivu
   mREZ11 = Space(18)
   mREZ22 = Space(18)
   mREZ33 = Space(18)

   DO WHILE ! Eof()
      IF rez11 = " "
         zez = zez + 0
      ELSE
         mREZ11 = REZ11
      ENDIF
      IF rez22 = " "
         zez = zez + 0
      ELSE
         mREZ22 = REZ22
      ENDIF
      IF rez33 = " "
         zez = zez + 0
      ELSE
         mREZ33 = REZ33
      ENDIF
      SKIP
   ENDDO

   * SELECT PLACP
   GO TOP
   * kraj obezbedjivanja po rezervama

   * idem po zbirove
   DO WHILE ! Eof()
      IF dplacpor < wod
         SKIP
         LOOP
      ENDIF

      IF dplacpor > wdo
         SKIP
         LOOP
      ENDIF

      wz1  = Round(wz1  + PPOP73,2)
      wz2  = Round(wz2  + PPUS05,2)
      wz3  = Round(wz3  + PPNV46,2)
      wz4  = Round(wz4  + PPSREC81,2)
      wz5  = Round(wz5  + PPKPC03,2)
      wz6  = Round(wz6  + PORNDO22,2)
      wz7  = Round(wz7  + DOPVL43,2)
      wz8  = Round(wz8  + FINTRA50,2)
      wz9  = Round(wz9  + PORIM82,2)
      wz10 = Round(wz10 + PORSRE66,2)
      wz11 = Round(wz11 + PORPAU36,2)
      wz12 = Round(wz12 + GGZEM,2)
      wz13 = Round(wz13 + REZ1,2)
      wz14 = Round(wz14 + REZ2,2)
      wz15 = Round(wz15 + REZ3,2)
      wz16 = Round(wz16 + PPLEL80,2)
      wz17 = Round(wz17 + PPLEO87,2)
      wz18 = Round(wz18 + PPKOMU53,2)
      wz19 = Round(wz19 + PPFINU60,2)
      wz20 = Round(wz20 + PPUUT67,2)
      wz21 = Round(wz21 + PPUEST74,2)
      wz22 = Round(wz22 + PPUAUT88,2)
      SKIP
   ENDDO
   * kraj idem po zbirove

   CLOSE PLACP
   CLOSE PLACPNAS

   @  5, 3 SAY "P/P OPSTI REZIM 73"
   @  6, 3 SAY "P/P USLUGA 05     "
   @  7, 3 SAY "P/P NA VELIKO 46  "
   @  8, 3 SAY "P/P SRECA 81      "
   @  9, 3 SAY mcPPKPC03
   @ 10, 3 SAY mcPORNDO22
   @ 11, 3 SAY mcDOPVL43
   @ 12, 3 SAY mcFINTRA50
   @ 13, 3 SAY mcPORIM82
   @ 14, 3 SAY mcPORSRE66
   @ 15, 3 SAY mcPORPAU36
   @ 16, 3 SAY mcGGZEM
   @ 17, 3 SAY mREZ11
   @ 18, 3 SAY mREZ22
   @ 19, 3 SAY mREZ33

   @  5,40 SAY "P/P LEK LISTA   80"
   @  6,40 SAY "P/P LEK OSTALI  87"
   @  7,40 SAY "P/P KOMUNA.USL. 53"
   @  8,40 SAY "P/P FIN.USLUGA  60"
   @  9,40 SAY "P/P UG.TUR.USL. 67"
   @ 10,40 SAY "P/P USL.ESTRADA 74"
   @ 11,40 SAY "P/P USL.AUT.PAU.88"

   @  5,22 SAY wz1  PICTURE "99,999,999.99"
   @  6,22 SAY wz2  PICTURE "99,999,999.99"
   @  7,22 SAY wz3  PICTURE "99,999,999.99"
   @  8,22 SAY wz4  PICTURE "99,999,999.99"
   @  9,22 SAY wz5  PICTURE "99,999,999.99"
   @ 10,22 SAY wz6  PICTURE "99,999,999.99"
   @ 11,22 SAY wz7  PICTURE "99,999,999.99"
   @ 12,22 SAY wz8  PICTURE "99,999,999.99"
   @ 13,22 SAY wz9  PICTURE "99,999,999.99"
   @ 14,22 SAY wz10 PICTURE "99,999,999.99"
   @ 15,22 SAY wz11 PICTURE "99,999,999.99"
   @ 16,22 SAY wz12 PICTURE "99,999,999.99"
   @ 17,22 SAY wz13 PICTURE "99,999,999.99"
   @ 18,22 SAY wz14 PICTURE "99,999,999.99"
   @ 19,22 SAY wz15 PICTURE "99,999,999.99"

   @  5,60 SAY wz16 PICTURE "99,999,999.99"
   @  6,60 SAY wz17 PICTURE "99,999,999.99"
   @  7,60 SAY wz18 PICTURE "99,999,999.99"
   @  8,60 SAY wz19 PICTURE "99,999,999.99"
   @  9,60 SAY wz20 PICTURE "99,999,999.99"
   @ 10,60 SAY wz21 PICTURE "99,999,999.99"
   @ 11,60 SAY wz22 PICTURE "99,999,999.99"

   @ 21, 1 SAY "UKUP. UPLACENO"
   @ 21,35 SAY "POR. I DOPRINOSA"
   @ 21,18 SAY Round(wz1+wz2+wz3+wz4+wz5+wz6+wz7+wz8+wz9+wz10+wz11+wz12+wz13+wz14+wz15+wz16+wz17+wz18+wz19+wz20+wz21+wz22,2) PICTURE "999,999,999.99"

   WAIT " "

RETURN
