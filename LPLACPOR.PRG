PRIVATE TabPos,hTabPos
TabPos:=hTabPos:=1

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

naslov:= {"Datplacp", ;
          "Period", ;
          "Podperiod", ;
          "Brnaloga", ;
          "Porez", ;
          "PIO", ;
          "Zdravstvo", ;
          "Nezaposlenost", ;
          mcPPKPC03, ;           && "PP KPC 03  ", ;
          mcPORNDO22, ;          && "PorNadoh 22", ;
          mcDOPVL43, ;           && "Dop.vla. 43", ;
          mcFINTRA50, ;          && "Fin.Tran 50", ;
          mcPORIM82, ;           && "PorImov. 82", ;
          mcPORSRE66, ;          && "PorSre.  66", ;
          mcPORPAU36, ;          && "PorPausa 36", ;
          mcGGZEM, ;             && "Grad.Zemlji", ;
          "Rezerva 1  ", ;
          "Rezerva 2  ", ;
          "Rezerva 3  ", ;
          "Naz.rez. 1 ", ;
          "Naz.rez. 2 ", ;
          "Naz.rez. 3 ", ;
          "Ppleklis 80", ;
          "Pplekost 87", ;
          "Ppuskomu 53", ;
          "Ppfinusl 60", ;
          "Ppusugtu 67", ;
          "Ppuslest 74", ;
          "Ppusauto 88" }

polja:= {"DPLACPOR", ;
         "PER", ;
         "OZPER", ;
         "BRNAL", ;
         "PPOP73", ;
         "PPUS05", ;
         "PPNV46", ;
         "PPSREC81", ;
         "PPKPC03", ;
         "PORNDO22", ;
         "DOPVL43", ;
         "FINTRA50", ;
         "PORIM82", ;
         "PORSRE66", ;
         "PORPAU36", ;
         "GGZEM", ;
         "REZ1", ;
         "REZ2", ;
         "REZ3", ;
         "REZ11", ;
         "REZ22", ;
         "REZ33", ;
         "PPLEL80", ;
         "PPLEO87", ;
         "PPKOMU53", ;
         "PPFINU60", ;
         "PPUUT67", ;
         "PPUEST74", ;
         "PPUAUT88" }

status="F1 - Pomo}   Del. - brisanje  Alt-N Nova stavka   <Enter> Izmena            "

vrati_se=.T.
DO WHILE vrati_se

   Editdb(status,'Cnl PREGLED KNJIGE PLACENOG POREZA',14,70,.f., polja, "DbCLikpc",,naslov)

ENDDO

SELECT PLACP
CLOSE PLACP
CLOSE PLACPNAS

RETURN

***********************************************************
PROCEDURE DbCLikpc
PARAMETERS pf1, pf2
UZMI="+RG/B,+W/R"
tipka = Lastkey()

IF pf1=0.AND.tipka=5
   TabPos=TabPos-1
   TabUpdate(vScrollBar,TabPos,LASTREC(),.t.)   && nova pozicija dugmeta vertSB
   RETURN(1)
ELSEIF pf1=0.AND.tipka=24
   TabPos=TabPos+1
   TabUpdate(vScrollBar,TabPos,LASTREC(),.t.)
   RETURN(1)
ELSEIF pf1=0.AND.tipka=19
   hTabPos=pf2                   &&hTabPos-1
   hTabUpdate(hScrollBar,hTabPos,FCOUNT(),.t.)
   RETURN(1)
ELSEIF pf1=0.AND.tipka=4
   hTabPos=pf2                   &&hTabPos+1
   hTabUpdate(hScrollBar,hTabPos,FCOUNT(),.t.)
   RETURN(1)
ELSEIF pf1=0
   RETURN(1)
ELSEIF pf1 = 3
   Msg("Baza je PRAZNA",5)
   GO TOP
   RETURN(0)
ENDIF

DO CASE
   CASE tipka =  5 .AND. pf1 != 1
      TabPos=TabPos+1
      TabUpdate(vScrollBar,TabPos,LASTREC(),.t.)
   CASE tipka =  5 .AND. pf1 = 1
      TabPos=1
      TabUpdate(vScrollBar,TabPos,LASTREC(),.t.)
      tone(777,1)
      @ 24,79 SAY ""
      RETURN(1)
   CASE tipka = 24 .AND. pf1 != 2
      TabPos=TabPos-1
      TabUpdate(vScrollBar,TabPos,LASTREC(),.t.)
   CASE tipka = 24 .AND. pf1 = 2
      TabPos=LASTREC()
      TabUpdate(vScrollBar,TabPos,LASTREC(),.t.)
      tone(555,1)
      @ 24,79 SAY ""
      RETURN(1)
   CASE tipka = 27
      vrati_se = .F.
      RETURN(0)
   CASE tipka = 13 .AND. VALTYPE (&(FIELDNAME(pf2))) != "M"
      temp = FIELDNAME(pf2)
      @Row(),Col() GET &temp COLOR UZMI
      SET CURSOR ON
      READ
      SET CURSOR OFF
      RETURN(2)
   CASE tipka = 7
      DELETE
      RETURN(0)
   CASE tipka = 305
      GO BOTTOM
      APPEND BLANK
      RETURN(2)
   OTHERWISE
      @ 24,79 SAY " "
      RETURN(2)
END CASE
