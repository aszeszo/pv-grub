#/bin/sh

set -e

[ -d illumos-gate.git/.git ] || git clone git://github.com/illumos/illumos-gate.git

git rm -rf grub-0.97 || true

mkdir -p grub-0.97/stage2/zfs-include
cp illumos-gate.git/usr/src/grub/grub-0.97/stage2/zfs-include/* grub-0.97/stage2/zfs-include
cp illumos-gate.git/usr/src/grub/grub-0.97/stage2/fsys_zfs.* grub-0.97/stage2
cp illumos-gate.git/usr/src/grub/grub-0.97/stage2/zfs_*.* grub-0.97/stage2

git add grub-0.97

COMMITMSG=$PWD/commitmsg
cd illumos-gate.git
printf "Syncing illumos.org grub up to commit $(git log --pretty=%h -1..HEAD usr/src/grub/grub-0.97/stage2):\n\n" >$COMMITMSG
git log --pretty -1..HEAD usr/src/grub/grub-0.97/stage2 >>$COMMITMSG
cd -

git commit grub-0.97 -F $COMMITMSG && rm $COMMITMSG
