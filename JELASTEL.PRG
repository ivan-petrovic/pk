LOCAL lSpaja3 := .F.
PRIVATE wdir1, wdir2, wdir3, wdir4, mSif, cRoot

wdir1 = Space(8)
wdir2 = Space(8)
wdir3 = Space(8)
wdir4 = Space(8)
cRoot = getRoot()

CLEAR SCREEN
@ 0, 0 TO 24,79 DOUBLE
@ 1,1 SAY Centriraj("SPAJA KNJIGE DVA ILI TRI KORISNIKA NA KORISNIKA NA KOJEM STE", 78)

@ 10,10 SAY "SPAJAJU SE KORISNICI:"
@ 11,10 SAY "1. " GET wdir1
@ 12,10 SAY "2. " GET wdir2
@ 13,10 SAY "3. " GET wdir3
@ 15,10 SAY "NA ZBIRNOG KORISNIKA: " GET wdir4 VALID ! Empty(wdir4)
READ

IF Lastkey() = 27
   RETURN
ENDIF

IF ! Empty(AllTrim(wdir3))
   lSpaja3 := .T.
ENDIF

IF(!Empty(cRoot))
   wdir1 = cRoot + "\" + wdir1
   wdir2 = cRoot + "\" + wdir2
   wdir3 = cRoot + "\" + wdir3
   wdir4 = cRoot + "\" + wdir4
ENDIF

IF ! wdir1 = " "
   ! cd \&wdir1
   ! copy rashodn.dbf rashodn1.dbf
   ! copy porezn.dbf porezn1.dbf
   ! copy kpr.dbf kpr1.dbf
   ! copy kir.dbf kir1.dbf
   ! copy rashodn1.dbf \&wdir4
   ! copy porezn1.dbf \&wdir4
   ! copy artpane.dbf \&wdir4
   ! copy kpr1.dbf \&wdir4
   ! copy kir1.dbf \&wdir4
   ! del rashodn1.dbf
   ! del porezn1.dbf
   ! del kpr1.dbf
   ! del kir1.dbf
ENDIF

IF ! wdir2 = " "
   ! cd \&wdir2
   ! copy rashodn.dbf rashodn2.dbf
   ! copy porezn.dbf porezn2.dbf
   ! copy artpane.dbf artpane1.dbf
   ! copy kpr.dbf kpr2.dbf
   ! copy kir.dbf kir2.dbf
   ! copy rashodn2.dbf \&wdir4
   ! copy porezn2.dbf \&wdir4
   ! copy artpane1.dbf \&wdir4
   ! copy kpr2.dbf \&wdir4
   ! copy kir2.dbf \&wdir4
   ! del rashodn2.dbf
   ! del porezn2.dbf
   ! del kpr2.dbf
   ! del kir2.dbf
ENDIF

IF lSpaja3
   ! cd \&wdir3
   ! copy rashodn.dbf rashodn3.dbf
   ! copy porezn.dbf porezn3.dbf
   ! copy kpr.dbf kpr3.dbf
   ! copy kir.dbf kir3.dbf
   ! copy rashodn3.dbf \&wdir4
   ! copy porezn3.dbf \&wdir4
   ! copy kpr3.dbf \&wdir4
   ! copy kir3.dbf \&wdir4
   ! del rashodn3.dbf
   ! del porezn3.dbf
   ! del kpr3.dbf
   ! del kir3.dbf
ENDIF

! cd \&wdir4
SELECT 0
USE RASHODN
ZAP
APPEND FROM RASHODN1
APPEND FROM RASHODN2

IF lSpaja3
   APPEND FROM RASHODN3
ENDIF

INDEX ON RBR TO RASHINKN
INDEX ON Dtos(RDK) TO RASHINDN
CLOSE RASHODN

SELECT 0
USE POREZN
ZAP
APPEND FROM POREZN1
APPEND FROM POREZN2

IF lSpaja3
   APPEND FROM POREZN3
ENDIF

INDEX ON Val(BROJ) TO POREZNB
INDEX ON DATK TO POREZND
INDEX ON BROJ TO POREZNBB
CLOSE POREZN

! del rashodn1.dbf
! del rashodn2.dbf

IF lSpaja3
   ! del rashodn3.dbf
ENDIF

! del porezn1.dbf
! del porezn2.dbf

IF lSpaja3
   ! del porezn3.dbf
ENDIF

SELECT 0
USE KIR
ZAP
APPEND FROM KIR1
APPEND FROM KIR2

IF lSpaja3
   APPEND FROM KIR3
ENDIF

INDEX ON Dtos(DATKKIR) TO KIRDK
INDEX ON BRRACKIR TO KIRBRAC
CLOSE KIR

! del kir1.dbf
! del kir2.dbf

IF lSpaja3
   ! del kir3.dbf
ENDIF

SELECT 0
USE KPR
ZAP
APPEND FROM KPR1
APPEND FROM KPR2

IF lSpaja3
   append from kpr3
ENDIF

INDEX ON BRACKPR TO KPRBRAC
INDEX ON BRKAL+BRACKPR TO KPRBRACK
INDEX ON DKKPR TO KPRDK
CLOSE KPR

! del kpr1.dbf
! del kpr2.dbf

IF lSpaja3
   ! del kpr3.dbf
ENDIF

* spojiti artikle od zadate sifre
mSif = val("0000000000000")
@ 17,10 SAY "NASTAVAK JE OD SIFRE: " GET mSif PICTURE "9999999999999"
READ

IF Lastkey() = 27
	RETURN
ENDIF

SELECT 0
USE ARTPANE1
SELECT 0
USE ARTPANE
SELECT ARTPANE1

DO WHILE ! Eof()
	SELECT ARTPANE
	APPEND BLANK
	REPLACE ARTSIF WITH MSIF
	REPLACE ARTNAZ WITH ARTPANE1->ARTNAZ
	REPLACE ARTJM WITH ARTPANE1->ARTJM
	REPLACE ARTKOL WITH ARTPANE1->ARTKOL
	REPLACE ARTCEN WITH ARTPANE1->ARTCEN
	REPLACE SIOP WITH ARTPANE1->SIOP
	REPLACE DATNAB WITH ARTPANE1->DATNAB
	REPLACE ARTTAR WITH ARTPANE1->ARTTAR
	SELECT ARTPANE1
	SKIP
	mSif = mSif + 1
ENDDO

CLOSE DATABASES

RETURN
