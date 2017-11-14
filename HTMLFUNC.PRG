***************************************************************
PROCEDURE header(pageTitle, styleName)
   ? "<!DOCTYPE html>"
   ? "<html>"
   ? "   <head>"
   ? "      <title>" + pageTitle + "</title>"
   ? '      <meta http-equiv="Content-Type" content="text/html; charset=utf-8">'
   ? '      <link href="css/style.css" type="text/css" rel="stylesheet" />'
   IF !Empty(styleName)
      ? '      <link href="css/' + styleName + '" type="text/css" rel="stylesheet" />'
   ENDIF
   ? "   </head>"
   ? "   <body>"
RETURN

***************************************************************
PROCEDURE reportBody(cKomintent)
   makeHeader(ckomintent)
   ? '   <div class="report-body">'

   ? '      <p class="button"><a href="kalk.htm">Kalkulacija</a></p>'
   ? '      <p class="button"><a href="nivel.htm">Nivelacija</a></p>'
   ? '      <p class="button"><a href="lagtar.htm">Lager po tarifama</a></p>'
   ? '      <p class="button"><a href="lagnul.htm">Lager sa kolicinom nula</a></p>'

   ? "   </div> <!-- report body -->"
   ? "   </body>"
   ? "</html>"
RETURN

***************************************************************
PROCEDURE makeHeader(cKomintent)
   ? "   <header>"
   ? "      <h1>Izvestaji za: " + cKomintent + "</h1>"
   ? "   </header>"
RETURN

***************************************************************
PROCEDURE backButton()
   
RETURN '      <p class="back button"><a href="pkprint.htm">Nazad</a></p>'
* RETURN '      <p class="back button"><a href="pkprint.htm">&laquo;</a></p>'

***************************************************************
PROCEDURE reloadButton()

* RETURN '      <p class="back button"><a href="pkprint.htm">Ucitaj ponovo</a></p>'
RETURN '      <p class="back button"><a href="pkprint.htm">&raquo;</a></p>'

***************************************************************
PROCEDURE futer
   ? backButton()
   ? "   </body>"
   ? "</html>"
RETURN

***************************************************************
PROCEDURE TBL_El_open(className, indent)
   IF className = ""
      output = "<table>"
   ELSE
      output = '<table class="' + className + '">'
   ENDIF
RETURN Space(indent) + output

***************************************************************
PROCEDURE TBL_El_close(className, indent)
   IF className = ""
      output = "</table>"
   ELSE
      output = "</table> <!--" + className + "-->"
   ENDIF
RETURN Space(indent) + output

***************************************************************
PROCEDURE TR_El_open(className, indent)
   IF className = ""
      output = "<tr>"
   ELSE
      output = '<tr class="' + className + '">'
   ENDIF
RETURN Space(indent) + output

***************************************************************
PROCEDURE TR_El_close(className, indent)
   IF className = ""
      output = "</tr>"
   ELSE
      output = "</tr> <!--" + className + "-->"
   ENDIF
RETURN Space(indent) + output

***************************************************************
PROCEDURE TH_El_Str(cLabel, indent)
   output = "<th>" + Alltrim(cLabel) + "</th>"
RETURN Space(indent) + output

***************************************************************

PROCEDURE TD_El_Num(nNum, nDec, indent)
   output = "<td>" + Alltrim(Str(Round(nNum,nDec),15,nDec)) + "</td>"
RETURN Space(indent) + output

***************************************************************
PROCEDURE TD_El_Str(cLabel, indent)
   output = "<td>" + Alltrim(cLabel) + "</td>"
RETURN Space(indent) + output

***************************************************************
PROCEDURE General_El_Str(cLabel, indent)

RETURN Space(indent) + Alltrim(cLabel)

***************************************************************
