LOCAL kljuc, xx, yy, ratko, zajeb, dijana, ivana
LOCAL pxOsn, pxPor, pxOdDob, pxRaz,	pxZakup,	pxZel

IF ! File("porpicdd.ntx")
	USE POREZPIC
	INDEX ON DtoS(DAT) TO PORPICDD
	USE
ENDIF

SELECT 9
USE POREZPIC INDEX PORPICKT,PORPICKA,PORPICDD

kljuc = wDmpBk + wDmpTar
SEEK kljuc
xx = 0
IF ! Found()
	APPEND BLANK
	REPLACE TAR  WITH wDmpTar
	REPLACE STOP WITH wTarZbir
	REPLACE DAT  WITH wDmpDat
	REPLACE KAL  WITH wDmpBk
	REPLACE OTP  WITH wDmpFak
	REPLACE OSN  WITH wDmpMsp * wDmpKol

	IF wDmpPpd = 0 .AND. wDmpPpk = 0
		xx = (wTarZbir * 100) / (100 + wTarZbir)
		ratko = (xx / 100) * wDmpMsp * wDmpKol
		zajeb = wTarZbir
		IF wTarZbir = 0
			zajeb = 1
		ENDIF
		dijana = wvoz / zajeb
		ivana = dijana * ratko
		REPLACE ZEL WITH ivana * 0
		REPLACE POR WITH ratko * 0
	ELSE
		ratko = wDmpPpk - wDmpPpd
		zajeb = wTarZbir
		IF wTarZbir = 0
			zajeb = 1
		ENDIF
		dijana = wVoz / zajeb
		ivana = dijana * ratko * wDmpKol
		REPLACE ZEL WITH ivana * 0
		REPLACE POR WITH wDmpPpk
	ENDIF

	REPLACE ODDOB WITH wDmpPpd
	REPLACE ZAKUP WITH wDmpPpk
	REPLACE RAZ WITH Round(wDmpPpk - wDmpPpd,2)

	yy = 0
	IF ! POR = 0
		yy = POR - ivana
	ENDIF

	IF ! RAZ = 0
		yy = RAZ - ivana
	ENDIF
ELSE
	pxOsn   = OSN
	pxPor   = POR
	pxOdDob = ODDOB
	pxRaz   = RAZ
	pxZakup = ZAKUP
	pxZel   = ZEL
	pxOsn   = pxOsn + wDmpMsp * wDmpKol

	IF wDmpPpk = 0 .and. wDmpPpd = 0
		xx = (wTarZbir * 100) / (wTarZbir + 100)
		ratko = (xx / 100) * wDmpMsp * wDmpKol
		pxPor =  pxPor + wDmpPpk
		zajeb = wTarZbir
		IF wTarZbir = 0
			zajeb = 1
		ENDIF
		dijana = wvoz / zajeb
		ivana = dijana *  ratko
		pxZel = pxZel + ivana
	ELSE
		ratko = wDmpPpk - wDmpPpd
		zajeb = wTarZbir
		IF wTarZbir = 0
			zajeb = 1
		ENDIF
		dijana = wvoz / zajeb
		ivana = dijana * ratko
		pxZel = pxZel + ivana * wDmpKol * 0
		pxRaz = pxRaz + ratko
		pxPor = pxPor + wDmpPpk
	ENDIF

	yy = 0
	pxOdDob = pxOdDob + wDmpPpd
	pxZakup = pxZakup + wDmpPpk

	REPLACE OSN   WITH pxOsn
	REPLACE POR   WITH pxPor
	REPLACE ODDOB WITH pxOdDob
	REPLACE ZAKUP WITH pxZakup
	REPLACE RAZ   WITH pxRaz
	REPLACE ZEL   WITH pxZel

	IF  pxPor = 0
		yy = pxPor - pxZel
	ENDIF

	IF ! pxRaz = 0
		yy = pxRaz - pxZel
	ENDIF
ENDIF

USE

RETURN
