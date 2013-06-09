Timetrap Formatters
===================

This is a repository of custom formatters available for Timetrap
(https://github.com/samg/timetrap).

Feel free to modify them for you own use or contribute to this repository (send
a pull request).

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

### Day Progress Formatter

The *day* formatter sums up the time you've logged today and
tells you how near your working day to completion is.

    $ t d -f day

    [################################### ] 70%
    1:03:04

Requires two properties to be added to `~/.timetrap.yml` (see `t configure`)

    day_length_hours => how long you want your working day to be
    progress_width => the width of the progress bar

A list of sheets to be ignored by the calculation can be specified by an optional
parameter

    day_exclude_sheets => a list of sheet names to exclude from calculations


### Datesheet

The *datesheet* formatter makes it easy to grep for an entry and get the
reference to date and sheet in the output lines.

    $ t d -f datesheet
    2011-12-01 17:28:25 - 17:34:37 0:06:12 [Sheet] Entry description

Some nice aliases for the datesheet formatter:

    alias tmf="clear && t d all -s 'today' -f datesheet"
    alias tmg="clear && t d all -s 'today' -f datesheet | sort -n -k 2.1 -k 2.2"

### Factor

The *factor* formatter is like the default *text* formatter, except it reads special
notes in your entry descriptions, and multiplies the entry's duration by them.
A note like *f:2* will multiply the entry's duration by two in the output.
See https://github.com/samg/timetrap/issues#issue/13 for more details.

    $ # note durations are multiplications of start and end times, based on notes
    $ t d -ffactor
    Timesheet: SpecSheet
        Day                Start      End        Duration   Notes
        Fri Oct 03, 2008   16:00:00 - 18:00:00   4:00:00    entry f:2
                                                 4:00:00
        Sat Oct 04, 2008   16:00:00 - 18:00:00   1:00:00    entry f:0.5
                           19:00:00 -            1:00:00    entry
                                                 2:00:00
        ---------------------------------------------------------
        Total                                    6:00:00

### LaTeX Invoice
The *invoice* formatter generates LaTeX output that will create a nice looking
invoice.  In order to generate the resulting LaTeX output, you must have
[invoice.cls](https://github.com/treyhunner/invoices) installed.

You can generate the LaTeX file and produce a PDF with

    $ t d -f invoice > invoice.tex; latexmk -pdf invoice.tex

The following properties can be added to `~/.timetrap.yml`

    company => The company name to be printed at the top of the invoice
    address1 => Typically the street address
    address2 => Typically the city, state, and zipcode
    phone
    email
    rate => The hourly rate at which to bill

The produced output will have placeholders `INSERT CONTACT` and `INSERT
COMPANY` which will need to be replaced with the name and company being billed.

If the invoice is generated for multiple sheets, header and subtotal lines will
be added for each sheet.

## Contributing

To contribute a formatter:

1. Fork this repo and create your formatter.
2. Choose a short descriptive name for your formatter.
3. Update the README with some info about your formatter and some sample output.
4. If you'd like to TDD your formatter `spec/timetrap_formatter_spec.rb` is available.
   This helps ensure future changes to timetrap won't break your formatter.

Bugs and Feature Requests
--------
Submit to http://github.com/samg/timetrap/issues
