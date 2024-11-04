IMAGE=bootd-ubuntu
MNT=`podman image mount $IMAGE`
SYSROOT_MNT=/root/sysroot

xargs -n1 -a /proc/cmdline | grep = | tee /tmp/cmdline.sh
source /tmp/cmdline.sh || true

mkdir -p $SYSROOT_MNT
mount $root $SYSROOT_MNT
mkdir -p $SYSROOT_MNT/composefs/images $SYSROOT_MNT/composefs/repo
mkcomposefs --digest-store=$SYSROOT_MNT/composefs/repo $MNT $SYSROOT_MNT/composefs/images/$IMAGE.cfs

cp $MNT/usr/lib/modules/*/vmlinuz /boot/bootd-vmlinuz-$IMAGE
cp $MNT/usr/lib/modules/*/initramfs.img /boot/bootd-initramfs.img-$IMAGE

# systemd.debug-shell=1
# https://vmware.github.io/photon/assets/files/html/3.0/photon_troubleshoot/enabling-systemd-debug.html
# Press Alt+Ctrl+F9 to switch to tty9 to access the debug shell.

# systemd.log_level=debug
cat << EOF > /boot/loader/entries/bootd.conf
title bootd $IMAGE
version 1
options root=$root rw image=bootd-ubuntu systemd.debug-shell=1 apparmor=0
linux /bootd-vmlinuz-$IMAGE
initrd /bootd-initramfs.img-$IMAGE
EOF


# copy default
mkdir -p $SYSROOT_MNT/composefs/etc
. $MNT/usr/lib/os-release

TARGET_ETC=$SYSROOT_MNT/composefs/etc/$ID.$VERSION_ID

#TARGET_VAR=$SYSROOT_MNT/ostree/deploy/default/var
#test -d $TARGET_VAR || TARGET_VAR=$SYSROOT_MNT/var
#
#test -d $SYSROOT_MNT/home && (mv $SYSROOT_MNT/home $TAGET_VAR/home && ln -s var/home $SYSROOT_MNT/home)
#test -d $SYSROOT_MNT/root && (mv $SYSROOT_MNT/root $TAGET_VAR/roothome && ln -s var/root $SYSROOT_MNT/root)
#test -d $SYSROOT_MNT/mnt && (mv $SYSROOT_MNT/mnt $TAGET_VAR/mnt && ln -s var/mnt $SYSROOT_MNT/mnt)
#test -d $SYSROOT_MNT/srv && (mv $SYSROOT_MNT/srv $TAGET_VAR/srv && ln -s var/mnt $SYSROOT_MNT/srv)

# FIXME
ln -s -f ../usr/share/bootd/apt $TAGET_VAR/lib/apt
ln -s -f ../usr/share/bootd/dpkg $TAGET_VAR/lib/dpkg

# FIXME 3 way merge
cp -rfv $MNT/usr/etc $TARGET_ETC
# override
for i in fstab passwd shadow sudo.conf sudoers
do
  cp /etc/$i $TARGET_ETC/$i
done
