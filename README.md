## libhdfs3 with kerberos auth support

In order to compile this lib, first we need this version of libgsasl that has kerberos support:

## Installation

First, we need to compile OpenSSL 0.9.7:
1. git clone https://github.com/openssl/openssl.git
2. cd openssl
3. git checkout OpenSSL_0_9_7-stable
4. ./config --prefix=/usr/local --openssldir=/usr/local/openssl
5. make -j$(nproc)
6. make install
7. make clean

Next, install this custom version of libgsasl with kerberos operations support:
1. cd /tmp/ 
2. git clone https://github.com/bdrosen96/libgsasl.git 
3. cd /tmp/libgsasl/lib 
4. ./configure --with-gssapi-impl=mit 
5. make -j$(nproc) 
6. make install 
7. rm -rf /tmp/libgsasl 
8. ldconfig

Now install latests OpenSSL version as previously shown with master branch.

Finally, install libhdfs3:
1. cd libhdfs3-downstream/libhdfs3  
2. sed -i 's/libgsasl7-dev//g' debian/build.sh
3. ./debian/build.sh install_depends  
4. mkdir build  
5. cd  build  
6. ../bootstrap --prefix=/usr/local 
7. make -j$(nproc)  
8. make install
9. make clean


