use ExtUtils::MakeMaker;
WriteMakefile(
    NAME => "Locale::gettext",
    LIBS => ["-lintl"],
    VERSION_FROM => 'gettext.pm', 
);
