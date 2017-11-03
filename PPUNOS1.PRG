*:*****************************************************************************
*:
*:        Program: C:\TK\PPUNOS.PRG
*:         System: Knjigovodstvo trgovacke radnje
*:         Author: Dzepina Marko
*:  Last modified: 04.29.93 at 17:48:15
*:
*:      Called by: PP.PRG                            
*:
*:      functions: UpisDobavljac
*:               : ListDobavljac
*:           Uses: PPDAT.DBF          
*:
*:        Indexes: PPINSIF.IDX        
*:               : PPINNAZ.IDX        
*:               : PPINMES.IDX        
*:               : PPINZIR.IDX
*:        program za unos podataka o pos.partnera
*:
*:      Documented 09:14:19                                FoxDoc version 3.00a
*:*****************************************************************************
PARAMETERS PROVERA
LOCAL B, m_upis
PRIVATE mPPNAZ, mPPADR, mPPZIR, mPPTEL, mPPMES
PRIVATE mPPPOS, mPPSIF, mPPDMG, mPib 

#IFDEF PREDUZECE
   IF PCOUNT() = 0
      USE (ProgDir+"ppdat") INDEX (ProgDir+"ppinsif"),;
                                  (ProgDir+"ppinnaz"),;
                                  (ProgDir+"ppinmes"),;
                                  (ProgDir+"ppinzir") NEW
   ENDIF
#ELSE
   IF PCOUNT() = 0
      USE ppdat INDEX ppinsif,ppinnaz,ppinmes,ppinzir NEW
   ENDIF
#ENDIF

GO BOTTOM
B = PPDAT->ppsif + 1
mPPNAZ := mPPADR:= mPPZIR := Space(30)
mPPTEL := mPPMES:= Space(20)
mPPPOS := 0
mPPSIF = B
mPPDMG = DATE()
mPib = Space(13)

Box("pp11",18,49,.F.)

m_upis = "D"
DO WHILE m_upis = "D"
   GO BOTTOM
   B = PPDAT->ppsif + 1
   mPPSIF = B

   PPEkran()

   m_izbor = 1

   CLEAR TYPEAHEAD

   m_izbor = al_box(IIF(Lastkey()=27,"Unos PREKINUT..!!!","Podaci su izmenjeni..!"),;
                    IIF(Lastkey()=27,2,3),;
                    IIF(Lastkey()=27,{"Nastavi","Prekini"},{"Ispravi","Odustani","Upis u bazu"}),;
                    1, m_x, m_y, m_x+6, m_y+42)

   DO CASE
      CASE m_izbor = 2 .OR. Lastkey() = 27
           EXIT
      CASE m_izbor = 3
           APPEND BLANK
           REPLACE ppsif WITH mPPSIF,;
                   ppnaz WITH mPPNAZ,;
                   ppadr WITH mPPADR,;
                   pppos WITH mPPPOS,;
                   ppmes WITH mPPMES,;
                   ppzir WITH mPPZIR,;
                   ppdmg WITH mPPDMG,;
                   pptel WITH mPPTEL,;
                   pppib WITH mPIB
      CASE m_izbor = 1
           LOOP
   ENDCASE
   m_upis = "N"
   IF PCOUNT() = 0
      @ 24,0 CLEAR
      @ 24,15 SAY "  Da li nastavljamo upis (D/N) ? " GET m_upis ;
              PICTURE "!" VALID(m_upis $ "DN")
      READ
   ENDIF
ENDDO m_upis

BoxC()

IF PCOUNT() = 0
   CLOSE PPDAT
   RETURN
ENDIF

IF m_izbor = 2 .OR. Lastkey() = 27
   RETURN(.F.)
ELSE
   wDMPDOB = mPPSIF
   RETURN(.T.)
ENDIF


**********************************************
PROCEDURE PPEKRAN
LOCAL GetList:={}, CurSav:=SETCURSOR(1)
   @ m_x+00, m_y+3 SAY "Podaci o novom POSLOVNOM PARTNERU" COLOR "B/W"
   @ m_x+02, m_y+3 SAY "SIFRA......" GET mppsif PICTURE "999999" VALID ProvPPSif(mppsif)
   @ m_x+04, m_y+3 SAY "NAZIV......" GET mppnaz PICTURE "@K!"
   @ m_x+06, m_y+3 SAY "ADRESA....." GET mppadr PICTURE "@K!"
   @ m_x+08, m_y+3 SAY "POSTA......" GET mpppos PICTURE "@K 99999"
   @ m_x+10, m_y+3 SAY "MESTO......" GET mppmes PICTURE "@K!"
   @ m_x+12, m_y+3 SAY "ZIRO-RACUN." GET mppzir PICTURE "@K!"
   @ m_x+14, m_y+3 SAY "TEL/FAX...." GET mpptel PICTURE "@K!"
   @ m_x+16, m_y+3 SAY "PIB , JMBG " GET mpib   PICTURE "@K!"

   READ
   SETCURSOR(CurSav)

RETURN


**********************************************
PROCEDURE ProvPPSif(mppsif)
   IF mPPSIF = 0
      MSG("Sifra '0' je rezervisana i ne moze biti dodeljena",5)
      RETURN(.F.)
   ENDIF
   SEEK mPPSIF
   IF Found()
      Msg("Takva sifra vec postoji!",5)
      RETURN(.F.)
   ELSE
      RETURN(.T.)
   ENDIF


**********************************************
FUNCTION ListDobavljac
LOCAL SelSav:=SELECT()

SELECT PPDat

pomoc = "F1-Help       F7-Nadji         <ENTER>-Izaberi   <ESC>-izlaz bez izbora"
idbox = "P11 DOBAVLJACI"

dataset={"PPsif","PPnaz"}
zaglav ={"Sifra","Naziv DOBAVLJACA"}
GO TOP
Editdb(pomoc,idbox,14,40,.f., dataset, "LPP",,zaglav)

SELECT(SelSav)

IF wDMPDOB <> 0
   return(.T.)
ELSE
   return(.F.)
END IF


**********************************************
PROCEDURE LPP
PARAMETERS pf1, pf2
LOCAL tipka

IF pf1 = 0
   RETURN(1)
ELSEIF pf1 = 3
   Msg("Baza je prazna",3)
   wDMPDOB = 0
   RETURN(0)
ENDIF

tipka = Lastkey()
DO CASE
   CASE tipka = 5 .AND. pf1 = 1
        TONE(777,1)
        @ 24,79 SAY ""
        RETURN(1)
   CASE tipka = 24 .AND. pf1 = 2
        TONE(777,1)
        @ 24,79 SAY ""
        RETURN(1)
   CASE tipka = 27
        wDMPDOB = 0
        RETURN(0)
   CASE tipka = 13
        temp = FIELDNAME(1)
        wDMPDOB = &temp
        beep(3)
        Msg("Sifra DOBAVLJACA  kojeg ste oznacili je "+ STR(wDMPDOB,4),3)
        return(0)
   CASE tipka = -6
        DO nadjiPP
        return(2)
   OTHERWISE
        @ 24,79 SAY ""
        return(2)
END CASE

**********************************************
