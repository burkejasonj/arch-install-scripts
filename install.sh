#!/bin/sh

echo Install Script V0.0.1 for ARCHPad
echo \(C\) 2021 CaptnJason.
echo 
echo KEYBOARD LAYOUT: US
echo 
ls /sys/firmware/efi/efivars
echo Boot mode should be BIOS. ^C to exit script.
echo 
echo Setting up DCHPCD. Assuming wired connection.
ping -c 5 rebelgaming.org | grep -v time=
echo done. Assuming successful ping.
echo 
echo Setting time.
timedatectl set-ntp true
echo done.
echo 
echo Partitioning /dev/sda
fdisk -l
echo -e "n\np\n\n\n+512M\nt\n82\nn\np\n\n\n\nw\n" | fdisk /dev/sda
echo done.
echo 
echo Making root file system
mkfs.ext4 /dev/sda2
echo done.
echo 
echo Making swap file system
mkswap /dev/sda1
echo done.
echo 
echo Mounting root file system at /mnt
mount /dev/sda2 /mnt
echo done.
echo 
echo Enabling swap file system.
swapon /dev/sda1
echo done.
echo 
echo Running pacstrap to install base packages.
pacstrap /mnt base linux linux-firmware
echo done.
echo 
echo Running pacstrap to install features.
pacstrap /mnt grub vim nano dhcpcd man-db man-pages texinfo sudo
echo done.
echo 
echo Generating fstab.
genfstab -U /mnt >> /mnt/etc/fstab
echo done.
echo 
echo Changing root. Completing install. 
echo "ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc
echo -e \"177G\nx:wq\" | vim /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo archpad > /etc/hostname
echo \"127.0.0.1	localhost
::1		localhost
127.0.1.1	archpad.localdomain	archpad\" > /etc/hosts
mkinitcpio -P
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
exit
" | arch-chroot /mnt
echo done. Root Password is archpad. Have fun!
echo 
echo Rebooting in 5 seconds.
sleep 5
reboot now