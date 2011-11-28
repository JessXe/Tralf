#!/usr/bin/python

import sys
import yoza

print "OK"

fname = sys.argv[1]
Interface = yoza.DisplayModule(fname)

print Interface.getCurFrame()
while 1==1:
    try: print Interface.nFrame()
    except EOFError as e: break

frame = Interface.iFrame(1)
html = "<section id=\"tralf_data\" hidden>\n"
tab = "    "
while 1==1:
    html_line = (tab + "<div class=\"frame\">\n" +
                 tab + tab + "<div class=\"edit_loc\">" +
                 str(frame[0]) + "</div>\n" +
                 tab + tab + "<div class=\"date\">" +
                 str(frame[2]) + "</div>\n" +
                 tab + tab + "<div class=\"time\">" +
                 str(frame[3]) + "</div>\n" +
                 tab + "</div>\n")

    html += html_line
    try: frame = Interface.nFrame()
    except EOFError as e: break

html += "</section>"
print html
