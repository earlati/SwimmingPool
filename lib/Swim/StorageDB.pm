#!/bin/perl
# ----------------------------------------------------------
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
	my ( $obj1, $sres, $param );

	$obj1 = new Swim::StorageDB();

	$param->{user}    = 'user2';
	$param->{pwd}     = 'password1';
	$param->{enabled} = '1';
	$param->{email}   = 'user1@swimming.it';
	$sres             = $obj1->StoreUser($param);
	print "Dump res: " . Dumper($sres) . " \n";

	$sres = $obj1->GetDumpUsers();
	print "$sres \n";

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
		lastUpdate  => '28.04.2011'
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
		foreach my $k ( keys %$ref )
		{
			printf " $k => [%-10s] ", $ref->{$k} if defined $k and defined $ref->{$k};
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

# ===================================================
#Table users
#===========
#id, user, pwd, enabled, dt_mod, email
#-----------
#id               int(11) PK
#user             varchar(20)
#pwd              varchar(30)
#enabled          tinyint(1)
#dt_mod           timestamp
#email            varchar(90)
#
# ===================================================
sub GetUser
{
	my ( $self, $username ) = @_;
	my ( $sqlcmd, $sth, $numRows, $ref );
	my ($rslt) = ();

	eval {

		$sqlcmd = "select * from users where user = ? ";
		$sth    = $self->{dbh}->prepare("$sqlcmd");
		$sth->execute("$username");
		$numRows         = $sth->rows;
		$rslt->{numrows} = $numRows;
		$ref             = $sth->fetchrow_hashref();

		foreach my $k ( keys %$ref )
		{
			$rslt->{$k} = $ref->{$k};
		}

		$sth->finish;
	};
	if ($@)
	{
		warn "[StoreUser] error $@ ";
		$rslt->{errordata} = "$@";
		$rslt->{error}     = 1;
	}

	return $rslt;

}    ## _________  sub GetUser

# ===================================================
=head2 sub StoreUser 

	$obj1 = new Swim::StorageDB();

	$param->{user}    = 'user2';
	$param->{pwd}     = 'password1';
	$param->{enabled} = '1';
	$param->{email}   = 'user1@swimming.it';
	$sres             = $obj1->StoreUser($param);
	print "Dump res: " . Dumper($sres) . " \n";
	
	
=head3 dump of input data
	
  Dump input $VAR1 = {
          'email' => 'user1@swimming.it',
          'pwd' => 'password1',
          'user' => 'user2',
          'enabled' => '1'
        };	
        
=head3 Dump of result returned after the creation of a new user

  Dump res: $VAR1 = {
          'info' => 'Creato nuovo utente user2 id=14 ',
          'error' => 0,
          'data' => {
                      'email' => 'user1@swimming.it',
                      'pwd' => 'usjRS48E8ZADM',
                      'numrows' => '1',
                      'dt_mod' => '2011-04-28 20:27:12',
                      'user' => 'user2',
                      'id' => '14',
                      'enabled' => '1'
                    }
        };

=head3 Dump of result returned when the user already exists

  Dump res: $VAR1 = {
          'info' => 'L\' utente user2 esiste gia\' ',
          'error' => 2
        };

=cut
# ===================================================
sub StoreUser
{
	my ( $self, $param ) = @_;
	my ( $sqlcmd, $sth, $numRows, $ref, $crypwd );
	my ($rslt) = ();

	eval {

		$ref = $self->GetUser("$param->{user}");
		if ( $ref->{numrows} == 0 )
		{
			$crypwd = crypt( "$param->{pwd}", "$param->{user}" );
			$sqlcmd = "insert into users ( user, pwd, enabled, email ) values (?,?,?,?)";
			$sth    = $self->{dbh}->prepare("$sqlcmd");
			$sth->execute( "$param->{user}", "$crypwd", "$param->{enabled}", "$param->{email}" );
			$sth->finish;
			$ref = $self->GetUser("$param->{user}");
			foreach my $k ( keys %$ref )
			{
				$rslt->{data}->{$k} = $ref->{$k};
			}
			$rslt->{error} = 0;
			$rslt->{info}  = "Creato nuovo utente $rslt->{data}->{user} id=$rslt->{data}->{id} ";
		}
		else
		{
			$rslt->{error} = 2;
			$rslt->{info} = "L' utente $param->{user} esiste gia' ";
		}

	};

	if ($@)
	{
		warn "[StoreUser] error $@ ";
		$rslt->{errordata} = "$@";
		$rslt->{error}     = 1;
	}

	return $rslt;

}    ## _________  sub StoreUser

1;

