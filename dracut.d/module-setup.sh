#!/bin/bash

# called by dracut
check() {
    require_binaries mount.composefs || return 1
    return 0
}

# called by dracut
depends() {
    return 0
}

# called by dracut
install() {
    inst_binary /usr/bin/mount.composefs
    inst_binary /usr/bin/tee
    inst_binary /usr/bin/xargs
    inst_binary /usr/bin/grep
    inst_binary /usr/bin/vi

    inst_simple "${moddir}/cfs-prepare-sysroot.sh" "/usr/libexec/cfs-prepare-sysroot.sh"
    inst_simple "${moddir}/cfs-prepare-sysroot.service" "$systemdsystemunitdir/cfs-prepare-sysroot.service"

    systemctl -q --root "$initdir" enable cfs-prepare-sysroot
    systemctl -q --root "$initdir" add-wants initrd.target cfs-prepare-sysroot
    return 0
}
