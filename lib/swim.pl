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
use File::Basename;

use lib '.';
use lib './lib';
use Swim::DBCommon;
use Swim::Login;

=head1   debug


=cut

eval {

	my ( $obj1,   $s1,      $qstring );
	my ( $params, $strpara, $hjson,   $k, $v, $ll, $ll2 );
	my ($base) = basename $0;
	my ( $cmd ) = '';

	# env QUERY_STRING : prog=login&user=enzo
	$qstring = $ENV{QUERY_STRING};
	$qstring = ''  if ! defined $qstring;
	warn("$base : query => $qstring ");

	@$ll = split( '&', $qstring );
	foreach $s1 (@$ll)
	{
		@$ll2 = split( '=', $s1 );
		$k    = @$ll2[0];
		$v    = @$ll2[1];
		$params->{$k} = "$v" if defined $k;
	}

	# print "Content-type: text/plain\n\n";

	$strpara = "";
	foreach $k ( keys %$params )
	{
		if ( "$k" eq "prog " ) { next; }
		warn "[$base] Param [$k] => [$params->{$k}]";
		$strpara .= sprintf "%s=%s&", $k, $params->{$k};
	}
	$strpara =~ s/&$//;
	$cmd = "$params->{prog}" if defined $params->{prog};

	warn "CMD => [$cmd] param=>[$strpara]\n";

	# ==============================================
	if ( $cmd eq 'formLogin' )
	{
		my ( $obj1, $s1 );
		$obj1 = new Swim::Login( $cmd, $strpara );
		$obj1->BuildHtmlLogin();
		$obj1->EndHtml();
		$s1 = $obj1->GetHtml();
		print "$s1 \n";

	}

	# ==============================================
	elsif ( $cmd eq 'checkLogin' )
	{
		my ( $obj1, $s1 );
		$obj1 = new Swim::Login( $cmd, $strpara );
		$s1 = $obj1->BuildAnswerCheckLogin();
		print "$s1 \n";

	}

	# ==============================================
	elsif ( $cmd eq 'formRegister' )
	{
		my ( $obj1, $s1 );
		$obj1 = new Swim::Login( $cmd, $strpara );
		$obj1->BuildHtmlRegister();
		$obj1->EndHtml();
		$s1 = $obj1->GetHtml();
		print "$s1 \n";

	}

	# ==============================================
	elsif ( $cmd eq 'storeRegister' )
	{
		my ( $obj1, $s1 );
		$obj1 = new Swim::Login( $cmd, $strpara );
		$s1 = $obj1->BuildAnswerStoreRegister();
		print "$s1 \n";

	}

	# ==============================================
	elsif ( $cmd eq 'formResetPwd' )
	{
		my ( $obj1, $s1 );
		$obj1 = new Swim::Login( $cmd, $strpara );
		$obj1->BuildHtmlResetPwd();
		$obj1->EndHtml();
		$s1 = $obj1->GetHtml();
		print "$s1 \n";
	}
	# ==============================================
	elsif ( $cmd eq 'reqResetPwd' )
	{
		my ( $obj1, $s1 );
		# CMD => [reqResetPwd] param=>[email=enzo.arlati@libero.it&prog=reqResetPwd]
		$obj1 = new Swim::Login( $cmd, $strpara );
		$s1 = $obj1->PerformRequestResetPassword();
		print "$s1 \n";
	}

	# ==============================================
	else
	{
		$cmd = "*****" if ! defined $cmd;
		warn "CMD : $cmd **** sconosciuto **** \n";
		print "Content-type: text/plain\n\n";
		print "ERRORE : Query string : $qstring : CMD = [$cmd] sconosciuto \n";
	}
};

if ($@)
{
	print "Content-type: text/plain\n\n";

	print " ERRORE : \n";
	print " $@ \n";
	print "INC:  @INC  \n";
}

