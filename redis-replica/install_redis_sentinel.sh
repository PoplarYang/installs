#!/bin/bash
# Desc: install redis sentinel in one host
# Date: 2020-03-12
# By: PoplarYang(echohelloyang@gmail.com)

set -o errexit
. env.sh

BIND_IP=${BIND_IP:-127.0.0.1}
MASTER_PORT=${MASTER_PORT:-7000}

## create redis sentinel instances
echo "install redis sentinel"
for port in ${SENTINEL_PORTS[@]}; do
    mkdir "sentinel-run-${port}"/{data,logs} -p
    cp redis-server sentinel.conf "sentinel-run-${port}"
    pushd "sentinel-run-${port}"
    # add config
    sed -i "3isentinel monitor mymaster ${BIND_IP} ${MASTER_PORT} 2" sentinel.conf
    ./redis-server sentinel.conf --sentinel --bind "${BIND_IP}" --port "${port}"
    popd
done
