*:*****************************************************************************
*:
*:        Program: C:\TK\ARTUNOS.PRG
*:         System: Knjigovodstvo trgovacke radnje
*:  Last modified: 11.30.93 at 21:48:08
*:
*:      Called by: ART.PRG                           
*:
*:           Uses: OJART.DBF          
*:               : ARTDAT.DBF         
*:               : OJDAT.DBF          
*:               : TARDAT.DBF         
*:
*:        Indexes: AOJINSIF.IDX       
*:               : ARTINSIF.IDX       
*:               : ARTINNAZ.IDX       
*:               : OJINSIF.IDX        
*:               : TARINSIF.IDX       
*:      functions: aOjUpis
*:               : ListOj
*:      Documented 09:17:59                                FoxDoc version 3.00a
*:*****************************************************************************
PARAMETERS PROVERA
LOCAL m_upis

IF PCOUNT() = 0
   USE ARTPANE INDEX APINSIF,APINNAZ  NEW
   USE (ProgDir+"tardat") INDEX (ProgDir+"tarinsif"),(ProgDir+"TARIN") NEW
ENDIF

GO BOTTOM
B = RECNO()

SELECT ARTPANE

DO WHILE .T.
   SELECT ARTPANE

   GO BOTTOM
   IF Eof()			   && Prazna baza
      mSIF1:=1
      mARTSIF    := mSIF1
   ELSE 			      && Nije prazna
      mARTSIF    := ARTPANE->artsif + 1
   ENDIF

   mARTPOP    := 0
   mARTNAZ    := Space(30)
   mARTJM     := Space(3)
   mARTTAR    := Space(8)
   mARTTAKSA  := VAL("0000.000")
   mARTKOL    := VAL("0000000000.000")
   * mSIOP      := VAL("00000")
   mSIOP      := 1   
*  za ojart
   mARTPOD  = 0
   mARTPOK  = 0
   mARTPRA  = 0
   mARTUKO  = 0
   mARTIKO  = 0
   mARTVPOJ = Radnja
   mARTMPOJ = Space(4)
   mARTPS   = 0
   mARTDAT  = DATE()
   mARTDPS  = DATE()
   dN = " "

   @ 7,11 SAY ""
   Box("A12",3,67,.F.)
   m_upis = "D"
   DO WHILE m_upis = "D"
      SELECT ARTPANE

      GO BOTTOM
      IF Eof()			      && Prazna baza
	 		mSIF1:=1
	 		mARTSIF    := mSIF1
      ELSE			        && Nije prazna
         mARTSIF    := ARTPANE->artsif + 1
      ENDIF

      ArtUEkran()
      set cursor on
      m_izbor = 1

      CLEAR TYPEAHEAD

      m_izbor = al_box(IIF(Lastkey()=27,"Unos PREKINUT..!!!","Podaci su izmenjeni..!"),;
                       IIF(Lastkey()=27,3,3),;
                       IIF(Lastkey()=27,{"Nastavi"," ","Prekini"},{"Ispravi","Odustani","Upis u bazu"}),;
                       3, m_x, m_y, m_x+6, m_y+42)

      DO CASE
         CASE m_izbor = 2 .OR. Lastkey() = 27
              CLEAR GETS
         CASE m_izbor = 3
              SELECT ARTPANE
              APPEND BLANK
              REPLACE ARTSIF   WITH mARTSIF,;
                      ARTNAZ   WITH mARTNAZ,;
                      ARTJM    WITH mARTJM ,;
                      SIOP     WITH mSIOP  ,;
                      DATNAB   WITH date() ,;
                      ARTTAR   WITH mARTTAR
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

   BoxC()       && artikl
   IF m_UPIS = "N"
      EXIT
   ENDIF
ENDDO   && od glavne DO WHILE .t.

IF PCOUNT() = 0
   CLOSE artpane
   CLOSE tardat
   RELEASE ALL
   RETURN
ENDIF

IF m_izbor = 2 .OR. Lastkey() = 27
   CLEAR GETS
   RETURN(.F.)
ELSE
   wDMPART = mARTSIF
   RETURN(.T.)
ENDIF


***************************************************
PROCEDURE ProvArtSif(mARTSIF)
   IF mARTSIF = 0
      MSG("Artikal ne sme imati sifru '0'",5)
      RETURN(.F.)
   ENDIF
   SEEK martsif
   IF Found()
      Msg("Vec je otvoren artikal sa tom sifrom!!",5)
      RETURN(.F.)
   ELSE
      RETURN(.T.)
   ENDIF

***************************************************
FUNCTION KalProvArt(SifArt)
LOCAL SelSav:=SELECT(),buttons:={"  Novi  "," Lista  "}
SELECT ARTPANE
IF (DBSEEK(SifArt))
   WDMPART = ARTSIF
   WARTCEN = ARTCEN
   SELECT(SelSav)
   RETURN(.T.)
ELSE
   IF .NOT. lPoz0
      * Vera i svi ostali su traze redosled dugmica "Novi" "Lista"
      izb = al_box("Niste upisali sifru ARTIKLA",2,buttons,1,6,25,12,59)
      DO CASE
         CASE izb = 1
              IF (ArtUnos1(1))
                 wDMPART = ARTSIF
                 WARTCEN = ARTCEN
                 SELECT(SelSav)
                 RETURN(.T.)
              END IF
              SELECT(SelSav)
              RETURN(.F.)
         CASE izb = 2
              IF (KalListArt())
                 wDMPART = ARTPANE->ARTSIF
                 WARTCEN = ARTPANE->ARTCEN
                 SELECT(SelSav)
                 RETURN(.T.)
              END IF
              SELECT(SelSav)
              RETURN(.F.)
      END CASE
   ELSE
      * Pozitiva 0 trazi redosled dugmica "Lista" "Novi"
      buttons = {" Lista  ", "  Novi  "}
      izb = al_box("Niste upisali sifru ARTIKLA",2,buttons,1,6,25,12,59)
      DO CASE
         CASE izb = 1
              IF (KalListArt())
                 wDMPART = ARTPANE->ARTSIF
                 WARTCEN = ARTPANE->ARTCEN
                 SELECT(SelSav)
                 RETURN(.T.)
              END IF
              SELECT(SelSav)
              RETURN(.F.)
         CASE izb = 2
              IF (ArtUnos1(1))
                 wDMPART = ARTSIF
                 WARTCEN = ARTCEN
                 SELECT(SelSav)
                 RETURN(.T.)
              END IF
              SELECT(SelSav)
              RETURN(.F.)
      END CASE
   ENDIF
END IF


***************************************************
FUNCTION KalListArt
LOCAL SelSav:=SELECT()
PARAMETERS KoZove
PRIVATE argument

IF PCOUNT()=0        && zove KalkCena
   SELECT ARTPANE

   IF .NOT. lPoz0
      * Vera i svi ostali su trazili ovaj redosled polja kod unosa artikla
      datas  :={"ARTSIF","ARTNAZ","artjm","artkol","artcen","siop","datnab","arttar"}
      zaglav :={"SIFRA","NAZIV ARTIKLA","J.M","KOLICINA","CENA","OP.GR.","DAT.NABAVKE","TARIFA"}
      format :={"999999","XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX","XXX","999999999.999","99999999999999.99","99999","XXXXXXXXXX","XXXXXXXX"}
      argument = 0
   ELSE
      * U poz0 jasna je trazila ovaj redosled polja kod unosa artikla
      datas  :={"ARTSIF","ARTNAZ","artcen","artkol","artjm","siop","datnab","arttar"}
      zaglav :={"SIFRA","NAZIV ARTIKLA","CENA","KOLICINA","J.M","OP.GR.","DAT.NABAVKE","TARIFA"}
      format :={"999999","XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX","99999999999999.99","999999999.999","XXX",,"99999","XXXXXXXXXX","XXXXXXXX"}
      argument = 0
   ENDIF   
ELSE                 && zove Otpremn
   *SELECT OJART
   *datas  :={"AOJSIF","ARTDAT->ARTNAZ","CNDAT->CNNMC","OJART->artps"}
   *zaglav :={"Sifra","Naziv ARTIKLA","Cena","Stanje"}
   *format :={"999999","XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX","@E 999,999.99","99999.9"}
   *argument = 1
ENDIF
   pomoc := "F1-Help F2ESCF2-Izme. F7-Nadji <ENTER>-Izaberi   <ESC>-izlaz bez izbora"
   idbox := "A12 ARTIKLI"
GO TOP
Editdb(pomoc,idbox,14,69,.f., datas, "LKalArt",format,zaglav)

SetColor(Normal)
SELECT(SelSav)
IF wDMPART <> 0
   return(.T.)
ELSE
   return(.F.)
END IF

***************************************************
PROCEDURE LKalArt
PARAMETERS pf1, pf2

UZMI="+RG/B,+W/R"
tipka = Lastkey()
IF pf1 = 0
   return(1)
elseif pf1 = 3
   Msg("Baza je prazna",3)
   wDMPART = 0
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
        wDMPART = 0
        RETURN(0)
   CASE tipka = 13
        temp = FIELDNAME(1)
        wDMPART = &temp
        beep(3)
        return(0)
   CASE tipka = -6
        IF argument = 0
            DO NadjiArt
        ELSE
          * DO NadjiOjA
        ENDIF
        return(2)
   CASE tipka = -1
        temp = FIELDNAME(pf2)
        @Row(),Col() GET &temp COLOR UZMI
        SET CURSOR ON
        READ
        SET CURSOR OFF
        return(2)
   OTHERWISE
        @ 24,79 SAY ""
        return(2)
END CASE

***************************************************
FUNCTION ListOj
LOCAL SelSav:=SELECT()

SELECT OjDat

pomoc := "F1-Help       F7-Nadji         <ENTER>-Izaberi   <ESC>-izlaz bez izbora"
idbox := "L11 RADNJE"

dataset:={"ojsif","ojnaz"}
zaglav :={"Sifra","Naziv RADNJE"}

GO TOP
Editdb(pomoc,idbox,14,40,.f., dataset, "LOrgJed",,zaglav)

SetColor(Normal)
SELECT(SelSav)
IF mRADNJA <> "   0"
   return(.T.)
ELSE
   mRADNJA = "    "
   return(.F.)
END IF

***************************************************
PROCEDURE LOrgJed
PARAMETERS pf1, pf2

IF pf1 = 0
   return(1)
elseif pf1 = 3
   Msg("Baza je prazna",3)
   mRADNJA = "   0"
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
        mRADNJA = "   0"
        RETURN(0)
   CASE tipka = 13
        temp = FIELDNAME(1)
        mRADNJA = &temp
        beep(3)
        Msg("Sifra RADNJE koju ste oznacili je "+ mRADNJA,3)
        return(0)
   CASE tipka = -6
*        DO nadjiOJ
        return(2)
   OTHERWISE
        @ 24,79 SAY ""
        return(2)
END CASE

***************************************************
FUNCTION ProvArtTar(SifTar)
LOCAL SelSav:=SELECT(),buttons:={"  Nova  "," Lista  "},;
      mxSav:=m_x, mySav:=m_y
SELECT TARDAT
IF (DBSEEK(SifTar))
   mARTTAR = TARSIF
   SELECT(SelSav)
   RETURN(.T.)
else
   izb = al_box("Niste upisali poresku TARIFU",2,buttons,2,6,25,12,59)
   DO CASE
      CASE izb = 1
           IF (TarUnos1(1))
              mARTTAR = TARSIF
              SELECT(SelSav)
              m_x=mxSav
              m_y=mySav
              RETURN(.T.)
           END IF
           SELECT(SelSav)
           m_x=mxSav
           m_y=mySav
           RETURN(.F.)
      CASE izb = 2
           IF (KalListTar())
              mARTTAR = TARSIF
              SELECT(SelSav)
              m_x=mxSav
              m_y=mySav
              RETURN(.T.)
           END IF
           SELECT(SelSav)
           m_x=mxSav
           m_y=mySav
           RETURN(.F.)
      END CASE
END IF

***************************************************
FUNCTION KalListTar
LOCAL SelSav:=SELECT()

SELECT TARDat

pomoc := "F1-Help       F7-Nadji         <ENTER>-Izaberi   <ESC>-izlaz bez izbora"
idbox := "T11 TARIFE"

dataset:={"tarsif","tarzbir"}
zaglav :={"Sifra","Zbirna STOPA"}

GO TOP
Editdb(pomoc,idbox,14,30,.f., dataset, "LtAR",,zaglav)

SetColor(Normal)
SELECT(SelSav)
IF mARTTAR <> "0"
   return(.T.)
ELSE
   return(.F.)
END IF

***************************************************
PROCEDURE LTAr
parameters pf1, pf2
IF pf1 = 0
   return(1)
elseif pf1 = 3
   Msg("Baza je prazna",3)
   mARTTAR = "0"
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
        mARTTAR = "0"
        RETURN(0)
   CASE tipka = 13
        temp = FIELDNAME(1)
        mARTTAR = &temp
        beep(3)
        Msg("Sifra TARIFE koju ste oznacili je "+ mARTTAR,3)
        return(0)
   CASE tipka = -6
*        DO nadjiOJ
        return(2)
   OTHERWISE
        @ 24,79 SAY ""
        return(2)
END CASE

***************************************************
PROCEDURE ArtUEkran
LOCAL GetList:={}
     @ m_x  , m_y+03 SAY "Unos padataka za: " +ImeRadnje COLOR "B/W+"
     @ m_x+2, m_y+01 SAY "SIFRA         Naziv ARTIKLA                  jm  Tarifa    Siop "  && Taksa   "
     @ m_x+3, m_y+01 GET  mARTSIF    PICTURE "@!"       VALID ProvArtSif(mARTSIF)
     @ m_x+3, m_y+15 GET  mARTNAZ    PICTURE "@K@!"     VALID !Empty(mARTNAZ)
     @ m_x+3, m_y+46 GET  mARTJM     PICTURE "@K@!"     VALID !Empty(mARTJM)
     @ m_x+3, m_y+50 GET  mARTTAR    PICTURE "@K"       VALID ProvArtTar(mARTTAR)
     @ m_x+3, m_y+59 GET  mSIOP      PICTURE "99999" VALID (mSIOP >= 0)
    *@ m_x+3, m_y+59 GET  mARTTAkSA  PICTURE "99999.999" VALID (mARTTAKSA >= 0)
     SET CURSOR ON
     READ
     SET CURSOR OFF
RETURN

***************************************************
FUNCTION aOjUpis
LOCAL GetList:={}, h_lin, r_upis, r_izbor

GO BOTTOM
*kreiranje memoVarijabli za sva polja

mNAZ_OJ = Space(30)
mADR_OJ = Space(30)
mTEL_OJ = Space(20)
mPOS_OJ = 0
mSEF_OJ = Space(30)
mMES_OJ = Space(20)
mSIF_OJ = mRADNJA
mDEL_OJ = Space(11)
mZIR_OJ = Space(30)

@6,4 SAY ""
h[1]="Nije otvoren slog u bazi RADNJI; prvo ga moramo upisati "
Box("O11. ",11,42,.T.)
r_upis = "D"
DO WHILE r_upis = "D"

   @ m_x+0,m_y+3  SAY "Upis maticnih podataka " COLOR "B/W"
   @ m_x+1,m_y+4  SAY "Naziv:"   GET mNAZ_oj picture "@!"
   @ m_x+3,m_y+3  SAY "Adresa:"  GET mADR_oj picture "@!"
   @ m_x+5,m_y+2  SAY "Telefon:" GET mTEL_oj picture "@!"
   @ m_x+7,m_y+2  SAY "PostBr :" GET mPos_oj picture "99999"
   @ m_x+7,m_y+16 SAY "Mesto:"   GET mMES_oj picture "@!"
   @ m_x+8,m_y+02 SAY "RacunoPol:"  GET mSEF_OJ  picture "@!"
   @ m_x+9,m_y+32 SAY "Sifra:"  GET mSIF_OJ  picture "@!" VALID (VAL(mSIF_OJ) > 0)
   @ m_x+10,m_y+2 SAY "ZiroRn:"  GET mZIR_OJ  picture "@!"
   @ m_x+11,m_y+02 SAY "Delatnost: "  GET mDEL_OJ  WHEN Look({"MALOPRODAJA","VELEPRODAJA","STRTRGOVINA"})

   set cursor on
   READ
   set cursor off
   r_izbor:= al_box("Podaci su izmenjeni..! Otvaranje NOVE RADNjE ?",3,;
                 {"Ispravi","Odustani","Upis u bazu"},;
                  1, m_x, m_y, m_x+6, m_y+42)

   DO CASE
   CASE r_izbor = 2 .OR. Lastkey() = 27
      CLEAR GETS
   CASE r_izbor = 3
      mRADNJA = mSIF_OJ
      NapraviDir:=FT_MKDIR(mSIF_OJ)
      DO CASE
         CASE NapraviDir = 0
              APPEND BLANK
              REPLACE ojNAZ WITH mNAZ_OJ,;
                      ojADR WITH mADR_OJ,;
                      ojTEL WITH mTEL_OJ,;
                      ojSIF WITH mSIF_OJ,;
                      ojPOS WITH mPOS_OJ,;
                      ojMES WITH mMES_OJ,;
                      ojDEL WITH mDEL_OJ,;
                      ojSEF WITH mSEF_OJ,;
                      ojZIR WITH mZIR_OJ
              Msg("Otvoren slog za novu radnju",1)
         CASE NapraviDir = 3
              Beep(3)
              Msg("Greska - nije nadjen PATH ",3)
         CASE NapraviDir = 5
              Beep(3)
              Msg("Slog ve} postoji",2)
              LOOP
         CASE NapraviDir = 99
              Beep(3)
              Msg("Prosledjeni su mi pogresni parametri",1)
      END CASE

   CASE r_izbor = 1
      LOOP
   ENDCASE
   r_upis = "N"
ENDDO r_upis
boxC()
set cursor on

IF r_izbor = 2 .OR. Lastkey() = 27
   RETURN(.F.)
ELSE
   RETURN(.T.)
END IF

***************************************************
