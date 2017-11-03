PRIVATE wDir1

wDir1 = Space(8)
cRoot = getRoot()

CLEAR SCREEN
@ 0, 0 TO 24,79 DOUBLE
@ 1,1 SAY Centriraj("PRENOS PODATAKA U NOVU GODINU", 78)

@ 10,10 SAY "PODACI SE PRENOSE NA KORISNIKA: " GET wDir1
READ

IF Lastkey() = 27
   RETURN
ENDIF

IF(!Empty(cRoot))
   wDir1 = cRoot + "\" + wDir1
ENDIF

@ 14,10 SAY "KOPIRAM DATOTEKE..."

IF File("dmpdatk.dbf")
   ! copy dmpdatk.dbf \&wDir1
ENDIF

! copy tar*.* \&wDir1
* ! copy bod*.* \&wDir1
! copy opi*.* \&wDir1
! copy artpane.dbf \&wDir1
! copy apinsif.ntx \&wDir1
! copy apinart.ntx \&wDir1
! copy pp*.* \&wDir1
! copy obv*.* \&wDir1
! copy zir*.* \&wDir1

RETURN
