* - nije pregledano - *
*@ 0,0 clear
*esckey()
*@ 1,13 SAY "LISTANJA,BRISANJA,DODAVANJA NA KARTICI REPROMATERIJALA"
*@ 3,2 SAY "ENTER - izmena polja(zapamtite prethodnu vrednost)"
*@ 4,2 SAY "DELETE - brisanje cele stavke"
*@ 5,2 SAY "ALT/N - unos nove stavke"

PRIVATE TabPos,hTabPos
TabPos:=hTabPos:=1

naslov:= {" R.Br", ;
        "DatKnj", ;
       "Opis knjizenja", ;
           "Prihod od prodaje proizvoda", ;
          "Prihod od izvrsenih usluga", ;
          "Preracunata stopa", ;
          "Iznos obracunatog poreza", ;
          "S V E G A      "}



polja:=  {"ERB", ;
        "EDAT", ;
        "EOPIS", ;
         "EODP", ;
         "EODU", ;
          "ESTOP", ;
          "EIZPOR", ;
          "ESVEGA"}

status="F1 - Pomo}   Del. - brisanje  Alt-N Nova stavka   <Enter> Izmena            "
select 0
USE epodat INDEX epoind,epoinrb
*Editdb(status,'Cnl PREGLED KARTICA',14,70,.f., polja, "DbCList1",format,naslov)

vrati_se=.T.
DO WHILE vrati_se

   Editdb(status,'Cnl PREGLED KNJIGE K P O ',14,70,.f., polja, "DbCList19",,naslov)

ENDDO

SetColor(Normal)
SELECT EPODAT
close epodat
return


************************
PROC DbCList19
************************
parameters pf1, pf2
UZMI="+RG/B,+W/R"
tipka = Lastkey()

IF pf1=0.AND.tipka=5
   TabPos=TabPos-1
   TabUpdate(vScrollBar,TabPos,LASTREC(),.t.)   && nova pozicija dugmeta vertSB
   return(1)
elseif pf1=0.AND.tipka=24
   TabPos=TabPos+1
   TabUpdate(vScrollBar,TabPos,LASTREC(),.t.)
   return(1)
elseif pf1=0.AND.tipka=19
   hTabPos=pf2                   &&hTabPos-1
   hTabUpdate(hScrollBar,hTabPos,FCOUNT(),.t.)
   return(1)
elseif pf1=0.AND.tipka=4
   hTabPos=pf2                   &&hTabPos+1
   hTabUpdate(hScrollBar,hTabPos,FCOUNT(),.t.)
   return(1)
elseif pf1=0
   return(1)
elseif pf1 = 3
   Msg("baza je PRAZNA",5)
   go top
   return(0)
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

*   CASE TIPKA = -9                         && Stampaj LAGER LISTU
*        RecSav:=RECNO()
*        GO TOP
*        MsgO("Stampam LAGER LISTU U DATOTEKU")
*           DO CenaStam WITH "PRINT.DAT"
*        MsgC()
*        GO RecSav
*        Izmenio := .T.
*        DO WHILE Izmenio
*           Izmenio = M_TYPE("PRINT.DAT",82)
*        ENDDO
*        RETURN(1)
   CASE tipka = 13 .AND. VALTYPE (&(FIELDNAME(pf2))) != "M"
        temp = FIELDNAME(pf2)
        @Row(),Col() GET &temp COLOR UZMI
        SET CURSOR ON
        READ
        SET CURSOR OFF
        return(2)
   CASE tipka = 7
        delete
        return(0)
   CASE tipka = 305
        go bott
        append blank
        return(2)
   OTHERWISE
        @ 24,79 SAY " "
        return(2)
END CASE

