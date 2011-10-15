#!/usr/bin/python

import os.path
import sys
from subprocess import call
import subprocess

class DisplayModule():
    def __init__(self, filename):
        self.Git = GitManager(filename)
        self.cur_frame = 0
        self.max_frame = self.Git.fCount()

    def nFrame(self):
        self.cur_frame += 1
        if not self.atMax():
            return self.getCurFrame()
        else: self.cur_frame -= 1

    def pFrame(self):
        self.cur_frame -= 1
        if not self.atMin():
            return self.getCurFrame()
        else: self.cur_frame += 1

    def getCurFrame(self):
        return self.Git.getFrame(self.cur_frame)

    def iFrame(self, index):
        save = self.cur_frame
        self.cur_frame = index
        if not self.outOfRange():
            return self.getCurFrame()
        else: self.cur_frame = save

    def outOfRange(self):
        if self.atMax() or self.atMin(): return True
        else: return False

    def atMax(self):
        if self.cur_frame >= self.max_frame: return True
        else: return False
        
    def atMin(self):
        if self.cur_frame < 0: return True
        else: return False

    def getFrameNum(self):
        return self.cur_frame 

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
        self.fname = filename
        hdir = "./.tralf/"
        if not os.path.exists(hdir):
            print "Error: No Tralf data directory found!"
        self.dirname = hdir + "." + self.fname + "/"  #Check for .tralf/.<fiename>
        os.chdir(self.dirname)
        self.change_index = self.buildTable()

    def buildTable(self):
        #  Soooo. . . this shit here like, pulls up the git log and creates a local table:
        #
        #    ID|GIT HASH|YEAR-MONTH-DAY|HOUR:MINUTE:SECOND    #
        #    --|--------|--------------|------------------    #
        #
        #   It's totally baller
        log = subprocess.Popen(["git", "log", "--pretty=format:%H %ci"], stderr=subprocess.STDOUT, stdout=subprocess.PIPE)
        logblob = log.stdout.read()
        logdata = logblob.splitlines()
        self.count = len(logdata)
        print "-" + str(self.count) + " Entries-"
        index = []
        for i, datum in enumerate(logdata):
            parsed = datum.split(" ")
            record = (self.count - 1 - i, parsed[0], parsed[1], parsed[2])
            index.append(record)
        index.sort()      #Put them in order from Oldest to Newest, for funsies
        print "#    ID|GIT HASH|YEAR-MONTH-DAY|HOUR:MINUTE:SECOND    #"
        print "#    --|--------|--------------|------------------    #"
        for entry in index:
            print str(entry[0]) + " | " + entry[1] + " | " + entry[2] + " | " + entry[3]
        return index

    def getFrame(self, i):
        frame = subprocess.Popen(["git", "show", str(self.change_index[i][1])+":"+self.fname], stderr=subprocess.STDOUT, stdout=subprocess.PIPE)
        return frame.stdout.read()

    def fCount(self):
        return self.count
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
print Interface.refresh()
while u_input != 'q':
    i = Interface.checkFrameNum()
    u_input = raw_input(fname+str(i) + ':')

    try:
        i = int(u_input)
        print Interface.jumpTo(i)
    except:
        if u_input == 'l':
            mode *= -1

        if mode > 0:  print Interface.nFrameButton()
        else: print Interface.pFrameButton()

os.chdir("../../")
