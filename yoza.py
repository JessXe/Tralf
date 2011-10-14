#!/usr/bin/python

import os.path
import sys
from subprocess import call
import subprocess

VER = "v0.3"
class DisplayModule():
    def __init__(self):
        pass

    def get_version():
        return VER
#open_session()
#close_session()
#display()
#stop_display()
#sync_display()
#get_time()

class DjangoInterface():
    def __init__(self):
        pass

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
    def __init__(self):
        pass

#get_version()
#checkout_repository()
#read_forwards()
#read_backwards()
#read_latest()
#get_time()


#Here is some poorly organized code to open the file n shit
fname = sys.argv[1]
hdir = "./.tralf/"
if not os.path.exists(hdir):
    print "Error: No Tralf data directory found!"
dirname = hdir + "." + fname + "/"  #Check for .tralf/.<fiename>
#check_init(dirname)

os.chdir(dirname)
log = subprocess.Popen(["git", "log", "--oneline"], stderr=subprocess.STDOUT, stdout=subprocess.PIPE)
logblob = log.stdout.read()
logdata = logblob.splitlines()
count = len(logdata)
print "-" + str(count) + " Entries-"
change_index = []
for i, datum in enumerate(logdata):
    datum = (count - 1 - i, datum.split(" \"")[0])
    change_index.append(datum)
change_index.sort()
for entry in change_index:
    print str(entry[0]) + ": " + str(entry[1])
#       logout = log.communicate()[0]
#       print logout
#       print count.communicate()
#call(["git", "commit", "-am", '"Tralf History"'], stderr=subprocess.STDOUT, stdout=subprocess.PIPE)
mode = 1
u_input = 0
i = 0
while u_input != 'q' and i < count and i >= 0:
    frame = subprocess.Popen(["git", "show", str(change_index[i][1])+":"+fname], stderr=subprocess.STDOUT, stdout=subprocess.PIPE)
    print frame.stdout.read()
    u_input = raw_input(fname+str(i) + ':')

    try:
        i = int(u_input)
    except:
        if u_input == 'l':
            mode *= -1

        i += 1*mode
os.chdir("../../")
