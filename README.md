# chroot.sh

usage:
1. create directory with rootfs
2. run chroot.sh DIRECTORY [CMD [ARGS...]]

if CMD is specified, this command will run in the chroot  
if CMD is not specified, the most suitable shell will be selected and ran

example:
* `chroot.sh void`  runs a shell in void (probably bash)
* `chroot.sh ubuntu ls -la` runs ls -la in an ubuntu chroot
