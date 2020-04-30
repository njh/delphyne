Delphyne
========
[![Build Status](https://travis-ci.org/njh/delphyne.svg)](https://travis-ci.org/njh/delphyne)

Delphyne is a command line tool written in Bash for interacting with the [Mythic Beasts] [DNS API].


Requirements
------------

- [bash] - the Bourne Again SHell
- [curl] - command line URL tool


Installation
------------


Usage
-----

    Usage: ./delphyne <command>

    Commands:
     delphyne get <zone>              Get a DNS zone
     delphyne help                    Show help text
     delphyne version                 Print version information


Authenticating
--------------

Authentication information is stored in a `.env` file in your working directory.

    MYTHIC_BEASTS_API_KEY="xxxx"
    MYTHIC_BEASTS_SECRET="xxxxxxxx"


Why is it called Delphyne?
--------------------------

In Greek mythology, [Delphyne](https://en.wikipedia.org/wiki/Delphyne) is the name given to the monstrous serpent killed by Apollo at Delphi.


Resources
---------

* DNS API v2 Documentation: https://www.mythic-beasts.com/support/api/dnsv2


License
-------

This tool is licensed under the terms of the MIT license.
See the file [LICENSE](/LICENSE.md) for details.


Contact
-------

* Author:    Nicholas J Humfrey
* Twitter:   [@njh]
* Home Page: https://njh.me/



[bash]:           https://www.gnu.org/software/bash/
[curl]:           https://curl.haxx.se/
[@njh]:           https://twitter.com/njh
[Mythic Beasts]:  https://www.mythic-beasts.com/
[DNS API]:        https://www.mythic-beasts.com/sales/domains/dynamic-dns

