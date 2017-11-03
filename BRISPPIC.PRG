* - nije pregledano - *
set date german
set confirm on
select 0
use porezpic
index on kal to kpckal
close porezpic
*
select 0
use porezpic index kpckal,porpickt,porpicka,porpicdd   && inkt,inkal
DO WHILE .t.
   CLEAR SCREEN
   esckey()
   bkkal = Space(10)
   brkal = val("0000000000")
   bktar = Space(8)
   *bkkal = wdmpbro
   @ 10,10 SAY "BROJ KALKULACIJE CIJI POREZ BRISETE" GET bkkal
   READ
   IF Lastkey() = 27
      EXIT
   ENDIF
   *brkal = val(bkkal)
   *set order to 2
   seek bkkal
   IF ! Found()
      @ 20,10 SAY "U KNJIZI POREZA NEMA KALKULACIJE POD TIM BROJEM"
      wait " "
      LOOP
   ENDIF
   * set order to 1
   *kljuc = bkkal + bktar
   *set  softseek on
   *seek kljuc
   *set softseek off
  DO WHILE bkkal = kal
     delete
     SKIP
  ENDDO
  pack
  EXIT
ENDDO
close porezpic
CLEAR SCREEN
return
