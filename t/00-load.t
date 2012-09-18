#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'SwimmingPool' ) || print "Bail out!
";
}

diag( "Testing SwimmingPool $SwimmingPool::VERSION, Perl $], $^X" );
