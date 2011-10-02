write\_graphite
==============

An output plugin for [collectd](http://collectd.org).

Description
-----------

The write\_graphite plugin sends data to [Carbon](http://graphite.wikidot.com/carbon), the [Graphite](http://graphite.wikidot.com) backend. Data is sent in 4K blocks over TCP to Carbon. I could possibly have named this plugin write\_carbon.


Installation
------------

First, modify the variables at the top of the Makefile to fit your system. (I use FreeBSD.) Then continue making the project as usual. During the initial make, collectd will be downloaded and configured to provide the neccesary libtool script.

    $ git clone git@github.com:jssjr/collectd-write_graphite.git
    $ cd collectd-write_graphite
    $ make
    $ sudo make install


Configuration
-------------

Enable the plugin in collectd.conf by adding:

    LoadPlugin write_graphite

Configure the plugin to match your carbon configuration.

    <Plugin write_graphite>
      <Carbon>
        Host "localhost"
        Port 2003
        Prefix "collectd"
      </Carbon>
    </Plugin>

Restart collectd to load the new plugin.
