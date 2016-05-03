#!/usr/bin/env python

import os
import sys
import glob
import shutil
from subprocess import Popen, PIPE

bad = ['.git', 'pdfs']

def get_dirs(d):
    return filter(lambda x: os.path.isdir(os.path.join(d, x)), os.listdir(d))


def recurse(d='.'):
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
rec.append('.')
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

    if '/src/' in directory:
        pdfs = [os.path.abspath(p) for p in glob.glob('*.pdf')]
        for pdf in pdfs:
            new_path = pdf.replace('/src/','/pdfs/')
            if not os.path.exists(os.path.split(new_path)[0]):
                os.makedirs(os.path.split(new_path)[0])
            if os.path.exists(new_path):
                os.remove(new_path)
            shutil.copy2(pdf, new_path)
