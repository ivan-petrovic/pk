***************************************************
*   NADJIART.PRG : NADJI program
*   Generisan Avgust 17, 1994
***************************************************
LOCAL RecSav    := RECNO(),;
      H_LinSav   := SaveScreen(24,0,24,79),;
      OldColor   := SetColor(),;
      SelSelect  := Select(),;
      JesteArtdat:= Otvorena('ARTPANE'),; && Vraca .T. ako je vec otvorena ARTDAT
      nasao      := .F.,;                && i selektuje
      GetList    := {}                   && funkcija je u MARKO.LIB

IF JesteArtdat
   SELECT ARTPANE
ELSE
   USE (ProgDir + "ARTPANE") NEW
ENDIF
GO TOP

* Kreiranje privatnih promenljivih za sva polja

private mARTNAZ

* inicijalizacija svih promenljivih

mARTNAZ = Space(30)


* Uzmi vrednosti promenljivih

@ 5,10 SAY ""
Box("NadjiArt",5,47,.f.)

@m_x+ 02,m_y+03 SAY "Upisi bilo koji deo naziva artikla"
@m_x+ 04,m_y+01 SAY "Naziv:" GET mARTNAZ picture "@!"

SET CURSOR ON
READ
SET CURSOR OFF

IF Lastkey() = 27.OR.!(UPDATED())
   BoxC()
   SetColor(OldColor)
   RestScreen(24,0,24,79,H_LinSav)
   RETURN
ENDIF

* Napravi LOCATE izraz od ulaznih promenljivih
loc_exp = ""

* dodaj kriterijum za ARTNAZ, ako je uneta vrednost
IF len(trim(mARTNAZ))<>0
  loc_exp = iif(len(loc_exp)=0,"AT(TRIM(mARTNAZ),ARTPANE->ARTNAZ) > 0",;
                 loc_exp+".and. AT(TRIM(mARTNAZ),ARTPANE->ARTNAZ) > 0")
ENDIF

DO WHILE .t.
  MsgO("         Trazim...       ")
    locate rest for {||&loc_exp}       &&locate rest for &loc_exp
  MsgC()
  * Prikazi zapis ako si nasao, inace izadji.
  IF .not. Eof()
    *SET COLO TO +W/BG, +GR/R

    @ m_x+04,m_y+08 SAY ARTNAZ
    @ m_x+05,m_y+01 SAY "Cena: " + Str(ARTCEN,17,2)
    
    dalje ="D"
    @24,00 clear
    @24,00 SAY "   Trazimo dalje ?     (D/N) " GET dalje picture "@!" color "W+/RB"
    READ
    IF dalje = "D"
       RecSav = RECNO()
       SKIP
    else
       mARTNAZ = ARTNAZ
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
IF JesteArtdat             && pre poziva ove funkcije bila je otvorena ARTDAT
   Select(SelSelect)       && neka tako i ostane samo selektuj staru oblast
ELSE
   CLOSE ARTPANE             && otvorena je tek ovde pa je moramo i zatvoriti ovde
   Select(SelSelect)
ENDIF

IF nasao
   RETURN(.T.)
ELSE
   RETURN(.F.)
ENDIF
