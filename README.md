# My Archlinux configuration

## Arch installation

### Keyboard layout

~~~~
# loadkeys la-latin1
~~~~

### Boot mode

~~~~
# ls /sys/firmware/efi/efivars
~~~~

must be populated.

### Connect to the internet

~~~~
# wifi-menu
~~~~

### Update the system clock

~~~~
# timedatectl set-ntp true
~~~~

### Partition disk

~~~~
# cfdisk
~~~~

Create the following partitions:

* EFI boot partition: 512MB, EFI System
* Root: 60GB, Linux Root (x86-64)
* Home: Remaining disk space, Linux home

Make filesystems:
~~~~
# mkfs.fat -F32 /dev/{boot}
# mkfs.ext4 /dev/{root,home}
~~~~

### Mount partitions

~~~~
# mount /dev/{root} /mnt
# mkdir /mnt/boot
# mount /dev/{boot} /mnt/boot
# mkdir /mnt/home
# mount /dev/{home} /mnt/home
~~~~

### Select mirrors

~~~~
# nano /etc/pacman.d/mirrorlist
~~~~

Put closer mirrors on top of the list.

### Install base packages

~~~~
# pacstrap /mnt base base-devel grub efibootmgr hfsprogs exfat-utils syslog-ng zsh zsh-completions iw wpa_supplicant dialog networkmanager alsi
~~~~

### Generate fstab file

~~~~
# genfstab -U /mnt >> /mnt/etc/fstab
~~~~

### Change root

`chroot` into the new system

~~~~
# arch-chroot /mnt
~~~~

### Set the time zone

~~~~
# ln -s /usr/share/zoneinfo/Chile/Continental /etc/localtime
# hwclock --systohc --utc
~~~~

### Locale

Edit `/etc/locale.gen`, uncomment `en_US` and `es_CL` and generate localizations with

~~~~
# locale-gen
# echo LANG=en_US.UTF-8 > /etc/locale.conf
# echo KEYMAP=la-latin1 > /etc/vconsole.conf
~~~~

### Hostname and users

Set hostname

~~~~
# hostnamectl set-hostname totilio
~~~~

Add the following line to `/etc/hosts`:

~~~~
127.0.1.1       totilio.localdomain     totilio
~~~~

Set root password

~~~~
# passwd
~~~~

Create user

~~~~
# useradd -m -G wheel -s /usr/bin/zsh toti
# passwd toti
~~~~

Allow sudo for wheel members by running `visudo` and uncommenting `%wheel ALL=(ALL) ALL`.

### Install GRUB

~~~~
# grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
# grub-mkconfig -o /boot/grub/grub.cfg
~~~~

### Reboot

~~~~
# exit
# umount -R /mnt
# reboot
~~~~

Login with user, connect to the internet via

~~~~
$ nmcli dev wifi connect <name> password <password>
~~~~

Enable system log

~~~~
$ systemctl enable syslog-ng
$ systemctl start syslog-ng
~~~~

### Yaourt and base installation/versioning tools

Edit `/etc/pacman.conf` and append the following lines:

~~~~
[archlinuxfr]
SigLevel=Never
Server=http://repo.archlinux.fr/$arch
~~~~

Install `yaourt`:

~~~~
sudo pacman -Syu yaourt git wget curl vi
~~~~

and optionally comment out the above lines.

### Xorg, window manager and DE utilities

Install additional firmware

~~~~
$ yaourt -Syu --aur
~~~~

Via `yaourt` install the following packages: `aic94xx-firmware wd719x-firmware`. 

Install video driver, Xorg and utilities

~~~~
$ yaourt -Syu --aur
# pacman -S xf86-video-intel xorg-server xorg-server-utils xorg-apps i3-wm terminator thunar thunar-archive-plugin thunar-volman libnotify dunst pulseaudio xfce4-power-manager network-manager-applet gnome-keyring rofi dmenu
~~~~

Via `yaourt` install the following packages: `i3blocks tzupdate pasystray-gtk2-standalone playerctl dmenu-extended oh-my-zsh-git`.

Set keyboard layout

~~~~
$ localectl set-keymap --no-convert la-latin1
$ localectl set-x11-keymap --no-convert latam pc105 deadtilde ctrl:swap_lalt_lctl
~~~~

#### Fonts and Infinality

Edit `/etc/pacman.conf` and append the following lines:

~~~~
[infinality-bundle]
Server = http://bohoomil.com/repo/$arch

[infinality-bundle-fonts]
Server = http://bohoomil.com/repo/fonts
~~~~

Add the keys to the `pacman` keyring by typing the following commands:

~~~~
# pacman-key -r 962DDE58
$ pacman-key -f 962DDE58
# pacman-key --lsign-key 962DDE58
~~~~

Install infinality patches and fonts

~~~~
$ yaourt -Syu --aur
# pacman -S freetype2-infinality-ultimate fontconfig-infinality-ultimate ibfonts-meta-extended
~~~~

Install other fonts with `yaourt`: `ttf-font-awesome ttf-mac-fonts ttf-ms-fonts ttf-brill otf-nerls ttf-aller ttf-envy-code-r`

#### Themes and appearance

~~~~
$ yaourt -Syu --aur
# pacman -S lxappearance arandr feh gtk-theme-arc deepin-icon-theme
~~~~

Via `yaourt` install the following packages: `compton-git compton-conf grub-customizer`.

Set themes using `lxappearance` and configure composition with `compton-conf`.

#### Utilities and printers

~~~~
$ yaourt -Syu --aur
# pacman -S bleachbit cups cups-pdf gtk3-print-backends
~~~~

### Applications

~~~~
$ yaourt -Syu --aur
# pacman -S firefox google-chrome flashplugin vlc spotify transmission-gtk
~~~~

Via `yaourt` install the following packages: `blockify`.

~~~~
$ yaourt -Syu --aur
# pacman -S pinta imagemagick ghostscript
~~~~

### Coding

~~~~
$ yaourt -Syu --aur
# pacman -Syu docker
~~~~

Via `yaourt` install the following packages: `sublime-text python-conda pyenv rbenv ruby-build`.

Make minimal `python` installations

~~~~
$ pyenv install 2.7.11
$ pyenv install 3.5.1
~~~~

Make `conda` environment

~~~~
conda create --name scientificpython3 python=3
~~~~

Activate the environment and install the scientific python stack

~~~~
$ source activate scientificpython3
$ pip install --upgrade pip
$ pip install scipy numpy matplotlib scikit-learn jupyter pandas
~~~~

Install Deep Learning frameworks and libraries

~~~~
# pacman -Syu
# pacman -S blas

$ source activate scientificpython3

$ pip install nose cython h5py Theano keras
$ pip install --ignore-installed --upgrade $TF_BINARY_URL

$ mkdir ~/.convnets-keras
$ git clone https://github.com/heuritech/convnets-keras.git ~/.convnets-keras
$ cd .convnets-keras
$ python setup.py install
$ wget -P ~/.convnets-keras/weights/ http://files.heuritech.com/weights/alexnet_weights.h5
~~~~

To obtain the Tensorflow binary url go to https://github.com/tensorflow/tensorflow.

### Latex

~~~~
# pacman -Syu texlive-core
~~~~

### Optionals and applications being tested

~~~~
$ yaourt -Syu --aur
# pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings accountsservice
~~~~