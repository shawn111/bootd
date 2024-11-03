#!/bin/sh -ex

CMDLINES=$(cat /proc/cmdline)

mkdir -p /sysroot.tmp

## FIXME rd.
xargs -n1 -a /proc/cmdline | grep = | grep -v rd. | tee /tmp/cmdline.sh
source /tmp/cmdline.sh

## FIXME root-device
mount -o rw $root /sysroot.tmp

# image=bootc-cs9
## FIXME image name
mount -t composefs /sysroot.tmp/composefs/images/$image.cfs -o basedir=/sysroot/composefs/repo /sysroot

## FIXME var / etc
mount --bind /sysroot.tmp/etc /sysroot/etc

test -d /sysroot.tmp/ostree/deploy/default/var && mount --bind /sysroot.tmp/ostree/deploy/default/var /sysroot/var || mount --bind /sysroot.tmp/var /sysroot/var


## FIXME
for i in fstab passwd shadow
do
test -f /sysroot/ostree/deploy/default/deploy/342d825130840afed290183be9e00a0e03907502bcb1f16cc60f92643924ed32.0/etc/$i && cp  /sysroot/ostree/deploy/default/deploy/342d825130840afed290183be9e00a0e03907502bcb1f16cc60f92643924ed32.0/etc/$i /sysroot/etc/$i
done
#mount --bind /sysroot.tmp/ostree/deploy/default/deploy/37595a2f96fc23131eef6af87920858e6eecc4de5540ef3278aa7e184c7d4d5c.0/etc /sysroot/etc
#mount --bind /sysroot.tmp/ostree/deploy/default/var /sysroot/var

