#!/bin/bash

NV=7.4

echo "INSTALLING Nebeans SE v$NV"
echo "Expecting that you will install netbeans in /opt/netbeans-$NV"

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "ERROR! This script must be run as root." 1>&2
   exit 1
fi

TDIR=`mktemp -d`
FILE="netbeans-$NV-javase-linux.sh"

wget -O $TDIR/$FILE http://download.netbeans.org/netbeans/7.4/final/bundles/$FILE

mkdir -p /opt/netbeans-$NV

sh $TDIR/$FILE

rm -Rf $DIR 

sed -i "s/netbeans_default_options=\"/netbeans_default_options=\"--locale en:US --laf javax.swing.plaf.metal.MetalLookAndFeel /g" /opt/netbeans-$NV/etc/netbeans.conf