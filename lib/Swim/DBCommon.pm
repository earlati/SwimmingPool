#!/bin/perl
# ----------------------------------------------------------
# FILE : DBCommon.pm
# ----------------------------------------------------------
# perltidy -l=120 -gnu -b program.pl
# ----------------------------------------------------------
#  { }  []  `` ~
# ----------------------------------------------------------

=head1 DBCommon module

=cut

package Swim::DBCommon;

use 5.006;
use strict;
use warnings;
use Data::Dumper;
use DBI;
use POSIX 'WNOHANG';

use lib '../';
use Swim::Log;

our $VERSION = '0.01';
require Exporter;
our @ISA = qw( Exporter );

# our %EXPORT_TAGS = ( 'all' => [qw( )] );
# our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
# our @EXPORT = qw(  );

RunTest() unless caller;

# =====================================
# =====================================
sub RunTest
{
	my ( $obj1, $sres, $params, $rslt, $sqlcmd );

	$obj1 = new Swim::DBCommon();
	$sres = $obj1->GetJsonTables();
	print "jsonTables: $sres \n";

	$sqlcmd  = "select * from users where user like ? and enabled like ? ";
	@$params = ( "test%", "1" );
	$rslt    = $obj1->ExecuteSelectCommand( $sqlcmd, $params );
	print "RSLT: " . Dumper($rslt);

	$rslt    = $obj1->GetLastInsertId( );
	print "LastInsertId: $rslt \n";

}    # ______ sub RunTest

# =====================================
#		dsn         => 'DBI:mysql:database=enzarl_db1;host=mysql2.freehostia.com',
# =====================================
#		servername  => 'mysql2.freehostia.com',
#		database    => "enzarl_db1",
#		user        => "enzarl_db1",
#		pwd         => "22006829",
# =====================================
#		servername  => 'mysql18.freehostia.com',
#		database    => "enzarl7_swim",
#		user        => "enzarl7_swim",
#		pwd         => "davidone",
# =====================================
sub new
{
	my ($class) = shift;
	my ($logPath);
	my ($self)  = {
		dsn         => '',
		servername  => 'mysql18.freehostia.com',
		database    => "enzarl7_swim",
		user        => "enzarl7_swim",
		pwd         => "davidone",
		logObj      => undef,
		localserver => "0",
		lastUpdate  => '18.07.2011'
	};

	bless $self, $class;

	if( -d '../logs/' ) { $logPath = '../logs/' }
	elsif( -d '../../logs/' ) { $logPath = '../../logs/' }
	else { $logPath = '/tmp/' }

	$self->{logObj} = new Swim::Log(  "$logPath/SwimmingPool.log" );

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

    if( ! defined $msg ) { return; }
    
	if ( defined $self->{logObj} )
	{
		$self->{logObj}->Log($msg);
	}
	else
	{
		warn "$msg \n";
	}

}    ## __________ sub Log

# ===================================================
sub CheckLocalServer
{
	my ($self)  = @_;
	my ($local) = 0;
	my ( $s1 ) = "";
	
	$s1 = $ENV{SERVER_NAME} if defined $ENV{SERVER_NAME};
	$self->Log( sprintf "serverName: [%s]", $s1 );
	
	if ( defined $ENV{SERVER_NAME} &&  $ENV{SERVER_NAME} eq "earlati.com"  )
	{
		$local = 0;
	}
	else
	{
		$local = 1;
	}
	
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
	# $self->Log( "open DB " );

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

	return $self->{dbh};
	
}   ## ___________ sub OpenDB

# ===================================================
# ===================================================
sub CloseDB
{
	my ($self) = @_;
	$self->{dbh}->disconnect();

}   ## _______ sub CloseDB

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

=head2 sub ExecuteSelectCommand

   		$sqlcmd = "select * from users where user like ? and enabled like ? ";
   		@$params = ( "test%", "1" );
   		$rslt = $self->ExecSelectCommand( $sqlCmd, $params );
   		
=head3   Result sample : founded 2 records
		
   RSLT: $VAR1 = {
          'numrows' => '2',
          'error' => 0,
          'errordata' => '',
          'rows' => {
                      '1' => {
                               'email' => 'test.tost@libero.it',
                               'pwd' => 'telZwaovBltHM',
                               'dt_mod' => '2011-05-03 23:28:04',
                               'user' => 'test1',
                               'id' => '38',
                               'enabled' => '1'
                             },
                      '2' => {
                               'email' => 'test.tost@libero.it',
                               'pwd' => 'teH0wLIpW0gyQ',
                               'dt_mod' => '2011-05-11 21:48:00',
                               'user' => 'test2',
                               'id' => '39',
                               'enabled' => '1'
                             }
                    }
        };   

=head3  Simulated error using a wrong table name

   RSLT: $VAR1 = {
          'error' => 1,
          'errordata' => 'DBD::mysql::st execute failed: Table \'enzarl_db1.userss\' doesn\'t exist at /home/enzo/ENZO/MYWEB/SwimmingPool/lib/Swim/DBCommon.pm line 267.
 '
        };

=cut

# ===================================================
sub ExecuteSelectCommand
{
	my ( $self, $sqlCmd, $params, $nofetchrow ) = @_;
	my ( $sqlcmd, $sth, $numRows, $ref, $idrow, $sts, $serr );
	my ( $rslt ) = ();
	my ( $s1 )   = "";

	eval {

		$rslt->{errordata} = "";
		$rslt->{error}     = 0;

        $s1 = join "=", @$params if defined $params;
        $self->Log( "Sqlcmd: $sqlCmd  params => $s1" ); 
        
		$sth = $self->{dbh}->prepare("$sqlCmd");
		$sts     = $sth->execute(@$params);
	    $numRows = $sth->rows;
				
		if( $numRows > 0 && ! defined $nofetchrow )
		{
		    $rslt->{numrows} = $numRows;
		    $idrow           = 1;
		    while ( my $ref = $sth->fetchrow_hashref() )
	    	{
			    foreach my $k ( keys %$ref )
			    {
		      		$rslt->{rows}->{$idrow}->{$k} = $ref->{$k};
			    }
			    $idrow += 1;
		    }
	    }
		$sth->finish;
	};
	if ($@)
	{
		warn " [ExecuteSelectCommand] error $@ sqlcmd = ${sqlCmd} ";
		$rslt->{errordata} = "$@ ";
		$rslt->{error}     = 1;
	}

	return $rslt;

}    ## _________  sub ExecuteSelectCommand



# ===================================================
sub GetLastInsertId
{
	my ( $self ) = @_;
	my ( $rslt, $lastid, $connid );
	my ( $sqlCmd ) = 'select last_insert_id() lastid';
	
    $rslt = $self->ExecuteSelectCommand( $sqlCmd, undef );
    $lastid = $rslt->{rows}->{1}->{lastid};
    $lastid = 0 if ! defined $lastid;
    $self->Log( "ERROR : lastid : $lastid " ) if $lastid < 1;; 
    
	return $lastid;

}    ## _________  sub GetLastInsertId

# ===================================================
sub GetConnectionId
{
	my ( $self ) = @_;
	my ( $rslt, $connid );
	my ( $sqlCmd ) = 'select connection_id() connid ';
	
    $rslt = $self->ExecuteSelectCommand( $sqlCmd, undef );
    $connid = $rslt->{rows}->{1}->{connid};
        
	return $connid;

}    ## _________  sub GetConnectionId


1;

