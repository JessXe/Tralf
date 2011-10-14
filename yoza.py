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
count = subprocess.Popen(["wc", "-l"], stderr=subprocess.STDOUT, stdin=subprocess.PIPE)
logdata = log.stdout.read()
print count.communicate(logdata) # number of changes, I think
print logdata
#       logout = log.communicate()[0]
#       print logout
#       print count.communicate()
#call(["git", "commit", "-am", '"Tralf History"'], stderr=subprocess.STDOUT, stdout=subprocess.PIPE)
os.chdir("../../")
