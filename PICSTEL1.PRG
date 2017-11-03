! copy porezpic.dbf porezpic.dd1 > nul
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

   mtar1   = Space(8)
   mStop1  = Val("000.00")
   mdat1   = Date()
   mkal1   = Space(10)
   motp1   = Space(10)
   mosn1   = Val("000000000000.00")
   mpor1   = Val("000000000000.00")
   moddob1 = Val("000000000000.00")
   mraz1   = Val("000000000000.00")
   mzakup1 = Val("000000000000.00")

   mtar2   = Space(8)
   mStop2  = Val("000.00")
   mdat2   = Date()
   mkal2   = Space(10)
   motp2   = Space(10)
   mosn2   = Val("000000000000.00")
   mpor2   = Val("000000000000.00")
   moddob2 = Val("000000000000.00")
   mraz2   = Val("000000000000.00")
   mzakup2 = Val("000000000000.00")

   mInd = Val("0")  && indikator 1 nivelacija 2 povracaj 3 prenosna (ili 2 i 3 zajedno)
   mInd = 0

   mIndv = Val("0")  && vrednost + ili -
   mIndv = 0         && 1 +  2 -

   mKal = DMPBRO

   DO WHILE mKal = DMPBRO
      IF VRSTA = " " .AND. DMPSIF = 0 .and. DMPJM = "-  "     && to je nivel.
         mInd = 1                                             && treba znati + ili -
      ENDIF
      
      IF VRSTA = " " .AND. DMPFAK = "         0"       && to je povracaj ili prenosna
         mInd = 2                                      && obavezno  -
      ENDIF

      DO CASE
        CASE DMPPOR = 18 .OR. DMPPOR = 20
             mtar   = DMPTAR
             mStop  = DMPPOR
             mdat   = DMPDAT
             motp   = DMPFAK
             mosn   = Round(mosn + DMPVSP,2)
             mpor   = Round(mpor + DMPPPK,2)
             moddob = Round(moddob + DMPPPD,2)
             mraz   = Round(mraz + DMPRAZ,2)
             mzakup = Round(mzakup + DMPPPK,2)
        CASE DMPPOR = 8 .OR. DMPPOR = 10
             mtar1   = DMPTAR
             mStop1  = DMPPOR
             mdat1   = DMPDAT
             motp1   = DMPFAK
             mosn1   = Round(mosn1 + DMPVSP,2)
             mpor1   = Round(mpor1 + DMPPPK,2)
             moddob1 = Round(moddob1 + DMPPPD,2)
             mraz1   = Round(mraz1 + DMPRAZ,2)
             mzakup1 = Round(mzakup1 + DMPPPK,2)
        CASE DMPPOR = 0
             mtar2   = DMPTAR
             mStop2  = DMPPOR
             mdat2   = DMPDAT
             motp2   = DMPFAK
             mosn2   = Round(mosn2 + DMPVSP,2)
             mpor2   = Round(mpor2 + DMPPPK,2)
             moddob2 = Round(moddob2 + DMPPPD,2)
             mraz2   = Round(mraz2 + DMPRAZ,2)
             mzakup2 = Round(mzakup2 + DMPPPK,2)
      ENDCASE
      SKIP
   ENDDO

   SELECT POREZPIC
   * upis novog, nije ga bilo u porezpic za jednu stopu
   IF mPor + mOddob + mRaz + mOsn <> 0
      APPEND BLANK
      REPLACE KAL  WITH mKal
      REPLACE TAR  WITH mtar
      REPLACE STOP WITH mStop
      REPLACE DAT  WITH mdat
      REPLACE OTP  WITH mOtp
      
      IF mInd = 1
         REPLACE OSN   WITH mosn
         REPLACE POR   WITH Round(mosn * Round(((mstop * 100)/(mstop + 100))/100,4),2)
         REPLACE ODDOB WITH 0
         REPLACE RAZ   WITH Round(mosn * Round(((mstop * 100)/(mstop + 100))/100,4),2)
         REPLACE ZAKUP WITH Round(mosn * Round(((mstop * 100)/(mstop + 100))/100,4),2)
      ENDIF

      IF mInd = 2
         REPLACE OSN   WITH (-1) * mosn
         REPLACE POR   WITH (-1) * Round(mosn * Round(((mstop * 100)/(mstop + 100))/100,4),2)
         REPLACE ODDOB WITH 0
         REPLACE RAZ   WITH (-1) * Round(mosn * Round(((mstop * 100)/(mstop + 100))/100,4),2)
         REPLACE ZAKUP WITH (-1) * Round(mosn * Round(((mstop * 100)/(mstop + 100))/100,4),2)
      ENDIF
      
      IF mInd = 0
         REPLACE OSN   WITH mosn
         REPLACE POR   WITH Mpor
         REPLACE ODDOB WITH mOddob
         REPLACE RAZ   WITH mRaz
         REPLACE ZAKUP WITH mZakup
      ENDIF
   ENDIF

   * upis novog, nije ga bilo u porezpic  za drugu stopu
   IF mPor1 + mOddob1 + mRaz1 + mOsn1 <> 0
      APPEND BLANK
      REPLACE KAL  WITH mKal
      REPLACE TAR  WITH mtar1
      REPLACE STOP WITH mStop1
      REPLACE DAT  WITH mdat1
      REPLACE OTP  WITH mOtp1
      
      IF mInd = 1
         REPLACE OSN   WITH mosn1
         REPLACE POR   WITH Round(mosn1 * Round(((mstop1 * 100)/(mstop1 + 100))/100,4),2)
         REPLACE ODDOB WITH 0
         REPLACE RAZ   WITH Round(mosn1 * Round(((mstop1 * 100)/(mstop1 + 100))/100,4),2)
         REPLACE ZAKUP WITH Round(mosn1 * Round(((mstop1 * 100)/(mstop1 + 100))/100,4),2)
      ENDIF

      IF mInd = 2
         REPLACE OSN   WITH (-1) * mosn1
         REPLACE POR   WITH (-1) * Round(mosn1 * Round(((mstop1 * 100)/(mstop1 + 100))/100,4),2)
         REPLACE ODDOB WITH 0
         REPLACE RAZ   WITH (-1) * Round(mosn1 * Round(((mstop1 * 100)/(mstop1 + 100))/100,4),2)
         REPLACE ZAKUP WITH (-1) * Round(mosn1 * Round(((mstop1 * 100)/(mstop1 + 100))/100,4),2)
      ENDIF

      IF mInd = 0
         REPLACE OSN   WITH mosn1
         REPLACE POR   WITH Mpor1
         REPLACE ODDOB WITH mOddob1
         REPLACE RAZ   WITH mRaz1
         REPLACE ZAKUP WITH mZakup1
      ENDIF
   ENDIF
   
   * upis novog, nije ga bilo u porezpic  za trecu  stopu
   IF mPor2 + mOddob2 + mRaz2 + mOsn2 <> 0
      APPEND BLANK
      REPLACE KAL  WITH mKal
      REPLACE TAR  WITH mtar2
      REPLACE STOP WITH mStop2
      REPLACE DAT  WITH mdat2
      REPLACE OTP  WITH mOtp2
      
      IF mInd = 1
         REPLACE OSN   WITH mosn2
         REPLACE POR   WITH Round(mosn2 * Round(((mstop2 * 100)/(mstop2 + 100))/100,4),2)
         REPLACE ODDOB WITH 0
         REPLACE RAZ   WITH Round(mosn2 * Round(((mstop2 * 100)/(mstop2 + 100))/100,4),2)
         REPLACE ZAKUP WITH Round(mosn2 * Round(((mstop2 * 100)/(mstop2 + 100))/100,4),2)
      ENDIF

      IF mInd = 2
         REPLACE OSN   WITH (-1) * mosn2
         REPLACE POR   WITH (-1) * Round(mosn2 * Round(((mstop2 * 100)/(mstop2 + 100))/100,4),2)
         REPLACE ODDOB WITH 0
         REPLACE RAZ   WITH (-1) * Round(mosn2 * Round(((mstop2 * 100)/(mstop2 + 100))/100,4),2)
         REPLACE ZAKUP WITH (-1) * Round(mosn2 * Round(((mstop2 * 100)/(mstop2 + 100))/100,4),2)
      ENDIF

      IF mInd = 0
         REPLACE OSN   WITH mosn2
         REPLACE POR   WITH Mpor2
         REPLACE ODDOB WITH mOddob2
         REPLACE RAZ   WITH mRaz2
         REPLACE ZAKUP WITH mZakup2
      ENDIF
   ENDIF

   SELECT DMPDAT
ENDDO

CLOSE DATABASES
RETURN
