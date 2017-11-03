*****************************************
* Glavni meni za problematiku knjige poreza
*****************************************
LOCAL Izbor, nPredhIzbor

nPredhIzbor = 1
DO WHILE .T.

    MainWnd("KNJIGA POREZA KAFE PI'A I CIGARETA")

    Izbor = nPredhIzbor
    @ 6 ,10 PROMPT "UNOS STAVKE POREZA               "
    @ 8 ,10 PROMPT "IZMENA STAVKE POREZA             "
    @ 10,10 PROMPT "BRISANJE POREZA PO KALK.         "
    @ 12,10 PROMPT "LISTANJE KNJIGE POREZA           "
    @ 14,10 PROMPT "UPIT POREZA PO TARIFI            "
    @ 16,10 PROMPT "UPIT POREZA ZBIRNO               "
    @ 18,10 PROMPT "STAMPA POREZA PO KALKULAC.       "
    @ 20,10 PROMPT "PUNJENJE KNJIGE IZ KALKULACIJA   "
    @ 22,10 PROMPT "PUNJENJE KNJIGE IZ KALKULACIJA I "

    MENU TO Izbor
    * nPredhIzbor = Izbor
    
    DO CASE
        CASE Lastkey() = 27
           EXIT
        CASE Izbor = 1
           DO POREUPIC
        CASE Izbor = 2
           DO PORIZPIC
        CASE Izbor = 3
           DO BRISPPIC
       CASE Izbor = 4
           DO PORLIPIC
        CASE Izbor = 5
           DO PORUPPIC
        CASE Izbor = 6
           DO PORZUPIC
        CASE Izbor = 7
           DO PORSPIC
        CASE Izbor = 8
           DO PICSTELA
        CASE Izbor = 9
           DO PICSTEL1
    ENDCASE

ENDDO

CLOSE DATABASES
RELEASE ALL

RETURN
