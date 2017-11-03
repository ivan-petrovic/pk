***************************************************
*   NADJIPP.PRG : NADJI program
*   Generisan Avgust 17, 1994
***************************************************
LOCAL RecSav     := RECNO(),;
      H_LinSav   := SaveScreen(24,0,24,79),;
      OldColor   := SetColor(),;
      SelSelect  := Select(),;
      SavCursor  := SETCURSOR(1),;
      nasao      := .F.,;
      GetList    := {}

GO TOP

* Kreiranje privatnih promenljivih za sva polja
private mPPNAZ

* inicijalizacija svih promenljivih

mPPNAZ = Space(30)


* Uzmi vrednosti promenljivih

@ 5,10 SAY ""
Box("NadjiPoslovnogPartnera",3,40,.f.)
@m_x+ 02,m_y+05 SAY "Upisi deo NAZIVA poslovnog part."
@m_x+ 03,m_y+01 SAY "Naziv:" GET mPPNAZ picture "@!"

READ
SETCURSOR(SavCursor)

IF Lastkey() = 27.OR.!(UPDATED())
   BoxC()
   SetColor(OldColor)
   RestScreen(24,0,24,79,H_LinSav)
   RETURN
ENDIF

* Napravi LOCATE izraz od ulaznih promenljivih
loc_exp = ""
* dodaj kriterijum za PPNAZ, ako je uneta vrednost
IF len(trim(mPPNAZ))<>0
  loc_exp = iif(len(loc_exp)=0,"AT(TRIM(mPPNAZ),PPDAT->PPNAZ)>0",;
                 loc_exp+".AND. AT(TRIM(mPPNAZ),PPDAT->PPNAZ)>0")
ENDIF

DO WHILE .t.
  MsgO("         Trazim...       ")
    locate rest for {||&loc_exp}       &&locate rest for &loc_exp
  MsgC()
  * Prikazi zapis ako si nasao, inace izadji.
  IF .not. Eof()
    *SET COLO TO +W/BG, +GR/R

    @ m_x+03,m_y+08 SAY PPNAZ
    
    dalje ="D"
    @24,00 clear
    @24,00 SAY "   Trazimo dalje ?     (D/N) " GET dalje picture "@!" color "W+/RB"
    READ
    IF dalje = "D"
       RecSav = RECNO()
       SKIP
    else
       nasao = .T.
       EXIT
    ENDIF
  else
    Msg("   Nema (vise) podataka koji zadovoljavaju vas uslov  ",3)
    go RecSav
    EXIT
  ENDIF
ENDDO
BoxC()
RestScreen(24,0,24,79,H_LinSav)
SetColor(OldColor)

IF nasao
   mDMPDOB = PPSIF
   RETURN(.T.)
ELSE
   mDMPDOB = 0
   RETURN(.F.)
ENDIF
