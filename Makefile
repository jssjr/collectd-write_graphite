COLLECTD_PREFIX?=/usr/local
COLLECTD_VERSION=5.0.0

COLLECTD_SRC=work/collectd-$(COLLECTD_VERSION)

LIBTOOL=$(COLLECTD_SRC)/libtool
FETCH=fetch

CFLAGS?=-DNDEBUG -O3

all: .INIT write_graphite.la

install: all
	$(LIBTOOL) --mode=install /usr/bin/install -c write_graphite.la \
		$(COLLECTD_PREFIX)/lib/collectd
	$(LIBTOOL) --finish \
		$(COLLECTD_PREFIX)/lib/collectd

clean:
	rm -rf .libs
	rm -rf build
	rm -f write_graphite.la

distclean: clean
	rm -rf work

.INIT:
	mkdir -p build
	mkdir -p work
	( if [ ! -d $(COLLECTD_SRC)/src ] ; then \
		if which fetch ; then \
			DOWNLOAD_TOOL=`which fetch` ; \
		elif which wget ; then \
			DOWNLOAD_TOOL=`which wget` ; \
		fi ; \
		cd work ; \
		$${DOWNLOAD_TOOL} http://collectd.org/files/collectd-$(COLLECTD_VERSION).tar.gz ; \
		tar zxvf collectd-$(COLLECTD_VERSION).tar.gz ; \
		cd collectd-$(COLLECTD_VERSION) ; \
		if [ ! -f libtool ] ; then \
			./configure ; \
		fi ; \
	fi )

write_graphite.la: build/write_graphite.lo
	$(LIBTOOL) --tag=CC --mode=link gcc -Wall -Werror $(CFLAGS) -module \
		-avoid-version -o $@ -rpath $(COLLECTD_PREFIX)/lib/collectd \
		-lpthread build/write_graphite.lo

build/write_graphite.lo: src/write_graphite.c
	$(LIBTOOL) --mode=compile gcc -DHAVE_CONFIG_H -I src \
		-I $(COLLECTD_SRC)/src -Wall -Werror $(CFLAGS) -MD -MP -c \
		-o $@ src/write_graphite.c
