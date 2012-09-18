#!/usr/bin/perl

use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

use lib '.';
use lib './lib';
use lib '../lib';

eval {
	my ( $obj1, $a, $s1 );
	print "Content-type: text/plain\n\n";
        open ( F, "df | " );
        @$a = <F>;
        close F; 
        chomp @$a;

        foreach $s1 ( @$a ) {
	print "$s1 \n";
        }
};

if ($@) {
	print "Content-type: text/plain\n\n";

	print " Error: \n";
	print " $@ \n";
	print "INC:  @INC  \n";
}





