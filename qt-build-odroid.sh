
sudo apt-get install build-essential perl python git

sudo apt-get install "^libxcb.*" libx11-xcb-dev libglu1-mesa-dev libxrender-dev

sudo apt-get install libgles2-mesa-dev libdbus-1-dev libatspi2.0-dev

echo "WebKit"
sudo apt-add-repository ppa:u-szeged/sedkit && sudo apt-get update && sudo apt-get install sedkit-env-qtwebkit
sudo apt-get install flex bison gperf libicu-dev libxslt-dev ruby

# libasound2-dev libgstreamer-plugins-base0.10-dev 
sudo apt-get install libxkbcommon-dev

git clone --depth 1 git://gitorious.org/qt/qt5.git qt5

cd qt5
perl init-repository

#mkdir -p qtbase/src/gui/.pch/release-shared/ 
#touch qtbase/src/gui/.pch/release-shared/Qt5Gui


./configure -v -release -opensource -confirm-license -opengl es2 -eglfs -qt-xcb -nomake examples -nomake tests

# Some patches
#http://qt-project.org/forums/viewthread/20202

# Additional configure http://qt-project.org/forums/viewthread/12008
# ./configure -opensource -arch arm -xplatform ??????? -release -opengl es2 -little-endian -nomake docs -no-svg -no-audio-backend -no-multimedia -no-xmlpatterns -no-v8 -no-location -no-declarative -no-cups -xcb -no-wayland -no-phonon -no-qt3support -no-webkit -no-javascript-jit -no-neon -confirm-license -verbose -qpa -no-gtkstyle

#I read already this thread: Qt5 on linux arm – xcb platform plugin not working [developer.qt.nokia.com]
#but I don’t know where exactly and how he got the linux-g++-mx5x compiler.

#Patch init-repository
#561     if ($do_clone) {
#562         $self->exe('git', 'clone', @reference_args, ($mirror ? $mirror : $url), $submodule);
#563     }
#
# ADD before 562 
# @reference_args = (("--depth", "1") , @reference_args);
#@reference_args = (("--depth", "1") , @reference_args);

