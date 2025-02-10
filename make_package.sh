#!/bin/bash

# Builds a .tar.gz archive that can be unpacked in root to install
#
# Usage:
# ./make_package.sh
#
# supervisord configuration files are in `conf` directory.

# Installs:
#
# /usr/local/bin/mobilecoind
# /usr/local/bin/deqs
# /etc/supervisor/conf.d/mobilecoind.conf
# /etc/supervisor/conf.d/deqs.conf
# /var/lib/mobilecoind/ledger
# /var/lib/mobilecoind/watcher
# /var/lib/mobilecoind/mobilecoind-db

set -e

usage() {
    cat << EOF
    ./make_package.sh

    Produces package.tar.gz artifact in root of repository
    Unpack this in / to install a supervisord config that runs the services
    with autorestart=true.
EOF
}

if [ "$#" -ne 0 ]; then
    echo "wrong number of arguments: $#"
    usage
    exit 1
fi


ROOT=`git rev-parse --show-toplevel`

if [ ! -f "$ROOT/deqs/mobilecoin/target/release/mobilecoind" ]; then
    echo "deqs/mobilecoin/target/release/mobilecoind not found: You must build in release mode before packaging"
    exit 1
fi

if [ ! -f "$ROOT/deqs/target/release/deqs-server" ]; then
    echo "deqs/target/release/deqs-server not found: You must build in release mode before packaging"
    exit 1
fi

if [[ "$NETWORK" == "prod"* ]; then
    MOBILECOIND_CONF="$ROOT/conf/mobilecoind.conf"
    PACKAGE_NAME=package_mainnet.tar.gz
else
    MOBILECOIND_CONF="$ROOT/conf/mobilecoind-testnet.conf"
    PACKAGE_NAME=package_testnet.tar.gz
fi
echo "NETWORK=$NETWORK"
echo "PACKAGE_NAME=$PACKAGE_NAME"
echo "Using MOBILECOIND_CONF=$MOBILECOIND_CONF"

cd /tmp
rm -rf package
mkdir -p package
cd package
mkdir -p usr/local/bin/
mkdir -p var/lib/deqs
mkdir -p var/lib/mobilecoind
# Note: Don't create mobilecoind/ledger-db, we want the process to do that
mkdir -p var/lib/mobilecoind/watcher-db
mkdir -p var/lib/mobilecoind/mobilecoind-db
mkdir -p etc/supervisor/conf.d/

cd ..
chmod -R 755 package
cd package

cp -f "$ROOT/deqs/mobilecoin/target/release/mobilecoind" usr/local/bin/
chmod 755 usr/local/bin/mobilecoind
cp -f "$MOBILECOIND_CONF" etc/supervisor/conf.d/mobilecoind.conf
chmod 644 etc/supervisor/conf.d/mobilecoind.conf

cp -f "$ROOT/deqs/target/release/deqs-server" usr/local/bin/
chmod 755 usr/local/bin/deqs-server
cp -f "$ROOT/conf/deqs.conf" etc/supervisor/conf.d/deqs.conf
chmod 644 etc/supervisor/conf.d/deqs.conf

cd ..
tar cvfz "package.tar.gz" --transform "s|^package||" package
mv package.tar.gz "$ROOT/$PACKAGE_NAME"
rm -rf package
echo "Produced $PACKAGE_NAME successfully."
