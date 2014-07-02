#!/bin/bash

show_header() {
    echo -e "\r\n\r\n========== $1 =========="
}

# Командя для инсталлирования через APT
apt_install() {
    apt-get -yq --force-yes install $@
}


# Действия, которые нужно запустить до начала инсталляции
preinstall_actions() {
    apt-get update
    apt-get -yq --force-yes upgrade
    apt-get -yq --force-yes dist-upgrade
}

postinstall_actions() {
    apt-get -yq --force-yes autoremove
}


# Общие пакеты, которые должны быть в кажой системе
# Не зависят от рабочего стола (gtk или qt), Firefox - это исключение :)
common_packages() {
    show_header "**BUNTU common packages"

    show_header "System Tools"
    apt_install mc vim default-jre icedtea-plugin java-common ntfs-3g ntfs-config
    #ntfsprogs

    show_header "Office"
    apt_install libreoffice clamav ttf-mscorefonts-installer p7zip p7zip-full p7zip-rar unrar xchm
    
    show_header "Spell Check"
    apt_install aspell aspell-en aspell-uk aspell-ru aspell-doc myspell-ru myspell-en-gb myspell-en-us myspell-uk

    show_header "Network"
    apt_install flashplugin-installer firefox

    apt_install network-manager-pptp network-manager-vpnc network-manager-openvpn smbfs smbclient

    show_header "Multimedia"
    apt_install lame vlc
    apt_install libavcodec-extra  libavformat-extra-54
}

# Теже самые общие пакеты, только для Debian
debian_common_packages() {
    show_header "COMMON DEBIAN squeeze"

    show_header "System"
    apt_install default-jre openjdk-6-jre icedtea6-plugin java-common
    apt_install sun-java6-jre sun-java6-plugin ntfs-3g ntfsprogs gdeb

    show_header "File sharing"
    apt_install smbfs smbclient

    show_header "Network"
    apt_install telepathy-haze filezilla
    #apt-get remove usbmount
    #apt_install pmount

    show_header "Office"
#    apt_install openoffice.org openoffice.org-l10n-ru openoffice.org-thesaurus-ru openoffice.org-help-ru
    apt_install ttf-mscorefonts-installer p7zip p7zip-full p7zip-rar unrar xchm clamav

    show_header "Multimedia"
    apt_install flashplugin-nonfree
    apt_install ffmpeg libavdevice53  libswscale0 vlc
    apt_install gstreamer-tools gstreamer0.10-plugins-base gstreamer0.10-plugins-ugly gstreamer0.10-plugins-bad gstreamer0.10-fluendo-mpegmux gstreamer0.10-fluendo-mp3 gnash
}

# GTK Приложения необходимые для KDE4
kde_gtk() {
    show_header "GTK usefull apps for KDE4"
    apt_install inkscape
    apt_install gimp  gnash pyrenamer easytag filezilla 
    # acroread acroread-fonts
    apt_install frefox
    apt_install synaptic
}


# GTK+ Приложения общие для GNOME и XFCE
gtk_packages() {
    show_header "GTK apps for Gnome/Xfce"

    show_header "Office and graphics"
    apt_install libreoffice-gtk gimp inkscape acroread acroread-fonts chmsee clamtk tuxcmd

    show_header "Multimedia"
    apt_install gstreamer-tools gstreamer0.10-plugins-base gstreamer0.10-plugins-ugly gstreamer0.10-plugins-bad  gstreamer0.10-fluendo-mp3 gstreamer0.10-alsa gstreamer0.10-pulseaudio swfdec-gnome

    apt_install avidemux avidemux-plugins-gtk
    apt_install pyrenamer easytag easytag-aac
    #gnash gstreamer0.10-fluendo-mpegmux
    #tagtool

    show_header "Network"
    apt_install filezilla filezilla-common mozilla-plugin-vlc

    show_header "System"
    apt_install synaptic
}

# Unity to Xubuntu migration
UNITY_TO_XUBUNTU() {

    # FIXME: тут что-то не так скорее всего
    apt-get -yq --force-yes purge unity unity-* lightdm nautilus gnome-* gedit file-roller

    INSTALL_XUBUNTU_PACKAGES

    rm -Rf /etc/lightdm

    apt_install lightdm

    echo "\nCompleted. Run xfce installation profile."
}


# Install Xubuntu desktop
INSTALL_XUBUNTU_PACKAGES() {

    preinstall_actions

    apt_install xubuntu-desktop xubuntu-default-settings

    apt-get -yq --force-yes purge gnumeric abiword

    #XFCE env configure
    common_packages

    apt_install xubuntu-restricted-extras xfce4-artwork xfce4-wmdock-plugin xfce4-indicator-plugin xfce4-xkb-plugin

    gtk_packages

    show_header "OFFICE"

    apt_install xarchiver stardict-gtk thunar-thumbnailers thunar-media-tags-plugin thunar-volman thunar-archive-plugin ffmpegthumbnailer

    postinstall_actions
}

# ЗАПУСКАЕМ ПРОЦЕСС
if [[ $EUID -ne 0 ]]; then # Пользователь не root
  echo "This script must be run as root" 1>&2
  exit 1
else # Все ок начинаем выборку

  case "$1" in


    kde) # KDE DESKTOP
        preinstall_actions
        # KDE Env configure
        common_packages
        kde_gtk

        show_header  "KDE4 PACKAGES"
        apt_install kubuntu-restricted-extras kde-style-qtcurve gtk2-engines-qtcurve gtk2-engines-oxygen gtk3-engines-oxygen kwin-style-qtcurve

        show_header "KDE4 OFFICE"
        apt_install k3b smb4k kdf qstardict krusader kchmviewer ksnapshot partitionmanager

        show_header "KDE4 NET"
        apt_install ktorrent kget  kvpnc kdenetwork-filesharing 

        show_header "KDE4 MULTIMEDIA"
        apt_install kipi-plugins smplayer smplayer-themes smplayer-translations avidemux-qt avidemux-common avidemux-plugins-qt kid3 klash phonon-backend-vlc ffmpegthumbs
	# mplayerthumbs 	
        apt_install digikam showfoto
        #apt_install krita krita-plugins
        
        apt_install kdeplasma-addons
	
	show_header "REMOVE UNITY FEATURES"
	apt-get remove -yq --force-yes firefox-globalmenu thunderbird-globalmenu appmenu-gtk appmenu-gtk3 appmenu-qt

	show_header "REMOVE SOME PACKAGES"
	apt-get remove -yq --force-yes gnash
	
	postinstall_actions
      ;;

    gnome) #GNOME DESKTOP
        preinstall_actions

        # GNOME env configure
        common_packages

        gtk_packages

        apt_install ubuntu-restricted-extras

        show_header "GNOME OFFICE"
        apt_install libreoffice-gnome nautilus-clamscan stardict-gnome nautilus-share

#        show_header "GNOME MULTIMEDIA"
#        apt_install
        # apt-get install xcursor-themes
	# gnome-art gnome-mplayer

	show_header "Gnome shell"
	apt_install gnome_shell myunity gnome-tweak-tool gconf-editor

        postinstall_actions
      ;;

    fixunity)
	show_header "Unity Fix"
        add-apt-repository ppa:diesch/testing
        apt-get update
	apt_install install unsettings
	
	#apt-get -yq --force-yes purge liboverlay-scrollbar*
	#apt-get -yq --force-yes purge appmenu-gtk appmenu-gtk3 firefox-globalmenu appmenu-qt


      ;;
    xfce) #XFCE DESKTOP
        INSTALL_XUBUNTU_PACKAGES
      ;;
    unity2xubuntu)
        UNITY_TO_XUBUNTU
      ;;
    debian) #DEBIAN DESKTOP
        preinstall_actions
        debian_common_packages
        postinstall_actions
      ;;
    LTS) #LTS release

        preinstall_actions

        show_header "**LTS 10.04 maverick install"

        show_header "System Tools"
        apt_install vim default-jre openjdk-6-jre icedtea6-plugin java-common ntfs-3g ntfs-config synaptic
	#ntfsprogs

        apt_install ubuntu-restricted-extras

        show_header "Office"
        apt_install openoffice.org openoffice.org-gtk clamav ttf-mscorefonts-installer p7zip p7zip-full p7zip-rar unrar xchm
        apt_install openoffice.org-gnome nautilus-clamscan stardict-gnome nautilus-share

        show_header "Office and graphics"
        apt_install  gimp inkscape acroread acroread-fonts chmsee clamtk tuxcmd

        show_header "Spell Check"
        apt_install aspell aspell-en aspell-uk aspell-ru aspell-doc myspell-ru myspell-en-gb myspell-en-us myspell-uk

        show_header "Network"
        #adobe-flashplugin
        apt_install flashplugin-installer flashplugin-nonfree-extrasound firefox mozilla-firefox-adblock firebug
        apt_install network-manager-pptp network-manager-vpnc network-manager-openvpn smbfs smbclient
        apt_install filezilla filezilla-common mozilla-mplayer

        show_header "Multimedia"
        apt_install lame mplayer-nogui vlc
        apt_install ffmpeg libavdevice-extra-53 libavcodec-extra-53 libavformat-extra-53 libavfilter2 libswscale2 libpostproc-extra-51
        apt_install gstreamer-tools gstreamer0.10-plugins-base gstreamer0.10-plugins-ugly gstreamer0.10-plugins-bad  gstreamer0.10-fluendo-mp3 gstreamer0.10-plugins-alsa gstreamer0.10-plugins-pulse swfdec-gnome
        apt_install avidemux avidemux-plugins
        apt_install pyrenamer easytag easytag-aac
        #gnash gstreamer0.10-fluendo-mpegmux
        #tagtool
        apt_install gnome-art gnome-mplayer

        # apt-get install xcursor-themes
        postinstall_actions
      ;;

    *)
      echo "Usage: $0 {kde|gnome|xfce|LTS|debian|fixunity}"
      ;;
  esac

fi

exit 0
