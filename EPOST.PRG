* - nije pregledano - *
*********************************************
* GKLDD  program za listanje knjige prihoda
*********************************************
LOCAL ekran:=SAVESCREEN(0,0,24,79), KURSOR:=SETCURSOR(1), OBLAST:=SELECT(1)
set date german
*SET CENT ON
SET CONFIRM ON

SELECT 0
USE EPODAT INDEX EPOIND

DO WHILE .T.
   CLEAR SCREEN
   WOD = DATE()
   WDO = DATE()
   wz1 = val("000000000000.00")
   wz2 = val("000000000000.00")
   wz3 = val("000000000000.00")
   wz4 = val("000000000000.00")
   wz5 = val("000000000000.00")
   wz6 = val("000000000000.00")
   WRED = 80
 *  ESCKEY()
   @ 12,10 SAY "OD DATUMA" GET WOD
   @ 12,32 SAY "DO DATUMA" GET WDO
   READ
   IF Lastkey() = 27
      CLEAR SCREEN
      close epodat
      SELECT(OBLAST)
      RESTSCREEN(0,0,24,79,EKRAN)
      SETCURSOR(KURSOR)
      return
   ENDIF
   SET DEVICE TO PRINT
   set print to lpt1
 *  set print to lista
   SET PRINT ON
   IF lLaser
      ? Chr(27) + '(s17.5H'      && kondenz On za laserski
   ELSE
      ? Chr(15)                  && kondenz On za matricni
   ENDIF

   CRTA = REPLI("-",120)
   brst=1
   ePONaslov()
   ePOZaglavlje()
   DO WHILE ! Eof()
      IF DTOS(EDAT) >= DTOS(WOD) .AND. DTOS(EDAT) <= DTOS(WDO)
         IF PROW() = 62
            IF !brst=0
               EPOFuter()
               EJECT
            ENDIF
            brst = brst + 1
            EPOZaglavlje()
         ENDIF
         EPOTekst()
        wz1 = round(wz1 + eodp,2)
        wz2 = round(wz2 + eodu,2)
        wz3 = round(wz3 + eizpor,2)
        wz4 = round(wz4 + esvega,2)
      ENDIF
         SKIP
      ENDDO
      EPOFUTER()
         ? "                                                " + STR(WZ1,20,2)
         ?? " " +STR(WZ2,19,2)
         ?? "                   " +STR(WZ3,12,2)
         ?? " " +STR(WZ4,12,2)
         ? " "
         ? "                                                              _______________                 _____________________ "
         ? "                                                                 sastavio                        odgovorno lice "
         
         IF lLaser
            ? Chr(27) + '&k0S' + Chr(27) + '(s10.5H'  && kondenz Off za laserski
         ELSE
            ? Chr(18)                                 && kondenz Off za matricni
         ENDIF
         EJECT
         SET DEVICE TO SCREEN
         SET PRINT OFF

ENDDO
*
SELECT(OBLAST)
RESTSCREEN(0,0,24,79,EKRAN)
SETCURSOR(KURSOR)
return
****************************
PROC eponaslov
? gcPrez_Ime
? alltrim(gcAdresa) + " " + alltrim(gcMesto)
? gcNazRad
? "                               KNJIGA O OSTVARENOM PROMETU                                                              Obrazac KPO "
? "                             PAUSALNO OPOREZOVANIH OBVEZNIKA"
return
****************************
PROC EPOZaglavlje
? " "
? "旼컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴�"
? "쿝ED �    DATUM        I        O P I S        �         PRIHOD OD DELATNOSTI           쿞VEGA PRIHODI OD �"
? "쿍R. �            K NJ I Z E NJ A              쿽d prodaje proizvoda쿽d izvrsenih usluga� DELATNOSTI (3+4)�"
? "쳐컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴탠컴컴컴컴컴컴컴컴�"
? "�  1 �                    2                    �         3          �         4         �        5        �"
? "쳐컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴탠컴컴컴컴컴컴컴컴�"

return

****************************
PROC EPOTekst

 ? "�"+STR(eRB,4,0)
?? "�"+DTOC(EDAT)
?? " "+SUBSTR(EOPIS,1,30)
?? "�"+STR(EODP,20,2)
?? "�"+STR(EODU,19,2)
?? "�"+STR(ESVEGA,17,2)+"�"

RETURN
****************************
PROC EPOFuter

? "읕컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴�"

RETURN

