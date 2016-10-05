sudo cp ./config/Xorg/* /etc/X11/
sudo cp -f ./config/grub.conf /boot/grub/grub.cfg
ln -f ./config/dmenu_extended.conf ~/.config/dmenu-extended/config/dmenuExtended_preferences.txt
ln -f ./config/exit_menu ~/.config/i3/exit_menu
ln -f ./config/i3.conf ~/.config/i3/config
ln -f ./config/i3blocks.conf ~/.config/i3/i3blocks.conf
ln -f ./config/sublime-keymap.conf ~'/.config/sublime-text-2/Packages/User/Default (Linux).sublime-keymap'
ln -f ./config/sublime-settings.conf ~/.config/sublime-text-2/Packages/User/Preferences.sublime-settings
ln -f ./config/terminator.conf ~/.config/terminator/config
ln -f ./config/xinitrc.conf ~/.xinitrc
ln -f ./config/zprofile.conf ~/.zprofile
ln -f ./config/zshrc.conf ~/.zshrc

mkdir ~/Pictures/Wallpapers
cp ./wallpapers/* ~/Pictures/Wallpapers/