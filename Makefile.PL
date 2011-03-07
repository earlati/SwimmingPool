use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'SwimmingPool',
    AUTHOR              => q{E. Arlati <enzo.arlati@libero.it>},
    VERSION_FROM        => 'lib/SwimmingPool.pm',
    ABSTRACT_FROM       => 'lib/SwimmingPool.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'SwimmingPool-*' },
);
