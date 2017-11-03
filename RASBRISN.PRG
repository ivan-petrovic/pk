* - nije pregledano - *
SET CONFIRM ON
SET DATE GERMAN
SET MESSAGE TO 24 CENTER
PUBLIC DATUM,V
DATUM = DATE()
select 0
USE RASHODN INDEX RASHINKN,RASHINDN
B = LASTREC()
B = B + 1
wimaras = 0
DO WHILE .T.
   CLEAR SCREEN
   CLEAR SCREEN
   WBROJ = Space(10)
   @ 10,10 SAY "UNESITE BROJ KALKULACIJE(POP./NIV.)" GET WBROJ
   READ
   IF Lastkey() = 27
      EXIT
   ENDIF
   SEEK WBROJ
   IF !Found()
      @ 20,10 SAY "NEMA TAKVE STAVKE U KNJIZI RASHODA"
      WAIT " "
      @ 20,10 SAY REPLI(" ",70)
      LOOP
   ENDIF
   V = 0
   wimapor = 0
   DN = " "
   WRRB = VAL("0000")
   WRRB = RRB
   WRDK = RDK
   WROPIS = ROPIS
   WRBR = RBR
   WRDATDOK = RDATDOK
   WRPV = RPV
   WRPN = RPN
   WRPN1 = RPN1
   WRPBEZ = RPBEZ
   WRUSP = RUSP
   WRUSBEZP = RUSBEZP
   WRPLACP = RPLACP
   WRSVEP = RSVEP
   wrsvepp = rsvep
   WRNVRRR = RNVRRR
   WRVSP = RVSP
   WRRUCP = RRUCP
   WROBPOR = ROBPOR
   WRPRODV = RPRODV
   WRMIN = RMIN
   WRDOP = RDOP
   WRRASF = RRASF
   WRRASUK = RRASUK
   WRZIRU = RZIRU
   WRZIRI = RZIRI
   WRSK = RSK
   DO RASMBRNN
   IF V = 1
     EXIT
   ENDIF
   @ 23,24 SAY "BRISANJE  D/N  ? " GET DN PICTURE "!" VALID(DN $ "DN")
   READ
   IF Lastkey() = 27
      EXIT
   ENDIF
   IF DN = "N"
      LOOP
   ENDIF
   DELETE
   wimaras = 1
   IF wrsvep <> 0
      select 0
      use porezn index poreznd,poreznb
      seek wrdk
      IF Found()
         DO WHILE wrdk = datk
            IF pazar <> 0
               delete
               wimapor = 1
               EXIT
            ENDIF
            SKIP
         ENDDO
         IF wimapor = 0
            @ 20,50 SAY "NEMA PAZARA U POREZIMA"
            WAIT " "
            @ 20,50 SAY REPLI(" ",28)
            CLOSE POREZN
            select rashodn
            LOOP
         ENDIF
         pack
         close porezn
         select rashodn
      else
            @ 20,50 SAY "NEMA PAZARA U POREZIMA"
            WAIT " "
            @ 20,50 SAY REPLI(" ",28)
            CLOSE POREZN
            select rashodn
      ENDIF
   ENDIF
ENDDO
*
IF wimaras = 1
   select rashodn
   PACK
ENDIF
close rashodn
*CLEAR ALL
CLEAR SCREEN
RETURN


