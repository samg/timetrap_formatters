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

A countdown of the remaining time in your working day can be displayed when an
optional parameter is set

    day_countdown => true to show the countdown


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

### Fraction

The *fraction* formatter is also like the default *text* formatter. In addition
to the information that is normally shown, it show the duration of the entry as
a fraction of an hour. This is useful for entry into some time accounting
systems.

    $ t d -ffraction
    Timesheet: mysheet
        Day                Start   End     Duration        Notes
        Wed Apr 23, 2014   10:12 - 10:15   0:02:23   0.04  entry
                           14:29 - 14:57   0:28:05   0.47
                           14:57 - 15:14   0:17:05   0.28  note
                           15:14 - 15:51   0:36:57   0.62
                           15:51 - 15:53   0:01:58   0.03
                                           1:26:28   1.44
        ---------------------------------------------------------
        Total                              5:12:47   5.21

Note that the fraction is computed independently for each item. In particular, the
fraction next to the total corresponds to the total. Due to rounding, that number
won't necessarily match the sum of the partial fractions. That is normally what you
want, but be aware of it if you include the partials in a report or invoice.

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

### by_day formatter

If you want to output your data grouped by date and not by sheet, you can use
this formatter.

    ## Fri Jul 19, 2013 ##

                   Sheet   Start      End        Duration   Notes
        housekeeping       08:43:00 - 12:30:00   3:47:00    cleaning everything
        comic time         14:01:27 - 15:38:41   1:37:14    saga, part II
        cooking            15:38:59 - 17:40:00   2:01:01    yummy lasagne
        ───────────────────────────────────────────────────────────────────────────────────────────────
        Total                                    7:25:15


### pay formatter

Will display per-session, per-day, per-sheet and global earnings. Put your
hourly pay rate in the config as `pay_rate`, and run `t d -f pay`.

Also supports prefixes and suffixes, so to have your pay printed in dollars, set
`pay_rate` to `$3.14`, or whatever your pay rate is. You could also add a prefix
which will be printed after each pay amount as such: `$3.14M` if you make, say,
3.14 million USD per hour.

### total formatter

This formatter simply displays the total amount of hours logged on this
timesheet as a decimal number.

```
$ t d -ftotal
4.709
```

### Harvest formatter

The Harvest formatter, developed separately as the [timetrap-harvest][timetrap-harvest] gem, will
submit your timetrap entries to timesheets on Harvest.

After adding Harvest credentials and project/task alias definitions to your
timetrap config file, you can tag entries for harvesting:

```bash
$ timetrap in working on timetrap-harvest @code
$ timetrap out
```

When you're ready to submit, you can use `timetrap` to limit the range of your
entries.

For example, you can submit your entries at the end of the day:

```bash
$ timetrap today --format harvest
```

Or for the past week:

```bash
$ timetrap display --start 'last monday' --end 'last friday' --format harvest
```

The output will list entries that `timetrap-harvest` successfully submitted as
well as entries that `timetrap-harvest` failed to submit.

```bash
Submitted: 1
Failed: 0

Submitted entries
--------------------------------------------------------------------------------
Submitted: working on timetrap-harvest @code
```

See timetrap-harvest's [README](timetrap-harvest) for more details.

### sum_notes

Sum the time depending on the notes:

```bash
t d -f sum_notes
```

```bash
Timesheet: RR
    Day                Start      End        Duration   Notes
    Tue Feb 27, 2024   10:00:00 - 14:00:00   4:00:00    Project 1
                                             4:00:00
    Wed Feb 28, 2024   09:30:00 - 10:00:00   0:30:00    Project 1
                       10:21:18 - 10:38:26   0:17:08    Project 3
                       11:17:15 - 11:48:33   0:31:18    Project 1
                       11:52:12 - 13:14:59   1:22:47    Project 3
                       14:02:20 - 14:47:53   0:45:33    Project 3
                                             3:26:46
    Fri Mar 01, 2024   11:49:16 - 11:58:08   0:08:52    Project 1
                       11:58:15 - 13:06:25   1:08:10    Project 3
                       14:00:37 - 15:32:37   1:32:00    Project 1
                                             2:49:02
    Sun Mar 03, 2024   18:58:42 - 19:58:30   0:59:48    Project 1
                                             0:59:48
    Mon Mar 04, 2024   11:04:36 - 11:57:42   0:53:06    Project 1
                                             0:53:06
    Tue Mar 05, 2024   12:06:44 - 12:41:25   0:34:41    Project 1
                                             0:34:41
    Thu Mar 07, 2024   11:20:20 - 11:31:11   0:10:51    Project 2
                                             0:10:51
    Mon Mar 11, 2024   07:33:29 - 08:56:53   1:23:24    Project 1
                       13:08:28 - 14:29:29   1:21:01    Project 1
                                             2:44:25
    Tue Mar 12, 2024   16:45:21 - 18:21:35   1:36:14    Project 1
                       19:01:32 - 20:27:11   1:25:39    Project 1
                                             3:01:53
    Wed Mar 13, 2024   10:08:41 - 11:15:59   1:07:18    Project 1
                       11:16:13 - 11:30:32   0:14:19    Project 1
                       12:02:46 - 12:20:40   0:17:54    Project 1
                       12:27:13 - 12:59:41   0:32:28    Project 1
                                             2:11:59
    ------------------------------------------------------------------------------------
    Total                                   21:07:20
```


```bash
Timesheet: RR
   Duration   Notes
   3:33:38    Project 3
   0:10:51    Project 2
  17:08:02    Project 1 
```

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

[timetrap-harvest]: https://github.com/dblandin/timetrap-harvest
