Timetrap Formatters
===================

This is a repository of custom formatters available for the Timetrap
(https://github.com/samg/timetrap).

Feel free to modify them for you own use or contribute to this repository (send
a pull request)


## Formatters:

The *factor* formatter is like the default *text* formatter, except it reads special
notes in your entry descriptions, and multiplies the entry's duration by them.
A note like *f:2* will multiply the entry's duration by two in the output.
See https://github.com/samg/timetrap/issues#issue/13 for more details.

    $ # note durations are multiplications of start and end times, based on notes
    $ t d -ffactor
    Timesheet: nopoconi
        Day                Start      End        Duration   Notes
        Mon Mar 07, 2011   19:56:06 - 20:18:37   0:22:31    merge factor in timetrap, f:3
                           20:19:04 - 20:23:02   0:01:59    document factor formatter f:0.5

                                                 0:22:34
        ---------------------------------------------------------
        Total                                    0:22:34


Bugs and Feature Requests
--------
Submit to http://github.com/samg/timetrap/issues
