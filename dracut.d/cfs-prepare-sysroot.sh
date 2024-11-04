#!/bin/sh -ex

CMDLINES=$(cat /proc/cmdline)

mkdir -p /sysroot.tmp

## FIXME rd.
xargs -n1 -a /proc/cmdline | grep root= | tee /tmp/cmdline.sh
. /tmp/cmdline.sh || true

xargs -n1 -a /proc/cmdline | grep image= | tee /tmp/cmdline.sh
. /tmp/cmdline.sh || true

## FIXME root-device
mount -o rw $root /sysroot.tmp

# image=bootc-cs9
## FIXME image name
mount -t composefs /sysroot.tmp/composefs/images/$image.cfs -o basedir=/sysroot/composefs/repo /sysroot

source /sysroot/usr/lib/os-release
# ID
# VERSION_ID

## init
#test -d /sysroot.tmp/composefs/etc/$ID.$VERSION_ID || cp -rpf /sysroot/usr/etc /sysroot.tmp/composefs/etc/$ID.$VERSION_ID

## FIXME var / etc
mount --bind /sysroot.tmp/composefs/etc/$ID.$VERSION_ID  /sysroot/etc
test -d /sysroot.tmp/ostree/deploy/default/var && mount --bind /sysroot.tmp/ostree/deploy/default/var /sysroot/var || mount --bind /sysroot.tmp/var /sysroot/var
