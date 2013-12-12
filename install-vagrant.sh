#!/bin/bash
#Compatible only with debian based distributions

VV=1.3.5

echo "Trying to install Vagrant $VV"

echo "Note that you should install virtualbox first"

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "Script \"`basename $0`\" must be run as root" 1>&2
   exit 1
fi

ARCH=i686

if [ "`uname -i`" == "x86_64" ]; then
    ARCH="x86_64"
fi

DIR=`mktemp -d`
FILE="vagrant_${VV}_${ARCH}.deb"

wget -O $DIR/$FILE http://files.vagrantup.com/packages/a40522f5fabccb9ddabad03d836e120ff5d14093/$FILE

dpkg -i $DIR/$FILE

apt-get -f install

rm -Rf $DIR