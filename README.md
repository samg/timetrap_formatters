Timetrap Formatters
===================

This is a repository of custom formatters available for the Timetrap
(https://github.com/samg/timetrap).

Feel free to modify them for you own use or contribute to this repository (send
a pull request)

## Installing

Custom formatters can be installed by saving the formatter source files in
`~/.timetrap/formatters` (or wherever you choose using `t configure`).

One easy way to install all of these formatters is with this command:

    git clone git://github.com/samg/timetrap_formatters ~/.timetrap

You can also:

    git clone git://github.com/samg/timetrap_formatters /some/path
    mkdir -p ~/.timetrap/
    ln -s /some/path ~/.timetrap/formatters

See https://github.com/samg/timetrap/blob/master/README.md for more details.

## Formatters:


### Factor

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

## Contributing

To contribute your custom formatter fork this repo and send a pull request.

Update the README with some info about your formatter and some sample output.

If you'd like to TDD your formatter `spec/timetrap_formatter_spec.rb` is available.
This helps ensure future changes to timetrap won't break your formatter.

Bugs and Feature Requests
--------
Submit to http://github.com/samg/timetrap/issues
