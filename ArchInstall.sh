#!/bin/bash
echo "Welcome to the Arch Linux Easy Setup by Gregor160300, 32-bit version !!!"
echo "Make sure you have a ext4 partition on your drive, then press enter"; read;
clear
echo "Write down the partition name on which you would like to install from below e.g. /dev/sda1"
echo
lsblk
echo
echo "Please check again, if you are sure press enter"; read;
echo "Now type the partition name on which you would like to install"
read partition
echo "Please give us sudo rights to continue"
sudo su
clear
mount $partition /mnt
echo "Please uncomment the server closest to you from the next file (remove #), then press ctrl + x"
nano /etc/pacman.d/mirrorlist
echo clear
echo "We are installing base packages, just accept it xD"
pacstrap -i /mnt base base-devel
genfstab -U -p /mnt >> /mnt/etc/fstab
echo "We are now going to run from your new installation"
arch-chroot /mnt
echo "Please uncomment the language you are going to use (pick UTF-8 one, remove #), then press ctrl + x"
echo "Also write down the uncommented line"
nano /etc/locale.gen
locale-gen
echo "Please type the uncommented line now e.g. en_US.UTF-8"
read language
echo LANG=$language > /etc/locale.conf
export LANG=%language
echo "Please choose your correct timezone from below"
ls /usr/share/zoneinfo/
echo "Now type your timezone e.g. Europe/Amsterdam"
read tzone
ln -s /usr/share/zoneinfo/$tzone > /etc/localtime
hwclock --systohc --utc
echo "What do you want your pc to be named?"
read pcname
echo $pcname > /etc/hostname
echo > /etc/pacman.conf
echo "[archlinuxfr]" > /etc/pacman.conf
echo "SigLevel = Never" > /etc/pacman.conf
echo "Server = http://repo.archlinux.fr/$arch" > /etc/pacman.conf
pacman -Sy
echo "We are now changing the root password, make it strong root users can modify anything..."
passwd
echo "Please provide a new username"
read uname
useradd -m -g users -G wheel,storage,power -s /bin/bash $uname
echo "We are now changing the password of " + $uname
passwd $uname
pacman -S sudo
echo "Uncomment: %wheel ALL=(ALL) ALL in the next file"
echo "Press enter to continue"; read;
EDITOR=nano visudo
pacman -S grub
echo "Please give the name of your partition without number e.g. /dev/sda"
read dname
grub-install --target=i386-pc --recheck $dname
pacman -S os-prober
grub-mkconfig -o /boot/grub/grub.cfg
echo "To make internet work on reboot, remember the name of the running service (shows it's mac adress) e.g. eth0"
ip link
echo "Now type it..."
read intserv
systemctl enable dhcpcd@$intserv
echo "Installing a nice desktop environment..."
pacman -S xorg-server xorg-server-utils xorg-xinit xorg-drivers mesa xf86-input-synaptics xfce4 xfce4-goodies plank yaourt alsa-utils pulseaudio libnm-glib network-manager-applet networkmanager nm-connection-editor 
systemctl enable NetworkManager
systemctl start NetworkManager
systemctl disable dhcpcd.service
yaourt -Syua
exit
umount -R /mnt
echo "Go for a reboot now and choose your new arch linux installation on boot"
reboot now
