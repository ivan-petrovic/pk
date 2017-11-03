*************************************************
* Pregled i stampa obrasca BU - bilans uspeha
*************************************************

LOCAL lIzmenio := .T.

PRIVATE Dat1, Dat2

MainMask("BILANS USPEHA")

Dat1 = Date()
Dat2 = Date()
@ 10,10 SAY "OD DATUMA: " GET Dat1
@ 11,10 SAY "DO DATUMA: " GET Dat2
READ

IF Lastkey() = 27
	RETURN
ENDIF

SELECT 0
USE RASHODN INDEX RASHINDN

Formiraj_BU(.T.)

SET KEY -9 TO F10_BU_Print

DO WHILE lIzmenio
   lIzmenio = m_type("bu.prn",78)
ENDDO

SET KEY -9 TO

CLOSE DATABASES
RETURN

*************************************************
PROCEDURE F10_BU_Print

	Formiraj_BU(.F.)

RETURN

*************************************************
PROCEDURE Formiraj_BU(lToFile)
	LOCAL nPrihod, nNabVrRobe, nTrNabUZal, nTrNabUProdRob
   LOCAL nTrZarada, nTrUsluga, nFinRash, cDivLine, nTmp
   LOCAL wpv, wpn, wrpbez, wpuv, wrusbezp, wrpv, wrpn
   LOCAL wrusp, wtz, wputun, wrprodv, wrsvep
   LOCAL nTrosak, wrrasf, nDobit, nPorezIzDobiti, nDoprIzDobiti
   LOCAL nPorezRPV, nPorezRUSP, strFormat
   LOCAL nPDV_Koef := 0.0
   LOCAL nPDV_KNiza := 0.0

   nPrihod    = Val("000000000000.00")
   nNabVrRobe = Val("00000000000000.00")
   nTrNabUZal = Val("000000000000.00")
   nTrNabUProdRob = Val("000000000000.00")
   nTrZarada    = Val("00000000000000.00")
   nTrUsluga    = Val("00000000000000.00")
   nFinRash  = Val("00000000000000.00")

   wpv      = Val("000000000000.00")
   wpn      = Val("000000000000.00")
   wrpbez   = Val("00000000000000.00")
   wpuv     = Val("000000000000.00")
   wrusbezp = Val("00000000000000.00")
   wrpv     = Val("00000000000000.00")
   wrpn     = Val("00000000000000.00")
   wrusp    = Val("00000000000000.00")
   wtz      = Val("000000000000.00")
   wputun   = Val("000.00")
   wrprodv  = Val("00000000000000.00")
   wrsvep   = Val("00000000000000.00")
   nPorezRPV  = Val("00000000000000.00")
   nPorezRUSP = Val("00000000000000.00")

   * ovih pet promenljivih se ne koriste u bilansu uspeha
   * ali sam ih ostavio jer treba da napisem i pregled troskova
   * pa da iskoristim racun u ovom potprogramu
   nTrosak = Val("000000000000.00")
   wrrasf  = Val("00000000000000.00")
   nDobit  = Val("000000000000.00")
   nPorezIzDobiti = Val("000000000000.00")
   nDoprIzDobiti  = Val("000000000000.00")

	GO TOP
	DO WHILE ! Eof()
      IF RDK >= Dat1 .AND. RDK <= Dat2
         nPDV_Koef  = KoefPDV(RDK)
         nPorezRPV  = Round(nPorezRPV + RPV * nPDV_Koef, 2)
         nPorezRUSP = Round(nPorezRUSP + RUSP * nPDV_Koef, 2)

         nNabVrRobe = Round(nNabVrRobe + RNVRRR,2)
         nTrUsluga  = Round(nTrUsluga + RMIN,2)
         nTrZarada  = Round(nTrZarada + RDOP,2)
         nFinRash   = Round(nFinRash + RRASF,2)
         wrpv     = Round(wrpv + RPV,2)
         wrpn     = Round(wrpn + RPN,2)
         wrpbez   = Round(wrpbez + RPBEZ,2)
         wrusp    = Round(wrusp + RUSP,2)
         wrusbezp = Round(wrusbezp + RUSBEZP,2)
         wrprodv  = Round(wrprodv + RPRODV,2)
         wrsvep   = Round(wrsvep + RSVEP,2)
         wrrasf   = Round(wrrasf + RRASF,2)
      ENDIF
		SKIP
	ENDDO

   wpv  = Round(wrpv - nPorezRPV,2)
   nPDV_KNiza = KoefPDVNiza(Dat1)
   wpn  = Round(wrpn - Round(wrpn * nPDV_KNiza,2),2)
   wpuv = Round(wrusp - nPorezRUSP,2)
   nPrihod = Round(wpv + wpn + wrpbez + wpuv + wrusbezp,2)

   wtz = Round(wrprodv - Round(wrsvep - wrusp - wrusbezp,2),2)
   wputun = Round((nNabVrRobe * 100) / wrprodv,2)
   nTrNabUZal = Round(wtz * (wputun / 100),2)

   nTrNabUProdRob = Round(nNabVrRobe - nTrNabUZal,2)

   nTrosak = Round(nNabVrRobe - nTrNabUZal + nTrUsluga + nTrZarada + wrrasf,2)
   nDobit = Round(nPrihod - nTrosak,2)
   nPorezIzDobiti = Round(nDobit * 0.1000,2)
   nDoprIzDobiti = Round(nDobit * 0.3508,2)

	SET DEVICE TO PRINT
	IF(lToFile)
		SET PRINT TO BU
	ELSE
		SET PRINT TO LPT1
	ENDIF
	SET PRINT ON

	BU_Zaglavlje()

   * zaokruzivanje
   nPrihod = Round(nPrihod,0)
   nNabVrRobe = Round(nNabVrRobe,0)
   nTrNabUZal = Round(nTrNabUZal,0)
   nTrNabUProdRob = Round(nTrNabUProdRob,0)
   nTrZarada = Round(nTrZarada,0)
   nTrUsluga = Round(nTrUsluga,0)
   nFinRash = Round(nFinRash,0)

   cDivLine = Chr(195) + Replicate(Chr(196),4) + Chr(197) + Replicate(Chr(196),45) ;
              + Chr(197) + Replicate(Chr(196),25) + Chr(180)
   ? "| I  | Prihodi od poslovanja                       |                         |"
   ? cDivLine
   strFormat = Formatiraj(nPrihod,25,2)
   ? "| 1. | Prihodi od delatnosti                       |" + SubStr(strFormat,1,len(strFormat)-3) + "   |"
   ? cDivLine
   ? "| II | Rashodi                                     |                         |"
   ? cDivLine
   strFormat = Formatiraj(nNabVrRobe,25,2)
   ? "| 2. | Nabavna vrednost robe, reprodukcionog       |                         |"
   ? "|    | materijala i rezervnih delova               |" + SubStr(strFormat,1,len(strFormat)-3) + "   |"
   ? cDivLine
   strFormat = Formatiraj(nTrNabUZal,25,2)
   ? "| 3. | Nabavna vrednost zaliha robe, reprodukcionog|                         |"
   ? "|    | materijala i rezervnih delova               |" + SubStr(strFormat,1,len(strFormat)-3) + "   |"
   ? cDivLine
   strFormat = Formatiraj(nTrNabUProdRob,25,2)
   ? "| 4. | Nabavna vrednost prodate robe, utrosenog    |                         |"
   ? "|    | reprodukcionog materijala i ugradjenih      |" + SubStr(strFormat,1,len(strFormat)-3) + "   |"
   ? "|    | rezervnih delova (red.br. 2 - red.br. 3)    |                         |"
   ? cDivLine
   strFormat = Formatiraj(nTrZarada,25,2)
   ? "| 5. | Zarade, naknade i ostali licni rashodi      |" + SubStr(strFormat,1,len(strFormat)-3) + "   |"
   ? cDivLine
   strFormat = Formatiraj(nTrUsluga,25,2)
   ? "| 6. | Troskovi proizvodnih usluga, amortizacije i |                         |"
   ? "|    | nematerijalni troskovi                      |" + SubStr(strFormat,1,len(strFormat)-3) + "   |"
   ? cDivLine
   strFormat = Formatiraj(nFinRash,25,2)
   ? "| 7. | Rashodi finansiranja i ostali rashodi       |" + SubStr(strFormat,1,len(strFormat)-3) + "   |"
   ? cDivLine
   nTmp = nTrNabUProdRob + nTrZarada + nTrUsluga + nFinRash
   strFormat = Formatiraj(nTmp,25,2)
   ? "| 8. | Rashodi poslovanja (red.br. 4 do red.br. 7) |" + SubStr(strFormat,1,len(strFormat)-3) + "   |"
   ? cDivLine
   ? "| III| Finansijski rezultati poslovanja            |                         |"
   ? cDivLine
   nTmp = nPrihod - nTmp
   IF nTmp >= 0
      strFormat = Formatiraj(nTmp,25,2)
   ELSE
      strFormat = Formatiraj(-nTmp,25,2)
   ENDIF
   ? "| 9. | Neto prihod - dobit (red.br. 1 - red.br. 8) |"
   IF nTmp >= 0
      ?? SubStr(strFormat,1,len(strFormat)-3) + "   |"
   ELSE
      ?? "                         |"
   ENDIF
   ? cDivLine
   ? "|10. | Gubitak - neto (red.br. 8 - red.br. 1)      |"
   IF nTmp < 0
      ?? SubStr(strFormat,1,len(strFormat)-3) + "   |"
   ELSE
      ?? "                         |"
   ENDIF
	? Chr(192) + Replicate(Chr(196),4) + Chr(193) + Replicate(Chr(196),45) ;
     + Chr(193) + Replicate(Chr(196),25) + Chr(217)

	BU_Futer()
	EJECT

	SET DEVICE TO SCREEN
	SET PRINT OFF

RETURN
*************************************************

*************************************************
PROCEDURE BU_Zaglavlje
   ?
	? "PIB            " + gcPIB + Space(40) + "Obrazac BU"
	? "Obveznik       " + gcPrez_Ime
	? "Firma - radnje " + gcNazRad
	? "Sediste        " + RTrim(gcAdresa) + ", " + gcMesto
	? "Sifra poreskog obveznika _____________"
	? "Sifra delatnosti         " + gcSifDel
	?
	?
	? Space(27) + "B I L A N S   U S P E H A"
	? Space(17) + "za period od " + dtoc(Dat1) + " do "  + dtoc(Dat2) + " godine"
	?
	?
	? Chr(218) + Replicate(Chr(196),4) + Chr(194) + Replicate(Chr(196),45) ;
     + Chr(194) + Replicate(Chr(196),25) + Chr(191)
	? "|Red.|                        Opis                 |           Iznos         |"
	? "|br. |                                             |                         |"
	? Chr(195) + Replicate(Chr(196),4) + Chr(197) + Replicate(Chr(196),45) ;
     + Chr(197) + Replicate(Chr(196),25) + Chr(180)
	? "| 1  |                          2                  |             3           |"
	? Chr(195) + Replicate(Chr(196),4) + Chr(197) + Replicate(Chr(196),45) ;
     + Chr(197) + Replicate(Chr(196),25) + Chr(180)

RETURN
*************************************************

*************************************************
PROCEDURE BU_Futer()
   ?
   ?
	? "U Obrenovcu                Odgovorno lice za sastavljanje         Obveznik"
	? "                                      bilansa"
	? "                                                          (M.P.)"
	? "Dana ____________ god.     ______________________________      _______________"
	?
RETURN
*************************************************
