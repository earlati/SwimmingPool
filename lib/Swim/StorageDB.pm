# FILE : StorageDB.pm
# ----------------------------------------------------------
# perltidy -l=120 -gnu -b program.pl
# ----------------------------------------------------------
#  { }  []  `` ~
# ----------------------------------------------------------

=head1 StorageDB module

=cut

package Swim::StorageDB;

use 5.006;
use strict;
use warnings;
use Data::Dumper;
use DBI;
use POSIX 'WNOHANG';

use lib '.';
use lib './lib';

# use Swim::Log;
# use base qw( Swim::CommonParent );

our $VERSION = '0.01';

RunTest() unless caller;

# =====================================
# =====================================
sub RunTest
{
	my ( $obj1, $s1 );

	$obj1 = new Swim::StorageDB();
	$s1   = $obj1->GetDumpUsers();
	print "$s1 \n";

}    # ______ sub RunTest

# =====================================
# =====================================
sub new
{
	my ($class) = shift;
	my ($self)  = {
		dsn         => 'DBI:mysql:database=enzarl_db1;host=mysql2.freehostia.com',
		servername  => 'mysql2.freehostia.com',
		database    => "enzarl_db1",
		user        => "enzarl_db1",
		pwd         => "22006829",
		logObj      => undef,
		localserver => "0",
		lastUpdate  => '03.04.2011'
	};

	bless $self, $class;

	$self->CheckLocalServer();
	if ( $self->{localserver} eq "1" ) { $self->{servername} = 'localhost'; }
	$self->{dsn} = sprintf "DBI:mysql:database=%s;host=%s", $self->{database}, $self->{servername};
	$self->OpenDB();

	return $self;
}

# ===================================================
sub DESTROY
{
	my ($self) = @_;
	$self->CloseDB();
}

# ===================================
sub Log
{
	my ( $self, $msg ) = @_;

	warn "$msg \n" if defined $msg;

	if ( defined $self->{logObj} )
	{
		$self->{logObj}->Log($msg) if defined $msg;
	}
	else
	{
		warn "$msg \n" if defined $msg;
	}

}    ## __________ sub Log

# ===================================================
sub CheckLocalServer
{
	my ($self)  = @_;
	my ($local) = 0;
	if ( defined $ENV{SERVER_ADDR}
		&& ( $ENV{SERVER_ADDR} eq "127.0.0.1" || $ENV{SERVER_ADDR} eq "::1" ) )
	{
		$local = 1;
	}
	if ( defined $ENV{SHELL} ) { $local = 1; }

	$self->{localserver} = $local;

}    ## ______ sub CheckLocalServer

# ===================================================
# $dsn   = "DBI:mysql:database=enzarl_db1;host=mysql2.freehostia.com";
#    username: enzarl_db1
#    password: 22006829
#    database name: enzarl_db1
#    database host: mysql2.freehostia.com
# ===================================================
sub OpenDB
{
	my ($self) = @_;
	my ( $nretry, $maxretry, $serr );

	$nretry   = 0;
	$maxretry = 10;

	while ( $nretry < $maxretry )
	{
		$nretry++;
		eval { $self->{dbh} = DBI->connect( $self->{dsn}, $self->{user}, $self->{pwd}, { 'RaiseError' => 1 } ); };

		if ($@)
		{
			$serr = $@;
			chomp $serr;
			$self->Log("[STEP=$nretry] ERRORE $serr .... RETRY CONNECTION ($self->{dsn})");
			$self->Log("********************************************** ");
			sleep 3;
		}
		else
		{
			last;
		}
	}

	# mylog( "[OPEN_CONNECTION]  " );

	return $self->{dbh};
}

# ===================================================
# ===================================================
sub CloseDB
{
	my ($self) = @_;
	$self->{dbh}->disconnect();

}

# ===================================================
sub GetDumpUsers
{
	my ($self) = @_;
	my ( $sqlcmd, $sth, $numRows );
	my ($local) = 0;
	print "Content-type: text/html\n\n";

	printf "<p> GetDumpUsers [$0] start test db [%s]\n", localtime();

	$sqlcmd = "select * from users";
	$sth    = $self->{dbh}->prepare("$sqlcmd");
	$sth->execute;
	$numRows = $sth->rows;

	print "<p> Founded $numRows rows. <p>\n";

	# dt_mod => [2011-03-30 22:07:35] enabled => [1 ] id => [1  ] pwd => [ ] user => [enzo ]
	while ( my $ref = $sth->fetchrow_hashref() )
	{
		foreach my $k ( sort keys %$ref )
		{
			printf " $k => [%-12s] ", $ref->{$k};
		}
		print "<p>\n";
	}
	$sth->finish();

}    ## __________  sub GetDumpUsers

# ===================================================
#Content-type: application/json
#
# { "type" : "tables" ,"num_rows" : "6" ,"time" : "54" ,
# 	"rows" : [  {  "Tables_in_enzarl_db1" : "groups"  },
# 	            {  "Tables_in_enzarl_db1" : "location"  },
#                .........
# 	            {  "Tables_in_enzarl_db1" : "users"  } ]  }
#
# ===================================================
sub GetJsonTables
{
	my ($self) = @_;
	my ( $sqlcmd, $sth, $numRows, $json, $ctxType, $row, $rows );
	my ($local) = 0;

	$sqlcmd = "show tables";
	$sth    = $self->{dbh}->prepare("$sqlcmd");
	$sth->execute;
	$numRows = $sth->rows;

	$ctxType = "Content-type: application/json\n\n";
	$json = sprintf "\"%s\" : \"%s\" ,", "type", "tables";
	$json .= sprintf "\"%s\" : \"%d\" ,", "num_rows", $numRows;
	$json .= sprintf "\"%s\" : \"%d\" ,", "time",     localtime();

	$rows = "";
	while ( my $ref = $sth->fetchrow_hashref() )
	{
		$row = "";
		foreach my $k ( sort keys %$ref )
		{
			$row .= sprintf " \"%s\" : \"%s\" ,", $k, $ref->{$k};
		}
		$row =~ s/\,$//;
		$row = sprintf "{ %s },", $row;
		$rows .= " $row ";
	}
	$sth->finish();
	$rows =~ s/\, *$//;
	$rows = sprintf " \"rows\" : [ %s ] ", $rows;
	$json .= $rows;
	$json = sprintf "%s { %s }", $ctxType, $json;

	return $json;

}    ## __________  sub GetJsonTables

1;

