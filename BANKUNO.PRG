* - nije pregledano - *
****************************************************************
*BANKUNO
*program za unos maticnih podataka o bankama                  
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
   WNAZBANK = Space(30) 
   WADRBANK = Space(30) 
   WMESBANK  = Space(30) 
   WZIRBANK = Space(30)
   DO BUNMAS
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
   APPEND BLANK
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