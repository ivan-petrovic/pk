* - nije pregledano - *
CLEAR SCREEN
set date german
set confirm on
select 1
use pritar index pritin
select 2
use rashodn index rashindn,rashinkn
select 3
use porezn index poreznd,poreznb
select 1
set filter to sk1 = 0
go top
DO WHILE .t.
   CLEAR SCREEN
   @ 2,20 SAY "PUNJENJE KNJIGA PAZAROM  S A M O  ZA STR"
   wdat = ctod("  .  .  ")
   wv = val("0000000000.00")
   wn = val("0000000000.00")
   wn1 = val("0000000000.00")
   wnul = val("0000000000.00")
   wnul06 = val("0000000000.00")
   wnul2 = val("0000000000.00")
   wnul4 = val("0000000000.00")
   @ 10,10 SAY "DATUM PAZARA ZA PUNJENJE" GET wdat
   READ
   IF Lastkey() = 27
      EXIT
   ENDIF
   seek dtos(wdat)
   IF Found()
      DO WHILE wdat = dph
         do case
            case sph = 18 .or. sph = 20
                 wv = round(wv + z1,2)
            case sph = 8
                 wn = round(wn + z1,2)
            case sph = 21
                 wn1 = round(wn1 + z1,2)
            * case sph = 20
            *      wnul06 = round(wnul06 + z1,2)
            case sph = 1
                 wnul2 = round(wnul2 + z1,2)
            case sph = 12
                 wnul4 = round(wnul4 + z1,2)
            case sph = 0
                 wnul = round(wnul + z1,2)
         endcase
         SKIP
      ENDDO
      select 2
      seek dtos(wdat)
      IF Found()
         DO WHILE wdat = rdk
            IF substr(rbr,1,2) = "5/"    &&  rsvep = 0 .and. rprodv = 0 .and. ostras = 0
               replace rpv with wv
               replace rpn with wn
               replace rpn1 with wn1
               replace rpbez with wnul
               replace rpbez06 with wnul06
               replace rpbez2 with wnul2
               replace rpbez4 with wnul4
               replace rsvep with round(wv + wn + WN1 + wnul + WNUL06 + wnul2 + wnul4,2)
               EXIT
            ENDIF
            SKIP
         ENDDO
      else
         append blank
         replace rdk with wdat
         replace rbr with "5/"
         replace ropis with "pazar str"
         replace rpv with wv
         replace rpn with wn
         replace rpn1 with wn1
         replace rpbez with wnul
         replace rpbez06 with wnul06
         replace rpbez2 with wnul2
         replace rpbez4 with wnul4
         replace rsvep with round(wv + wn + WN1 + wnul + WNUL06 + wnul2 + wnul4,2)
      ENDIF
      select 3
      seek wdat
      IF Found()
         DO WHILE wdat = datk
            IF pazar = 0 .and. vrrobe = 0 .and. substr(broj,1,2) = "5/"
               replace pazar with round(wv + wn + wn1 + wnul + WNUL06 + wnul2 + wnul4,2)
               EXIT
            ENDIF
            SKIP
         ENDDO
      else
         append blank
         replace datk with wdat
         replace broj with "5/"
         replace ropis with "pazar str"
         replace pazar with round(wv + wn + wn1 + wnul ,2)
      ENDIF
      @ 19,10 SAY "upisao pazar"
      wait " "
      select 1
   else
      @ 20,10 SAY "NEMA PAZARA ZA TAJ DATUM"
      wait " "
   ENDIF
ENDDO
set filter to
close databases
CLEAR SCREEN
return

