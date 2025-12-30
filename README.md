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

```sh
git clone git://github.com/samg/timetrap_formatters ~/.timetrap
```

You can also:

```sh
git clone git://github.com/samg/timetrap_formatters /some/path
mkdir -p ~/.timetrap/
ln -s /some/path ~/.timetrap/formatters
```

See https://github.com/samg/timetrap/blob/master/README.md for more details.

## Formatters:

### Day Progress Formatter

The *day* formatter sums up the time you've logged today and
tells you how near your working day to completion is.

```sh
$ t d -f day

[################################### ] 70%
1:03:04
```

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

```sh
$ t d -f datesheet
2011-12-01 17:28:25 - 17:34:37 0:06:12 [Sheet] Entry description
```

Some nice aliases for the datesheet formatter:

```sh
alias tmf="clear && t d all -s 'today' -f datesheet"
alias tmg="clear && t d all -s 'today' -f datesheet | sort -n -k 2.1 -k 2.2"
```

### Factor

The *factor* formatter is like the default *text* formatter, except it reads special
notes in your entry descriptions, and multiplies the entry's duration by them.
A note like *f:2* will multiply the entry's duration by two in the output.
See https://github.com/samg/timetrap/issues#issue/13 for more details.

```sh
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
```

### Fraction

The *fraction* formatter is also like the default *text* formatter. In addition
to the information that is normally shown, it show the duration of the entry as
a fraction of an hour. This is useful for entry into some time accounting
systems.

```sh
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
```

Note that the fraction is computed independently for each item. In particular, the
fraction next to the total corresponds to the total. Due to rounding, that number
won't necessarily match the sum of the partial fractions. That is normally what you
want, but be aware of it if you include the partials in a report or invoice.

### LaTeX Invoice
The *invoice* formatter generates LaTeX output that will create a nice looking
invoice.  In order to generate the resulting LaTeX output, you must have
[invoice.cls](https://github.com/treyhunner/invoices) installed.

You can generate the LaTeX file and produce a PDF with

```sh
$ t d -f invoice > invoice.tex; latexmk -pdf invoice.tex
```

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

```sh
## Fri Jul 19, 2013 ##

            Sheet   Start      End        Duration   Notes
    housekeeping       08:43:00 - 12:30:00   3:47:00    cleaning everything
    comic time         14:01:27 - 15:38:41   1:37:14    saga, part II
    cooking            15:38:59 - 17:40:00   2:01:01    yummy lasagne
    ───────────────────────────────────────────────────────────────────────────────────────────────
    Total                                    7:25:15
```

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

```sh
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

### sum_notes formatter

Text formatter for sum of spent time grouped by note. 

```sh 
t d other -f sum_notes
# Timesheet: other
#   Duration   Notes
#   0:46:03    bank
#   0:27:37    blogs
#   0:52:36    coffee
#   0:48:24    lunch
#   0:18:02    tea
```


### sum_weeks formatter

Text formatter for sum of spent time grouped by week with progress bar.
Can adapt with progess bar, change the formatter fields as you which.
The progress bar can go above 100% you see the delimitation with the characters difference : ████▉▉▉▉

```sh
t d other -f sum_weeks
# Week       Hours     %        Progress
# 2024-53     62.01     215%   █████████████████████████▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉▉
# 2025-01      5.65      20%   ████---------------------
# 2025-02     35.57     124%   █████████████████████████▉▉▉▉▉▉
# 2025-03     34.83     121%   █████████████████████████▉▉▉▉▉
# 2025-04     22.83      79%   ███████████████████------
# 2025-05     21.62      75%   ██████████████████-------
```

### sum_years formatter

Text formatter for sum of days per year with specific tag (@tag)
Days for tags are counted using starttime and endtime. This is not counting the number of lines !!!
For this example I have 2 tags @event and @ka

```sh
t d -f sum_years
# Explanation:
#   - Days for @event and @ka are counted using starttime and endtime.
#   Year      Hours   %H     Progress Hours                       DaysEv   %D    Progress Days                   DaysKA   %K     Progress KA
#    2024      62.01    4%    4% ---------------                  0    0%    0% ---------------                  0    0%    0% ---------------
#    2025    1647.82  110%  110% ███████████████▉▉               64  116%  116% ███████████████▉▉               39  156%  156% ███████████████▉▉▉▉▉▉▉▉
```


### oneline formatter


# Similar to "t d" but print all in 1 line to allow grep
# Dorian Gravier
# https://dgrv.github.io/dorian-gravier/

```sh
$ t d | grep @event
Sat Jul 05, 2025   06:30:00 - 19:00:00  12:30:00    Example1 @event @ka
Sun Jul 06, 2025   06:30:00 - 21:00:00  14:30:00    Example1 @event @ka
                                                    @event @ka
                                                    @event @ka
                                                    @event @ka
Sat Aug 09, 2025   10:00:00 - 21:00:00  11:00:00    Example2 @event
                    07:12:44 - 21:00:00  13:47:16    Example2 @event

to

$ t d -f oneline| grep @event
508      2025-07-04 20:08:28 - 2025-07-04 23:08:28      3:00:00    Example1 @event @ka
729      2025-07-05 06:30:00 - 2025-07-05 19:00:00     12:30:00    Example1 @event @ka
730      2025-07-06 06:30:00 - 2025-07-06 21:00:00     14:30:00    Example1 @event @ka
555      2025-08-01 18:00:00 - 2025-08-01 23:00:00      5:00:00    Example3 @event @ka
556      2025-08-02 06:00:00 - 2025-08-02 18:30:00     12:30:00    Example3 @event @ka
557      2025-08-03 06:00:00 - 2025-08-03 21:30:00     15:30:00    Example3 @event @ka
574      2025-08-09 10:00:00 - 2025-08-09 21:00:00     11:00:00    Example2 @event
576      2025-08-10 07:12:44 - 2025-08-10 21:00:00     13:47:16    Example2 @event
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
