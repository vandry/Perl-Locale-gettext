# `Locale::gettext`
## version 1.07

This is a Perl5 module quickly written to gain access to the C library
functions for internatialization. They work just like the C versions of
the "GNU gettext utilities."

As of version 1.04, an object-oriented interface more suitable to native Perl
programs is available.

`Locale::gettext` is Copyright 1996–2005 by Kim Vandry
<vandry@TZoNE.ORG>. All rights reserved.

This library is free software; you may distribute under the terms of either the
GNU General Public License or the Artistic License, as specified in the Perl
README file.

# Changes

<dl>
<dt>1.07</dt>
<dd>Fix test failures caused by <code>$LANGUAGE</code> being set</dd>

<dt>1.06</dt>
<dd>Bugfix: #104667 <code>Makefile.PL</code> libaries need to be listed after
<code>.o</code> files

Bugfix: #104668	ensure availability of locale API, correct typo in documentation

Add <code>META.yml</code> (Fixes #91921)</dd>

<dt>1.05</dt>
<dd>Bugfix: [cpan #13042] useless <code>#ifdef</code> should be
<code>#if</code>

Bugfix: [cpan #13044] make test fails when using POSIX locale</dd>

<dt>1.04</dt>
<dd>Add several functions provided by the GNU gettext library<br/>

Create object oriented interface</dd>

<dt>1.03</dt>
<dd>Fix error in README file</dd>

<dt>1.02</dt>
<dd>Include a License</dd>

<dt>1.01</dt>
<dd>Changed from <code>gettext</code> to <code>Locale::gettext</code> (i.e.
moved under <code>Locale::</code>) on the advice of several people<br/>

Small "lint" fix from <schwern@starmedia.net></dd>

<dt>1.00</dt>
<dd>Initial version</dd>
</dl>

# TODO

A TIEHASH interface

# Here's a quick tutorial.

Note that your vendor's implementation of these functions may be a bit
different, but I think that in general these are quite standard POSIX
functions.

Kim Vandry <vandry@TZoNE.ORG>,
Mlink Internet <http://www.Mlink.NET>,
July 1996

INTERNATIONALIZING YOUR PROGRAM

## Step 1

If you've already written your code, you need to wrap the `gettext()` function
around all of the text strings. Needless to say, this is much easier if you do
it while you write.

```
# create object for oo interface
my $d = Locale::gettext->domain("my_program");

print "Welcome to my program\n";

# oo
print $d->get("Welcome to my program"), "\n";

# traditional
print gettext("Welcome to my program"), "\n";
```

Note that you probably don't want to include that newline in the `gettext()`
call, nor any formatting codes such as HTML tags. The argument to `gettext()`
is the text string in the default language or locale. This is known as the C
locale and should probably be usually English.

## Step 2

Do the apropriate initializations at the beginning of your program:

```
use POSIX;     # for setlocale()
use Locale::gettext;
```
The following statement initializes the locale handling code in the C library.
Normally, it causes it to read in the environment variables that determine the
current locale.

The first parameter is the category you would like to initialize locale
information for. You can use `LC_ALL` for this, which will set locale
information for all categories, including `LC_CTYPE`, `LC_TIME`, `LC_NUMERIC`,
etc.

I recommend that you set only `LC_MESSAGES` (text strings) or `LC_CTYPE`
(character sets) and `LC_TIME` (time conventions) too at most. You may find
that if you set `LC_NUMERIC` or some other categories, you will start
outputting decimal numbers with strange thousand separators and decimal points
and they will be unparseable in other countries.

The second parameter is the locale name. If it is an empty string, then this
information will be fetched from environment variables.

Note that `setlocale()` will cause every part of your program to start
operating in the new, non-default (C) locale, including C library functions. So
don't be surprised if `POSIX::ctime` returns `"Montag, 22. Juli 1996, 12:08:25
Uhr EDT"` instead of `"Mon Jul 22 12:08:25 EDT 1996"`, if you set `LC_TIME` or
`LC_ALL` using `setlocale()`.

```
setlocale(LC_MESSAGES, "");
```

Decide on a unique identifier that will distinguish your program's text strings
in the `LC_MESSAGES` database. This would usually be the name of your program.

By default, locale information is found in OS dependant system directories such
as `/usr/share/locale`, or any directory found in the `$PATH`-like environment
variable `$NLSPATH`.  I recommend that you do _not_ install files in `/usr`. If
your program is installed in a directory tree such as
`/opt/my_package_name/{bin,man,lib,etc}`, then you could use
`/opt/my_package_name/locale` to store locale information specific to your
program, or you could put in somewhere in `/usr/local/share/locale`.

Wherever you put it, if it is not one of the default directories, you will need
to call `bindtextdomain()` to tell the library where to find your files. The
first parameter is your database's identifier that you chose above.

```
# oo interface:
my $d = Locale::gettext->domain("my_domain");
$d->dir("/opt/my_package_name/locale");

# traditional interface:
bindtextdomain("my_domain", "/opt/my_package_name/locale");
textdomain("my_domain");
```

That's it for the initializations.

## Step 3

Test to see if your program still works after all these mods `:-)`

## Step 4

TRANSLATE!

Read
[`msgfmt(1)`](https://www.gnu.org/software/gettext/manual/html_node/msgfmt-Invocation.html)
for details on this. Basically, for each locale other than the default, you
need to create a file like this: Call this file with the `.po` extension.

```
domain "my_domain"

msgid  "Welcome to my program"
msgstr "Willkommen in meinem Programm"

msgid  "Help"
msgstr "Hilfe"
```

The `msgid` parameter must match exactly the argument to the `gettext()`
function, and `msgstr` is the corresponding translation.

You can use the
[xgettext(1)](https://www.gnu.org/software/gettext/manual/html_node/xgettext-Invocation.html)
utility to initially construct this file from all of the `gettext()` calls in
your source code. It was designed for C but it works OK with perl.

## Step 5

Compile the .po file

```
$ msgfmt my_file.po
```

This will create a file called `my_domain.mo` (default `messages.mo`) which you
should place in the `<locale>/LC_MESSAGES/my_domain.mo` subdirectory of either
a system default directory, a directory in `$NLSPATH`, or the directory
argument to `bindtextdomain()`.  Replace `<locale>` with the name of the locale
for which this file is created.

For example:

```
$ mkdir -p /opt/my_package/locale/de/LC_MESSAGES
$ mkdir -p /opt/my_package/locale/fr/LC_MESSAGES
$ cd /path/to/my/source/code
$ cd de
$ msgfmt my_domain.po
$ mv my_domain.mo /opt/my_package/locale/de/LC_MESSAGES
$ cd ../fr
$ msgfmt my_domain.po
$ mv my_domain.mo /opt/my_package/locale/fr/LC_MESSAGES
```

## Step 6

Test it out

```
$ my_program
Welcome to my program
$ LANG=fr my_program
Bienvenue à mon programme
$ LANG=de my_program
Willkommen in meinem Programm
```

(Or, set only the messages category instead of the whole locale)

```
$ LC_MESSAGES=fr
$ export LC_MESSAGES
$ my_program
Bienvenue à mon programme
```

