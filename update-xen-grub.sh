#/bin/sh

set -e

[ -f grub-0.97.tar.gz ] || curl -O http://alpha.gnu.org/gnu/grub/grub-0.97.tar.gz
[ -d xen.git ] || git clone git://xenbits.xen.org/xen.git xen.git

git rm grub-0.97 || true
[ -d grub-0.97 ] && rm -rf grub-0.97
gzip -dc grub-0.97.tar.gz | tar xf -

cd grub-0.97
for p in ../xen.git/stubdom/grub.patches/*; do
    patch -p1 < $p
done
find . -name \*\.orig -exec rm {} \;

cd -
git add grub-0.97

cd xen.git
printf "Syncing xen.org pv-grub up to commit $(git log --pretty=%h -1..HEAD stubdom/grub.patches):\n\n" >../commitmsg
git log --pretty -1..HEAD stubdom/grub.patches >>../commitmsg
cd -

git commit grub-0.97 -F commitmsg && rm commitmsg
