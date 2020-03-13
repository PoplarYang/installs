VERSION=4.0.12
VERSION=5.0.8
REDIS_DIR=redis-$(VERSION)
REDIS_TARGZ=redis-$(VERSION).tar.gz

.PHONY: all
all: deps build install status

.PHONY: deps
deps:
	yum install -y jemalloc jemalloc-devel gcc
	test -e $(REDIS_TARGZ) || wget http://download.redis.io/releases/$(REDIS_TARGZ)

.PHONY: build
build:
	rm -rf $(REDIS_DIR) && tar xf $(REDIS_TARGZ)
	cd $(REDIS_DIR) && $(MAKE)
	cp -fv $(REDIS_DIR)/src/{redis-server,redis-cli} ./

.PHONY: replica
replica:
	bash install_redis_replica.sh

.PHONY: sentinel
sentinel:
	bash install_redis_sentinel.sh

.PHONY: install
install: replica sentinel

.PHONY: status
status:
	-netstat -natp | grep redis-ser 2> /dev/null || echo "No redis is running"

.PHONY: test
test:
	python redis_test.py

.PHONY: clean
clean:
	-killall -9 redis-server &> /dev/null
	-rm -rf redis-run-*
	-rm -rf sentinel-run-*
	-rm -rf $(REDIS_DIR) $(REDIS_TARGZ)
	-rm redis-cli redis-server