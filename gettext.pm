package Locale::gettext;

use Carp;

require Exporter;
require DynaLoader;
@ISA = qw(Exporter DynaLoader);

$VERSION = "1.01" ;

%EXPORT_TAGS = (

    locale_h =>	[qw(LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES LC_ALL)],

    libintl_h => [qw(gettext textdomain bindtextdomain dcgettext dgettext)],

);

Exporter::export_tags();

@EXPORT_OK = qw(
);

bootstrap Locale::gettext $VERSION;

sub AUTOLOAD {
    local $! = 0;
    my $constname = $AUTOLOAD;
    $constname =~ s/.*:://;
    my $val = constant($constname, (@_ ? $_[0] : 0));
    if ($! == 0) {
	*$AUTOLOAD = sub { $val };
    }
    else {
	croak "Missing constant $constname";
    }
    goto &$AUTOLOAD;
}

1;

__END__

=head1 NAME

gettext - message handling functions

=head1 SYNOPSIS

    use Locale::gettext;
    use POSIX;     # Needed for setlocale()

    setlocale(LC_MESSAGES, "");
    textdomain("my_program");

    print gettext("Welcome to my program"), "\n";
            # (printed in the local language)

=head1 DESCRIPTION

The gettext module permits access from perl to the gettext() family of
functions for retrieving message strings from databases constructed
to internationalize software.

gettext(), dgettext(), and dcgettext() attempt to retrieve a string
matching their C<msgid> parameter within the context of the current
locale. dcgettext() takes the message's category and the text domain
as parameters while dcgettext() defaults to the LC_MESSAGES category
and gettext() defaults to LC_MESSAGES and uses the current text domain.
If the string is not found in the database, then C<msgid> is returned.

textdomain() sets the current text domain and returns the previously
active domain.

I<bindtextdomain(domain, dirname)> instructs the retrieval functions to look
for the databases belonging to domain C<domain> in the directory
C<dirname>

=head1 VERSION

1.01.

1.00 was not under the Locale/ directory.

=head1 SEE ALSO

gettext(3i), gettext(1), msgfmt(1)

=head1 AUTHOR

Kim Vandry <vandry@Mlink.NET>
