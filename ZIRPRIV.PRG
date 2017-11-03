LOCAL Dat1, Dat2, nBanka, wz1, wz2, wz3, wz4, rbrn, wprebr, wpred, wrbr

Dat1 = Date()
Dat2 = Date()
nBanka = 0
wz1  = Val("00000000.00")
wz2  = Val("00000000.00")
wz3  = Val("00000000.00")
wz4  = Val("00000000.00")
rbrn = Val("0000")

MainMask("PRIPAJANJE U KNJIGU PRIHOD-RASHOD")
@ 6,3 SAY "OD DATUMA: " GET Dat1
@ 7,3 SAY "DO DATUMA: " GET Dat2
@ 8,3 SAY "BANKA:     " GET nBanka
* ne radi ovo za sve banke, ovako kako je izvedeno
* pa ga izbacujem - mora da se precizira banka
* @ 9,3 SAY "0-sve banke"
READ

IF Lastkey() = 27
   RETURN
ENDIF

SELECT 0
USE RASHODN INDEX RASHINDN,RASHINKN
GO BOTTOM
rbrn = RRB

SELECT 0
USE GKZIRO INDEX GKZIPOM
GO TOP

DO WHILE ! Eof()
   * dodati proveru za banku
   * IF nBanka <> 0
      IF nBanka <> BANK
         SKIP
         LOOP
      ENDIF
   * ENDIF

   IF BDIZ < Dat1
      SKIP
      LOOP
   ENDIF

   IF BDIZ > Dat2
      EXIT
   ENDIF
   
   wz1 = 0
   wz2 = 0
   wz3 = 0     && PDV
   wz4 = 0     && Provizija
   wprebr = RB
   wpred  = BDIZ
   DO WHILE wpred = BDIZ
      wz1 = Round(wz1 + UPL,2)   && platili firmi
      wz2 = Round(wz2 + ISPL,2)  && platila firma

      DO CASE
         CASE SALDO = 1
            wz3 = Round(wz3 + ISPL,2)  && platila firma
         CASE SALDO = 2
            wz4 = Round(wz4 + ISPL,2)  && platila firma
      ENDCASE

      SKIP
   ENDDO       &&  kraj od jednog datuma

   * ide upis jednog datuma u bazu RASHODN
   wrbr = Space(10)
   wrbr = Str(wprebr,3,0) + "/izvod"
   SELECT RASHODN
   APPEND BLANK
   REPLACE RRB     WITH rbrn
   REPLACE RDK     WITH wpred
   REPLACE RBR     WITH Alltrim(wrbr)
   REPLACE ROPIS   WITH "knjizenje izvoda"
   REPLACE RDATDOK WITH wpred
   REPLACE RPBEZ4  WITH wz3
   REPLACE RRASF   WITH wz4
   REPLACE RRASUK  WITH wz4
   REPLACE RZIRU   WITH wz1
   REPLACE RZIRI   WITH wz2
   rbrn = rbrn + 1
   SELECT GKZIRO
ENDDO     && od kraja baze

CLOSE GKZIRO
CLOSE RASHODN

RETURN
***********************************************************
