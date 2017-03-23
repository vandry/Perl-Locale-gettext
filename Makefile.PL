use ExtUtils::MakeMaker;
use Config;

use strict;
use warnings;
use Config::AutoConf;
use Data::Dumper ();

my %args;
for (@ARGV) {
    $args{$1} = $2 if /(\w+)=(.*)/;
}

my @libs;

my $ac = Config::AutoConf->new;

if (defined(my $ccflags = $args{CCFLAGS})) {
    $ac->check_compiler_flags($ccflags);
}
if (defined(my $inc = $args{INC})) {
    $ac->push_preprocess_flags($inc)
}
if (defined(my $lddlflags = $args{LDDLFLAGS})) {
    $ac->push_link_flags($lddlflags);
}
if (defined(my $libs = $args{LIBS})) {
    push @libs, $libs;
    $ac->push_link_flags($libs);
}

$ac->check_valid_compiler() or die;
$ac->check_header('libintl.h') or die;

my $lib = $ac->search_libs('gettext', ['intl']);
if ($lib eq '0') {
    die;
}
elsif ($lib ne 'none required') {
    push @libs, "-l$lib";
}

for my $fn (qw(gettext dgettext dcgettext ngettext bind_textdomain_codeset chirpy_canary)) {
    if ($ac->check_decl($fn, {prologue => "#include <libintl.h>\n"})) {
        $ac->define_var("HAVE_".uc($fn), 1);
    }
}

$ac->write_config_h;

my %config;
if (defined(my $dlpath = $args{DLPATH})) {
    $^O eq 'MSWin32' or die "DLPATH is only supported on MS Windows operating systems";
    $config{DLPATH} = $dlpath;
}

open my $fh, '>', "Config.pm" or die "Unable to create file 'Config.pm': $!";
print {$fh} "package Locale::gettext;\n";
print {$fh} Data::Dumper->Dump([\%config], [qw(*config)]);
print {$fh} "1;\n";
close $fh;

WriteMakefile(
    NAME => "Locale::gettext",
    VERSION_FROM => 'gettext.pm',
    LICENSE => 'perl_5',
    LIBS => join(" ", @libs),
    PM => {
        'gettext.pm' => '$(INST_LIB)/Locale/gettext.pm',
        'Config.pm' => '$(INST_LIB)/Locale/gettext/Config.pm',
    },
    CONFIGURE_REQUIRES => {
        "ExtUtils::MakeMaker" => "6.52",
        "Config::AutoConf" => "0.313",
    },
    META_MERGE => {
        resources => {
            repository => 'https://github.com/vandry/Perl-Locale-gettext',
            license => 'http://dev.perl.org/licenses/',
        },
    },
    ABSTRACT => "Perl bindings for POSIX i18n gettext functions",
    AUTHOR => 'Kim Vandry <vandry@TZoNE.ORG>',
    LICENSE => 'perl',
);
