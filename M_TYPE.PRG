*************************************
* M_type.prg
* Program za prikazivanje
* text datoteke na ekran
* i stampu iste
*************************************
PARAMETERS text_dat,line_length
IF PCOUNT() = 1
   line_length:=132
ENDIF

ekrn=SaveScreen(0,0,maxrow(),maxcol())
curs_on:=.F.
SET SCOREBOARD ON
SET CURSOR OFF
PRIVATE t,l,b,r,mark_poc,mark_kraj,velicina,ostaje,bytes,poz,;
        update,Scrl_on,ispitan,line_num,col_num,;
        rel_row,rel_col,ret_val,init_count,usao,zapamti,memorandum  && line_length,

t = 0
l = 0
b = maxrow()-5
r = maxcol()
mark_poc:=mark_kraj:=0
SETCOLOR(normal)
@ 0,0 clear
@ t,l,b,r BOX okvir           && sframe
@ b+1,0,maxrow(),maxcol() BOX okvir       && frame
SETCOLOR(invert)
@ b-1,l+1 SAY      '  F2 - NOVI BLOK     <PgUp>,,<PgDn>,   -   Listanje      <Esc> - izlaz      '
@ maxrow()-1,1 SAY '           MARKIRANJE  F7 - Od    F8 - Do     STAMPA - F10                    '
SETCOLOR(normal)

* Rezervacija mesta za blokove
*******************************
block:=block1:=30*1023
usr_memo:=Space(block+132)
velicina:=ostaje:=bytes:=poz:=0
usao:=.F.
**** Otvaram TEXT FAJL  ******
kanal = FOPEN(text_dat)
IF kanal = -1
   @ 20,10 SAY "greska u otvaranju"
   wait " "
ENDIF
velicina = FSEEK(kanal,0,2)          &&  skoci na kraj i kazi koliko si....
ostaje := velicina                   &&  preskocio (bajta)
DO WHILE ostaje > 0 .AND. Lastkey() <> 27
    curs_on:=.F.
    SET CURSOR OFF
    update = .T.                      &&  editovanje
    zapamti = .F.                     &&  Pamte li se izmene ?
    Scrl_on = .F.
*    line_length = 132
    line_num = 1
    col_num = 0
    rel_row = 0
    rel_col = 0
    ret_val = 0
    IF ostaje < block
       block = ostaje
       usao:=.T.
    ENDIF
    usr_memo:=Space(block+50)
    FSEEK(kanal,poz,0)
    bytes = FREAD(kanal,@usr_memo,block)
    block1 = RAT('',usr_memo)
    IF block1 = 0
       block1 := block
    ENDIF
    usr_memo:=Space(block1+50)
    FSEEK(kanal,poz,0)
    bytes = FREAD(kanal,@usr_memo,block1)
    poz = poz + bytes
    ostaje = ostaje - block1
    *** VAZNO ***
    init_count = 1
    ispitan = .F.
    ***************
    SET CURSOR ON
    curs_on:=.T.
    usr_memo = MEMOEDIT(usr_memo,t+1,l+1,b-2,r-1,update,'mfunc',;
                       line_length,'',line_num,col_num,rel_row,rel_col)
    ***  Citaj sledeci blok ******
    @ t+1,l+1 CLEAR TO b-2,r-1
    @ b+1,6 SAY Space(63)
    IF usao
       EXIT
    ENDIF
    INKEY()
ENDDO
FCLOSE(kanal)
IF ZAPAMTI                           && da zapamti u datoteku iz bafera usr_memo
   MEMOWRIT((text_dat),usr_memo)
   SET CURSOR Off
   SET SCOREBOARD OFF
   RestScreen(0,0,maxrow(),maxcol(),Ekrn)
   RETURN(.T.)
ELSE
   SET CURSOR Off
   SET SCOREBOARD OFF
   RestScreen(0,0,maxrow(),maxcol(),Ekrn)
   RETURN(.F.)
ENDIF

******************************************************************
*    mfunc()
*
*    memoedit korisnicka funkcija
*
*    Namena....:  Sluzi za editovanje i prikazivanje TEXT datoteka
*
******************************************************************

****
FUNCTION mfunc
LOCAL Hlin:=SAVESCREEN(maxrow(),0,maxrow(),maxcol())
PARAMETERS mode, line, col
PRIVATE keypress
ret_val = 0
DO CASE
   CASE mode = 3
      * inicijalizacija. Globalne varijable 'init_count' i 'ispitan'
      * kontrolisu proces inicijalizacije
      IF init_count = 1
          * setuje inicijalno scroll state (inicijalno ON ako je update OFF)
          IF ((.NOT. scrl_on .AND. .NOT. update) .OR.;
              (scrl_on .AND. update)) .AND. .NOT. ispitan
              * potrebno toggle
              ispitan = .T.
              ret_val = 35
            ELSE
              * scroll state ispravan
              init_count = 2
              ispitan = .F.
          ENDIF
      ENDIF
      IF init_count = 2
          * zavrsena inicijalizacija..Zapaziti da ako je inic. sve u redu
          * stizemo na ovu tacku na prvi poziv
          KEYBOARD CHR(31)
          SET CURSOR OFF
          @ b,r - 15 SAY "Linija: " + pad(LTRIM(STR(line)), 4)
          IF curs_on
              SET CURSOR ON
          ENDIF
          ret_val = 0
      ENDIF
   CASE mode = 0
      * idle
      SET CURSOR OFF
      @ b,r - 15 SAY "Linija: " + pad(LTRIM(STR(line)), 4)
      IF curs_on
          SET CURSOR ON
      ENDIF
   OTHERWISE
      * keystroke exception
      keypress = Lastkey()
      * sacuvaj vrednosti u slucaju editovanja
      line_num = line
      col_num = col
      rel_row = ROW() - t - 1
      rel_col = COL() - l - 1
      DO CASE
         CASE keypress = 23          && ^W..za upis na disk
            zapamti = .T.
            ret_val = 23
         CASE keypress = -1
            * F2            sledeci blok
            **** izlaz ****
            ret_val = 27
         CASE keypress = -9         && F10 - Stampa
            IF mark_poc = mark_kraj .OR. mark_poc*mark_kraj = 0 && stampa celog dok ?
               stampa := al_box("Stampate CEO dokument ?",2,;
                        {"Nastavi","Odustani"},2,6,22,12,59)
               DO CASE
               CASE stampa = 1
                    mark_poc = 1
                    mark_kraj = MlCount(usr_memo,line_length)
                    @ b+1,6 SAY 'Pocetak stampe na liniji '+STR(mark_poc,4)+' a zavrsetak na liniji           '+STR(mark_kraj,4) COLOR "W+/G"
               END CASE
            ENDIF

            IF .NOT. F_STAMP()
                Msg('Stampac nije spreman',5)
                ret_val = 32
            ELSE
                mBr_kop = 1
                memorandum ="N"
                @ 10,10 SAY ""
                h[1]='U koliko primeraka se stampa i da li se stampa memorandum'
                Box("Memo i kopije",2,21,.T.)
                @ m_x+1, m_y+2 SAY "Broj kopija.....: " GET mBr_kop;
                                    PICTURE "9" VALID mBr_kop>0
                IF FILE("logo.prn")
                   @ m_x+2, m_y+2 SAY "Memorandum (D/N): " GET memorandum;
                                       VALID (memorandum $ "DdNn")
                ENDIF
                READ
                BoxC()
                RESTSCREEN(maxrow(),0,maxrow(),maxcol(),hLin)
                IF Lastkey() = 27
                   return(27)
                END IF
                SET CURSOR OFF
                IF mark_poc <= mark_kraj .AND. mark_poc*mark_kraj <> 0
                    SETCOLOR(blink)
                    TONE(444,3)
                    @ b+1,6 SAY 'Stampa TEXT datoteke je u toku, strpljenja molim !!!           '
                    SETCOLOR(normal)
                    SET DEVICE TO PRINT
                    SET PRINTER ON
                    SET CONSOLE OFF
                    FOR mBrK = 1 TO mBr_kop
                        IF memorandum $ ("Dd")
                           Prtb(ProgDir+"logo.prn")
                        ENDIF
                        FOR ij = mark_poc TO mark_kraj
                            print_line=MEMOLINE(usr_memo,line_length,ij,3,.F.)
                            IF !IsPrinter()
                               InKey(10)
                               IF !IsPrinter()
                                  SET DEVICE TO SCREEN
                                  SET CONSOLE ON
                                  Greska(2)
                                  izb = al_box("Stampac nije spreman ! NASTAVLJAMO SA STAMPOM ?",2,,1,6,16,12,65)
                                  DO CASE
                                     CASE izb = 1
                                        SET DEVICE TO PRINT
                                        SET CONSOLE OFF
                                        ? print_line      && @ PROW()+1,1 SAY print_line
                                     CASE izb = 2
                                        ij = mark_kraj
                                        mBrK = mBr_Kop
                                  ENDCASE
                               ENDIF
                            ELSE
                               ? print_line      && @ PROW()+1,1 SAY print_line
                            ENDIF
                        NEXT
                    NEXT
                    SET DEVICE TO SCREEN
                    SET PRINTER OFF
                    SET CONSOLE ON
                ELSE
                    * poruka
                    TONE(555,2)
                    @ b+1,6 SAY 'Niste dobro markirali stampu,pocetak mora biti manji od kraja!!' COLOR "R+***/W"
                    INKEY(4)
                ENDIF
                @ b+1,6 SAY Space(63)
                STORE 0 TO mark_poc,mark_kraj
                IF curs_on
                   SET CURSOR ON
                ENDIF
                ret_val = 32
            END IF
         CASE keypress = -6
            * F7 OZNACAVANJE pocetak
            SET CURSOR OFF
            mark_poc = line
            mark_kraj = 0
            @ b+1,6 SAY 'Pocetak stampe na liniji '+STR(mark_poc,4)+' a zavrsetak na liniji      ' COLOR "W+/G"
            IF curs_on
                SET CURSOR ON
            ENDIF
            ret_val = 32
         CASE keypress = -7
            * F8  OZNACAVANJE kraj
            SET CURSOR OFF
            mark_kraj = line
            @ b+1,58 SAY STR(mark_kraj,4) COLOR "W+/G"
            IF curs_on
               SET CURSOR ON
            ENDIF
            ret_val = 32
         CASE keypress = 301 .OR. keypress = 27
            * Esc/Alt-X......EXIT
            * nema promena
            ret_val = 27
      ENDCASE
ENDCASE
RETURN ret_val


 FUNCTION PrintCodes( cCtrlCode )
    LOCAL nRow, nCol, lPrinter
    lPrinter := SET(_SET_PRINTER, .T.)  // SET PRINTER ON
    nRow = PROW()                       // Save printhead position
    nCol = PCOL()
    //
    ?? cCtrlCode                        // Send control code
    //
    SETPRC(nRow, nCol)
    SET(_SET_PRINTER, lPrinter)         // Restore printer setting
    RETURN ""                           // Return a null ("") string


