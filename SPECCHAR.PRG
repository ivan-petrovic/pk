* Stampa karaktere tipa uglovi okvira i sl.

SET DEVICE TO PRINTER
SET PRINT TO LISTA
SET PRINTER ON

? "Karakter    Opis"
? "------------------------------------"
? Space(2), Chr(218), "       Gornji levi ugao prozora"
? Space(2), Chr(191), "       Gornji desni ugao prozora"
? Space(2), Chr(192), "       Donji levi ugao prozora"
? Space(2), Chr(217), "       Donji desni ugao prozora"
? Space(2), Chr(179), "       Vertikalna crta"
? Space(2), Chr(196), "       Horizontalna crta"

SET DEVICE TO SCREEN
SET PRINTER OFF

CLEAR SCREEN
RETURN

/*
Karakter    Opis
------------------------------------
   �        Gornji levi ugao prozora
   �        Gornji desni ugao prozora
   �        Donji levi ugao prozora
   �        Donji desni ugao prozora
   �        Vertikalna crta
   �        Horizontalna crta
*/
