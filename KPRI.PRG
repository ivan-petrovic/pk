WRRB = Val("0000")
/*
SELECT 0
USE KPR
GO BOTTOM
* WRRB = RRB + 1
CLOSE KPR
*/

SELECT 0
USE KPR INDEX KPRBRAC,KPRDK,KPRBRACK

SELECT KPR
DO WHILE .T.
   CLEAR SCREEN
   DN = " "
   WRBkPr = Val("0000")
   WdkkPr = DATE()
   WdPPVDKPR = DATE()
   wbracKPR = Space(10)
   wbrKAL = Space(10)
   wdracKPR = date()
   Wkupkpr = Val("000000")
   wpibkpr = Space(13)
   wukspdv = Val("000000000.00")
   wukspdv1 = Val("000000000.00")
   woslpdv = Val("000000000.00")
   wnpdv = Val("000000000.00")
   wuvozn = Val("000000000.00")
   wukppdv = Val("000000000.00")
   wodpdv = Val("000000000.00")
   wneodpdv = Val("000000000.00")
   wvbezpdvu = Val("000000000.00")
   wiznpdvu = Val("000000000.00")
   wvdu = Val("000000000.00")
   wiznn5 = Val("000000000.00")

   @ 5,5 SAY "BROJ RACUNA                  " GET WBRACKPR VALID(wbrackpr # Space(10))
   READ
   IF Lastkey() = 27
      EXIT
   ENDIF

   SELECT KPR
   SEEK wbrackpr

   IF Found()
      WRBkPr =    RBkPr
      WdkkPr =    dkkPr
      WdPPVDKPR = dPPVDKPR
      *wbracKPR =  bracKPR
      WBRKAL = BRKAL
      wdracKPR =  dracKPR
      Wkupkpr =   kupkpr
      wpibkpr =   pibkpr
      wukspdv =   ukspdv
      wukspdv1 =  ukspdv1
      woslpdv =   oslpdv
      wuvozn =    uvozn
      wnpdv =     npdv
      wukppdv =   ukppdv
      wodpdv =    odpdv
      wneodpdv =  neodpdv
      wvbezpdvu = vbezpdvu
      wiznpdvu =  iznpdvu
      wvdu =      vdu
      wiznn5 =    iznn5
   ELSE
      MessageBox("NE POSTOJI TAJ BROJ RACUNA")
      LOOP
   ENDIF

   wrsk = Val("0")

   ************************************************************
   MainMask("IZMENA PODATAKA U KNJIZI PRIMLJENIH RACUNA")

   @ 2, 5 SAY "REDNI BROJ                   " GET WRBKpR PICTURE "9999"
   @ 3, 5 SAY "DATUM KNJIZENJA              " GET WDKKpR
   @ 4, 5 SAY "DATUM PLAC.UVOZ ILI POLJOP.  " GET WDppvdkpr
   @ 5, 5 SAY "BROJ RACUNA                  " GET WBRACKPR
   @ 5,48 SAY "BROJ KALKULACIJE " GET WBRKAL
   @ 6, 5 SAY "DATUM IZDAVANJA RACUNA (DOK.)" GET WDRACKPR
   @ 7, 5 SAY "KUPAC (NAZIV I SEDISTE)      " GET WKUPKPR PICTURE "999999"
   @ 8, 5 SAY "PIB ili JMBG                 " GET WPIBKPR
   @ 9, 5 SAY "UKUPNA NAKNADA SA PDV        " GET WUKSPDV PICTURE "999999999.99"
   @ 9,48 SAY "UK.NAK.SA PDV POM." GET WUKSPDV1 PICTURE "999999999.99"
   @ 10,5 SAY "OSLOBODJENE NABAVKE (cl.18) " GET WOSLPDV PICTURE "999999999.99"
   @ 11,5 SAY "NABAVKA IZ UVOZA NE PLACA    "
   @ 12,5 SAY "SE PDV                       " GET WUVOZN PICTURE "999999999.99"
   @ 13,5 SAY "NAKNADA BEZ PDV              " GET WNPDV PICTURE "999999999.99"
   @ 15,5 SAY "UK.IZN.OBR. PRETHODNOG PDV   " GET WUKPPDV PICTURE "999999999.99"
   @ 16,5 SAY "IZN.PRETH. PDV MOZE SE ODBITI" GET WODPDV PICTURE "999999999.99"
   @ 17,5 SAY "IZN.PRETH. PDV NE MOZE SE OD." GET WNEODPDV PICTURE "999999999.99"
   @ 18,5 SAY "VREDNOST BEZ PDV UVOZ tac. 21" GET WVBEZPDVU PICTURE "999999999.99"
   @ 19,5 SAY "IZNOS PDV UVOZ tac. 23       " GET WIZNPDVU PICTURE "999999999.99"
   @ 20,5 SAY "VRED.PRIM.DOBARA I ULUGA t.25" GET WVDU PICTURE "999999999.99"
   @ 21,5 SAY "IZNOS NAKNADE OD 5 %  t. 24  " GET WIZNN5 PICTURE "999999999.99"

   READ

   IF Lastkey() = 27
      EXIT
   ENDIF
   ************************************************************

   @ 23,24 SAY "Upis (D/N)? " GET DN PICTURE "!" VALID(DN $ "DN")
   READ

   IF Lastkey() = 27
      EXIT
   ENDIF
   IF DN = "N"
      LOOP
   ENDIF

   REPLACE RBkPr    WITH WRBkPr
   REPLACE dkkPr    WITH WdkkPr
   REPLACE dPPVDKPR WITH WdPPVDKPR
   * REPLACE bracKPR WITH wbracKPR
   REPLACE brKAL    WITH wbrKAL
   REPLACE dracKPR  WITH wdracKPR
   REPLACE kupkpr   WITH Wkupkpr
   REPLACE pibkpr   WITH wpibkpr
   REPLACE ukspdv   WITH wukspdv
   REPLACE ukspdv1  WITH wukspdv1
   REPLACE oslpdv   WITH woslpdv
   REPLACE uvozn    WITH wuvozn
   REPLACE npdv     WITH wnpdv
   REPLACE ukppdv   WITH wukppdv
   REPLACE odpdv    WITH wodpdv
   REPLACE neodpdv  WITH wneodpdv
   REPLACE vbezpdvu WITH wvbezpdvu
   REPLACE iznpdvu  WITH wiznpdvu
   REPLACE vdu      WITH wvdu
   REPLACE IZNN5    WITH wiznn5
   SELECT KPR
   wrrb = wrrb + 1
ENDDO

CLOSE DATABASES
RETURN
