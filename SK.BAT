@echo off

echo.
echo Kompajliram CPL fajlove...
echo.

for %%F in (*.clp) do CLIPPER @%%F

echo.
echo Uspesna kompilacija!
echo Pozivam linker...
echo.

RTLINK @KOMSTR.LNK

echo.
echo Zavrseno.
