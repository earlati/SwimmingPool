#!/usr/bin/perl

use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

use lib '.';
use lib './lib';
use Swim::DBCommon;

eval {
	my ( $obj1, $s1 );
	$obj1 = new Swim::StorageDB();
	$s1   = $obj1->GetJsonTables();
	print "$s1 \n";
};

if ($@) {
	print "Content-type: text/plain\n\n";

	print " Error: \n";
	print " $@ \n";
	print "INC:  @INC  \n";
}




