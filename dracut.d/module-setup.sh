#!/bin/bash


# called by dracut
check() {
    require_binaries mount.composefs || return 1
    return 0
}

# called by dracut
depends() {
    echo network
    return 0
}

# called by dracut
install() {
    inst_binary /usr/bin/touch
    inst_binary /usr/sbin/chroot
    inst_binary /usr/bin/bootctl
    inst_binary /usr/bin/rsync
    inst_binary /usr/bin/find
    inst_binary /usr/bin/curl
    inst_binary /usr/bin/less
    inst_binary /usr/bin/wc
    inst_binary /usr/bin/basename
    inst_binary /usr/bin/cut
    inst_binary /usr/bin/grep
    inst_binary /usr/bin/sed
    inst_binary /usr/bin/awk
    inst_binary /usr/bin/fmt
    inst_binary /usr/bin/uname
    inst_binary /usr/bin/ocipkg
    inst_binary /usr/sbin/dhclient
    inst_binary /usr/bin/vim
    inst_binary /usr/sbin/partx
    inst_binary /usr/bin/lsblk
    inst_binary /usr/sbin/lvm
    inst_binary /usr/sbin/parted
    inst_binary /usr/sbin/mkfs.xfs
    inst_binary /usr/sbin/mkfs.fat
    inst_binary /usr/sbin/mkfs.vfat
    inst_binary /usr/sbin/blkid
    inst_binary /usr/sbin/sgdisk
    inst_binary /usr/sbin/grub2-install
    inst_binary /usr/sbin/grub2-mkconfig
    inst_binary /usr/sbin/grub2-probe
    inst_binary /usr/sbin/grub2-get-kernel-settings
    inst_binary /usr/bin/grub2-script-check
    inst_binary /usr/bin/grub2-mkrelpath

    inst_hook initqueue/online 10 "$moddir/ulo-env.sh"
    inst_hook initqueue/online 65 "$moddir/ulo-parted.sh"

    inst_simple "${moddir}/ulo-load-distro.sh" "/usr/libexec/ulo-load-distro.sh"
    inst_simple "${moddir}/ulo-grub-bls.sh" "/usr/libexec/ulo-grub-bls.sh"
    inst_simple "${moddir}/ulo-parted.sh" "/usr/libexec/ulo-parted.sh"
    inst_simple "${moddir}/ulo-load-distro.service" "$systemdsystemunitdir/ulo-load-distro.service"

    inst_simple "${moddir}/lvm.conf" "/etc/lvm/lvm.conf"
    inst_simple "${moddir}/ulo-sample.env" "/var/lib/ulo/var.env"
    inst_dir /lib/grub/x86_64-efi
    inst_dir /lib/grub/i386-pc
    inst_dir /usr/share/grub
    inst_multiple -o $(find /lib/grub/ -type f)
    inst_multiple -o $(find /usr/share/grub/ -type f)
    inst_multiple -o $(find /etc/grub.d/ -type f)

    systemctl -q --root "$initdir" enable ulo-load-distro
    systemctl -q --root "$initdir" add-wants initrd.target ulo-load-distro
    return 0
}
