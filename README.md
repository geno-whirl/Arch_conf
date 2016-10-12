# My Archlinux configuration

## Arch installation

### Keyboard layout

~~~~bash
# loadkeys la-latin1
~~~~

### Boot mode

~~~~bash
# ls /sys/firmware/efi/efivars
~~~~

must be populated.

### Connect to the internet

~~~~bash
# wifi-menu
~~~~

### Update the system clock

~~~~bash
# timedatectl set-ntp true
~~~~

### Partition disk

~~~~bash
# cfdisk
~~~~

Create the following partitions:

* EFI boot partition: 512MB, EFI System
* Root: 50GB, Linux Root (x86-64)
* Home: Remaining disk space, Linux home

Make filesystems:
~~~~bash
# mkfs.fat -F32 /dev/{boot}
# mkfs.ext4 /dev/{root,home}
~~~~

### Mount partitions

~~~~bash
# mount /dev/{root} /mnt
# mkdir /mnt/boot
# mount /dev/{boot} /mnt/boot
# mkdir /mnt/home
# mount /dev/{home} /mnt/home
~~~~

### Select mirrors

~~~~bash
# nano /etc/pacman.d/mirrorlist
~~~~

Put closer mirrors on top of the list.

### Install base packages

~~~~bash
# pacstrap /mnt base base-devel grub efibootmgr hfsprogs exfat-utils zsh zsh-completions iw wpa_supplicant dialog networkmanager alsi
~~~~

### Generate fstab file

~~~~bash
# genfstab -U /mnt >> /mnt/etc/fstab
~~~~

### Change root

`chroot` into the new system

~~~~bash
# arch-chroot /mnt
~~~~

### Set the time zone

~~~~bash
# ln -s /usr/share/zoneinfo/Chile/Continental /etc/localtime
# hwclock --systohc --utc
~~~~

### Locale

Edit `/etc/locale.gen`, uncomment `en_US` and `es_CL` and generate localizations with

~~~~bash
# locale-gen
# echo LANG=en_US.UTF-8 > /etc/locale.conf
# echo KEYMAP=la-latin1 > /etc/vconsole.conf
~~~~

### Hostname and users

Set hostname

~~~~bash
# hostnamectl set-hostname totilio
~~~~

Add the following line to `/etc/hosts`:

~~~~
127.0.1.1       totilio.localdomain     totilio
~~~~

Set root password

~~~~bash
# passwd
~~~~

Create user

~~~~bash
# useradd -m -G wheel -s /usr/bin/zsh toti
# passwd toti
~~~~

Allow sudo for wheel members by running `visudo` and uncommenting `%wheel ALL=(ALL) ALL`.

### Install GRUB

~~~~bash
# grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
# grub-mkconfig -o /boot/grub/grub.cfg
~~~~

### Reboot

~~~~bash
# exit
# umount -R /mnt
# reboot
~~~~

Login with user, connect to the internet via

~~~~bash
$ nmcli dev wifi connect <name> password <password>
~~~~

### Yaourt and base installation/versioning tools

Edit `/etc/pacman.conf` and append the following lines:

~~~~bash
[archlinuxfr]
SigLevel=Never
Server=http://repo.archlinux.fr/$arch
~~~~

Install `yaourt`:

~~~~bash
sudo pacman -Syu yaourt git wget curl
~~~~

and optionally comment out the above lines.

### Xorg, window manager and DE utilities

Install video driver, Xorg and utilities

~~~~bash
$ yaourt -Syu --aur
# pacman -S xf86-video-intel xorg-server xorg-server-utils xorg-apps i3-wm terminator thunar thunar-archive-plugin thunar-volman libnotify dunst pulseaudio xfce4-power-manager network-manager-applet gnome-keyring rofi dmenu
~~~~

Via `yaourt` install the following packages: `i3blocks tzupdate pasystray-gtk2-standalone playerctl dmenu-extended oh-my-zsh-git`.

Set keyboard layout

~~~~bash
$ localectl set-keymap --no-convert la-latin1
$ localectl set-x11-keymap --no-convert latam pc105 deadtilde ctrl:swap_lalt_lctl
~~~~

#### Fonts and Infinality

Edit `/etc/pacman.conf` and append the following lines:

~~~~bash
[infinality-bundle]
Server = http://bohoomil.com/repo/$arch

[infinality-bundle-fonts]
Server = http://bohoomil.com/repo/fonts
~~~~

Install infinality patches and fonts

~~~~bash
$ yaourt -Syu --aur
# pacman -S freetype2-infinality-ultimate fontconfig-infinality-ultimate ibfonts-meta-extended
~~~~

#### Themes and appearance

~~~~bash
$ yaourt -Syu --aur
# pacman -S lxappearance arandr feh gtk-theme-arc deepin-icon-theme
~~~~

Via `yaourt` install the following packages: `compton-git compton-conf grub-customizer `.

Set themes using `lxappearance` and configure composition with `compton-conf`.

#### Utilities

~~~~bash
$ yaourt -Syu --aur
# pacman -S bleachbit
~~~~

### Applications

~~~~bash
$ yaourt -Syu --aur
# pacman -S firefox google-chrome flashplugin vlc spotify transmission-gtk
~~~~

Via `yaourt` install the following packages: `blockify`.

~~~~bash
$ yaourt -Syu --aur
# pacman -S pinta
~~~~

### Coding

~~~~bash
$ yaourt -Syu --aur
~~~~

Via `yaourt` install the following packages: `sublime-text python-conda pyenv rbenv ruby-build`.

### Optionals and applications being tested

~~~~bash
$ yaourt -Syu --aur
# pacman -S lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings accountsservice
~~~~