#!/usr/bin/perl

use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;
use DBI;
use POSIX 'WNOHANG';

eval { PrintUserList(); };

if ($@)
{
	print "Content-type: text/plain\n\n";

	print " Error: \n";
	print " $@ \n";
	print "INC:  @INC  \n";

    warn sprintf  "[%s] Error : %s ", $0, $@;
	##foreach my $k ( keys %ENV ) { print "ENV[$k] => $ENV{$k} \n"; }

}

# ===================================
sub PrintUserList
{
	my ( $dbh, $sqlcmd, $sth, $numRows, $s1 );
	my ($local) = 0;
	print "Content-type: text/plain\n\n";

	printf "Test1 [$0] start test db [%s]\n", localtime();

	# foreach my $k ( keys %ENV ) { print "<p>ENV[$k] => $ENV{$k} \n"; }
	if ( defined $ENV{SERVER_ADDR} && ( $ENV{SERVER_ADDR} eq "127.0.0.1" || $ENV{SERVER_ADDR} eq "::1" ) )
	{
		$local = 1;
	}
	if ( defined $ENV{SHELL} ) { $local = 1; }
	$dbh = OpenDB($local);
	print "opened db \n";

	# $sqlcmd = "select * from users";
	$sqlcmd = "show full processlist";
	# $sqlcmd = "show variables";

	$sth    = $dbh->prepare("$sqlcmd");
	$sth->execute;
	$numRows = $sth->rows;

	print "founded $numRows rows. \n";


	# dt_mod => [2011-03-30 22:07:35] enabled => [1 ] id => [1  ] pwd => [ ] user => [enzo ]
	while ( my $ref = $sth->fetchrow_hashref() )
	{
		foreach my $k ( sort keys %$ref )
		{
			$s1 = $ref->{$k} || 'NULL';
			printf "$k => [%-12s] ", $s1;
			warn "$k => [%-12s] ", $s1;
		}
		print "\n";
	}
	$sth->finish();

	CloseDB($dbh);
	print "closed db \n";

}    ## __________ sub Test1

# ===================================================
# $dsn   = "DBI:mysql:database=enzarl_db1;host=mysql2.freehostia.com";
#    username: enzarl_db1
#    password: 22006829
#    database name: enzarl_db1
#    database host: mysql2.freehostia.com
# ===================================================
#    username: enzarl7_swim
#    password: davidone
#    database name: enzarl7_swim
#    database host: mysql2.freehostia.com
# ===================================================
sub OpenDB
{
	my ($local) = @_;
	my ( $dbh, $nretry, $maxretry, $serr );

	# my ($dsn) = "DBI:mysql:database=enzarl_db1;host=mysql2.freehostia.com";
	my ($user) = "enzarl7_swim";
	my ($pwd)  = "davidone";
	my ($dsn)  = "DBI:mysql:database=enzarl7_swim;host=mysql2.freehostia.com";

	if ( defined $local && $local == 1 )
	{
		$dsn  = "DBI:mysql:database=enzarl_db1;host=localhost";
		$user = "enzarl_db1";
		$pwd  = "22006829";
	}

	$nretry   = 0;
	$maxretry = 10;

	while ( $nretry < $maxretry )
	{
		$nretry++;
		eval {
			$dbh = DBI->connect( $dsn, "$user", "$pwd", { 'RaiseError' => 1 } );

		};

		if ($@)
		{
			$serr = $@;
			chomp $serr;
			mylog("[STEP=$nretry] ERRORE $serr .... RETRY CONNECTION ($dsn)");
			mylog("********************************************** ");
			sleep 3;
			if ( ( $nretry + 1 ) == $maxretry )
			{
				die("OpenDB ERROR $serr ");
			}
		}
		else
		{
			last;
		}
	}

	# mylog( "[OPEN_CONNECTION]  " );

	return $dbh;
}

# ===================================================
# ===================================================
sub CloseDB
{
	my ($dbh) = @_;

	$dbh->disconnect();

	# mylog( "[CLOSE_CONNECTION]  " );

}

# ===================================================
sub mylog
{
	my ($msg) = @_;

}
