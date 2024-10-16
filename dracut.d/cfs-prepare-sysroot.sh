#!/bin/sh -ex

mkdir /sysroot.tmp

## FIXME root-device
mount /dev/vda3 /sysroot.tmp

## FIXME image name
mount -t composefs /sysroot.tmp/composefs/images/bootc-cs9.cfs -o basedir=/sysroot/composefs/repo /sysroot

## FIXME var / etc
mount --bind /sysroot.tmp/ostree/deploy/default/deploy/37595a2f96fc23131eef6af87920858e6eecc4de5540ef3278aa7e184c7d4d5c.0/etc /sysroot/etc
mount --bind /sysroot.tmp/ostree/deploy/default/var /sysroot/var

