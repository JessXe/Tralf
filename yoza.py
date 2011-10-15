#!/usr/bin/python

import os.path
import sys
from subprocess import call
import subprocess

class DisplayModule():
    def __init__(self, filename):
        """Initiate Attributes"""
        self.Git = GitManager(filename)
        self.cur_frame = 0
        self.max_frame = self.Git.fCount()

    def nFrame(self):
        """Advance to next History Frame
        Returns Frame Record

        """
        self.cur_frame += 1
        if not self._atMax():
            return self.getCurFrame()
        else: self.cur_frame -= 1
            #Probably should throw an exception here

    def pFrame(self):
        """Regress to previous History Frame
        Returns Frame Record

        """
        self.cur_frame -= 1
        if not self._atMin():
            return self.getCurFrame()
        else: self.cur_frame += 1
            #Probably should throw an exception here

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
        if self.atMax() or self.atMin(): return True
        else: return False

    def _atMax(self):
        if self.cur_frame >= self.max_frame: return True
        else: return False
        
    def _atMin(self):
        if self.cur_frame < 0: return True
        else: return False

#open_session()
#close_session()
#display()
#stop_display()
#sync_display()
#get_time()

class DjangoInterface():
    def __init__(self, filename):
        self.Player = DisplayModule(filename)

    def nFrameButton(self):
        return self.Player.nFrame()

    def pFrameButton(self):
        return self.Player.pFrame()

    def jumpTo(self, index):
        return self.Player.iFrame(index)

    def checkFrameNum(self):
        return self.Player.getFrameNum()

    def refresh(self):
        return self.Player.getCurFrame()
#start_playback()
#show_current_version()
#pause()
#reverse_playback()
#jump_next_marker()
#jump_previous_marker()
#show_initial_then_final()
#get_time()
#measure_latency_between_classes()

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
        print "-" + str(self.count) + " Entries-"
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
        print "#  ID|GIT HASH|YEAR-MONTH-DAY|HOUR:MINUTE:SECOND|CHANGE_LOC  #"
        print "#  --|--------|--------------|------------------|----------  #"
        for entry in index:
            print (str(entry[0]) + " | " + entry[1] + " | " + entry[2] + " | " +
                   entry[3] + " | " + str(entry[4]))
        return index
#get_version()
#checkout_repository()
#read_forwards()
#read_backwards()
#read_latest()
#get_time()


#here in the main function we will create a DjangoInterface Object to run the sample.

fname = sys.argv[1]
Interface = DjangoInterface(fname)

#This part will emulate an interface using the frame-by-frame style
mode = 1
u_input = 0
print_height = 30
disp = Interface.refresh()
#print disp[1] + "\nEdit at: " + str(disp[0])
while u_input != 'q':
    i = Interface.checkFrameNum()
    u_input = raw_input(fname+str(i) + ':')

    try:
        i = int(u_input)
        disp = Interface.jumpTo(i)
    except:
        if u_input == 'l':
            mode *= -1

        if mode > 0:
            disp = Interface.nFrameButton()
        else:
            disp = Interface.pFrameButton()

    os.system('clear')
    try:
        print str(disp[0]-(print_height/2))
        t = disp[1].splitlines()
        for j, e in enumerate(t):
            if j + (print_height/2) >= disp[0] and j - (print_height/2) <= disp[0]:
                print e
        print "\n" + str(disp[0]+(print_height/2)) + "\nEdit at line: " + str(disp[0])
        print "Filesize " + str(len(t))
        print str(disp[2]) + " " + str(disp[3]) 
#       print disp[1] + "\nEdit at: " + str(disp[0])
    except: print "At history limit!"
os.chdir("../../")
