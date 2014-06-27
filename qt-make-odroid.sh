#!/bin/bash

./configure -prefix /opt/qt5.1/ -v -release -opensource -confirm-license -opengl es2 -eglfs -qt-xcb -nomake examples -nomake tests

# Fix unknown bug
mkdir -p qtbase/src/gui/.pch/release-shared/ 
touch qtbase/src/gui/.pch/release-shared/Qt5Gui

make
