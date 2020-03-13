import redis     # pip install redis
from redis.sentinel import Sentinel
import random

bind_ip="localhost"
master_port=7000
slave_ports=[7001, 7002]
master_name = "mymaster"
sentinel_hosts=[(bind_ip, 5000), (bind_ip, 5001), (bind_ip, 5002)]

# TODO: intend to split reads and writes
master = redis.Redis(host=bind_ip, port=master_port, db=0)
clients = [redis.Redis(host=bind_ip, port=port) for port in slave_ports]

master.set("foo", "bar")
assert "bar" == master.get("foo"), "get foo not return bar"
client = random.choice(clients)
assert "bar" == client.get("foo"), "get foo not return bar"
master.delete("foo")
assert None == client.get("foo"), "get foo not return None"
print("test set get delete ok")

sentinel = Sentinel(sentinel_hosts, socket_timeout=0.1)
print(sentinel.discover_master(master_name))
print(sentinel.discover_slaves(master_name))

master = sentinel.master_for(master_name, socket_timeout=0.1)
slave = sentinel.slave_for(master_name, socket_timeout=0.1)
master.set('foo1', 'bar1')
print(slave.get('foo1'))