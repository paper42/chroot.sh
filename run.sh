#!/bin/sh
# usage:
# 1. create directory root/ with rootfs
# 2. ./run.sh
#
# any argument to run.sh will be passed to the shell interpreter
# example: ./run.sh -c ls

if ! [ $(whoami) = "root" ]; then
	sudo sh "$0" "$@"
	exit 0
fi
cd "$(dirname "$0")" || exit 1
oldPS1=$PS1
oldPATH=$PATH
chroot_dir='root'
cp /etc/resolv.conf "$chroot_dir/etc/"
mount -t proc none "$chroot_dir/proc"
mount -o bind /sys "$chroot_dir/sys"
mount -o bind /dev "$chroot_dir/dev"
mount -t tmpfs -o size=1G tmpfs "$chroot_dir/tmp"

PATH='/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin'
PS1='$(pwd): '
shell=
for s in zsh fish bash loksh ksh mksh ash sh; do
	if [ -e "$chroot_dir/bin/$s" ]; then
		shell="$s"
		break
	fi
done
TERM=xterm-256color chroot "$chroot_dir" "/bin/$shell" $@
PS1=$oldPS1
PATH=$oldPATH

umount "$chroot_dir/dev" "$chroot_dir/proc" "$chroot_dir/sys" "$chroot_dir/tmp"
