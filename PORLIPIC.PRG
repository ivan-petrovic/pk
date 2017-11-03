* - nije pregledano - *
*********************************************
* RASLIST  program za listanje knjige rashoda
*********************************************
SET WRAP ON
SET MESSAGE TO 24 CENTER
SET DATE GERMAN
*USE RASHOD INDEX RASHIND,RASHINK
*GO TOP
*DO WHILE .T.
CLEAR SCREEN
SK = " "
mNivo = " "
mNivo1 = "  "
@ 10,10 SAY "Nivo Prodavnice: " GET mNivo VALID ! Empty(mNivo)
READ
 IF Lastkey() = 27
     CLEAR SCREEN
     RETURN
 ENDIF
 mNivo1 = "/" + mNivo
*select 0
*use porezpic
*index on kal to kpckal
*close porezpic
select 0
    USE POREZPIC INDEX porpicdd    && INKAL
*IF SK = "S"
     IF mNivo # "1"
        SET FILTER TO right(alltrim(kal),2) = mNivo1
        GO TOP
     else
        SET FILTER TO right(alltrim(kal),2) # "/2" .and. right(alltrim(kal),2) # "/3" .and. right(alltrim(kal),2) # "/4"
        GO TOP
     ENDIF
*ENDIF
*IF SK = "K"
*   SET FILTER TO ODDOB = 2
*   GO TOP
*ENDIF
@ 10,10 SAY REPLI(" ",60)
DO WHILE .t.
CLEAR SCREEN
CRTA = REPLI("-",80)
@ 23,0 TO 24,79 DOUBLE
ESCKEY()
@ 1,0 SAY CRTA
*SET COLO TO /W
@ 2,0 SAY " BROJ KALK "
@ 2,12 SAY " DAT KALK "
*@ 2,23 SAY " TARIFA   "
*@ 2,35 SAY " STOPA  "
*@ 2,50 SAY " OSNOVICA "
@ 2,24 SAY "OBRACUNAT POREZ"
@ 2,44 SAY "PRENETI POREZ"
@ 2,61 SAY "POREZ ZA UPLATU"
*SET COLO TO
@ 3,0 SAY CRTA
DISP OFF NEXT 15 KAL,DAT,Space(2),POR,Space(1),ODDOB,Space(2),RAZ
  SKIP
IF Eof()
IZBOR = 3
ELSE
IZBOR = 1
ENDIF
@ 22,25 PROMPT " Dalje " MESSAGE "Sledeca stranica"
@ 22,32 PROMPT " Nazad " MESSAGE "Predhodna stranica"
@ 22,39 PROMPT " Pocetak " MESSAGE "Lista od pocetka"
*@ 24,0           
CLEAR TYPEAHEAD
MENU TO IZBOR
DO CASE
   CASE Lastkey() = 27
   SET FILTER TO
   RELEASE ALL
   @ 10,10 SAY REPLI(" ",60)
   USE
   CLEAR SCREEN
   RETURN
   CASE IZBOR = 1
   LOOP
   CASE IZBOR = 2
   SKIP -29
   CASE IZBOR = 3
   GO TOP
   LOOP
ENDCASE
ENDDO
*ENDDO
*set filter to
*CLEAR SCREEN
*close databases
*return

