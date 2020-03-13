#!/bin/bash
# Desc: install redis replication in one host
# Date: 2020-03-11
# By: PoplarYang(echohelloyang@gmail.com)

set -o errexit
. env.sh

BIND_IP=${BIND_IP:-127.0.0.1}
MASTER_PORT=${MASTER_PORT:-7001}
SLAVE1_PORT=${SLAVE1_PORT:-7002}
SLAVE2_PORT=${SLAVE2_PORT:-7003}

## create redis master instances
echo "install redis master"
mkdir "redis-run-${MASTER_PORT}"/{data,logs} -p
cp redis-server redis.conf "redis-run-${MASTER_PORT}"
pushd "redis-run-${MASTER_PORT}"
./redis-server redis.conf --bind "${BIND_IP}" --port "${MASTER_PORT}" --protected-mode no
popd

echo "install redis slave1"
## create redis slave1 instances
mkdir "redis-run-${SLAVE1_PORT}"/{data,logs} -p
cp redis-server redis.conf "redis-run-${SLAVE1_PORT}"
pushd "redis-run-${SLAVE1_PORT}"
./redis-server redis.conf --bind "${BIND_IP}" --port "${SLAVE1_PORT}" --protected-mode no \
    --slaveof "${BIND_IP}" "${MASTER_PORT}"
popd

## create redis slave2 instances
echo "install redis slave2"
mkdir "redis-run-${SLAVE2_PORT}"/{data,logs} -p
cp redis-server redis.conf "redis-run-${SLAVE2_PORT}"
pushd "redis-run-${SLAVE2_PORT}"
./redis-server redis.conf --bind "${BIND_IP}" --port "${SLAVE2_PORT}" --protected-mode no \
    --slaveof "${BIND_IP}" "${MASTER_PORT}"
popd
echo "install finished"
