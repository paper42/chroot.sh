#!/bin/sh
# usage:
# 1. create directory root/ with rootfs
# 2. ./run.sh
#
# any argument to run.sh will be ran inside the chroot
# example: ./run.sh ls -la
SUDO=sudo
if command -v doas >/dev/null; then
    SUDO=doas
fi

if ! [ "$(id -u)" -eq 0 ]; then
	exec $SUDO sh "$0" "$@"
fi

chroot_dir='root'
if ! [ -d "$chroot_dir" ]; then
    echo "chroot directory $chroot_dir does not exist"
    exit 1
fi

cmd="$*"

oldPS1=$PS1
oldPATH=$PATH
cp /etc/resolv.conf "$chroot_dir/etc/"
mount -t proc none "$chroot_dir/proc"
mount -o bind /sys "$chroot_dir/sys"
mount -o bind /dev "$chroot_dir/dev"
mount -t tmpfs -o size=1G tmpfs "$chroot_dir/tmp"

PATH='/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin'
if ! [ "$cmd" ]; then
    shell=
    for s in zsh fish bash loksh ksh mksh ash sh; do
        if [ -f "$chroot_dir/bin/$s" ] || [ -L "$chroot_dir/bin/$s" ]; then
            shell="$s"
            break
        fi
    done
    cmd="/bin/$shell"
fi

PS1='\w: '
[ "$shell" = "zsh" ] && PS1='%~: '
PS1="$PS1" TERM=xterm-256color chroot "$chroot_dir" $cmd
PATH=$oldPATH
PS1="$oldPS1"

sleep .1
umount "$chroot_dir/dev" "$chroot_dir/proc" "$chroot_dir/sys" "$chroot_dir/tmp"
