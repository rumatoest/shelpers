#!/bin/bash
#Remove flash from ubuntu

sudo apt-get remove -y --purge flashplugin-installer gnash gnash-common libflashsupport mozilla-plugin-gnash nspluginwrapper swfdec-mozilla adobe-flashplugin 
sudo rm -f /usr/lib/mozilla/plugins/*flash* ~/.mozilla/plugins/*flash*so /usr/lib/firefox-addons/plugins/libflashplayer.so /usr/lib/mozilla/plugins/libflashplayer.so ~/.wine/dosdevices/c:/windows/system32/Macromed/Flash /usr/lib/chromium-browser/plugins/libflashplayer.so /usr/lib/flashplugin-installer/libflashplayer.so /usr/share/ubufox/plugins/libflashplayer.so 
sudo dpkg -r --force-remove-reinstreq flashplugin-nonfree 
sudo rm -f /usr/lib/mozilla/plugins/flashplugin-alternative.*
