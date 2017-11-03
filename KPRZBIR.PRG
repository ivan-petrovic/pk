* - nije pregledano - *
SET CONFIRM ON
SET DATE GERMAN
SET MESSAGE TO 24 CENTER
PUBLIC DATUM,V
DATUM = DATE()
*
WRRB = VAL("0000")
SELECT 0
USE KPR
GO BOTTOM
*WRRB = RRB + 1
CLOSE KPR
*
select 0
USE KPR
DO WHILE .T.
CLEAR SCREEN
V = 0
DN = " "
mNivo = " "
mNivo1 = "  "
WRBkPr = VAL("0000")
WdkkPr = DATE()
WdPPVDKPR = DATE()
wbracKPR = Space(10)
wdracKPR = date()
Wkupkpr = VAL("000000")
wpibkpr = Space(13)
wukspdv = VAL("000000000.00")
wukspdv1 = VAL("000000000.00")
woslpdv = VAL("000000000.00")
wnpdv = VAL("000000000.00")
wuvozn = VAL("000000000.00")
wukppdv = VAL("000000000.00")
wodpdv = VAL("000000000.00")
wneodpdv = VAL("000000000.00")
wvbezpdvu = VAL("000000000.00")
wiznpdvu = VAL("000000000.00")
wvdu = VAL("000000000.00")
wiznn5 = VAL("000000000.00")
*
dat1 = date()
dat2 = date()
   @ 3,10 SAY "Nivo Prodavnice: " GET mNivo VALID ! Empty(mNivo)
   @ 5,10 SAY "ZBIROVI KNJIGE KPR  OD DATUMA" GET DAT1
   @ 5,52 SAY "DO DATUMA" GET DAT2
   READ
   IF Lastkey() =  27
      EXIT
   ENDIF
* OVDE IYRACUNATI YBIROVE
  mNivo1 = "/" + mNivo
  * izvrsiti filtriranje
     IF mNivo # "1"
        SET FILTER TO right(alltrim(brkal),2) = mNivo1
        GO TOP
     else
        SET FILTER TO right(alltrim(brkal),2) # "/2" .and. right(alltrim(brkal),2) # "/3" .and. right(alltrim(brkal),2) # "/4"
        GO TOP
     ENDIF
  * kraj vrsenja filtriranja
  DO WHILE ! Eof()
   IF drackpr >= dat1 .and. drackpr <= dat2
     wukspdv = ROUND(wukspdv + ukspdv,2)
     wukspdv1 = ROUND(wukspdv1 + ukspdv1,2)
     woslpdv = round(woslpdv + oslpdv,2)
     wuvozn = round(wuvozn + uvozn,2)
     wnpdv = round(wnpdv + npdv,2)
     wukppdv = round(wukppdv + ukppdv,2)
     wodpdv = round(wodpdv + odpdv,2)
     wneodpdv = round(wneodpdv + neodpdv,2)
     wvbezpdvu = round(wvbezpdvu + vbezpdvu,2)
     wiznpdvu = round(wiznpdvu + iznpdvu,2)
     wvdu = round(wvdu + vdu,2)
     wiznn5 = round(wiznn5 + iznn5,2)
   ENDIF
     SKIP
  ENDDO
  set filter to
  *
@ 9,5 SAY "UKUPNA NAKNADA SA PDV        "
@ 9,35 SAY WUKSPDV PICTURE "999999999.99"
@ 9,48 SAY "UK.NAK.SA PDV POM. "
@ 9,68 SAY WUKSPDV1 PICTURE "999999999.99"
@ 10,5 SAY "OSLOBODJENE NABAVKE (cl.18) "
@ 10,35 SAY WOSLPDV PICTURE "999999999.99"
@ 11,5 SAY "UVOZ NE PLACA SE             "
@ 12,5 SAY "PDV                          "
@ 12,35 SAY WUVOZN PICTURE "999999999.99"
@ 13,5 SAY "NAKNADA BEZ PDV              "
@ 13,35 SAY WNPDV PICTURE "999999999.99"
@ 15,5 SAY "UK.IZN.OBR. PRETHODNOG PDV   "
@ 15,35 SAY WUKPPDV PICTURE "999999999.99"
@ 16,5 SAY "IZN.PRETH. PDV MOZE SE ODBITI"
@ 16,35 SAY WODPDV PICTURE "999999999.99"
@ 17,5 SAY "IZN.PRETH. PDV NE MOZE SE OD."
@ 17,35 SAY WNEODPDV PICTURE "999999999.99"
@ 18,5 SAY "VREDNOST BEZ PDV UVOZ tac. 21"
@ 18,35 SAY WVBEZPDVU PICTURE "999999999.99"
@ 19,5 SAY "IZNOS PDV UVOZ tac. 23       "
@ 19,35 SAY WIZNPDVU PICTURE "999999999.99"
@ 20,5 SAY "VRED.PRIM.DOBARA I ULUGA t.25"
@ 20,35 SAY WVDU PICTURE "999999999.99"
@ 21,5 SAY "IZNOS NAKNADE OD 5 %  t. 24  "
@ 21,35 SAY WIZNN5 PICTURE "999999999.99"
wait " "
EXIT
ENDDO
*
close databases
*CLEAR ALL
CLEAR SCREEN
RETURN

