*************************************************
* Glavni meni za podesavanje raznih parametara
*************************************************

********************************************************************************
* Baza C:\PK\Settings.dbf sadrzi sledeca polja:
* 
* 4001 - Sifra za podesavanja stampe
*        PNUMVAL: 0  - matricni stampac
*                 >0 - laserski stampac
*        PSTRVAL: ne koristi se
* 6001 - Datum isteka licence za program
*        PNUMVAL: ne koristi se
*        PSTRVAL: sifriran datum licence (ENCLIC.PRG)
* 8001 - Sifra za podesavanja root direktorijuma za komitente
*        PNUMVAL: ne koristi se
*        PSTRVAL: naziv root direktorijuma za komitente
* 9001 - Sifra za podesavanja redosleda kolona pri unosu artikala
*        Ako postoji ova sifra redosled je kao sto je Pozitivna nula trazila,
*        u protivnom, redosled je kao sto svi ostali koriste.
*        Vidi ARTUNOS1.PRG 
*        PNUMVAL: ne koristi se
*        PSTRVAL: ne koristi se
           
********************************************************************************
LOCAL Izbor, nPredhIzbor

nPredhIzbor = 1
DO WHILE .T.

	MainWnd("P O D E S A V A NJ A")

	Izbor = nPredhIzbor
	@ 10,27 PROMPT " PODESAVANJE BOJA  " MESSAGE "PODESAVANJE BOJA POZADINE, TEKSTA, POLJA ZA UNOS"
	@ 12,27 PROMPT " STAMPANJE VIRMANA " MESSAGE "STAMPANJE VIRMANA ZA OBACUNATI POREZ"

	CLEAR TYPEAHEAD
	MENU TO Izbor
	* nPredhIzbor = Izbor

	DO CASE
		CASE Lastkey() = 27
			EXIT
		CASE Izbor = 1
			SetClr()
		CASE Izbor = 2
			SetVirPrn()
	ENDCASE

ENDDO

RETURN

* Cita iz fajla sa podesavanjima da li je postavljen
* laserski ili matricni printer
* Sifra za podesavanja stampe: 4001
FUNCTION getIsLPrn()
   LOCAL SelSav
   LOCAL lLPrn := .F.      && po defaultu matricni printer

   IF File("C:\PK\SETTINGS.DBF")
      SelSav = SELECT()
      SELECT 0
      USE C:\PK\SETTINGS.DBF

      LOCATE FOR param = 4001
      IF Found()
         IF PNUMVAL > 0
            lLPrn = .T.
         ENDIF
      ENDIF

      CLOSE SETTINGS
      SELECT(SelSav)
   ENDIF
RETURN lLPrn

* Cita iz fajla sa podesavanjima root direktorijum za komintente
* Sifra za root direktorijum: 8001
FUNCTION getRoot()
   LOCAL SelSav
   LOCAL cRoot := ""      && po defaultu hard drive root

   IF File("C:\PK\SETTINGS.DBF")
      SelSav = SELECT()
      SELECT 0
      USE C:\PK\SETTINGS.DBF

      LOCATE FOR param = 8001
      IF Found()
         cRoot = AllTrim(PSTRVAL)
      ENDIF

      CLOSE SETTINGS
      SELECT(SelSav)
   ENDIF
RETURN cRoot

* Kod unosa artikla iz kalkulacije (ARTUNOS1.PRG)
* neki klijenti su trazili razlicite redoslede u tabeli pri unosu artikla.
* Vera je trazila jedan redosled (koji koriste i svi ostali),
* a Jasna iz Pozitivne nule je trazila drugi. 
* Sifra za podesavanja redosleda je: 9001
* Ako je setovan ovaj red u c:\pk\settings.dbf onda je Jasnin rezim.
* Ako nije onda je rezim svih ostalih.
FUNCTION getRedUArt()
   LOCAL SelSav
   LOCAL lRedArt := .F.      && po defaultu stari rezim

   IF File("C:\PK\SETTINGS.DBF")
      SelSav = SELECT()
      SELECT 0
      USE C:\PK\SETTINGS.DBF

      LOCATE FOR param = 9001
      IF Found()
         lRedArt := .T.
      ENDIF

      CLOSE SETTINGS
      SELECT(SelSav)
   ENDIF
RETURN lRedArt

* Cita iz fajla sa podesavanjima datum isteka licence za korisnika
* Sifra za datum licence: 6001
FUNCTION getLicDate()
   LOCAL SelSav
   LOCAL cLicDatum := ""

   IF File("C:\PK\SETTINGS.DBF")
      SelSav = SELECT()
      SELECT 0
      USE C:\PK\SETTINGS.DBF

      LOCATE FOR param = 6001
      IF Found()
         cLicDatum = Upper(AllTrim(PSTRVAL))
      ENDIF

      CLOSE SETTINGS
      SELECT(SelSav)
   ENDIF
RETURN DecodeLicD(cLicDatum)

* Dekodira datum licence na osnovu kodiranog stringa iz baze
* Bitno je da li je pre poziva ove funkcije
* postavljeno SET DATE GERMAN, jer od toga zavisi da li je
* format datuma dd/mm/yyyy (ako je postavljeno)
* ili mm/dd/yyyy (ako nije postavljeno)
FUNCTION DecodeLicD(cLicDatum)
   LOCAL cLicMesec, cLicDan, cLicGod

   * proveriti duzinu cLicD i ako nije 8, vratiti default 01/01/2015
   IF Len(AllTrim(cLicDatum)) = 8
      cLicDan   = DecDay(SubStr(cLicDatum,1,2))
      cLicMesec = DecMonth(SubStr(cLicDatum,3,2))
      cLicGod   = DecYear(SubStr(cLicDatum,5,4))  

      * greska u kodu datuma
      IF cLicDan = "--" .OR. cLicMesec = "--" .OR. cLicGod = "----"
         RETURN CtoD("01/01/2015")
      ENDIF 

      RETURN CtoD(cLicDan + "/" + cLicMesec + "/" + cLicGod)
   ENDIF

RETURN CtoD("01/01/2015")      

* Dekodira mesec iz datuma licence na osnovu kodiranog stringa iz baze
* Kodove za 12 meseci sam proizvoljno smislio
FUNCTION DecMonth(cMesec)
   LOCAL cRetMes := "--"    && default
    
	DO CASE
		CASE cMesec = "RN"
			cRetMes = "01"
		CASE cMesec = "TX"
			cRetMes = "02"
		CASE cMesec = "WX"
			cRetMes = "03"
		CASE cMesec = "WC"
			cRetMes = "04"
		CASE cMesec = "UM"
			cRetMes = "05"
		CASE cMesec = "YC"
			cRetMes = "06"
		CASE cMesec = "OL"
			cRetMes = "07"
		CASE cMesec = "PT"
			cRetMes = "08"
		CASE cMesec = "TK"
			cRetMes = "09"
		CASE cMesec = "FS"
			cRetMes = "10"
		CASE cMesec = "AH"
			cRetMes = "11"
		CASE cMesec = "JE"
			cRetMes = "12"
	ENDCASE
RETURN cRetMes

* Dekodira dan iz datuma licence na osnovu kodiranog stringa iz baze
FUNCTION DecDay(cDan)
   LOCAL cDan1, cDan2, cRetDan1 := "-", cRetDan2 := "-"
   cDan1 = SubStr(cDan, 1, 1)
   cDan2 = SubStr(cDan, 2, 1) 
    
	DO CASE
		CASE cDan1= "K" .OR. cDan1= "G" 
			cRetDan1 = "0"
		CASE cDan1= "A" .OR. cDan1= "V"
			cRetDan1 = "1"
		CASE cDan1= "N" .OR. cDan1= "E"
			cRetDan1 = "2"
		CASE cDan1= "C" .OR. cDan1= "M"
			cRetDan1 = "3"
	ENDCASE

	DO CASE
		CASE cDan2= "Q" .OR. cDan2= "M" 
			cRetDan2 = "0"
		CASE cDan2= "E" .OR. cDan2= "B"
			cRetDan2 = "1"
		CASE cDan2= "T" .OR. cDan2= "C"
			cRetDan2 = "2"
		CASE cDan2= "U" .OR. cDan2= "Z"
			cRetDan2 = "3"
		CASE cDan2= "O" .OR. cDan2= "F" 
			cRetDan2 = "4"
		CASE cDan2= "P" .OR. cDan2= "H"
			cRetDan2 = "5"
		CASE cDan2= "I" .OR. cDan2= "S"
			cRetDan2 = "6"
		CASE cDan2= "Y" .OR. cDan2= "X"
			cRetDan2 = "7"
		CASE cDan2= "R" .OR. cDan2= "V" 
			cRetDan2 = "8"
		CASE cDan2= "W" .OR. cDan2= "N"
			cRetDan2 = "9"
	ENDCASE
   
   IF cRetDan1 = "-" .OR. cRetDan2 = "-"
      RETURN "--"
   ENDIF  
RETURN (cRetDan1 + cRetDan2)

* Dekodira godinu iz datuma licence na osnovu kodiranog stringa iz baze
* Kodove za godine sam proizvoljno smislio
FUNCTION DecYear(cGod)
   LOCAL cRetGod := "----"    && default

	DO CASE
		CASE cGod = "VIZQ"
			cRetGod = "2015"
		CASE cGod = "ICYG"
			cRetGod = "2016"
		CASE cGod = "FBCP"
			cRetGod = "2017"
		CASE cGod = "SPVC"
			cRetGod = "2018"
		CASE cGod = "GMCT"
			cRetGod = "2019"
		CASE cGod = "YPGD"
			cRetGod = "2020"
		CASE cGod = "EZEH"
			cRetGod = "2021"
		CASE cGod = "QRUW"
			cRetGod = "2022"
		CASE cGod = "EWFG"
			cRetGod = "2023"
		CASE cGod = "QWOH"
			cRetGod = "2024"
		CASE cGod = "GTDL"
			cRetGod = "2025"
		CASE cGod = "MNXQ"
			cRetGod = "2026"
		CASE cGod = "OFVZ"
			cRetGod = "2027"
		CASE cGod = "GKLI"
			cRetGod = "2028"
		CASE cGod = "FKRG"
			cRetGod = "2029"
		CASE cGod = "DGEI"
			cRetGod = "2030"
	ENDCASE
RETURN cRetGod


PROCEDURE SetClr()
   LOCAL cColorFg, cColorBg
   LOCAL nMenuItem := 1, cScreen := SaveScreen( 7,3,19,30 )

   DO WHILE .T.
   	@ 7,3 CLEAR TO 19,30
    	@ 7,3 TO 19,30
    	@ 9 ,3 SAY Chr(195) + Replicate(Chr(196),29 - 3 ) + Chr(180)
    	@ 17,3 SAY Chr(195) + Replicate(Chr(196),29 - 3 ) + Chr(180)
   	@ 8 ,4 SAY "Promena boje"

      @ 10, 4 PROMPT " Tekst                    "
      @ 12, 4 PROMPT " Polje za unos            "
      @ 14, 4 PROMPT " Neoznaceno polje za unos "
      @ 16, 4 PROMPT " Standardne boje (default)"

      MENU TO nMenuItem

      DO CASE
   		CASE nMenuItem == 0
   			EXIT
         CASE nMenuItem == 1
   			cColorFg = SubStr(cColor1, 1, At(cColor1,"/") - 1)
   			cColorBg = SubStr(cColor1, At(cColor1,"/") + 1)
            ChangeClr(@cColorFg, "Tekst - osnovna boja")
   			ChangeClr(@cColorBg, "Tekst - pozadina")
   			cColor1 = cColorFg + "/" + cColorBg
         CASE nMenuItem == 2
   			cColorFg = SubStr(cColor2, 1, At(cColor2,"/") - 1)
   			cColorBg = SubStr(cColor2, At(cColor2,"/") + 1)
            ChangeClr(@cColorFg, "Unos - osnovna boja")
   			ChangeClr(@cColorBg, "Unos - pozadina")
   			cColor2 = cColorFg + "/" + cColorBg
         CASE nMenuItem == 3
   			cColorFg = SubStr(cColor5, 1, At(cColor5,"/") - 1)
   			cColorBg = SubStr(cColor5, At(cColor5,"/") + 1)
            ChangeClr(@cColorFg, "Neaktivni unos - osnovna boja")
   			ChangeClr(@cColorBg, "Neaktivni unos - pozadina")
   			cColor5 = cColorFg + "/" + cColorBg
         CASE nMenuItem == 4
   			cColor1 := "RG+/B"
   			cColor2 := "+W/R"
   			cColor5 := "W/B+"
      ENDCASE

   	normal = cColor1 + "," + cColor2 + ",B/B,," + cColor5
   	SetColor(normal)

   ENDDO

   SAVE ALL LIKE cColor? TO C:\Apli\ClrSett

   RestScreen( 7,3,19,30, cScreen )
RETURN

PROCEDURE ChangeClr(cClr, cNaslov)
	LOCAL nIzbor
	LOCAL cScreen := SaveScreen( 3,31,22,62 ) 
 
 	@ 3,31 CLEAR TO 22,62
 	@ 3,31 TO 22,62
 	@ 4,32 SAY cNaslov
 	@ 5,31 SAY Chr(195) + Replicate(Chr(196),61 - 31 ) + Chr(180)

	@  6, 32 PROMPT " Crna           "   && Black                   
	@  7, 32 PROMPT " Plava          "   && Blue             
	@  8, 32 PROMPT " Zelena         "   && Green                   
	@  9, 32 PROMPT " Cijan          "   && Cyan                   
	@ 10, 32 PROMPT " Crvena         "   && Red                   
	@ 11, 32 PROMPT " Magenta        "   && Magenta                   
	@ 12, 32 PROMPT " Braon          "   && Brown                   
	@ 13, 32 PROMPT " Bela           "   && White                   
	@ 14, 32 PROMPT " Siva           "   && Gray                   
	@ 15, 32 PROMPT " Jarko plava    "   && Pale blue    
	@ 16, 32 PROMPT " Jarko zelena   "   && Pale green              
	@ 17, 32 PROMPT " Jarko tirkizna "   && Pale turquoise              
	@ 18, 32 PROMPT " Jarko crvena   "   && Pale red              
	@ 19, 32 PROMPT " Jarka magenta  "   && Pale magenta              
	@ 20, 32 PROMPT " Zuta           "   && Yellow              
	@ 21, 32 PROMPT " Jarko bela     "   && Pale white              
	                 
   MENU TO nIzbor 

   DO CASE 
      CASE nIzbor == 1   
			cClr = "N"				&& Black
		CASE nIzbor == 2                   
			cClr = "B"        	&& Blue
		CASE nIzbor == 3             
			cClr = "G"        	&& Green
		CASE nIzbor == 4                   
			cClr = "BG"       	&& Cyan
		CASE nIzbor == 5                   
			cClr = "R"        	&& Red
		CASE nIzbor == 6                   
			cClr = "RB"       	&& Magenta
		CASE nIzbor == 7                   
			cClr = "GR"       	&& Brown
		CASE nIzbor == 8                   
			cClr = "W"        	&& White                   
		CASE nIzbor == 9
			cClr = "N+"       	&& Gray
		CASE nIzbor == 10                   
			cClr = "B+"       	&& Pale blue
		CASE nIzbor == 11    
			cClr = "G+"       	&& Pale green
		CASE nIzbor == 12              
			cClr = "BG+"      	&& Pale turquoise
		CASE nIzbor == 13              
			cClr = "R+"       	&& Pale red
		CASE nIzbor == 14              
			cClr = "RB+"      	&& Pale magenta
		CASE nIzbor == 15              
			cClr = "GR+"      	&& Yellow
		CASE nIzbor == 16              
			cClr = "W+"       	&& Pale white              
   ENDCASE	

	RestScreen( 3,31,22,62, cScreen ) 

RETURN

PROCEDURE SetVirPrn()
   LOCAL getnPos1, getnPos2, getnPos3
   LOCAL cScreen := SaveScreen( 10,25,14,55 )

   getnPos1 = nPos1
   getnPos2 = nPos2
   getnPos3 = nPos3

   @ 10,25 TO 14,55
   @ 11,27 SAY "Pozicija prvog virmana: " GET getnPos1 ;
      PICTURE "999" VALID getnPos1 >= 0
   @ 12,27 SAY "Pozicija prvog virmana: " GET getnPos2 ;
      PICTURE "999" VALID getnPos2 >= 0
   @ 13,27 SAY "Pozicija prvog virmana: " GET getnPos3 ;
      PICTURE "999" VALID getnPos3 >= 0
   READ

   RestScreen( 10,25,14,55, cScreen )

   IF Lastkey() = 27 ; RETURN ; ENDIF

   nPos1 = getnPos1
   nPos2 = getnPos2
   nPos3 = getnPos3
   
   SAVE ALL LIKE nPos? TO C:\Apli\Virpos

RETURN
