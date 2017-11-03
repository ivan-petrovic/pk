wfirm   = Val("00000")
wfirnaz = Space(70)
bst     = Val("000")
izn     = Val("0000000000000.00")
ukizn   = Val("00000000000000.00")

SET DEVICE TO SCREEN
SET PRINTER OFF
SET FILTER TO
SET SOFTSEEK OFF

wod = Date()
wdo = Date()
wd  = Date()
wmes   = Space(20)
wmes   = "OBRENOVAC"
wfilij = Space(20)
wfilij = "                    "
wsifpl = Val("000")
WSIFPL = 253
ind  = 0
ind1 = 0
wsibank = Space(3)
SVRHA   = "uplata PDV "
SVRHA1  = "OD           DO          "

CLEAR SCREEN
@ 5,18 SAY "Datum  stampe (vidljivo na virmanu) :  " GET wd
@ 7,18 SAY "Mesto (vidljivo na virmanu)         :  " GET wmes
@ 9,18 SAY "Sifra placanja                      :  " GET wsifpl PICTURE "999"
READ

IF Lastkey() = 27
   RETURN
ENDIF

red = 1
SET DEVICE TO PRINTER
SET PRINT TO LPT1
SET PRINTER ON
setprc(0,0)
wsb = Space(3)

*** izracunavanje kontrolnog broj
wops    = Val("000")
wops    = 601
wpib    = Val("000000000")
wkont   = Val("00000")
wslovo  = " "
wpom    = Space(12)
wpomp   = Val("000000000000")
wpomp1  = Val("00000000000000")
wpomp11 = Val("00000000000000")        &&  wpom1 * 97
wpomp2  = Val("000000000000.00000")    && za deljenje na sest  decimale
wpomp22 = Val("000000000000")          && za celobrojni transfer
wpomp02 = Val("000000000000")          && za celobrojno deljenje
wpom1   = Val("0000000000000000000")
wpom2   = Val("000000000000000000000")
wkon    = Val("00")
wkonpom = Val("00")
zez     = Val("00")
zr      = "840-714112843-10"
wpom    = Str(wops,3,0) + gcPIB
wpomp   = Val(alltrim(wpom))

wpomp1  = wpomp*100
wpomp2  = Round(wpomp1 / 97,6)
wpomp02 = Round(wpomp1 / 97,0)
DO CASE
   CASE wpomp02 - wpomp2 < 0
      wpomp22 = wpomp02
   CASE wpomp02 - wpomp2 > 0
      wpomp22 = wpomp02 - 1
ENDCASE
wpomp11 = wpomp22 * 97
wkonpom = wpomp1 - wpomp11
wkon    = 98 - wkonpom
wpom2   = wpomp2 * 100
*** kraj izracunavanja kontrolnog broja

@ red,4 SAY " "
red = red + 1
@ red,4 SAY alltrim(gcPrez) + " " + alltrim(gcIme)
red = red + 1
@ red,4 SAY gcNazRad
@ red,43 SAY WSIFPL  PICTURE "999"
red = red + 1
@ red,4 SAY gcMesto
red = red + 2
@ red,51 SAY gcZiro
red = red + 1
@ red,10 SAY substr(svrha,1,18)
red = red + 1
@ red,04 SAY SVRHA1
red = red + 3
@ red,51 SAY substr(zr,1,20)
red = red + 1
@ red,4 SAY "PORESKA UPRAVA"
red = red + 2
@ red,43 SAY "97"
@ red,51 SAY wkon PICTURE "99"
@ red,53 SAY "601"
@ red,56 SAY gcPIB
red = red + 3
@ red,16 SAY rtrim(wmes)
red = red + 6
@ red,0 SAY " "

RETURN
