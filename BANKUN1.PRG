* - nije pregledano - *
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
LOCAL B, mNAZBANK, mADRBANK, mMESBANK, mZIRBANK, mSibank


#IFDEF PREDUZECE
   IF PCOUNT() = 0
      USE (ProgDir+"bankdat") INDEX (ProgDir+"binsif") NEW
   ENDIF
#ELSE
   IF PCOUNT() = 0
      USE bankdat INDEX binsif NEW
   ENDIF
#ENDIF


GO BOTTOM
B = BANKDAT->SIBANK + 1
mNAZBANK := mADRBANK:= mMESBANK := mZIRBANK :=Space(30)
mSibank = val("000")

Box("bb11",18,49,.F.)

m_upis = "D"
DO WHILE m_upis = "D"
   GO BOTTOM
   B = BANKDAT->SIBANK + 1
   mSIBANK = B

   BBEkran()

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
           REPLACE SIBANK WITH mSIBANK,;
                   NAZBANK WITH mNAZBANK,;
                   ADRBANK WITH mADRBANK,;
                   MESBANK WITH mMESBANK,;
                   ZIRBANK WITH mZIRBANK
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
   CLOSE BANKDAT
   RETURN
ENDIF
IF m_izbor = 2 .OR. Lastkey() = 27
   RETURN(.F.)
ELSE
   wSIFBANK = mSIBANK
   RETURN(.T.)
ENDIF


**********************************************
PROCEDURE BBEKRAN
LOCAL GetList:={}, CurSav:=SETCURSOR(1)
   @ m_x+00, m_y+3 SAY "Podaci o novoj POSLOVNOJ BANCI" COLOR "B/W"
   @ m_x+02, m_y+3 SAY "SIFRA......" GET msibank PICTURE "999999" VALID ProvPPBan(msibank)
   @ m_x+04, m_y+3 SAY "NAZIV......" GET mnazbank PICTURE "@K!"
   @ m_x+06, m_y+3 SAY "ADRESA....." GET madrbank PICTURE "@K!"
   @ m_x+08, m_y+3 SAY "MESTO......" GET mmesbank PICTURE "@K!"
   @ m_x+10, m_y+3 SAY "TEKUCI RAC." GET mzirbank PICTURE "@K!"

   READ
   SETCURSOR(CurSav)

RETURN

**********************************************
PROCEDURE ProvPPBan(msibank)
   IF msibank = 0
      MSG("Sifra '0' je rezervisana i ne moze biti dodeljena",5)
      RETURN(.F.)
   ENDIF
   SEEK msibank
   IF Found()
      Msg("Takva sifra vec postoji!!!!",5)
      RETURN(.F.)
   ELSE
      RETURN(.T.)
   ENDIF

**********************************************
FUNCTION ListBanke
LOCAL SelSav:=SELECT()

SELECT bankdat

pomoc = "F1-Help       F7-Nadji         <ENTER>-Izaberi   <ESC>-izlaz bez izbora"
idbox = "B11 BANKE     "

dataset={"Sibank","nazbank"}
zaglav ={"Sifra","Naziv BANKE"}
GO TOP
Editdb(pomoc,idbox,14,40,.f., dataset, "LBB",,zaglav)

SELECT(SelSav)
IF wSIFBANK <> 0
   return(.T.)
ELSE
   return(.F.)
END IF

**********************************************
PROCEDURE LBB
parameters pf1, pf2
IF pf1 = 0
   return(1)
elseif pf1 = 3
   Msg("Baza je prazna",3)
   wDMPDOB = 0
   return(0)
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
        wSIFBANK = 0
        RETURN(0)
   CASE tipka = 13
        temp = FIELDNAME(1)
        wSIFBANK = &temp
        beep(3)
        Msg("Sifra BANKE  koju ste oznacili je "+ STR(wSIFBANK,4),3)
        return(0)
   CASE tipka = -6
        *DO nadjiPP
        return(2)
   OTHERWISE
        @ 24,79 SAY ""
        return(2)
END CASE

**********************************************
