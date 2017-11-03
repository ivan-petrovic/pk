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
       "BrojDokumenta", ;
       "Opis knjizenja", ;
           "DatumDokZaknjiz", ;
          "Prihod od robe OPSTA", ;
          "Prihod od robe NIZA", ;
          "Prihod od robe NIZA1", ;
          "Prihod bez POREZA", ;
          "Preneti porez", ;
          "Prihod od usluga sa P/P", ;
          "Prihod od usluga bez P/P", ;
          "Placeni porez proiz.uslu.", ;
         "Svega Prihoda", ;
         "Nab.Vred.Robe,Repro.Rez.Del", ;
        "VrednostSopst.Proiz.", ;
            "RazlikaUCeni,Provizija", ;
           "ObracPor.Akciza,P/P Usluga", ;
          "Prodaj.Vredn.Robe i Proiz.", ;
           "Mat.i Nemat.Tros. i Amortizacija", ;
            "Dop. i Bruto Zarade zaposlenih", ;
            "Ostali Rashodi i ras.Finansiranja", ;
            "Rashodi", ;
            "Ziroracun Uplaceno", ;
            "Ziroracun Isplaceno", ;
            "Porez na usluge"}


polja:=  {"RRB", ;
        "RDK", ;
        "RBR", ;
         "ROPIS", ;
         "RDATDOK", ;
          "RPV", ;
          "RPN", ;
          "RPN1", ;
          "RPBEZ", ;
          "RPBEZ2", ;
         "RUSP", ;
         "RUSBEZP", ;
          "RPLACP", ;
        "RSVEP", ;
         "RNVRRR", ;
          "RVSP", ;
          "RRUCP", ;
          "ROBPOR", ;
         "RPRODV", ;
         "RMIN", ;
         "RDOP", ;
         "RRASF", ;
         "RRASUK", ;
         "RZIRU", ;
         "RZIRI",;
         "ROBPORU"}
status="F1 - Pomo}   Del. - brisanje  Alt-N Nova stavka   <Enter> Izmena            "
select 0
USE rashodn INDEX rashindn,rashinkn
*Editdb(status,'Cnl PREGLED KARTICA',14,70,.f., polja, "DbCList1",format,naslov)

vrati_se=.T.
DO WHILE vrati_se

   Editdb(status,'Cnl PREGLED KNJIGE RASHODA',14,70,.f., polja, "DbCList1",,naslov)

ENDDO

*SetColor(Normal)
SELECT RASHODN
USE
CLEAR SCREEN
return


************************
PROC DbCList1
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
