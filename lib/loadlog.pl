#!/usr/bin/perl
# ----------------------------------------------------------
# FILE : loadlog.pl
# ----------------------------------------------------------
# perltidy -l=120 -gnu -b loadlog.pl
# ----------------------------------------------------------
#  { }  []  `` ~
# ----------------------------------------------------------

use strict;
use warnings;

my ($fname) = '../logs/SwimmingPool.log';
my ($s1, $s2);
my ($nrow)   = 1;
my ($maxrow) = 400;
my (@ll)     = ();

eval {
    open F, "$fname" or die "Cannot open file $fname ( $! ) \n";
    while ($nrow < $maxrow)
    {
        $s1 = <F>;
        if (defined $s1)
        {
            chomp $s1;
            $s2 = sprintf "[%03d] %s ", $nrow, $s1;
            push @ll, $s2;
        }
        $nrow++;
    }
    close F;

    print "Content-type: text/plain\n\n";

    foreach my $r (reverse @ll)
    {
        print "$r\n";
    }

};

if ($@)
{
    print "Content-type: text/plain\n\n";

    print " ERRORE : \n";
    print " $@ \n";
    print "INC:  @INC  \n";
}

