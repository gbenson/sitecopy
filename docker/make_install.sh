set -exuo pipefail

tar xf $1.tar.gz
cd $1
./configure
make
strip sitecopy
make install
