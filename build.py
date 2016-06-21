#!/usr/bin/env python

import os
import sys
import glob
import shutil
from subprocess import Popen, PIPE

bad = ['.git']

def get_dirs(d):
    return filter(lambda x: os.path.isdir(os.path.join(d, x)), os.listdir(d))


def recurse(d='assignments/'):
    l = []
    dirs = get_dirs(d)
    for subdir in dirs:
        full = os.path.join(d, subdir)
        if full[2:] not in bad:
            l.append(full)
            l.extend(recurse(d=full))
    return l

# Change directory to path of script
initpath = os.path.dirname(os.path.realpath(__file__))
os.chdir(initpath)

# Run make on subdirectories
rec = recurse()
rec.append('interview-prep/')
r = [os.path.abspath(p) for p in rec]
mpath = os.path.abspath('Makefile')
for directory in r:
    os.chdir(directory)
    print(directory)
    if len(sys.argv) == 1:
        p = Popen('make -f ' + mpath, shell=True, stdout=PIPE, stderr=PIPE)
    else:
        p = Popen('make -f ' + mpath + ' ' + sys.argv[1],
                  shell=True, stdout=PIPE, stderr=PIPE)
    (out, err) = p.communicate()
    print(out)