* - nije pregledano - *
****************************************************************
*BANKUP  
*program za UPIT u maticnE podatkE o bankama                  
****************************************************************
*
SET PROCEDURE TO FUNKCIJE
SELECT 0
USE BANKDAT INDEX BINSIF                    
*
DO WHILE .T.
   V = 0
   CLEAR SCREEN
   ESCKEY() 
   DN = " "
   WSIBANK = VAL("000")
   @ 8,16 SAY "SIFRA BANKE :" GET WSIBANK
   READ
   IF Lastkey() = 27
      EXIT
   ENDIF
*   IF WSIBANK = "   "
*      PORUKA()
*      LOOP
*   ENDIF
   SEEK WSIBANK
   IF !Found()
       NEMAB()
       LOOP
   ENDIF
   WNAZBANK = NAZBANK   
   WADRBANK = ADRBANK   
   WMESBANK  = MESBANK   
   WZIRBANK = ZIRBANK  
   DO BUPMAS
   PAUZA()
   LOOP
ENDDO
*RELEASE ALL
CLEAR SCREEN
CLOSE BANKDAT
RETURN
