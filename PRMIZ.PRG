* - nije pregledano - *
*****************************************
*PRMIZ 
* maska za izmenu podataka o KNJIZI PRIHODA
*****************************************
*
SET CONFIRM ON
SET DATE GERMAN
CLEAR SCREEN
ESCKEY()
@ 1,0 TO 24,79 DOUBLE
D = 1
DO WHILE D = 1
@ 2,20 SAY "IZMENA MATICNIH PODATAKA U KNJIZI PRIHODA"
*
@ 4,26 SAY "RED.BROJ         :"                     
@ 4,45 SAY WRB
@ 6,26 SAY "DATUM KNJIZENJA  :" GET WDK                        
@ 8,26 SAY "OPIS KNJIZENJA I BROJ DOKUMENTA"
@ 10,26 SAY "PAZAR ILI RACUN :" GET WPIR PICTURE "AAAAA"
@ 12,26 SAY "DATUM R/P       :" GET WDRP
@ 14,26 SAY "BROJ RAC./PAZAR :" GET WBRP PICTURE "9999"
@ 16,26 SAY "PRIHOD OD DELATNOSTI"
@ 17,26 SAY "OD PRODAJE PROIZVODA"
@ 18,26 SAY "ROBA I MATERIJALA   "
@ 19,26 SAY "SA P/P              "
@ 18,47 GET WPRIH PICTURE "999999999999.99"
*
READ
*
 IF Lastkey() = 27
 V = 1
 RETURN
 ENDIF
D = 0
*
ENDDO D
*
RETURN
