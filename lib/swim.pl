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
use Swim::Log;

=head1   debug

	curl  'http://earlati.com/SwimmingPool/lib/swim.pl?prog=reqRemoteResetPwd&email=enzo.arlati@libero.it'
	curl 'http://earlati.com/SwimmingPool/lib/swim.pl?prog=execRemoteCmd&cmd=0000005600000021reqRemoteResetPwd'
	
	curl 'http://enzo6/SwimmingPool/lib/swim.pl?prog=execRemoteCmd&cmd=0000005600000021reqRemoteResetPwd'

=cut

eval {

	my ( $obj1,   $s1, $log,   $qstring, $logPath );
	my ( $params, $strpara, $hjson, $k, $v, $ll, $ll2, $now, $t1, $diff );
	my ($base) = basename $0;
	my ( $cmd ) = '';
	$now = localtime;
	$t1  = time;

	# env QUERY_STRING : prog=login&user=enzo
	$qstring = $ENV{QUERY_STRING};
	$qstring = ''  if ! defined $qstring;

	if( -d '../logs/' ) { $logPath = '../logs/' }
	elsif( -d '../../logs/' ) { $logPath = '../../logs/' }
	else { $logPath = '/tmp/' }

	$log = new Swim::Log(  "$logPath/SwimmingPool.log" );

    warn "LogPath $logPath " ;
	$log->Log( "=========================== " );
	$log->Log( "[$base] query => $qstring   " );
	$log->Log( "=========================== " );

	@$ll = split( '&', $qstring );
	foreach $s1 (@$ll)
	{
		@$ll2 = split( '=', $s1 );
		$k    = @$ll2[0];
		$v    = @$ll2[1] || "";
		$params->{$k} = "$v" if defined $k;
	}
	
	# ==============================================
	# ==============================================
	# $s1 = "";
	# foreach $k ( keys %ENV ) {	$log->Log( sprintf "ENV [%-20s] => [%s] ", $k, $ENV{$k} );	}

	# ==============================================
	# swim.pl?prog=reqRemoteResetPwd&email=enzo.arlati@libero.it'
	# $params->{prog}  = 'reqRemoteResetPwd';
    # $params->{email} = 'enzo.arlati@libero.it';
    
	# ==============================================
	# http://earlati.com/SwimmingPool/lib/swim.pl?prog=execRemoteCmd&cmd=0000005800000021reqRemoteResetPwd
	# $params->{prog}  = 'execRemoteCmd';
	# $params->{cmd}   = '0000005600000021reqRemoteResetPwd';
	# ==============================================
	$strpara = "";
	foreach $k ( keys %$params )
	{
		if ( "$k" eq "prog" ) { next; }
		$log->Log( "[$base] Param [$k] => [$params->{$k}]" );
		$strpara .= sprintf "%s=%s&", $k, $params->{$k};
	}

	$strpara =~ s/&$//;
	$cmd = "$params->{prog}" if defined $params->{prog};

	$log->Log( "[$base] cmd=[$cmd] param=>[$strpara]" );

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
	elsif ( $cmd eq 'reqRemoteResetPwd' )
	{
		my ( $obj1, $s1 );
		# CMD => [reqResetPwd] param=>[email=enzo.arlati@libero.it&prog=reqRemoteResetPwd]
		$obj1 = new Swim::Login( $cmd, $strpara );
		$s1 = $obj1->PerformRequestRemoteCmd();
		print "$s1 \n";
	}
	# ==============================================
	elsif ( $cmd eq 'reqRemoteEnableUser' )
	{
		my ( $obj1, $s1 );
		# CMD => [reqRemoteEnableUser] param=>[email=enzo.arlati@libero.it&prog=reqRemoteEnableUser]
		$obj1 = new Swim::Login( $cmd, $strpara );
		$s1 = $obj1->PerformRequestRemoteCmd();
		print "$s1 \n";
	}

	# ==============================================
	# curl 'http://enzo6/SwimmingPool/lib/swim.pl?prog=execRemoteCmd&cmd=0000005600000021reqRemoteResetPwd'
	# ==============================================
	elsif ( $cmd eq 'execRemoteCmd' )
	{
		my ( $obj1, $s1 );
		# CMD => [execRemoteCmd] param=>[cmd=0000005600000021reqRemoteResetPwd]
		$obj1 = new Swim::Login( $cmd, $strpara );
		$s1 = $obj1->PerformExecRemoteCmd();  
		$log->Log( "CMD: [$cmd] => res: $s1 " );
		print "$s1 \n";
	}
	
	# ==============================================
	elsif ( $cmd eq 'formEnableUser' )
	{
		my ( $obj1, $s1 );
		$obj1 = new Swim::Login( $cmd, $strpara );
		$obj1->BuildHtmlEnableUser();
		$obj1->EndHtml();
		$s1 = $obj1->GetHtml();
		print "$s1 \n";
	}
	# ==============================================
	elsif ( $cmd eq 'reqRemoteEnableUser' )
	{
		my ( $obj1, $s1 );
		# CMD => [reqRemoteEnableUser] param=>[email=enzo.arlati@libero.it&prog=reqRemoteEnableUser]
		$obj1 = new Swim::Login( $cmd, $strpara );
		$s1 = $obj1->PerformRequestRemoteCmd();
		print "$s1 \n";
	}
	
	
	
	# ============================================== 
	else
	{
		my ( $s1 ) = "";
		$cmd = "*****" if ! defined $cmd;
		warn "CMD : $cmd **** sconosciuto **** \n";
		$s1 = sprintf "Content-type: text/plain\n\n";
		$s1 .= sprintf "ERRORE : Query string : $qstring : CMD = [$cmd] sconosciuto \n";
		$diff = time - $t1;
		$s1 .= sprintf "Date $now  : call lasted $diff seconds \n";
		$log->Log( "CMD: [$cmd] => res: $s1 " );
		print "$s1";
	}
	
	$diff = time - $t1;
	$log->Log( " last $diff seconds " ); 
};

if ($@)
{
	print "Content-type: text/plain\n\n";

	print " ERRORE : \n";
	print " $@ \n";
	print "INC:  @INC  \n";
}

