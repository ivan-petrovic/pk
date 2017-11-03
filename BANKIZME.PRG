* - nije pregledano - *
****************************************************************
*BANKIZME
*program za izmenu maticnih podataka o bankama                  
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
   @ 8,16 SAY "SIFRA BANKE :" GET WSIBANK PICTURE "999"
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
   DO BIZMAS
   *
   IF V = 1    && KONTROLA DA LI JE PRITISNUT ESC NA NEKOM POLJU MASKE
      EXIT        && AKO JESTE POVRATAK NA MENI O CEKOVIMA
   ENDIF
   *
   @ 24,35 SAY " UPIS D/N " GET DN PICTURE "!" VALID (DN $ "DN")
   READ
   IF Lastkey() = 27
      EXIT
   ENDIF
   IF DN = "N"
      *CLEAR GETS
      LOOP
   ENDIF
   REPLACE SIBANK WITH WSIBANK
   REPLACE NAZBANK WITH WNAZBANK
   REPLACE ADRBANK WITH WADRBANK
   REPLACE MESBANK WITH WMESBANK
   REPLACE ZIRBANK WITH WZIRBANK 
ENDDO
*RELEASE ALL
CLEAR SCREEN
CLOSE BANKDAT
RETURN
