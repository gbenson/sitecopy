set -exu

package=$(basename $PWD)
name=$(echo $package | sed 's/-.*//')
version=$(echo $package | sed "s/$name-//")

sed -i 's/ChangeLog//g' $name.spec.in

sed -i "s/@TARGET@/$name/g" Makefile.in

sed 's/@mkdir_p@/$(MKDIR_P)/g' \
  < /usr/share/gettext/po/Makefile.in.in \
  > po/Makefile.in.in

cp -a .update-po.sh .update-po.sh.keep
echo > .update-po.sh

./.release.sh $version
./autogen.sh

mv -f .update-po.sh.keep .update-po.sh

cd ..
tar cf $package.tar $package
gzip -9 $package.tar
