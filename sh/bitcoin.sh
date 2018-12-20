#!/bin/sh
BITCOIN_ROOT=/mnt/bitd

# Pick some path to install BDB to, here we create a directory within the bitcoin directory
BDB_PREFIX="${BITCOIN_ROOT}/db4"
mkdir -p $BDB_PREFIX

# Fetch the source and verify that it is not tampered with
wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
echo '12edc0df75bf9abd7f82f821795bcee50f42cb2e5f76a6a281b85732798364ef  db-4.8.30.NC.tar.gz' | sha256sum -c
tar -xzvf db-4.8.30.NC.tar.gz

cd /mnt/bitd
wget https://sourceforge.net/projects/boost/files/boost/1.64.0/boost_1_64_0.tar.bz2/download -O boost_1_64_0.tar.bz2
tar jxvf boost_1_64_0.tar.bz2
cd boost_1_64_0
./bootstrap.sh
./b2 --prefix=/mnt/bitd/deps link=static runtime-link=static install

# Build the library and install to our prefix
cd db-4.8.30.NC/build_unix/
#  Note: Do a static build so that it can be embedded into the executable, instead of having to find a .so at runtime
../dist/configure --enable-cxx --disable-shared --with-pic --prefix=$BDB_PREFIX
make install

# Configure Bitcoin Core to use our own-built instance of BDB
cd $BITCOIN_ROOT
./autogen.sh
./configure --prefix=$BITCOIN_ROOT --without-gui LDFLAGS="-L${BDB_PREFIX}/lib/" CPPFLAGS="-I${BDB_PREFIX}/include/"
