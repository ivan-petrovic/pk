* - nije pregledano - *
*:*****************************************************************************
*:
*:        Program: C:\TK\LISTbaza.PRG
*:         System:
*:         Author: Dzepina Marko
*:  Last modified: 03.18.93 at 18:12:22
*:
*:      Called by:
*:
*:          calls: DbList() function in LISTBAZA.PRG
*:           Uses: (baza)
*:        Indexes: (index)
*:
*:      Documented 09:18:10                                FoxDoc version 3.00a
*:*****************************************************************************
PARAMETER T, L ,B ,R, baza, indexbaza1, indexbaza2, indezbaza3
*LOCAL SelSav, EkrnSav
set delete on
SelSav = SELECT()
*INVERT = "N/W"
*T = VAL(T)
*L = VAL(L)
*B = VAL(B)
*R = VAL(R)

EkrnSav = SaveScreen(T-1, L-1, B+1, R+1)
@ T-1, L-1 CLEAR TO B+1, R+1
@ T-1, L-1 TO B+1, R+1 DOUBLE

SELECT 0
do case
   case PCOUNT() = 5
      USE &baza
   case PCOUNT() = 6
      USE &baza INDEX &indexbaza1
   case PCOUNT() = 7
      USE &baza INDEX &indexbaza2
   case PCOUNT() = 8
      USE &baza INDEX &indexbaza3
ENDcase

declare polja[fcount()]
for x =1 to fcount()
    polja[x] = FIELDNAME(x)
next
_izadji=.F.
DO WHILE !_izadji
   DbEdit(t, l, b, r, polja, "DbList1")
ENDDO

USE
SELECT(SelSav)
RestScreen(T-1, L-1, B+1, R+1,EkrnSav)
return

************************
FUNCTION DbList1
************************
parameters pf1, pf2
*LOCAL tipka, polje

tipka = Lastkey()
polje = FIELDNAME(pf2)

IF pf1=0
   return(1)
elseif pf1 = 3
   @ 24,0 SAY "baza je PRAZNA, pritisni bilo koji taster za nastavak "
   InKey(5)
   @ 24,0 clear
   _izadji=.T.
   return(0)
ENDIF
DO CASE
   CASE tipka =  5 .AND. pf1 = 1
        tone(777,1)
        @ 24,79 SAY ""
        RETURN(1)
   CASE tipka = 24 .AND. pf1 = 2
        tone(555,1)
        @ 24,79 SAY ""
        RETURN(1)
   CASE tipka = 27
        _izadji=.T.
        RETURN(0)
   CASE tipka = 13 .AND. TYPE(polje) != "M"
        @Row(),Col() GET &polje
        SET CURSOR ON
        READ
        SET CURSOR OFF
        return(1)
   CASE tipka = 13 .AND. TYPE(polje) == "M"
        set cursor on
        a = EditMem1(Invert,&polje,polje,10,17,16,64,.T.,"e1")
        set cursor off
        REPLACE &polje WITH a
        RETURN(1)
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
**************
func e11
**************
IF Lastkey() = -8
   keyboard chr(23)
elseif Lastkey() = -9
   Stampa1()
ENDIF

***********************************
FUNCTION STAMPA1
duzlin = 60
veltab = 3
Wrap = .T.
@ 24,0
set printer on
set console off
linija = MLCOUNT(&POLJE, duzlin, veltab, Wrap)
FOR teklin = 1 TO linija
  ? MEMOLINE(&POLJE, duzlin, teklin, veltab, Wrap)
NEXT
set printer off
set console on
RETURN ""

**********************************************
FUNCTION EditMem1
PARAMETERS cMemColor,cString,cTitle,nTop,nLeft,nBottom,nRight,lEdit,uFun

*Local cScreen

cScreen=SAVESCREEN(nTop-1,nLeft-2,nBottom+2,nRight+3)

OldCol=SetColor(cMemColor)
@ nTop-1,nLeft-2 CLEAR TO nBottom+1,nRight+2
@ nTop-1,nLeft-2 TO nBottom+1,nRight+2 DOUBLE
@ nTop-1,nLeft SAY "µ"+cTitle+"Æ"
@ nBottom+1,nLeft SAY "µ F9-UPIS  F10-Stampa <ESC>-izlaz BEZ UPISA Æ"
set cursor on
cString=MEMOEDIT(cString,nTop,nLeft,nBottom,nRight,lEdit,uFun)
set cursor off
RESTSCREEN(nTop-1,nLeft-2,nBottom+2,nRight+3,cScreen)
SetColor(OldCol)
RETURN (cString)
