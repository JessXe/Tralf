#!/usr/bin/python

import sys
import os.path
import sys
from subprocess import call
import subprocess
import HTML_CONV

class DisplayModule():
    def __init__(self, filename):
        """Initiate Attributes"""
        self.Git = GitManager(filename)
        self.cur_frame = 0
        self.max_frame = self.Git.fCount()

    def testEnd(self):
        if self._atMax(): return True
        else: return False

    def nFrame(self):
        """Advance to next History Frame
        Returns Frame Record

        """
        self.cur_frame += 1
        if not self._atMax():
            return self.getCurFrame()
        else:
            self.cur_frame -= 1
            #Probably should throw an exception here
            raise EOFError("File History end reached")

    def pFrame(self):
        """Regress to previous History Frame
        Returns Frame Record

        """
        self.cur_frame -= 1
        if not self._atMin():
            return self.getCurFrame()
        else:
            self.cur_frame += 1
            #Probably should throw an exception here
            raise EOFError("File History beginning reached")

    def getCurFrame(self):
        """Return current History Frame
        Returns Frame Record

        """
        return self.Git.getFrame(self.cur_frame)

    def iFrame(self, index):
        """Return History Frame at index
        Returns Frame Record

        """
        save = self.cur_frame
        self.cur_frame = index
        if not self._outOfRange():
            return self.getCurFrame()
        else: self.cur_frame = save
            #Probably should throw an exception here

    def getFrameNum(self):
        return self.cur_frame 

    def _outOfRange(self):
        if self._atMax() or self._atMin(): return True
        else: return False

    def _atMax(self):
        if self.cur_frame >= self.max_frame: return True
        else: return False
        
    def _atMin(self):
        if self.cur_frame < 0: return True
        else: return False


class GitManager():
    def __init__(self, filename):
        """Initiate Attributes"""
        self.fname = filename
        hdir = "./.tralf/"
        if not os.path.exists(hdir):
            print "Error: No Tralf data directory found!"
        self.dirname = hdir + "." + self.fname + "/"  #Check for .tralf/.<fiename>
        os.chdir(self.dirname)
        self.change_index = self._buildTable()

    def getFrame(self, i):
        """Return History Frame at index i
        Returns Frame Record

        """
        frame = subprocess.Popen(["git", "show",
                                  str(self.change_index[i][1])+":"+self.fname],
                                  stderr=subprocess.STDOUT,
                                  stdout=subprocess.PIPE)
        record = self.change_index[i]
        linenum = record[4]
        date = record[2]
        time = record[3]
        return [linenum, frame.stdout.read(), date, time]

    def fCount(self):
        """Returns number of History Frames"""
        return self.count

    def _buildTable(self):
        # Soooo. . . this shit here like, pulls up the git log and creates
        # a local table:
        #
        #   ID|GIT HASH|YEAR-MONTH-DAY|HOUR:MINUTE:SECOND|CHANGE_LOC    #
        #   --|--------|--------------|------------------|----------    #
        #
        #  It's totally baller
        log = subprocess.Popen(["git", "log", "--pretty=format:%H %ci"],
                               stderr=subprocess.STDOUT, stdout=subprocess.PIPE)
        logblob = log.stdout.read()
        logdata = logblob.splitlines()
        self.count = len(logdata)
        #print "-" + str(self.count) + " Entries-"
        index = []
        for i, datum in enumerate(logdata):
            parsed = datum.split(" ")
            record = [self.count - 1 - i, parsed[0], parsed[1], parsed[2]]
            index.append(record)
        index.sort()      #Put them in order from Oldest to Newest, for funsies
        for entry in index:
            i = entry[0]
            if i > 0:
                linechange = subprocess.Popen(["git", "diff", "--unified=1",
                                               str(entry[1]),
                                               str(index[i-1][1])],
                                               stderr=subprocess.STDOUT,
                                               stdout=subprocess.PIPE)
            else: linechange = subprocess.Popen(["git", "diff", "--unified=1",
                                                 str(entry[1]),
                                                 str(index[i+1][1])],
                                                 stderr=subprocess.STDOUT,
                                                 stdout=subprocess.PIPE)
            lc = linechange.stdout.read()
            try:
                linenum =  int(lc.splitlines()[4][4:].split(",")[0]) + 1
            except: linenum = 0
            entry.append(linenum)
        #print "#  ID|GIT HASH|YEAR-MONTH-DAY|HOUR:MINUTE:SECOND|CHANGE_LOC  #"
        #print "#  --|--------|--------------|------------------|----------  #"
#       for entry in index:
            #print (str(entry[0]) + " | " + entry[1] + " | " + entry[2] + " | " +
#                  entry[3] + " | " + str(entry[4]))
        return index

#print "OK"

fname = sys.argv[1]
Interface = DisplayModule(fname)


frame = Interface.iFrame(0)
tab = "    "
html = "<section id=\"tralf_data\" hidden>\n"
i = 0
while 1==1:
    html_line = (tab + "<div id=\"f" + str(i) + "\"" +
                 "class=\"frame\">\n" +
                 tab + tab + "<div class=\"edit_loc\">" +
                 str(frame[0]) + "</div>\n" +
                 tab + tab + "<div class=\"date\">" +
                 str(frame[2]) + "</div>\n" +
                 tab + tab + "<div class=\"time\">" +
                 str(frame[3]) + "</div>\n")
    cont = frame[1].split('\n')
    html_cont = ""
    for line in cont: html_cont += HTML_CONV.plaintext2html(line) + "<br>"
    html_cont += "\n"
    html_line += (tab + tab + "<div class=\"content\">" +
                 html_cont + tab + tab + "</div>\n" +
                 tab + "</div>\n")

    html += html_line
    i += 1
    try: frame = Interface.nFrame()
    except EOFError as e: break

html += "</section>"
print html
