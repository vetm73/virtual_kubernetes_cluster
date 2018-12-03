#/bin/bash

set -e

DEST=/opt/

if [ ! -d $DEST ]; then
  mkdir -p $DEST
fi

cd $DEST

if [[ -e $DEST/.bootstrapped ]]; then
  exit 0
fi

# https://bitbucket.org/pypy/pypy/downloads/pypy2-v6.0.0-linux64.tar.bz2
PYPY_VERSION=v6.0.0
PYPY_DIR=pypy2-$PYPY_VERSION-linux64
PYPY_FILE=$PYPY_DIR.tar.bz2

if [[ -e $DEST/$PYPY_FILE ]]; then
  tar -xjf $DEST/$PYPY_FILE
  rm -rf $DEST/$PYPY_FILE
else
  wget -O - https://bitbucket.org/pypy/pypy/downloads/$PYPY_FILE |tar -xjf -
fi

mv -n $PYPY_DIR pypy

## library fixup
mkdir -p pypy/lib
[ -f /lib64/libncurses.so.5.9 ] && ln -snf /lib64/libncurses.so.5.9 $DEST/pypy/lib/libtinfo.so.5
[ -f /lib64/libncurses.so.6.1 ] && ln -snf /lib64/libncurses.so.6.1 $DEST/pypy/lib/libtinfo.so.5

mkdir -p $DEST/bin

cat > $DEST/bin/python <<EOF
#!/bin/bash
LD_LIBRARY_PATH=$DEST/pypy/lib:$LD_LIBRARY_PATH exec $DEST/pypy/bin/pypy "\$@"
EOF

chmod +x $DEST/bin/python
$DEST/bin/python --version

touch $DEST/.bootstrapped
