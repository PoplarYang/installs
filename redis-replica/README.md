## Introduction 
create a redis-sentinel demo in a single server

## version
redis-4.0.12
redis-5.0.8

## dependencies
* redis
    yum install -y jemalloc-devel
* test
    pip install redis

## Ports
1. redis replica
    * 7000
    * 7001
    * 7002
2. sentinel
    * 5000
    * 5001
    * 5002
