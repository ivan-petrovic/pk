* - nije pregledano - *
PRIVATE TabPos,hTabPos
TabPos:=hTabPos:=1
*************************

IF ! FILE("ZIRPLAC.DBF")
	CREATE RADNA
	STORE "SVRHA     C50 " TO POLJE1
	STORE "ZR        C30 " TO POLJE2
	STORE "IZNOS     N172" TO POLJE3
	STORE "SIFPLAC   C5  " TO POLJE4
	STORE "TARIFA    C8  " TO POLJE5
	STORE "PODTAR    C1  " TO POLJE6
	FOR I = 1 TO 6
		STORE STR(I,1) TO BROJ
		STORE "POLJE" + BROJ TO P1
		APPEND BLANK
		REPLACE FIELD_NAME WITH SUBSTR(&P1,1,10)
		REPLACE FIELD_TYPE WITH SUBSTR(&P1,11,1)
		REPLACE FIELD_LEN WITH VAL(SUBSTR(&P1,12,2))
		REPLACE FIELD_DEC WITH VAL(SUBSTR(&P1,14,1))
	NEXT I
	CREATE ZIRPLAC FROM RADNA
	INDEX ON TARIFA+PODTAR TO ZIRPLAC1
	USE
	ERASE RADNA.DBF
ENDIF


naslov := {"Svrha uplate", ;
           "Ziro racun", ;
           "Iznos", ;
           "Sif.plac", ;
           "Tarifa", ;
           "Vrsta (R,Z,T,V)" }

polja := {"SVRHA", ;
          "ZR", ;
          "IZNOS", ;
          "SIFPLAC", ;
          "TARIFA", ;
          "PODTAR" }

status = "F1 - Pomo}   Del. - brisanje  Alt-N Nova stavka   <Enter> Izmena            "

SELECT 0
USE ZIRPLAC INDEX ZIRPLAC1

vrati_se=.T.
DO WHILE vrati_se

   Editdb(status,'Cnl UPLATNI ZIRO RACUNI   ',14,70,.f., polja, "DbVIR",,naslov)

ENDDO

SELECT ZIRPLAC
CLOSE ZIRPLAC
CLEAR SCREEN
RETURN

*************************************************
PROCEDURE Dbvir
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
   RETURN(1)
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
