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
# pacstrap /mnt base base-devel grub efibootmgr zsh zsh-completions iw wpa_supplicant dialog networkmanager
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

and comment out the above lines.

### Xorg, window manager and DE utilities

Install video driver, Xorg and utilities

~~~~bash
$ yaourt -Syu
$ yaourt xf86-video-intel xorg-server xorg-server-utils xorg-apps i3-wm i3blocks terminator thunar thunar-archive-plugin thunar-volman pulseaudio pasystray-gtk2-standalone playerctl xfce4-power-manager network-manager-applet gnome-keyring rofi dmenu dmenu-extended oh-my-zsh-git
~~~~

Set keyboard layout

~~~~bash
$ localectl set-keymap --no-convert la-latin1
$ localectl set-x11-keymap --no-convert latam pc105 deadtilde ctrl:swap_lalt_lctl
~~~~

Themes and appearance

~~~~bash
$ yaourt -Syu
$ yaourt lxappearance arandr feh compton-git grub-customizer
~~~~

Utilities

~~~~bash
$ yaourt -Syu
$ yaourt bleachbit
~~~~

### Applications

~~~~bash
$ yaourt -Syu
$ yaourt firefox google-chrome flashplugin vlc spotify blockify transmission-gtk
~~~~

~~~~bash
$ yaourt -Syu
$ yaourt sublime-text
~~~~