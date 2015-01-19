#!/bin/bash
# Init kate for working with Python on *buntus
# https://github.com/goinnn/Kate-plugins

sudo apt-get install python-pip

# Recommended deps
# pip install pysmell==0.7.3 pyplete==0.0.2 pep8==0.6.1 pyflakes==0.5.0 pyjslint==0.3.3 simplejson==2.6.1
sudo pip install --upgrade jedi
sudo apt-get install pep8 pyflakes python-simplejson 
sudo pip install pysmell pyplete pyjslint

sudo apt-get install python-kde4 python-jedi

sudo pip install Kate-plugins

ln -s /usr/local/lib/python2.7/dist-packages/kate_plugins/ $(kde4-config --localprefix)/share/apps/kate/pate

