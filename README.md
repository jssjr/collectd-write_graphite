write_graphite
==============

An output plugin for [collectd](http://collectd.org).

It sends data to [Carbon](http://graphite.wikidot.com/carbon), the [Graphite](http://graphite.wikidot.com) backend. Data is sent in 4K blocks over TCP to Carbon. I could possibly have named this plugin write_carbon.


Installation
------------

First, modify the variables at the top of the Makefile to fit your system. (I use FreeBSD.) Then continue making the project as usual. During the initial make, collectd will be downloaded and configured to provide the neccesary libtool script.

    $ make

    $ sudo make install


Configuration
-------------

Enable the plugin in collectd.conf by adding:

    LoadPlugin write_graphite

Configure the plugin to match your cabron configuration.

    <Plugin write_graphite>
      <Carbon "backend1">
        Host "localhost"
        Port 2003
        Prefix "collectd"
      </Carbon>
    </Plugin>

Restart collectd to load the new plugin.
