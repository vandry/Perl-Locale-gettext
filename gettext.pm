package gettext;

use Carp;

require Exporter;
require DynaLoader;
@ISA = qw(Exporter DynaLoader);

$VERSION = "1.00" ;

%EXPORT_TAGS = (

    locale_h =>	[qw(LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES LC_ALL)],

    libintl_h => [qw(gettext textdomain bindtextdomain dcgettext dgettext)],

);

Exporter::export_tags();

@EXPORT_OK = qw(
);

bootstrap gettext $VERSION;

sub AUTOLOAD {
    local $! = 0;
    my $constname = $AUTOLOAD;
    $constname =~ s/.*:://;
    my $val = constant($constname, $_[0]);
    if ($! == 0) {
	*$AUTOLOAD = sub { $val };
    }
    else {
	croak "Missing constant $constname";
    }
    goto &$AUTOLOAD;
}

1;
