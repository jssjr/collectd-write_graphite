COLLECTD_PREFIX=/usr/local
COLLECTD_VERSION=5.0.0

COLLECTD_SRC=work/collectd-$(COLLECTD_VERSION)

LIBTOOL=$(COLLECTD_SRC)/libtool
FETCH=fetch

all: .INIT write_graphite.la

install: all
	$(LIBTOOL) --mode=install /usr/bin/install -c write_graphite.la \
		$(COLLECTD_PREFIX)/lib/collectd

test: Makefile
	@echo $^

clean:
	rm -rf .libs
	rm -rf build
	rm -rf work
	rm -f write_graphite.la

.INIT:
	mkdir -p build
	mkdir -p work
	( if [ ! -d $(COLLECTD_SRC)/src ] ; then \
		cd work ; \
		$(FETCH) http://collectd.org/files/collectd-$(COLLECTD_VERSION).tar.gz ; \
		tar zxvf collectd-$(COLLECTD_VERSION).tar.gz ; \
		cd collectd-$(COLLECTD_VERSION) ; \
		if [ ! -f libtool ] ; then \
			./configure ; \
		fi ; \
	fi )

write_graphite.la: build/write_graphite.lo
	$(LIBTOOL) --tag=CC --mode=link gcc -Wall -Werror -g -O2 -module \
		-avoid-version -o $@ -rpath $(COLLECTD_PREFIX)/lib/collectd \
		-lpthread build/write_graphite.lo

build/write_graphite.lo: src/write_graphite.c
	$(LIBTOOL) --mode=compile gcc -DHAVE_CONFIG_H -I src \
		-I $(COLLECTD_SRC)/src -Wall -Werror -g -O2 -MD -MP -c -o $@ src/write_graphite.c
