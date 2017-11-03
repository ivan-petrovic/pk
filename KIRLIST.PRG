PRIVATE TabPos,hTabPos
TabPos:=hTabPos:=1

naslov := {" R.Br", ;
           "DatKnj", ;
           "BrojRacuna", ;
           "Dat.Racuna", ;
           " Kupac ", ;
           "PIB ili JMBG ", ;
           "Uk.nak. sa pdv", ;
           "Oslob. sa prav.na od.", ;
           "Oslob. bez prav.na od.", ;
           "Inos.pravo na pred.por.", ;
           "Inos.bez prav. na pred.por.", ;
           "Osnovica PDV 18 %", ;
           "Iznos PDV 18 %", ;
           "Osnovica PDV 8 %", ;
           "Iznos PDV 8 %", ;
           "Uk.prom. sa p. bez p.", ;
           "Uk.prom. sa pravom"}


polja := {"RBKIR", ;
          "DATKKIR", ;
          "BRRACKIR", ;
          "DATRACKIR", ;
          "KUPKIR", ;
          "PIBJMBGKIR", ;
          "UKNAKKIR", ;
          "OSAOD", ;
          "OBEZOD", ;
          "OSAODI", ;
          "OBEZODI", ;
          "OSN18", ;
          "IZN18", ;
          "OSN8", ;
          "IZN8", ;
          "UKSIB", ;
          "UKS"}

status="F1 - Pomo}   Del. - brisanje  Alt-N Nova stavka   <Enter> Izmena            "

SELECT 0
USE KIR INDEX KIRDK

vrati_se=.T.
DO WHILE vrati_se

   Editdb(status,'Cnl PREGLED K I R _ a     ',14,70,.f., polja, "DbCListkir",,naslov)

ENDDO

SELECT KIR
CLOSE KIR

RETURN

*************************************************
PROCEDURE DbCListkir
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
   Msg("baza je PRAZNA",5)
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
*************************************************
