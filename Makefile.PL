use ExtUtils::MakeMaker;
WriteMakefile(
    LIBS => ["-lintl"],
    XSPROTOARG => '-noprototypes', 		# XXX remove later?
    VERSION_FROM => 'gettext.pm', 
);
