SELECT 0
USE KIR INDEX KIRDK

DO WHILE .T.

   WRBkir    = Val("0000")
   Wdatkkir  = DATE()
   wbrrack   = Space(10)
   WdATrack  = DATE()
   Wkupkir   = Val("000000")
   wpib      = Space(13)
   wuknakkir = Val("000000000.00")     && 7
   wosaod    = Val("000000000.00")     && 8
   wobezod   = Val("000000000.00")     && 9
   wosaodi   = Val("000000000.00")     && 10
   wobezodi  = Val("000000000.00")     && 11
   wosn18    = Val("000000000.00")     && 12
   wizn18    = Val("000000000.00")     && 13
   wosn8     = Val("000000000.00")     && 14
   wizn8     = Val("000000000.00")     && 15
   wuksib    = Val("000000000.00")
   wuks      = Val("000000000.00")
   w105      = Val("000000000.00")
   w109      = Val("000000000.00")
   dat1      = Date()
   dat2      = Date()

   CLEAR SCREEN
   @ 4,2 SAY "PORESKA PRIJAVA ( OBRAZAC PPPDV ) OD DATUMA " GET DAT1
   @ 4,58 SAY "DO DATUMA" GET DAT2
   READ

   IF Lastkey() =  27
      EXIT
   ENDIF

   * ovde izracunati zbirove
   SELECT KIR
   DO WHILE ! Eof()
      IF DATKKIR >= dat1 .AND. DATKKIR <= dat2
         wuknakkir = Round(wuknakkir + uknakkir,2)
         wosaod    = Round(wosaod + osaod,2)
         wobezod   = Round(wobezod + obezod,2)
         wosaodi   = Round(wosaodi + osaodi,2)
         wobezodi  = Round(wobezodi + obezodi,2)
         wosn18    = Round(wosn18 + osn18,2)
         wizn18    = Round(wizn18 + izn18,2)
         wosn8     = Round(wosn8 + osn8,2)
         wizn8     = Round(wizn8 + izn8,2)
         wuksib    = Round(wuksib + uksib,2)
         wuks      = Round(wuks + uks,2)
      ENDIF
      SKIP
   ENDDO
   * kraj izracunavanja zbirova za kir

   EXIT
ENDDO

* sada zbirovi iz KPR
SELECT 0
USE KPR

WRBkPr    = Val("0000")
WdkkPr    = Date()
WdPPVDKPR = Date()
wbracKPR  = Space(10)
wdracKPR  = Date()
Wkupkpr   = Val("000000")
wpibkpr   = Space(13)
wukspdv   = Val("000000000.00")
wukspdv1  = Val("000000000.00")
woslpdv   = Val("000000000.00")
wnpdv     = Val("000000000.00")
wuvozn    = Val("000000000.00")     && 11
wukppdv   = Val("000000000.00")     && 12
wodpdv    = Val("000000000.00")     && 13
wneodpdv  = Val("000000000.00")
wvbezpdvu = Val("000000000.00")     && 15
wiznpdvu  = Val("000000000.00")     && 16
wvdu      = Val("000000000.00")     && 17
wiznn5    = Val("000000000.00")     && 18

DO WHILE ! Eof()
   IF DRACKPR >= dat1 .AND. DRACKPR <= dat2
      wukspdv   = Round(wukspdv + ukspdv,2)
      wukspdv1  = Round(wukspdv1 + ukspdv1,2)
      woslpdv   = Round(woslpdv + oslpdv,2)
      wnpdv     = Round(wnpdv + npdv,2)
      wuvozn    = Round(wuvozn + uvozn,2)
      wukppdv   = Round(wukppdv + ukppdv,2)
      wodpdv    = Round(wodpdv + odpdv,2)
      wneodpdv  = Round(wneodpdv + neodpdv,2)
      wvbezpdvu = Round(wvbezpdvu + vbezpdvu,2)
      wiznpdvu  = Round(wiznpdvu + iznpdvu,2)
      wvdu      = Round(wvdu + vdu,2)
      wiznn5    = Round(wiznn5 + iznn5,2)
   ENDIF
   SKIP
ENDDO

* stampa izvestaja
SET DEVICE TO PRINT
* SET PRINT TO LISTA
SET PRINT TO LPT1
SET PRINT ON

@  1, 5 SAY gcNazRad
@  3,15 SAY "PORESKA PRIJAVA OD "
@  3,35 SAY DAT1
@  3,46 SAY "DO "
@  3,50 SAY DAT2
@  5, 5 SAY "I  PROMET DOBARA I USLUGA  "
@  5,45 SAY "Iznos naknade bez PDV "
@  5,70 SAY " P D V "
@  7, 0 SAY "1. Promet dobara i usluga koji je oslobodjen PDV"
@  8, 3 SAY "sa pravom na odbitak prethodnog poreza"
@  8,46 SAY "001"
IF Round(wosaod,0) + Round(wosaodi,0) <> 0
   @ 8,50 SAY Round(wosaod,0) + Round(wosaodi,0) PICTURE "999,999,999"
ENDIF

@ 10, 0 SAY "2. Promet dobara i usluga koji je oslobodjen PDV"
@ 11, 3 SAY "bez prava na odbitak prethodnog poreza"
@ 11,46 SAY "002"
IF Round(wobezod,0) + Round(wobezodi,0) <> 0
   @ 11,50 SAY Round(wobezod,0) + Round(wobezodi,0) PICTURE "999,999,999"
ENDIF

@ 13, 0 SAY "3. Promet dobara i usluga po opstoj stopi"
@ 13,46 SAY "003"
IF Round(wosn18,0) <> 0
   @ 13,50 SAY Round(wosn18,0) PICTURE "999,999,999"
ENDIF

@ 13,64 SAY "103"
IF Round(wizn18,0) <> 0
   @ 13,68 SAY Round(wizn18,0) PICTURE "999,999,999"
ENDIF

@ 15,0 SAY "4. Promet dobara i usluga po posebnoj stopi"
@ 15,46 SAY "004"
IF Round(wosn8,0) <> 0
   @ 15,50 SAY Round(wosn8,0) PICTURE "999,999,999"
ENDIF

@ 15,64 SAY "104"
IF Round(wizn8,0) <> 0
   @ 15,68 SAY Round(wizn8,0) PICTURE "999,999,999"
ENDIF

@ 17, 0 SAY "5. ZBIR ( 1 + 2 + 3 + 4 )               "
@ 17,46 SAY "005"
@ 17,50 SAY Round(wosaod,0) + Round(wosaodi,0) + Round(wosn18,0) + Round(wosn8,0) PICTURE "999,999,999"
@ 17,64 SAY "105"
@ 17,68 SAY Round(wizn18,0) + Round(wizn8,0) PICTURE "999,999,999"

* sada stampa iz KPR
@ 19, 5 SAY "II  PRETHODNI POREZ         "
@ 21, 0 SAY "6. Prethodni porez placen prilikom uvoza   "
@ 21,46 SAY "006"
@ 21,50 SAY Round(wvbezpdvu,0) PICTURE "999,999,999"
@ 21,64 SAY "106"
@ 21,68 SAY Round(wiznpdvu,0) PICTURE "999,999,999"
@ 23, 0 SAY "7. PDV naknada placena poljoprivredniku    "
@ 23,46 SAY "007"
@ 23,50 SAY Round(wvdu,0) PICTURE "999,999,999"
@ 23,64 SAY "107"
@ 23,68 SAY Round(wiznn5,0) PICTURE "999,999,999"
@ 25, 0 SAY "8. Prethodni porez osim prethodnog poreza  "
@ 26, 3 SAY "sa red. br. 6 i 7  "
@ 26,46 SAY "008"
@ 26,50 SAY Round(wnpdv,0) - Round(wvbezpdvu,0) - Round(wvdu,0) PICTURE "999,999,999"
@ 26,64 SAY "108"
@ 26,68 SAY Round(wodpdv,0) - Round(wiznpdvu,0) - Round(wiznn5,0) PICTURE "999,999,999"
@ 28, 0 SAY "9. ZBIR ( 6 + 7 + 8  )                "
@ 28,46 SAY "009"
@ 28,50 SAY Round(wvbezpdvu,0) + Round(wvdu,0) + Round(wnpdv,0) - Round(wvbezpdvu,0) - Round(wvdu,0) PICTURE "999,999,999"
@ 28,64 SAY "109"
@ 28,68 SAY Round(wiznpdvu,0) + Round(wiznn5,0) + Round(wodpdv,0) - Round(wiznpdvu,0) - Round(wiznn5,0) PICTURE "999,999,999"
@ 30, 5 SAY "III  PORESKA OBAVEZA         "

w105 = Round(wizn18,0) + Round(wizn8,0)
w109 = Round(wiznpdvu,0) + Round(wiznn5,0) + Round(wodpdv,0) - Round(wiznpdvu,0) - Round(wiznn5,0)

@ 32, 0 SAY "10. Iznos PDV u poreskom periodu           "
@ 32,64 SAY "   "
@ 32,68 SAY w105 - w109 PICTURE "999,999,999"
@ 34,0 SAY "11. Povracaj    "
IF w105 >= w109
   @ 34,69 SAY "NE"
ELSE
   @ 34,76 SAY "DA"
ENDIF

EJECT
SET DEVICE TO SCREEN
SET PRINT OFF

CLOSE DATABASES
RETURN
