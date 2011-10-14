if !has('python')
    echo "Error: Need vim compiled with +python"
    finish
endif

set updatetime=400

let g:idle_counter = 0
function! Idle()
   echo "I am idle!!!! (" .  g:idle_counter . ")"
let fname = expand("%")
python << EOF

import os.path
import vim
import filecmp
from subprocess import call
import subprocess

def check_init(e):
    d = os.path.dirname(e)
    if not os.path.exists(d):
        os.makedirs(d)
        write_H_file(e)
        os.chdir(e)
        call(["git", "init"])
        call(["git", "add", "."])
        call(["git", "commit", "-m", '"Tralf History Initialized"'])
        os.chdir("../../")
    else:
        write_H_file(e)
        os.chdir(e)
        log = subprocess.Popen(["git", "log", "--pretty=oneline"], stderr=subprocess.STDOUT, stdout=subprocess.PIPE)
        count = subprocess.Popen(["wc", "-l"], stderr=subprocess.STDOUT, stdin=subprocess.PIPE)
#       print count.communicate(log.stdout.read())
#       logout = log.communicate()[0]
#       print logout
#       print count.communicate()
        call(["git", "commit", "-am", '"Tralf History"'], stderr=subprocess.STDOUT, stdout=subprocess.PIPE)
        os.chdir("../../")
def write_H_file(d):
    writef = False
    while not writef:
        fname = vim.eval("fname")
        name = fname
        path = d + name
        write = ":w! " + path
    
        try:
            vim.command(write)
            writef = True
        except vim.error:
            writef = False
            print write[3:]
            print vim.error

fname = vim.eval("fname")
hdir = "./.tralf/"
if not os.path.exists(hdir):
    os.makedirs(hdir)
dirname = hdir + "." + fname + "/"  #Check for .tralf/.<fiename>
check_init(dirname)

#In the old version, this was how the current version number was calculated
#while check_filecnt(fname):
#       vim.command("let g:idle_counter = g:idle_counter + 1")

EOF

endfunction

function! Stop()
autocmd! CursorHold
autocmd! CursorHoldI
endfunction


function! Start()
autocmd CursorHold * call Idle()
autocmd CursorHoldI * call Idle()
endfunction


autocmd CursorHold * call Idle()
autocmd CursorHoldI * call Idle()
