Delphyne
========
[![Build Status](https://travis-ci.org/njh/delphyne.svg)](https://travis-ci.org/njh/delphyne)

Delphyne is a command line tool written in [Bash] for interacting with the [Mythic Beasts] [DNS API].

The primary use for it is publishing a directory of [zone file]s to the Mythic Beasts API.
This allows for the zones to be version controlled, for example, using git.


Installation
------------

Delphyne has two major dependencies:

- [bash] - the Bourne Again SHell
- [curl] - command line URL tool

They will typically already be installed on Linux and Mac OS systems.
If not available on your system, they are widely available in package managers.

To then install delphyne on your system run:

    make install

By default it will be installed to `/usr/local/bin/delphyne`.


Usage
-----

    Usage: delphyne [options] <command>

    Commands:
     delphyne zones                   List the registered zones
     delphyne get <zone>              Get a DNS zone
     delphyne dynamic <hostname>      Update hostname to public IP address of this machine
     delphyne publish [<filename>]    Replace zone(s) with contents of file(s)
     delphyne help                    Show help text
     delphyne version                 Print version information

    Options:
     -j, --json                       Use JSON file format for DNS records
     -r, --rfc1035                    Use RFC1035 (aka bind) zone file format
     -d, --debug                      Turn on debugging of the HTTP request
     -4, --ipv4                       Use IPv4 when talking to the Mythic Beasts API
     -6, --ipv6                       Use IPv6 when talking to the Mythic Beasts API


### Authenticating

Credentials can be obtained from the [API Keys] section of the [Mythic Beasts] control panel.
Credentials can be unrestricted, allowing them to manage all zones on your account, or restricted to individual zones, records and record types.

Authentication information is stored in a `.env` file in your working directory.

    MYTHIC_BEASTS_API_KEY="xxxx"
    MYTHIC_BEASTS_SECRET="xxxxxxxx"

Alternatively, you can define them as environment variables.


### Getting a list of zones

Use the `zone` command to get a list of domains/zones.
The zone names are displayed with one zone per line.

Example:
```
$ delphyne zones
Getting zones
example.com
example.org
example.net
```


### Getting a zone's records

The `get` command fetches the records for a zone from the API.
The zone can be output either as [RFC1035] zone file (the file format that [bind] uses) or JSON.

Example:
```
$ delphyne get example.com
Getting zone example.com
@                      900 NS    ns1.mythic-beasts.com.
@                      900 NS    ns2.mythic-beasts.com.
@                      900 A     93.184.216.34
www                    900 A     93.184.216.34
```

To fetch as JSON, use `-j` option. This example pipes the result through [jq] to format it nicely:
```
$ delphyne -j get aelius.net | jq
Getting zone aelius.net
{
  "records": [
    {
      "data": "ns1.mythic-beasts.com.",
      "host": "@",
      "ttl": 900,
      "type": "NS"
    },
    {
      "data": "ns2.mythic-beasts.com.",
      "host": "@",
      "ttl": 900,
      "type": "NS"
    },
    {
      "data": "93.184.216.34",
      "host": "@",
      "ttl": 900,
      "type": "A"
    },
    {
      "data": "93.184.216.34",
      "host": "www",
      "ttl": 900,
      "type": "A"
    }
  ]
}
```


### Dynamic DNS

The `dynamic` command creates a DNS entry pointing to the public IP address of your computer.

```
$ delphyne dynamic dsl.example.net
Dynamic update for dsl.example.net
=> Dynamic DNS for dsl set to 198.51.100.18
```

By default, the `dynamic` command will use IPv4 to talk to the Mythic Beasts API and set an `A` record.
However, if you pass the `-6` option, it will set an `AAAA` IPv6 address instead.


### Publishing zone records

The `publish` command allows you to upload a [zone file] and **replace** all the records for that zone.
It uses the `PUT` HTTP method, which deletes all the existing records and replaces them with the new records in a single transaction.

The zone name must be in the filename and must follow the following pattern:
* `<zonename>.zone` - a [RFC1035] formatted zone file
* `<zonename>.json` - a JSON formatted file
* `db.<zonename>` - same as .zone but with a [bind] style filename

Example of publishing a single zone file:
```
$ delphyne publish ./example.net.zone
Publishing: example.net
=> 8 records added

```

If `filename` is a directory, then all the matching files in that directory are published.
If no `filename` is given, then all the files in the current directory are published.

Example of publishing multiple zone files in the current working directory:
```
$ delphyne publish
Publishing: example.com
=> 31 records added

Publishing: example.net
=> 8 records added

Publishing: example.org
=> 8 records added

```

If you want to publish all the `.json` files in a directory, then the `-j` option must be given.


Why is it called Delphyne?
--------------------------

In Greek mythology, [Delphyne](https://en.wikipedia.org/wiki/Delphyne) is the name given to the monstrous serpent killed by Apollo at Delphi.


Resources
---------

* DNS API v2 Tutorial: https://www.mythic-beasts.com/support/api/dnsv2/tutorial
* DNS API v2 Documentation: https://www.mythic-beasts.com/support/api/dnsv2
* File format for .zone files: https://tools.ietf.org/html/rfc1035


License
-------

This tool is licensed under the terms of the MIT license.
See the file [LICENSE](/LICENSE.md) for details.


Contact
-------

Please note that this is not an official tool.
I am a customer of [Mythic Beasts], not an employee.

* Author:    Nicholas J Humfrey
* Twitter:   [@njh]
* Home Page: https://njh.me/



[bash]:           https://www.gnu.org/software/bash/
[curl]:           https://curl.haxx.se/
[bind]:           https://www.isc.org/bind/
[@njh]:           https://twitter.com/njh
[Mythic Beasts]:  https://www.mythic-beasts.com/
[DNS API]:        https://www.mythic-beasts.com/sales/domains/dynamic-dns
[API Keys]:       https://www.mythic-beasts.com/customer/api-users
[RFC1035]:        https://tools.ietf.org/html/rfc1035
[jq]:             https://stedolan.github.io/jq/
[zone file]:      https://en.wikipedia.org/wiki/Zone_file
