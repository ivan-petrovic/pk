*******************************************
* Glavni meni programa
*******************************************
LOCAL Izbor, nPredhIzbor

PUBLIC h[20]
PUBLIC menu_ptr, menu_id[20], menu_sel, menu_stat
PUBLIC cur_ptr, cx, cy

PUBLIC invert, normal, magenta, blink, nevid, greska, zelena, HelpBoja 
PUBLIC okvir, Datum, V
PUBLIC gcNazRad, gcPrez, gcIme, gcPrez_Ime, gcPIB, gcAdresa
PUBLIC gcMesto, gcBrRad, gcSifDel, gcZiro, gcJMBG, gnKontrol, gnBod

PUBLIC lLaser:= getIsLPrn(), lPoz0 := getRedUArt()

PRIVATE cColor1, cColor2, cColor5

* nPos1, nPos2 i nPos3 se koriste kao pozicije na kojima
* pocinje stampanje virmana u podprogramima VIRPOROO i VIRPORDO
* jer na A4 stranu staje po 3 virmana, a na razlicitim stampacima
* razlicito se pomere redovi, pa da moze da se podesi
* od stampaca do stampaca
PRIVATE nPos1, nPos2, nPos3

* Sledece promenljive koriste se u izgleda
* u bibliotekama marko.lib i util.lib
PUBLIC cur_pos[20], m_x, m_y, menu_bckg[20]
PUBLIC Radnja := Space(4), ImeRadnje:=Space(30)

* inicijalizacija nekih globalnih promenljivih
menu_ptr   = 1
menu_id[1] = ""
menu_sel   = 0
menu_stat  = .F.
cur_ptr = 0
cx = 5
cy = 5
AFill(h,"")

USE OBVEZMAT
	gcNazRad  = NAZRAD
	gcPrez    = PREZ
	gcIme     = IME
	gcPrez_Ime = Alltrim(PREZ) + "  " + Alltrim(IME)
	gcPIB     = PORSIFN
	gcAdresa  = ADRR
	gcMesto   = ADR
	gcBrRad   = Str(MBRRAD,10,0)
	gcSifDel  = Str(SIFDEL,10)
   gcZiro    = ZIRO
   gcJMBG    = JMBG
   gnKontrol = KONTROL
USE

* gnBod je ostatak iz doba inflacije kada se svakog dana
* menjao odnos dinara i marke, pa se unosio i ucitavao
* iz baze BOD.DBF; uklonio sam tu bazu iz programa, ali
* sam ostavio ovu globalnu promenljivu, da bih omogucio
* eventualno vracanje te baze
gnBod = Val("1.00")

IF (File("C:\Apli\Virpos.mem"))
	RESTORE FROM ("C:\Apli\Virpos.mem") ADDITIVE
ELSE
   nPos1 = 8
   nPos2 = 95
   nPos3 = 183
ENDIF

SET CENTURY ON
SET MESSAGE TO 24 CENTER
SET DELETED ON
SET DATE GERMAN
SET SCOREBOARD OFF
SET CONFIRM ON
SET WRAP ON
SET EXACT ON
SET ESCAPE ON
SET SAFETY OFF
SET BELL OFF

* setovanje globalnih boja
invert   = "+W/BG,+W/B,,,W+/B"
normal   = "RG+/B,+W/R,B/B,,W/B+"
magenta  = "+GR/RB,+W/R,,,+W/RB"
blink    = "B+****/W,W+/N,,,W/N"
nevid    = "RG+/B,X,,,"
greska   = "+W/R,+W/BG,,,W/B"
zelena   = "+W/G,+RG/GR,,,+G/W"
HelpBoja = "+W/G,+RG/GR,,,+G/W"
okvir    = CHR(213) + CHR(210) + CHR(184) + CHR(181) + CHR(190) + ;
           CHR(207) + CHR(212) + CHR(198)

IF (File("C:\Apli\ClrSett.mem"))
	RESTORE FROM ("C:\Apli\ClrSett.mem") ADDITIVE
ELSE
	cColor1 := "RG+/B"
	cColor2 := "+W/R"
	cColor5 := "W/B+"
ENDIF

normal = cColor1 + "," + cColor2 + ",B/B,," + cColor5
SetColor(normal)

Datum = DATE()
Inkey(0.2)  && bez ovoga pojavi se kursor

* provera licence
* ovde direktno ucitavam datum licence, jer na redosled dd/mm/yyyy
* utice SET DATE GERMAN
IF getLicDate() < Datum
   MainWnd("ISTEKLA LICENCA")
   MessageBox("Istekla Vam je licenca za koriscenje programa.")
   CLEAR SCREEN
   QUIT
ENDIF

nPredhIzbor = 1
DO WHILE .T.

	MainWnd("GLAVNI MENI")

	Izbor = nPredhIzbor
	@  6,27 PROMPT " KNJIGOVODSTVO            " MESSAGE "PRIHODI RASHODI POREZ ZIRORACUN"
	@  8,27 PROMPT " KALKULACIJE              " MESSAGE "MODUL ZA OBRADU KALKULACIJA"
	@ 10,27 PROMPT " ARTIKLI                  " MESSAGE "MODUL ZA OBRADU ARTIKALA"
	@ 12,27 PROMPT " POVRACAJ ROBE DOBAVLJACU " MESSAGE "MODUL ZA POVRACAJ ROBE DOBAVLJACU"
	@ 14,27 PROMPT " POSLOVNI PARTNERI        " MESSAGE "MODUL POSLOVNIH PARTNERA"
	@ 16,27 PROMPT " NIVELACIJE               " MESSAGE "NIVELACIJE I POPISI ARTIKALA"
	@ 17,27 PROMPT " IZVESTAJI                " MESSAGE "PRODATI ARTIKLI (DNEVNO) I OBRACUN POREZA ZA PLACANJE"
	@ 18,27 PROMPT " SIFARNIK OPISA           " MESSAGE "SIFRE I NAZIVI GRUPA ARTIKALA KOJE PRODAJETE"
	@ 19,27 PROMPT " TARIFE                   " MESSAGE "OBRADA PODATAKA O TARIFAMA"
   @ 20,27 PROMPT " MATICNI PODACI FIRME     " MESSAGE "OSNOVNI PODACI O FIRMI CIJE SE KNJIGOVODSTVO VODI"
   @ 21,27 PROMPT " POMOCNE FUNKCIJE         " MESSAGE "REINDEX BAZA, KONTROLE ZBIROVA, PODESAVANJA"
   @ 22,27 PROMPT "   IZLAZ (Esc)            " MESSAGE "IZLAZ IZ PROGRAMA"

	CLEAR TYPEAHEAD
	MENU TO Izbor
	* nPredhIzbor = Izbor

	DO CASE
		CASE Lastkey() = 27
			EXIT
		CASE IZBOR = 1
			DO GKMENI
		CASE IZBOR = 2
			DO KALMAMA
		CASE IZBOR = 3
			DO ART
		CASE IZBOR = 4
			DO POVROB
		CASE IZBOR = 5
			DO PP
		CASE IZBOR = 6
			DO POPIS
		CASE IZBOR = 7
			DO STRIZV
		CASE IZBOR = 8
			DO OPISMEN
		CASE IZBOR = 9
			DO TAR
		CASE IZBOR = 10
			DO MATGLMEN
		CASE IZBOR = 11
			DO OSTALE
		CASE Izbor = 12
			EXIT
	ENDCASE

ENDDO

CLEAR SCREEN

QUIT

*******************************************
