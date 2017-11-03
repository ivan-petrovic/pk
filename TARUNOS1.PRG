*:*****************************************************************************
*:
*:        Program: C:\TK\TARUNOS.PRG
*:         System: Knjigovodstvo trgovacke radnje
*:         Author: Dzepina Marko
*:  Last modified: 11.30.93 at 21:34:18
*:
*:      Called by: TAR.PRG                           
*:
*:           Uses: TARDAT.DBF         
*:
*:        Indexes: TARINSIF.IDX       
*:
*:      Documented 09:18:21                                FoxDoc version 3.00a
*:*****************************************************************************
PARAMETERS PROVTAR
LOCAL m_UPIS
PRIVATE mTARSIF, mTARDAT, mTARSST, mTARRST
PRIVATE mTAROST, mTARVOJ, mTARZBIR 

IF PCOUNT() = 0
   USE (ProgDir+"tardat") INDEX (ProgDir+"tarinsif"),(ProgDir+"tarin")  NEW
ENDIF

mTARSIF = Space(8)
mTARDAT = DATE()
mTARSST = 0
mTARRST = 0
mTAROST = 0
mTARVOJ = 0
mTARZBIR = 0
m_UPIS = "D"

Box("T11",14,42,.F.)

DO WHILE m_upis = "D"

   TarUnosEkrn()

   m_izbor = 1

   CLEAR TYPEAHEAD

   m_izbor = al_box(IIF(Lastkey()=27,"Unos PREKINUT..!!!","Podaci su izmenjeni..!"),;
                    IIF(Lastkey()=27,2,3),;
                    IIF(Lastkey()=27,{"Nastavi","Prekini"},{"Ispravi","Odustani","Upis u bazu"}),;
                    1, m_x, m_y, m_x+6, m_y+42)

   DO CASE
      CASE m_izbor = 2 .OR. Lastkey() = 27
           CLEAR GETS
           EXIT
      CASE m_izbor = 3
	   mtarzbir = mtarsst + mtarrst + mtarost + mtarvoj
           APPEND BLANK
           REPLACE tarsif  WITH mtarsif,;
                   tarsst  WITH mtarrst,;
                   tarrst  WITH mtarsst,;
                   tarost  WITH mtarost,;
		   			 tarvoj  WITH mTARVOJ,;
                   tarzbir WITH mtarzbir,;
                   tardat  WITH mtardat
      CASE m_izbor = 1
           LOOP
   ENDCASE
   m_upis = "N"
   IF PCOUNT() = 0
      @ 24,0 CLEAR
      @ 24,15 SAY "  Da li nastavljamo upis (D/N) ? " GET m_upis ;
                  PICTURE "!" VALID(m_upis $ "DN")
      READ
   ENDIF
ENDDO m_upis
BoxC()

IF PCOUNT() = 0
   CLOSE TARDAT
   RETURN
ENDIF
IF m_izbor = 2 .OR. Lastkey() = 27
   CLEAR GETS
   RETURN(.F.)
ELSE
   mARTTAR = mTARSIF
   RETURN(.T.)
ENDIF


************************************
PROCEDURE TarUnosEkrn
   LOCAL GetList:={}
   @ m_x   , m_y+03 SAY "Unos NOVIH tarifa"  COLOR "B/W+"
   @ m_x+02, m_y+03 SAY "           TARIFA:" GET mtarsif PICTURE "@!" VALID ProvTar(mtarsif).AND.!Empty(mTarSif)
   @ m_x+04, m_y+03 SAY " REPUBLICKA STOPA:" GET mtarsst PICTURE "999.99"
   @ m_x+06, m_y+03 SAY "  ZELEZNICA STOPA:" GET mtarrst PICTURE "999.99"
   @ m_x+08, m_y+03 SAY "      TAKSA STOPA:" GET mtarost PICTURE "999.99"
   @ m_x+10, m_y+03 SAY "POSEBAN SAV. POR.:" GET mtarvoj PICTURE "999.99"
   @ m_x+12, m_y+03 SAY "Datum pocetka vazenja tarife:";
                    GET mtardat VALID ! Empty(mtardat)
   OldCur:=SetCURSOR(1)
   READ
   SETCURSOR(OldCur)
RETURN

***********************************
PROCEDURE ProvTar(mtarsif)

   SEEK mtarsif
   IF Found()
      Msg("Vec postoji otvorena takva tarifa!",5)
      RETURN(.F.)
   ELSE
      RETURN(.T.)
   ENDIF

***********************************
