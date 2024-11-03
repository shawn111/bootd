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

cat << EOF > /boot/loader/entries/bootd.conf
title bootd $IMAGE
version 1
options root=$root rw image=bootd-ubuntu rd.break=cleanup
linux /bootd-vmlinuz-$IMAGE
initrd /bootd-initramfs.img-$IMAGE
EOF

# copy default
cp -rfv $MNT/usr/etc /etc

# override
for i in fstab passwd shadow
do
  cp /etc/$i $SYSROOT_MNT/etc
done

#repo /composefs/repo
#composefs/images/$image.cfs
