/*
SET ALTERNATE TO lista.htm
SET ALTERNATE ON

? "<!DOCTYPE html>"
? "<html>"
? "	<head>"
? "		<title>Stampa virmana</title>"
? '      <meta http-equiv="Content-Type" content="text/html; charset=utf-8">'
? "	</head>"
? "	<body>"
? "		<div id='nalog1'>"
? "            <h2>Uplatilac</h2>"
? "            <p>Иван Ivan Petrovic</p>"
? "      </div>"
? "	</body>"
? "</html>"

SET ALTERNATE TO
SET ALTERNATE OFF
CLEAR SCREEN
RETURN
*/
/*
IF logUsage("PROBA")
   ? "Uspesan upis."
ELSE
   ? "Neuspesan upis."
ENDIF


FUNCTION logUsage(fname)
   LOCAL lSuccess := .F.

   IF File("C:\PK\USAGELOG.DBF")
      SELECT 0
      USE C:\PK\USAGELOG.DBF
      
      LOCATE FOR FILENAME = fname
      IF Found()
         REPLACE CNT WITH CNT + 1
      ELSE
         APPEND BLANK
         REPLACE FILENAME WITH fname
         REPLACE CNT WITH 1
      ENDIF
      
      USE
      lSuccess = .T.
   ENDIF

RETURN lSuccess
*/
LOCAL cBrojOld, cBrojNew
cBrojOld = Space(10)
cBrojNew = Space(10)

DO WHILE .T.

   CLEAR SCREEN
   @ 3,1 SAY "Stari broj kalkulacije: " GET cBrojOld
   @ 4,1 SAY "Novi broj kalkulacije:  " GET cBrojNew
   READ

   IF Lastkey() = 27
      EXIT
   ENDIF

   USE DMPDAT
   REPLACE DMPBRO WITH cBrojNew FOR DMPBRO = cBrojOld
   USE

   USE RASHODN
   REPLACE RBR WITH cBrojNew FOR RBR = cBrojOld
   USE

   USE POREZN
   REPLACE BROJ WITH cBrojNew FOR BROJ = cBrojOld
   USE

   * ? cBrojOld, " se koristi umesto ",cBrojNew
   * WAIT ""

ENDDO
