! copy porezpic.dbf porezpic.ddd > nul
SELECT 0
USE dmpdat INDEX dmpinbro
SELECT 0
USE porezpic INDEX porpicka,porpickt,porpicdd,kpckal
ZAP
GO TOP

SELECT DMPDAT
DO WHILE ! Eof()
   * inicijalizacija promenljivih
   mtar   = Space(8)
   mStop  = Val("000.00")
   mdat   = Date()
   mkal   = Space(10)
   motp   = Space(10)
   mosn   = Val("000000000000.00")
   mpor   = Val("000000000000.00")
   moddob = Val("000000000000.00")
   mraz   = Val("000000000000.00")
   mzakup = Val("000000000000.00")
   mKal   = DMPBRO

   DO WHILE mKal = DMPBRO
      IF VRSTA = " "
         SKIP
         LOOP
      ENDIF
      mtar   = DMPTAR
      mStop  = DMPPOR
      mdat   = DMPDAT
      motp   = DMPFAK
      mosn   = Round(mosn + DMPVSP, 2)
      mpor   = Round(mpor + DMPPPK, 2)
      moddob = Round(moddob + DMPPPD, 2)
      mraz   = Round(mraz + DMPRAZ, 2)
      mzakup = Round(mzakup + DMPPPK, 2)
      SKIP
   ENDDO
   
   IF ! mosn = 0
     * ide upis u porezpic
     SELECT porezpic
     SEEK Val(mkal)
     IF Found()
        * zamena
        REPLACE TAR   WITH mtar
        REPLACE STOP  WITH mStop
        REPLACE DAT   WITH mdat
        REPLACE OTP   WITH mOtp
        REPLACE OSN   WITH mOsn
        REPLACE POR   WITH Mpor
        REPLACE ODDOB WITH mOddob
        REPLACE RAZ   WITH mRaz
        REPLACE ZAKUP WITH mZakup
     else
        * upis novog, nije ga bilo u porezpic
        APPEND BLANK
        REPLACE KAL   WITH mKal
        REPLACE TAR   WITH mtar
        REPLACE STOP  WITH mStop
        REPLACE DAT   WITH mdat
        REPLACE OTP   WITH mOtp
        REPLACE OSN   WITH mOsn
        REPLACE POR   WITH Mpor
        REPLACE ODDOB WITH mOddob
        REPLACE RAZ   WITH mRaz
        REPLACE ZAKUP WITH mZakup
     ENDIF
  ENDIF
     SELECT DMPDAT
ENDDO

CLOSE DATABASES
RETURN
