#!/bin/bash

if [ $(id -u) = 0 ]; then
   echo "This script changes your users gsettings and should thus not be run as root!"
   echo "You may need to enter your password multiple times!"
   exit 1
fi


# This function creates a .tar archive of `$XDG_CONFIG_HOME/.themes` so it can be sent over to say (nextcloud/dropbox/gdrive/github) and then pulled over later instead of manually reinstalling every theme over.
# This is currently unused but thrown here as a reference, copy pasta and it will work :)
function backup_installed_themes(){
    outfile="$HOME/themes.tar.xz" && themes_dir="$HOME/.themes" && if [ -d "$themes_dir" ]; then rm -f "$outfile"; tar cfJ $outfile $themes_dir && sleep 1 && printf "\n\nDone backing up themes directory to file $outfile\n\n" && cd $curdir; fi
}


###
# Optionally clean all dnf temporary files
###

sudo dnf clean all

###
# RpmFusion Free Repo
# This is holding only open source, vetted applications - fedora just cant legally distribute them themselves thanks to 
# Software patents (also install non-free repo because my soul is dark :p)
###

sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

###
# Disable the Modular Repos
# So far they are pretty empty, and sadly can muck with --best updates
# Reenabling them at the end for future use
###

sudo sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/fedora-updates-modular.repo
sudo sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/fedora-modular.repo


###
# Force update the whole system to the latest and greatest
###

sudo dnf upgrade --best --allowerasing --refresh -y
# And also remove any packages without a source backing them
# If you come from the Fedora 30 Future i'll check if this is still optimal before F30 comes out.
sudo dnf distro-sync -y

###
# Install base packages and applications
###

sudo dnf install \
-y \
arc-theme `#A more comfortable GTK/Gnome-Shell Theme` \
blender `#3D Software Powerhouse` \
breeze-cursor-theme `#A more comfortable Cursor Theme from KDE` \
calibre `#Ebook management` \
chrome-gnome-shell `#Gnome <> Browser Integration for the gnome plugins website` \
chromium-vaapi `#Comes with hardware acceleration and all Codecs` \
darktable `#Easy RAW Editor` \
evolution-spamassassin `#Helps you deal with spam in Evolution` \
exfat-utils `#Allows managing exfat (android sd cards and co)` \
ffmpeg `#Adds Codec Support to Firefox, and in general` \
file-roller-nautilus `#More Archives supported in nautilus` \
filezilla `#S/FTP Access` \
fuse-exfat `#Allows mounting exfat` \
fuse-sshfs `#Allows mounting servers via sshfs` \
gimp `#The Image Editing Powerhouse - and its plugins` \
gimp-data-extras \
gimp-dbp \
gimp-dds-plugin \
gimp-elsamuko \
gimp-focusblur-plugin \
gimp-fourier-plugin \
gimpfx-foundry.noarch \
gimp-gap \
gimp-high-pass-filter \
gimp-layer-via-copy-cut \
gimp-lensfun \
gimp-lqr-plugin \
gimp-luminosity-masks \
gimp-paint-studio \
gimp-resynthesizer \
gimp-save-for-web \
gimp-wavelet-decompose \
gimp-wavelet-denoise-plugin \
git `#VCS done right` \
gmic-gimp \
gnome-shell-extension-dash-to-dock `#dash for gnome` \
gnome-shell-extension-topicons-plus `#Notification Icons for gnome` \
gnome-shell-extension-user-theme `#Enables theming the gnome shell` \
gnome-tweak-tool `#Your central place to make gnome like you want` \
GREYCstoration-gimp \
gtkhash-nautilus `#To get a file has via gui` \
gvfs-fuse `#gnome<>fuse` \
gvfs-mtp `#gnome<>android` \
gvfs-nfs `#gnome<>ntfs` \
gvfs-smb `#gnome<>samba` \
htop `#Cli process monitor` \
inkscape  `#Working with .svg files` \
kdenlive  `#Advanced Video Editor` \
keepassxc  `#Password Manager` \
krita  `#Painting done right keep in mind mypaint and gimp cant work together in current upstream versions - yet` \
libreoffice-gallery-vrt-network-equipment `#Network Icon Preset for LibreOffice` \
lm_sensors `#Show your systems Temparature` \
'mozilla-fira-*' `#A nice font family` \
mpv `#The best media player (with simple gui)` \
mumble `#Talk with your friends` \
nautilus-extensions `#What it says on the tin` \
nautilus-image-converter \
nautilus-search-tool \
NetworkManager-openvpn-gnome `#To enforce that its possible to import .ovpn files in the settings` \
openshot `#Simple Video Editor` \
openssh-askpass `#Base Lib to let applications request ssh pass via gui` \
p7zip `#Archives` \
p7zip-plugins `#Even more of them` \
pop-icon-theme `#The Icon theme from system76, which is quite nice` \
pv `#pipe viewer - see what happens between the | with output | pv | receiver ` \
python3-devel `#Python Development Gear` \
python3-neovim `#Python Neovim Libs` \
rawtherapee `#Professional RAW Editor` \
spamassassin `#Dep to make sure it is locally installed for Evolution` \
telegram-desktop `#Chatting, with newer openssl and qt base!` \
tilix `#The best terminal manager i know of` \
tilix-nautilus `#Adds right click open in tilix to nautilus` \
transmission `#Torrent Client` \
tuned `#Tuned can optimize your performance according to metrics. tuned-adm profile powersave can help you on laptops, alot` \
unar `#free rar decompression` \
vagrant `#Virtual Machine management and autodeployment` \
vagrant-libvirt `#integration with libvirt` \
virt-manager `#A gui to manage virtual machines` \
wavemon `#a cli wifi status tool` \
youtube-dl `#Allows you to download and save youtube videos but also to open their links by dragging them into mpv!`


###
# Developer Niceties
###

sudo dnf install \
-y \
ansible `#Awesome to manage multiple machines or define states for systems` \
adobe-source-code-pro-fonts `#The most beautiful monospace font around` \
borgbackup `#If you need backups, this is your tool for it` \
gitg `#a gui for git, a little slow on larger repos sadly` \
iotop  `#disk usage cli monitor` \
meld `#Quick Diff Tool` \
nano `#Because pressing i is too hard sometimes` \
neovim `#the better vim` \
nethogs `#Whats using all your traffic? Now you know!` \
nload `#Network Load Monitor` \
tig `#cli git tool` \
vim-enhanced `#full vim` \
zsh `#Best shell` \
zsh-syntax-highlighting `#Now with syntax highlighting`


###
# These are more targeted to developers/advanced Users/specific usecases, you might want them - or not.
###
sudo dnf install \
-y \
cantata `#A beautiful mpd control` \
caddy `#A quick webserver that can be used to share a directory with others in <10 seconds` \
cockpit `#A An awesome local and remote management tool` \
cockpit-bridge \
fortune-mod `#Inspiring Quotes` \
hexchat `#Irc Client` \
libguestfs-tools `#Resize Vm Images and convert them` \
ncdu `#Directory listing CLI tool. For a gui version take a look at "baobab"` \
nextcloud-client `#Nextcloud Integration for Fedora` \
nextcloud-client-nautilus `#Also for the File Manager, shows you file status` \
sqlite-analyzer `#If you work with sqlite databases` \
sqlitebrowser `#These two help alot` \
syncthing-gtk `#Syncing evolved - to use the local only mode open up the ports with firewall-cmd --add-port=port/tcp --permanent && firewall-cmd --reload`

###
# also install some other "cool" stuff from repos (so free software only :))
###
sudo dnf install \
-y \
adwaita-icon-theme `# install icon themes (packages) found in the repos (probably crazy but meh)` \
adwaita-icon-theme-devel \
bluecurve-icon-theme \
breeze-icon-theme \
breeze-icon-theme-rcc \
deepin-icon-theme \
echo-icon-theme \
elementary-icon-theme \
elementary-icon-theme-gimp-palette \
elementary-icon-theme-inkscape-palette \
elementary-xfce-icon-theme \
evopop-icon-theme \
faience-icon-theme \
fedora-icon-theme \
gnome-colors-icon-theme \
gnome-icon-theme \
gnome-icon-theme-devel \
gnome-icon-theme-extras \
gnome-icon-theme-legacy \
gnome-icon-theme-symbolic \
hicolor-icon-theme \
humanity-icon-theme \
kfaenza-icon-theme \
libreoffice-icon-theme-papirus \
lxde-icon-theme \
mate-icon-theme \
mate-icon-theme-faenza \
mingw32-adwaita-icon-theme \
mingw32-hicolor-icon-theme \
mingw64-adwaita-icon-theme \
mingw64-hicolor-icon-theme \
moka-icon-theme \
mono-icon-theme \
monochrome-icon-theme \
nimbus-icon-theme \
numix-icon-theme \
numix-icon-theme-circle \
numix-icon-theme-square \
nuvola-icon-theme \
oxygen-icon-theme \
paper-icon-theme \
papirus-icon-theme \
tango-icon-theme \
tango-icon-theme-extras \
breeze-cursor-theme \
gnome-shell-extension-gpaste  `# install all GNOME extensions packages available in the repos (crazy, but they're only installed, not enabled, so meh).` \
gnome-shell-extension-common \
gnome-shell-extension-fedmsg \
gnome-shell-extension-netspeed \
gnome-shell-extension-apps-menu \
gnome-shell-extension-gsconnect \
gnome-shell-extension-places-menu \
gnome-shell-extension-window-list \
gnome-shell-extension-refresh-wifi \
gnome-shell-extension-suspend-button \
gnome-shell-extension-disconnect-wifi \
gnome-shell-extension-workspace-indicator \
gnome-shell-extension-do-not-disturb-button \
gnome-shell-extension-activities-configurator \
gnome-shell-extension-dash-to-dock \
gnome-shell-extension-freon \
gnome-shell-extension-drive-menu \
gnome-shell-extension-panel-osd \
gnome-shell-extension-topicons-plus \
gnome-shell-extension-system-monitor-applet \
gnome-shell-extension-media-player-indicator \
gnome-shell-extension-user-theme \
mingw32-nsis `# install lots of other apps/packages (mostly development stuff and some other niceties).` \
java-openjdk `# a lot of stuff below might be repeated from above (lazy to remove dupes, sorry :3).` \
android-tools \
adobe-source-code-pro-fonts \
jq \
codeblocks \
borgbackup \
cscope \
arc-theme \
ShellCheck \
pitivi \
cheese \
diffuse \
meld \
gpick \
mediainfo \
p7zip \
p7zip-plugins \
nautilus-gsconnect \
p7zip-gui \
kdiff3 \
colordiff \
vagrant \
valgrind \
fdupes \
mediawriter \
remmina \
ncdu \
baobab \
yum-utils \
xorg-x11-drv-nvidia-cuda \
obs-studio \
atool \
rofi \
lastpass-cli \
nomacs \
x2goclient \
openvpn \
wireguard \
wireshark \
flameshot \
meson \
ninja-build \
parallel \
rubygem-sass \
sassc \
optipng \
libffi-devel \
gcc \
python-virtualenv \
redhat-rpm-config \
inkscape \
midori \
gtk3-devel \
gdk-pixbuf2-xlib \
bridge-utils \
virt-top \
libguestfs-tools \
libvirt \
virt-install \
qemu-kvm \
glib2-devel \
glib2 \
libxml2-devel \
librsvg2-devel \
gnome-themes-standard \
gtk-murrine-engine \
gtk2-engines \
google-roboto-fonts \
google-noto-sans-fonts \
google-noto-mono-fonts \
qemu-img \
libvirt \
libvirt-python \
libvirt-client \
libguestfs-tools \
gtk3-devel \
gtk2-devel \
gtk+-devel \
dnf-plugins-core \
i3 \
i3status \
dmenu \
i3lock \
xbacklight \
feh \
conky \
emacs \
emacs-rpm-spec-mode \
neofetch \
gparted \
screenfetch \
texlive-scheme-basic \
dkms \
make \
bzip2 \
perl \
filezilla \
automake \
autoconf \
intltool \
libtool \
autoconf-archive \
pkgconfig \
glib2-devel \
binutils \
gcc \
patch \
libgomp \
glib \
glibc-headers \
glibc-devel \
kernel-headers \
kernel-devel \
qt5-qtx11extras \
libxkbcommon \
glib \
ntfs-3g \
cmake \
git \
subversion \
zlib \
libsoup \
vlc \
dpkg \
unzip \
python-vlc \
gimpfx-foundry \
gimp-luminosity-masks \
gimp-fourier-plugin \
gmic \
gmic-gimp \
inkscape \
vokoscreen \
menulibre \
ansible \
tmux \
eclipse \
geany \
blender \
qt-creator \
bless \
onboard \
discord \
hwinfo \
brasero-nautilus \
texmaker \
nmap \
screen \
samba-client \
pandoc \
pandoc-pdf \
calibre \
okular \
gnome-dictionary \
gnome-nettool \
gtkhash \
md5deep \
dconf-editor \
testdisk \
snapd \
thefuck \
cantata \
thunderbird \
guake \
caddy \
WoeUSB \
libXScrnSaver \
chrome-gnome-shell \
chromium \
clementine \
cockpit \
cockpit-bridge \
deja-dup \
deja-dup-nautilus \
duplicity \
easytag \
easytag-nautilus \
evolution-spamassassin \
exfat-utils \
fbreader \
ffmpeg \
file-roller-nautilus \
fortune-mod \
fuse-exfat \
fuse-sshfs \
gimp \
gimp-data-extras \
gimp-dbp \
gimp-dds-plugin \
gimp-elsamuko \
gimp-focusblur-plugin \
gimpfx-foundry.noarch \
gimp-gap \
gimp-high-pass-filter \
gimp-layer-via-copy-cut \
gimp-lensfun \
gimp-lqr-plugin \
gimp-paint-studio \
gimp-resynthesizer \
gimp-save-for-web \
gimp-wavelet-decompose \
gimp-wavelet-denoise-plugin \
gitg \
handbrake \
wxGTK3-devel \
gnome-terminal-nautilus \
curl \
gnome-tweak-tool \
GREYCstoration-gimp \
'gstreamer*good*' \
gtkhash-nautilus \
gvfs-fuse \
gvfs-mtp \
gvim \
gvfs-nfs \
gvfs-smb \
hexchat \
htop \
iotop \
kdenlive \
keepassxc \
krita \
libreoffice-gallery-vrt-network-equipment \
lm_sensors \
mpv \
mumble \
nano \
nautilus-extensions \
nautilus-image-converter \
nautilus-search-tool \
neovim \
nethogs \
libgit2 \
NetworkManager-openvpn-gnome \
nextcloud-client \
nextcloud-client-nautilus \
nload \
openssh-askpass \
p7zip-plugins \
pop-icon-theme \
protobuf-vim \
pv \
wget \
zip \
unzip \
file \
fedora-workstation-repositories \
python2-devel \
python3-devel \
python2-neovim \
python3-neovim \
qutebrowser \
rawtherapee \
redhat-rpm-config \
rpm-build \
seahorse-nautilus \
spamassassin \
sqlite-analyzer \
sqlitebrowser \
syncthing-gtk \
qbittorrent \
telegram-desktop \
tig \
tilix \
tilix-nautilus \
totem-nautilus \
transmission \
tuned \
unar \
vagrant-libvirt \
vim-enhanced \
virt-manager \
wavemon \
youtube-dl \
zsh \
zsh-syntax-highlighting \
grub-customizer \
fontforge \
cloc \
ddgr \
python2 \
python3 \
golang \
darktable \
'mozilla-fira-*' \
openshot

##############################################################
#       INSTALL OTHER STUFF (SOME CRAP, SOME NICETIES)
#
#       WARNING: ONE-LINERS AHEAD!
#
##############################################################

######### Wine development builds (winehq-stable is very slow compared to devel) ##########
sudo dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/$(rpm -E %fedora)/winehq.repo && sudo dnf --best install -y winehq-devel && printf "\n\nDone installing WineHQ Devel packages! \n\n"

##################### PHP, phpmyadmin, composer, extensions, and laravel ###################
sudo dnf --best install -y php php-cli php-common phpunit composer php-mysqli php-json php-mbstring php-pdo php-xml php-bcmath php-pecl-apcu php-cli php-pear php-pdo php-mysqlnd php-pgsql php-pecl-mongodb php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml php-php-gettext php-mbstring phpmyadmin php-mcrypt php-mysqlnd php-pear php-curl php-gd php-xml php-bcmath php-zip && composer global require laravel/installer && printf "\n\nDone installing PHP, Extensions, and Laravel! \n\n"

############## nodejs latest, npm, yarn, and other global npm packages ##############
curl -sL https://rpm.nodesource.com/setup_11.x | sudo bash - && sudo dnf --best install -y nodejs && sudo npm i -g npm && curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo && sudo dnf --best install -y yarn && echo "Done installing Yarn pkg manager!" && sudo npm i -g eslint jshint typescript @angular/cli npm-check-updates npx tldr spoof create-react-app react-native-cli eslint-config-standard eslint-config-standard-react eslint-config-standard-jsx eslint-plugin-react eslint-config-prettier eslint-plugin-prettier prettier standard gulp create-react-app create-react-library babel-eslint @vue/cli vue grunt-cli mocha gatsby-cli nodemon webpack react react-dom webpack-dev-server webpack-cli babel-core babel-loader babel-preset-env babel-preset-react html-webpack-plugin tldr now spoof && echo -en "\n\nDone installing Node, npm, yarn and a few packages OK! \n\n"

############## slack (cuz work) ##############
SLACK_DIRECT_DOWNLOAD="https://downloads.slack-edge.com/linux_releases/slack-3.3.8-0.1.fc21.x86_64.rpm" && sudo dnf --best install -y "$SLACK_DIRECT_DOWNLOAD" && echo -en "\n\ndone installing slack! \n\n"

############## Todoist to-do app ##############
sudo dnf --best install -y $(curl -sL "https://api.github.com/repos/krydos/todoist-linux/releases/latest" | grep "https.*.rpm" | cut -d '"' -f 4)

############## Sublime text and Sublime Merge (a nice GIT frontend) ##############
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg && sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo && sudo dnf --best install -y sublime-text sublime-merge

############## M$ vscode (spyware but lazy meh) ##############
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc && sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo' && sudo dnf check-update && sudo dnf --best install -y code && echo "spyware VS Code installed successfully!"

############## vscode insiders ##############
filename="./vscode_insiders.rpm" && DOWNLOAD_LINK="https://go.microsoft.com/fwlink/?LinkID=760866" && rm -f $filename; wget -O $filename "$DOWNLOAD_LINK" && sudo dnf --best install -y $filename && rm -f $filename && echo -en "\n\nDone installing $filename! \n\n"

############## google chrome ##############
sudo dnf --best install -y "https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm"

############## atom editor ##############
sudo dnf --best install -y $(curl -sL "https://api.github.com/repos/atom/atom/releases/latest" | grep "https.*atom.x86_64.rpm" | cut -d '"' -f 4)

############## Install Virtualbox latest version and also latest guest extensions ##############
sudo rpm --import https://www.virtualbox.org/download/oracle_vbox.asc && sudo dnf config-manager --add-repo https://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo && sudo dnf check-update -y && sudo dnf --best install -y binutils git vim gcc make patch libgomp glibc-headers glibc-devel kernel-headers kernel-devel dkms qt5-qtx11extras libxkbcommon VirtualBox-6.0 virtualbox-guest-additions && sudo bash /usr/lib/virtualbox/vboxdrv.sh setup && sudo usermod -a -G vboxusers $USER && latest_version="$(curl -s https://download.virtualbox.org/virtualbox/LATEST.TXT)" && extpack_url=https://download.virtualbox.org/virtualbox/$latest_version/Oracle_VM_VirtualBox_Extension_Pack-$latest_version.vbox-extpack && wget -q $extpack_url && export KERN_DIR=/usr/src/kernels/`uname -r`/build && filename=$(basename $extpack_url) && yes | sudo VBoxManage extpack install --replace $filename && sleep 5 && rm $filename && echo -en "\n\n Done installing VirtualBox! \n\n"

############## teamviewer (crap, but so much for being the family's IT guy) ##############
sudo dnf --best install -y "https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm" && echo "Done installing teamviewer!"

###### hardinfo (a nice systeminfo GUI) (git clone master && make && make install) ########
sudo dnf --best install -y git gtk3-devel gtk2-devel gtk+-devel glib cmake make git zlib libsoup && rm -rf hardinfo; git clone https://github.com/lpereira/hardinfo.git hardinfo && cd hardinfo && mkdir build && cd build && cmake .. && make && sudo make install && cd ../../ && rm -rf hardinfo && echo "Done installing HardInfo from source!"

#### fsearch (like Search Everything but for Linux) (git clone master && make && make install) ####
sudo dnf --best install -y git automake autoconf intltool libtool autoconf-archive pkgconfig glib2-devel gtk3-devel && rm -rf fsearch; git clone https://github.com/cboxdoerfer/fsearch.git fsearch && cd fsearch && ./autogen.sh && ./configure && make && sudo make install && cd .. && rm -rf fsearch && echo "Done installing FSearch from source!"

############## VMWare workstation player ##############
dload_filename="./vmware.bundle" && VM_WARE_WORKSTATION_PLAYER_DLINK="https://www.vmware.com/go/getplayer-linux" && rm -f $dload_filename; wget -O $dload_filename $VM_WARE_WORKSTATION_PLAYER_DLINK && chmod +x $dload_filename && sudo $dload_filename && rm -f $dload_filename && echo -en "\n\nDone installing VMWare Player! \n\n"

############## veracrypt :3 ##############
sudo dnf copr enable -y  bgstack15/stackrpms && sudo dnf --best install -y veracrypt

############## intellij idea ##############
INTELLIJ_DIRECT_DOWNLOAD="https://download.jetbrains.com/idea/ideaIC-2019.1.tar.gz"
 && DOWNLOAD_LINK="$INTELLIJ_DIRECT_DOWNLOAD" && filename="./intellij.tar.gz" && rm -f $filename; wget -O $filename $DOWNLOAD_LINK && curdirname=$(pwd) && xdirname="/home/$USER/JetBrains_IDEs/IntelliJ_IDE" && mkdir -p $xdirname; tar -xzf $filename -C $xdirname --strip-components=1 && rm -f $filename && cd $xdirname/bin && echo "Done installing $filename!" && ./idea.sh; cd $curdirname && echo "Starting IntelliJ now..."

############## pycharm ##############
PYCHARM_DIRECT_DOWNLOAD="https://download.jetbrains.com/python/pycharm-community-2019.1.tar.gz" && DOWNLOAD_LINK="$ANDROID_STUDIO_DOWNLOAD" && filename="./android_studio.zip" && rm -f $filename; wget -O $filename $DOWNLOAD_LINK && curdirname=$(pwd) && xdirname="/home/$USER/JetBrains_IDEs" && mkdir -p $xdirname; unzip -q $filename -d $xdirname && rm -f $filename && cd $xdirname && mv android-studio Android_Studio && cd Android_Studio/bin && echo "Done installing $filename!" && ./studio.sh; cd $curdirname && echo "Starting Android Studio now..."

############## Android studio ##############
ANDROID_STUDIO_DOWNLOAD="https://dl.google.com/dl/android/studio/ide-zips/3.3.2.0/android-studio-ide-182.5314842-linux.zip" && DOWNLOAD_LINK="$ANDROID_STUDIO_DOWNLOAD" && filename="./android_studio.zip" && rm -f $filename; wget -O $filename $DOWNLOAD_LINK && curdirname=$(pwd) && xdirname="/home/$USER/JetBrains_IDEs" && mkdir -p $xdirname; unzip -q $filename -d $xdirname && rm -f $filename && cd $xdirname && mv android-studio Android_Studio && cd $curdirname && echo "Done installing $filename!"

############### docker-CE ####################
sudo dnf -y install dnf-plugins-core && sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo && sudo dnf --best install -y docker-ce docker-ce-cli containerd.io && sudo usermod -aG docker $USER && sudo systemctl start docker && sudo systemctl enable docker && echo -en "\nDone installing docker and adding $USER to docker group, logout and back in to normally use docker-- try example: docker run hello-world\n\n"

############### one-liner to pull/install/update latest versions of 30+ AWESOME GNOME GTK/SHELL THEMES (repo: https://github.com/tliron/install-gnome-themes) ####################
sudo dnf --best install -y curl git wget && curl -s https://raw.githubusercontent.com/tliron/install-gnome-themes/master/install-requirements-fedora | bash - && THEMES_PATH="/home/$USER/repos/install-gnome-themes" && mkdir -p "$THEMES_PATH"; git clone https://github.com/tliron/install-gnome-themes "$THEMES_PATH"; git -C "$THEMES_PATH" pull && DOWNLOAD_LINK="https://github.com/cyfrost/dotfiles/raw/master/themes.tar.xz" && filename="./themes.tar.xz" && rm -f $filename; wget -O $filename $DOWNLOAD_LINK && curdirname=$(pwd) && xdirname="$HOME/.themes" &&  if [ -d "$xdirname" ]; then   mv -f "$xdirname" "$HOME/.themes_orig"; fi; mkdir -p $xdirname; tar -xf $filename -C $xdirname --strip-components=1 && rm -f $filename && cd $curdirname && "$THEMES_PATH/install-gnome-themes" && echo -en "\n\nDone installing themes! \n\n"

# Install and setup Guake terminal (an awesome drop-down terminal)
# this will install guake, and pull my guake config.
# after this is finished, hit "Alt+Space" to see magic :)
sudo dnf --best install -y guake && guake_config_xml_filename="./apps-guake.xml" && guake_schemas_filename="./schemas-apps-guake.xml" && rm -f $guake_config_xml_filename $guake_schemas_filename; curl -s "https://raw.githubusercontent.com/cyfrost/dotfiles/master/apps-guake.xml" >> $guake_config_xml_filename && curl -s "https://raw.githubusercontent.com/cyfrost/dotfiles/master/schemas-apps-guake.xml" >> $guake_schemas_filename && gconftool-2 --load $guake_config_xml_filename && gconftool-2 --load $guake_schemas_filename && rm -f $guake_config_xml_filename $guake_schemas_filename && echo -en "\n\nGuake Installed and configured Successfully! \n\n"

# Install and setup Tilix
# this will install Tilix, and pull my Tilix config.
# after this is finished, hit "Ctrl+Space" to see magic :)
sudo dnf --best install -y tilix tilix-nautilus dconf && filename="tilix_config.dconf" && rm -f $filename; gsettings set org.gnome.desktop.wm.keybindings activate-window-menu [] && curl -s "https://raw.githubusercontent.com/cyfrost/dotfiles/master/tilix_conf.dconf" >> $filename && dconf load /com/gexperts/Tilix/ < "$filename" && rm -f $filename && py_script_filename="add-custom-keybindings.py" && rm -f $py_script_filename; curl -s "https://raw.githubusercontent.com/cyfrost/dotfiles/master/add-custom-keybindings.py" >> $py_script_filename && python $py_script_filename 'Tilix Quake Mode Binding' 'tilix --quake' '<Primary>space' && rm -f $py_script_filename && echo -en "\n\nTilix installed and configured successfully! \n\nDone! \n\n"

###
# Remove some un-needed stuff
###

sudo dnf remove \
-y \
gnome-shell-extension-background-logo `#Tasteful but nah` \
totem `#With mpv installed totem became a little useless` \
chromium `#Using Chromium resets chromium-vaapi so remove it if installed, userprofiles will be kept and can be used in -vaapi` \
flowblade `#Sadly has really outdated mlt dependencies`


###
# Enable some of the goodies, but not all
# Its the users responsibility to choose and enable zsh, with oh-my-zsh for example
# or set a more specific tuned profile
###

################################################################
#
#                    SYSTEM CONFIG       
#
#################################################################

# change plymouth boot theme to display details only (cuz that's how I roll --maybe not on flicker-free boot in F30 awww).
sudo plymouth-set-default-theme details -R

# Stop and disable bluetooth (I seldom use it on my laptop)
sudo systemctl stop bluetooth
sudo systemctl disable bluetooth

# Start and enabel apache (cuz whynot)
sudo systemctl enable --now httpd

# Start and enable sshd
sudo systemctl enable --now sshd

# here its usually some secrets (ssh keys etc...)

# Git config
GITHUB_USERNAME="<placeholder>"
GITHUB_PWD="placeholder (can also be OAuth token instead)"
GITHUB_MAIL="<placeholder>"
git config --global user.name $GITHUB_USERNAME
git config --global user.password $GITHUB_PWD
git config --global user.email $GITHUB_MAIL
git config --global credential.helper store
git config --global credential.helper cache
git config --global credential.helper "cache --timeout=950400"

# Change root password
NEW_ROOT_PASSWORD="<placeholder>" && echo $NEW_ROOT_PASSWORD | sudo passwd --stdin root && echo "Root password configured successfully!"

# Create and config home account (my computer may be used by someone else too)
# one-liner to create their account, add them to wheel, and setup their password.
ACCOUNT_NAME="home" && ACCOUNT_FULL_NAME="Home" && ACCOUNT_PWD="CorrectHorseBatteryStaple" && sudo adduser $ACCOUNT_NAME -c "$ACCOUNT_FULL_NAME" && echo "$ACCOUNT_PWD" | sudo passwd --stdin $ACCOUNT_NAME && sudo usermod -aG wheel $ACCOUNT_NAME && echo "User $ACCOUNT_NAME created and configured successfully!"

# Set hostname
HOST_NAME="hyperion" && sudo hostnamectl set-hostname $HOST_NAME && echo "Hostname set successfully!"

# Pull my bashrc from github and install it.
# THIS IS A DUMMY BASHRC!
filename="./new_bashrc" && rm -f $filename; curl -s "https://raw.githubusercontent.com/cyfrost/dotfiles/master/_sample_.bashrc" >> $filename && mv $HOME/.bashrc $HOME/.backup_dotbashrc && echo -en "\nRestoring .bashrc config\n\n" && cp "$filename" "$HOME/.bashrc" && source "$HOME/.bashrc" && rm -f $filename && echo -en "Bashrc restore Done and new config is loaded successfully\n\n";

# Change default apps (browser --chrom*ium, text==sublime, media==mpv)
assoc_file="./mimeapps.list" && rm -f $assoc_file; curl -s "https://raw.githubusercontent.com/cyfrost/dotfiles/master/mimeapps.list" >> $assoc_file && cp -f $assoc_file "$HOME/.config/" && rm -f $assoc_file && echo -en "\n\nApp defaults have been set sucessfully! \n\n\n" 

sudo systemctl enable --now tuned
sudo tuned-adm profile balanced

#Performance:
#sudo tuned-adm profile desktop

#Virtual Machine Host:
#sudo tuned-adm profile virtual-host

#Virtual Machine Guest:
#sudo tuned-adm profile virtual-guest

#Battery Saving:
#sudo tuned-adm profile powersave

# Virtual Machines
sudo systemctl enable --now libvirtd

# Management of local/remote system(s) - available via http://localhost:9090
sudo systemctl enable --now cockpit.socket



########################################################################
#
#   GNOME, EXTENSIONS, PERSONALIZATION, GSETTINGS, DCONF, KEYBINDINGS      
#
########################################################################


# INSTALL, ENABLE, AND CONFIG wanted extensions.

sudo dnf --best install -y gnome-shell-extension-freon gnome-shell-extension-gpaste gnome-shell-extension-common gnome-shell-extension-fedmsg  gnome-shell-extension-netspeed gnome-shell-extension-apps-menu gnome-shell-extension-gsconnect gnome-shell-extension-places-menu gnome-shell-extension-drive-menu gnome-shell-extension-user-theme gnome-shell-extension-window-list gnome-shell-extension-dash-to-dock gnome-shell-extension-refresh-wifi gnome-shell-extension-topicons-plus gnome-shell-extension-suspend-button gnome-shell-extension-disconnect-wifi gnome-shell-extension-workspace-indicator gnome-shell-extension-do-not-disturb-button gnome-shell-extension-media-player-indicator gnome-shell-extension-activities-configurator && \
filename="./extensions_to_install.txt" && rm -f $filename && \
echo "https://extensions.gnome.org/extension/1236/noannoyance/
https://extensions.gnome.org/extension/517/caffeine/
https://extensions.gnome.org/extension/355/status-area-horizontal-spacing/
https://extensions.gnome.org/extension/1156/gsnow/
https://extensions.gnome.org/extension/118/no-topleft-hot-corner/
" > $filename && dload_filename="./install-gnome-extensions.sh" && rm -f $dload_filename; wget -N -q "https://raw.githubusercontent.com/cyfrost/install-gnome-extensions/master/install-gnome-extensions.sh" -O $dload_filename && chmod +x $dload_filename && $dload_filename --enable --overwrite --file $filename && sleep 2 && rm -f $filename && rm -f $dload_filename

EXTENSIONS_TO_ENABLE=(
user-theme@gnome-shell-extensions.gcampax.github.com
TopIcons@phocean.net
dash-to-dock@micxgx.gmail.com
apps-menu@gnome-shell-extensions.gcampax.github.com
gsconnect@andyholmes.github.io
drive-menu@gnome-shell-extensions.gcampax.github.com
places-menu@gnome-shell-extensions.gcampax.github.com
window-list@gnome-shell-extensions.gcampax.github.com
refresh-wifi@kgshank.net
suspend-button@laserb
mediaplayer@patapon.info
caffeine@patapon.info
launch-new-instance@gnome-shell-extensions.gcampax.github.com
disconnect-wifi@kgshank.net
workspace-indicator@gnome-shell-extensions.gcampax.github.com
noannoyance@sindex.com
status-area-horizontal-spacing@mathematical.coffee.gmail.com
eric.rice
)

for ext in "${EXTENSIONS_TO_ENABLE[@]}"; do
    gnome-shell-extension-tool -e "$ext"
done

gsettings set org.gnome.shell.extensions.topicons tray-pos 'center'
gsettings --schemadir "$HOME/.local/share/gnome-shell/extensions/caffeine@patapon.info/schemas" set org.gnome.shell.extensions.caffeine show-notifications false

# dash to dock config
gsettings set org.gnome.shell.extensions.dash-to-dock apply-custom-theme false
gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
gsettings set org.gnome.shell.extensions.dash-to-dock custom-background-color true
gsettings set org.gnome.shell.extensions.dash-to-dock background-color '#000000'
gsettings set org.gnome.shell.extensions.dash-to-dock custom-theme-customize-running-dots true
gsettings set org.gnome.shell.extensions.dash-to-dock custom-theme-running-dots-color '#729fcf'
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
gsettings set org.gnome.shell.extensions.dash-to-dock custom-theme-shrink true
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
gsettings set org.gnome.shell.extensions.dash-to-dock extend-height true
gsettings set org.gnome.shell.extensions.dash-to-dock force-straight-corner true
gsettings set org.gnome.shell.extensions.dash-to-dock icon-size-fixed true
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide-mode 'ALL_WINDOWS'
gsettings set org.gnome.shell.extensions.dash-to-dock isolate-workspaces true
gsettings set org.gnome.shell.extensions.dash-to-dock show-apps-at-top true
gsettings set org.gnome.shell.extensions.dash-to-dock unity-backlit-items false
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'FIXED'
gsettings set org.gnome.shell.extensions.dash-to-dock running-indicator-style 'SEGMENTED'
gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 1
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
gsettings set org.gnome.shell.extensions.dash-to-dock scroll-action 'switch-workspace'
echo -en "\n\nExtensions manager complete! RESTART GNOME SHELL OR LOGOUT AND BACK IN! \n\n"

# END ------ INSTALL, ENABLE, AND CONFIG wanted extensions.

###########################
#  BEGIN GSETTINGS STUFF
###########################

# GNOME Terminal
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ background-color 'rgb(0,0,0)'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ foreground-color 'rgb(255,255,255)'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ scrollback-unlimited true
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ use-theme-colors false

# Theming (GTK Apps, Icons pack, Cursor, Shell theme)
gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Pop'
gsettings set org.gnome.desktop.interface cursor-theme 'Breeze_Snow'
gsettings set org.gnome.shell.extensions.user-theme name 'Adapta-Nokto-Eta'

# Add favourites apps to launcher
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'google-chrome.desktop', 'org.gnome.Evolution.desktop', 'code.desktop', 'sublime_text.desktop', 'whatsappdesktop.desktop', 'telegram-desktop.desktop', 'slack.desktop', 'todoist.desktop', 'gvim.desktop', 'code-insiders.desktop', 'realvnc-vncviewer.desktop', 'firefox.desktop', 'chromium-browser.desktop', 'virt-manager.desktop', 'gnome-system-monitor.desktop', 'sublime_merge.desktop']"

# Date, battery, timezone, calendar
gsettings set org.gnome.desktop.calendar show-weekdate true
gsettings set org.gnome.desktop.datetime automatic-timezone true
gsettings set org.gnome.desktop.interface clock-format '24h'
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface show-battery-percentage true

# Mouse, touchpad --tap to click, sensitivity, accel profile.
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.mouse speed 1
gsettings set org.gnome.desktop.peripherals.touchpad speed 1

# Desktop and Lock screen Wallpaper settings
gsettings set org.gnome.desktop.background picture-options 'stretched'
gsettings set org.gnome.desktop.background picture-uri ''
gsettings set org.gnome.desktop.background primary-color '#000000'
gsettings set org.gnome.desktop.screensaver primary-color '#000000'
gsettings set org.gnome.desktop.background color-shading-type 'solid'
gsettings set org.gnome.desktop.screensaver picture-uri ''
gsettings set org.gnome.desktop.screensaver color-shading-type 'solid'

# Nautilus settings
gsettings set org.gtk.Settings.FileChooser show-hidden true
gsettings set org.gtk.Settings.FileChooser show-size-column true
gsettings set org.gtk.Settings.FileChooser sidebar-width 180
gsettings set org.gtk.Settings.FileChooser sort-column 'name'
gsettings set org.gtk.Settings.FileChooser sort-directories-first true
gsettings set org.gtk.Settings.FileChooser sort-order 'ascending'
gsettings set org.gnome.nautilus.icon-view default-zoom-level 'standard'
gsettings set org.gnome.nautilus.preferences default-folder-viewer 'icon-view'
gsettings set org.gnome.nautilus.preferences executable-text-activation 'ask'
gsettings set org.gnome.nautilus.preferences search-filter-time-type 'last_modified'
gsettings set org.gnome.nautilus.preferences search-view 'list-view'
gsettings set org.gnome.nautilus.preferences show-create-link true
gsettings set org.gnome.nautilus.preferences show-delete-permanently true
gsettings set org.gnome.nautilus.preferences show-hidden-files true
gsettings set org.gnome.FileRoller.FileSelector show-hidden true
gsettings set org.gnome.nautilus.list-view use-tree-view true

# usability niceties
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
gsettings set org.gnome.desktop.sound allow-volume-above-100-percent true
gsettings set org.gnome.desktop.interface monospace-font-name 'Source Code Pro Semi-Bold 12'
gsettings set org.gnome.settings-daemon.peripherals.keyboard numlock-state 'on'
gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing 'rgba'
gsettings set org.gnome.desktop.privacy report-technical-problems true
gsettings set org.gnome.desktop.wm.preferences action-middle-click-titlebar 'toggle-shade'
gsettings set org.virt-manager.virt-manager system-tray true

# Night light
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 4900
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true
gsettings set org.gnome.settings-daemon.plugins.color night-light-last-coordinates "(17.378399999999999, 78.471199999999996)"

# Power settings
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 1800 # suspend after 30mins on battery power
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 7200 # suspend after 2hrs on AC power
gsettings set org.gnome.settings-daemon.plugins.power idle-dim true

# Image Viewer (EOG -- eye of gnome)
gsettings set org.gnome.eog.view background-color 'rgb(0,0,0)'
gsettings set org.gnome.eog.view use-background-color true
gsettings set org.gnome.eog.ui disable-close-confirmation true

# Mutter, shell and window management
gsettings set org.gnome.mutter center-new-windows true
gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true
gsettings set org.gnome.shell.overrides workspaces-only-on-primary false
gsettings set org.freedesktop.Tracker.Miner.Files index-on-battery false
gsettings set org.freedesktop.Tracker.Miner.Files index-on-battery-first-time false
gsettings set org.freedesktop.Tracker.Miner.Files throttle 15

### Keybindings (stock and custom)

# nullify some keybindings just in case.
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['']"
gsettings set org.gnome.settings-daemon.plugins.media-keys search ''
gsettings set org.gnome.desktop.wm.keybindings activate-window-menu []

# set wm keybindings
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Super>Page_Up', '<Shift><Alt>Q']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Super>Page_Down', '<Shift><Alt>W']"
gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot-clip 'Insert'
gsettings set org.gnome.settings-daemon.plugins.media-keys screenshot '<Control>Insert'
gsettings set org.gnome.settings-daemon.plugins.media-keys home '<Super>E'
gsettings set org.gnome.settings-daemon.plugins.media-keys control-center '<Super>S'
gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']"

# Custom keybindings
py_scriptname="add-custom-keybindings.py" && rm -f $py_scriptname; curl -s "https://raw.githubusercontent.com/cyfrost/dotfiles/master/add-custom-keybindings.py" >> $py_scriptname && \
python $py_scriptname 'Screenshot Area Clip' 'gnome-screenshot -ac' 'Print'
python $py_scriptname 'Save Screenshot Instantly' 'gnome-screenshot' '<Control>Print'
python $py_scriptname 'Launch Tilix' 'tilix' '<Primary><Alt>t'
python $py_scriptname 'Launch Tilix' 'tilix' '<Super>R'

#### ---END GNOME, PERSONALIZATION, GSETTINGS, DCONF, KEYBINDINGS

# Add Startup apps

startup_items=(
"whatsappdesktop.desktop"
"guake.desktop"
"telegram-desktop.desktop"
"todoist.desktop"
"slack.desktop"
"org.gnome.Evolution.desktop"
"org.gnome.Terminal.desktop"
)

mkdir -p "$HOME/.config/autostart/"

for startup_app in "${startup_items[@]}"
do
	cp -f "/usr/share/applications/$startup_app" "$HOME/.config/autostart/"
done

echo -en "\n\n\nDone! all specified startup items are now enabled on logon\n\n"

# Git clone all my repos and update them
pip3 install pygithub --user; pip3 install pygithub3 --user; GITHUB_OAUTH_TOK=$GITHUB_OAUTH_TOKEN && filename="./pull_repos.sh" && rm -f $filename; curl -s https://raw.githubusercontent.com/cyfrost/dotfiles/master/pull_repos.sh >> "$filename"; chmod +x $filename && $filename $GITHUB_OAUTH_TOK

###
# These will be more used in the future by some maintainers
# Reenabling them just to make sure.
###

sudo sed -i '0,/enabled=0/s/enabled=0/enabled=1/g' /etc/yum.repos.d/fedora-updates-modular.repo
sudo sed -i '0,/enabled=0/s/enabled=0/enabled=1/g' /etc/yum.repos.d/fedora-modular.repo

#The user needs to reboot to apply all changes.
echo "Please Reboot" && exit 0