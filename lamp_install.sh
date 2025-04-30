#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

set -e

SRC_PATH="/opt/src"
MAIN_PATH="/opt"
PCRE2_VER="10.43"
ZLIB_VER="1.3.1"
OPENSSL_VER="3.0.13"
NGINX_VER="1.27.4"
MARIADB_VER="10.6.17"

function temp_install_build_tools {
    apt update
    apt install -y build-essential cmake pkg-config git wget bison
}

function pcre2_build {
    cd "$SRC_PATH"
    wget "github.com/PCRE2Project/pcre2/releases/download/pcre2-$PCRE2_VER/pcre2-$PCRE2_VER.tar.gz"
    tar -zxf "pcre2-$PCRE2_VER.tar.gz"
    cd "pcre2-$PCRE2_VER"
    #./configure --prefix="$MAIN_PATH/pcre2-$PCRE2_VER"
    #make && make install
    ls -la
    #cd ..
}

function zlib_build() {
    cd "$SRC_PATH"
    wget "http://zlib.net/zlib-$ZLIB_VER.tar.gz"
    tar -zxf "zlib-$ZLIB_VER.tar.gz"
    cd "zlib-$ZLIB_VER"
    ./configure --prefix="$MAIN_PATH/zlib-$ZLIB_VER"
    make && make install
    cd ..
}

function openssl_build() {
    cd "$SRC_PATH"
    wget "https://www.openssl.org/source/openssl-$OPENSSL_VER.tar.gz"
    tar -zxf "openssl-$OPENSSL_VER.tar.gz"
    cd "openssl-$OPENSSL_VER"
    ./config --prefix="$MAIN_PATH/openssl-$OPENSSL_VER" --openssldir"=$MAIN_PATH/openssl-$OPENSSL_VER"
    make && make install
    cd ..
}

function nginx_build() {
    cd "$SRC_PATH"
    wget "http://nginx.org/download/nginx-$NGINX_VER.tar.gz"
    tar -zxf "nginx-$NGINX_VER.tar.gz"
    cd "nginx-$NGINX_VER"
    ./configure \
        --prefix="$MAIN_PATH/nginx" \
        --with-zlib="$SRC_PATH/zlib-$ZLIB_VER" \
        --with-pcre="$SRC_PATH/pcre2-$PCRE2_VER" \
        --with-openssl="$SRC_PATH/openssl-$OPENSSL_VER" \
        --with-http_ssl_module
    make && make install
    cd ..
}

function mariadb_build() {
    cd "$SRC_PATH"
    wget "https://downloads.mariadb.org/f/mariadb-$MARIADB_VER/source/mariadb-$MARIADB_VER.tar.gz"
    tar -xzf "mariadb-$MARIADB_VER.tar.gz"
    cd "mariadb-$MARIADB_VER"
    cd ..
    #todo
}

#temp_install_build_tools
mkdir -p "$SRC_PATH"
cd "$MAIN_PATH"

pcre2_build
#zlib_build
#openssl_build
#nginx_build
#mariadb_build