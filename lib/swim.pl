#!/usr/bin/perl
# ----------------------------------------------------------
# FILE : swim.pl
# ----------------------------------------------------------
# perltidy -l=120 -gnu -b program.pl
# ----------------------------------------------------------
#  { }  []  `` ~
# ----------------------------------------------------------


use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;

use lib '.';
use lib './lib';
use Swim::StorageDB;
use Swim::Login;

eval {
	my ( $obj1, $s1, $qstring, $cmd );
    my ( $params, $strpara, $k, $v, $ll, $ll2 );

	# env QUERY_STRING : prog=login&user=enzo
	$qstring = $ENV{QUERY_STRING};
    @$ll = split( '&', $qstring );
    foreach $s1 ( @$ll )
    {
    	@$ll2 = split( '=', $s1 );
    	$k = @$ll2[0];
    	$v = @$ll2[1];
    	$params->{$k} = "$v";
    }

	# print "Content-type: text/plain\n\n";
    
    $strpara = "";
    foreach $k ( keys %$params )
    {
    	if( "$k" eq "prog ") { next; };
    	$strpara .= sprintf "%s=%s&", $k, $params->{$k},
    }
    $strpara =~ s/&$//;
    $cmd = "$params->{prog}";

    warn "CMD => [$cmd] param=>[$strpara]\n";
    
	if ( $cmd eq 'login' ) {
		my ( $obj1, $s1 );
    	
    	warn "CMD : login \n";
		$obj1 = new Swim::Login( $cmd, $strpara );
		$obj1->EndHtml();
		$s1 = $obj1->GetHtml();
		print "$s1 \n";

	}
	elsif ( $cmd eq 'register' )
	{
    	warn "CMD : register \n";

	}
	else {
		print "Content-type: text/plain\n\n";
		print "ERRORE : Query string : $qstring : CMD = [$cmd] sconosciuto \n";

	}

};

if ($@) {
	print "Content-type: text/plain\n\n";

	print " Error: \n";
	print " $@ \n";
	print "INC:  @INC  \n";
}

