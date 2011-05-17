#!/bin/perl
# ----------------------------------------------------------
# FILE : DBUser.pm
# ----------------------------------------------------------
# perltidy -l=120 -gnu -b program.pl
# ----------------------------------------------------------
#  { }  []  `` ~
# ----------------------------------------------------------

=head1 DBUser module

=cut

package Swim::DBUser;

use 5.006;
use strict;
use warnings;
use Data::Dumper;
use DBI;
use POSIX 'WNOHANG';

use base qw( Swim::DBCommon );

RunTest() unless caller;

# =====================================

=head sub RunTest

	TestSaveUser();
	TestCheckLogin();
	TestIdSession();

=cut

# =====================================
sub RunTest
{
	my ( $obj1, $sres, $param );

	# $obj1 = new Swim::DBUser();
	# $sres = $obj1->GetUser( "test1c" );
	# mylog ( "Dump result: " . Dumper($sres) );

	TestCheckLogin();

}

# =====================================
sub mylog
{
	my ($msg) = @_;
	my ( $s1, $ll );
	my @call = caller(1);
	if ( "$call[3]" eq "(eval)" )
	{
		@call = caller(2);
	}

	# print "Dumer call: " . Dumper( \@call ) . "\n";
	$s1 = sprintf "[%s] %s", $call[3], $msg;
	warn sprintf "$s1 \n";

}

# =====================================
sub TestSaveUser
{
	my ( $obj1, $sres, $param );

	$obj1 = new Swim::DBUser();

	$param->{user}    = 'user2';
	$param->{pwd}     = 'password1';
	$param->{checked} = 'true';
	$param->{email}   = 'user1@swimming.it';
	$sres             = $obj1->SaveUser($param);
	mylog "Dump res: " . Dumper($sres) . " \n";

	$sres = $obj1->GetDumpUsers();
	mylog "$sres \n";

}    # ______ sub TestSaveUser

# =====================================
sub TestCheckLogin
{
	my ( $obj1, $sres, $param );

	$obj1 = new Swim::DBUser();

	$param->{user}      = 'pippo';
	$param->{pwd}       = 'pluto';
	$param->{idSession} = '';

	$param->{idSession} = '37 pippo piIzbflOaDn1Q';
	$param->{user}      = '';
	$param->{pwd}       = '';

	mylog "Dump input: " . Dumper($param);
	$sres = $obj1->CheckLogin($param);
	mylog "Dump result: " . Dumper($sres);

	# $sres = $obj1->GetDumpUsers();
	# mylog " DumpUser: $sres \n";

}    # ______ sub TestCheckLogin

# ===================================================
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

=head2 sub GetUser

    Table users
	===========
	id               int(11) PK
	user             varchar(20)
	pwd              varchar(30)
	enabled          tinyint(1)
	dt_mod           timestamp
	email            varchar(90)
	

 Sample result : found user
 
  RSLT : $VAR1 = {
          'email' => 'test.tost@libero.it',
          'pwd' => 'telZwaovBltHM',
          'dt_mod' => '2011-05-03 23:28:04',
          'numrows' => '1',
          'user' => 'test1',
          'error' => 0,
          'errordata' => '',
          'id' => '38',
          'enabled' => '1'
        };

 
 Sample result : user not found
  
  RSLT : $VAR1 = {
          'numrows' => '0',
          'error' => 0,
          'errordata' => ''
        };
        
 Sample result : report error

   RSLT : $VAR1 = {
          'numrows' => undef,
          'error' => 1,
          'errordata' => 'DBD::mysql::st execute failed: Table \'enzarl_db1.userss\' doesn\'t exist at /home/enzo/ENZO/MYWEB/SwimmingPool/lib/Swim/DBCommon.pm line 276.
 '
        };

=cut

# ===================================================
sub GetUser
{
	my ( $self, $username ) = @_;
	my ( $sqlcmd, $params, $rsltTmp, $htmp );
	my ($rslt) = ();

	eval {

		$sqlcmd  = "select * from users where user = ? ";
		@$params = ("$username");
		$rsltTmp = $self->ExecuteSelectCommand( $sqlcmd, $params );

		$rslt->{numrows}   = $rsltTmp->{numrows};
		$rslt->{errordata} = $rsltTmp->{errordata};
		$rslt->{error}     = $rsltTmp->{error};
		if ( $rsltTmp->{numrows} == 1 )
		{
			$htmp = $rsltTmp->{rows}->{1};
			foreach my $k ( keys %$htmp )
			{
				$rslt->{$k} = $htmp->{$k};
			}

		}
	};
	if ($@)
	{
		warn "[GetUser] error $@ ";
		$rslt->{errordata} = "$@";
		$rslt->{error}     = 1;
	}

	return $rslt;

}    ## _________  sub GetUser

# ===================================================
sub GetUserById
{
	my ( $self, $iduser ) = @_;
	my ( $sqlcmd, $params, $rsltTmp, $htmp );
	my ($rslt) = ();

	eval {

		$sqlcmd  = "select * from users where id = ? ";
		@$params = ("$iduser");
		$rsltTmp = $self->ExecuteSelectCommand( $sqlcmd, $params );

		$rslt->{numrows}   = $rsltTmp->{numrows};
		$rslt->{errordata} = $rsltTmp->{errordata};
		$rslt->{error}     = $rsltTmp->{error};
		if ( $rsltTmp->{numrows} == 1 )
		{
			$htmp = $rsltTmp->{rows}->{1};
			foreach my $k ( keys %$htmp )
			{
				$rslt->{$k} = $htmp->{$k};
			}

		}
	};
	if ($@)
	{
		warn "[GetUser] error $@ ";
		$rslt->{errordata} = "$@";
		$rslt->{error}     = 1;
	}

	return $rslt;

}    ## _________  sub GetUserById

# ===================================================

=head2 sub SaveUser 

	$obj1 = new Swim::StorageDB();

	$param->{user}    = 'user2';
	$param->{pwd}     = 'password1';
	$param->{checked} = 'true';
	$param->{email}   = 'user1@swimming.it';
	$sres             = $obj1->SaveUser($param);
	print "Dump res: " . Dumper($sres) . " \n";
	
	
=head3 dump of input data
	
  Dump input $VAR1 = {
          'email' => 'user1@swimming.it',
          'pwd' => 'password1',
          'user' => 'user2',
          'checked' => 'true'
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
sub SaveUser
{
	my ( $self, $param ) = @_;
	my ( $sqlcmd, $sth, $numRows, $ref, $crypwd );
	my ($rslt) = ();

	eval {

		$ref = $self->GetUser("$param->{user}");
		if ( $ref->{numrows} == 0 )
		{
			if   ( $param->{checked} eq "true" ) { $param->{enabled} = 1; }
			else                                 { $param->{enabled} = 0; }

			warn sprintf "[SaveUser] user=%s enabled=[%s] checked=[%s]",
			  $param->{user}, $param->{enabled}, $param->{checked};
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
			$rslt->{info}  = "L' utente $param->{user} esiste gia' ";
		}

	};

	if ($@)
	{
		warn "[SaveUser] error $@ ";
		$rslt->{errordata} = "$@";
		$rslt->{error}     = 1;
	}

	return $rslt;

}    ## _________  sub SaveUser

# ===================================================

=head sub CheckLogin

   [Swim::DBUser::TestCheckLogin] Dump input: $VAR1 = {
          'pwd' => 'pluto',
          'idSession' => '',
          'user' => 'pippo'
        };     
        
   Dump user: $VAR1 = {
          'email' => 'user1@swimming.it',
          'pwd' => 'usjRS48E8ZADM',
          'dt_mod' => '2011-05-03 21:58:55',
          'numrows' => 1,
          'user' => 'user2',
          'id' => '36',
          'enabled' => '0'
        };
 

 
   Dump result: $VAR1 = {
          'info' => 'L\' utente user20 non esiste  ',
          'error' => 3
        };
   Dump result: $VAR1 = {
          'info' => 'L\' utente user2 non e\' abilitato  ',
          'error' => 4
        };        
        
        
   [Swim::DBUser::CheckLogin] Dump rslt $VAR1 = {
          'info' => 'Utente pippo connesso ',
          'error' => 0,
          'data' => {
                      'pwd' => 'pilstH2iw/zY.',
                      'idSession' => '37 pippo piIzbflOaDn1Q',
                      'user' => 'pippo',
                      'id' => '37'
                    }
        };
         


=cut

# ===================================================
sub CheckLogin
{
	my ( $self, $params ) = @_;
	my ( $sqlcmd, $sth, $numRows, $refUser, $crypwd, $rsltSess, $paramTmp, $rsltTmp );
	my ($rslt) = ();

	eval {

		$rslt->{data}->{user}      = "";
		$rslt->{data}->{id}        = "0";
		$rslt->{data}->{idSession} = "0";

		if ( defined $params->{idSession} )
		{
			$rsltTmp = $self->GetIdSession($params);
			if ( defined $rsltTmp->{id_user} )
			{
				$params->{id_user} = $rsltTmp->{id_user};
				$refUser = $self->GetUserById("$params->{id_user}");
				$crypwd = "$refUser->{pwd}" if defined "$refUser->{pwd}";
			}
		}
		else
		{
			$crypwd = crypt( "$params->{pwd}", "$params->{user}" );
			$refUser = $self->GetUser("$params->{user}");
		}
		if ( $refUser->{numrows} == 0 )
		{
			$rslt->{error} = 3;
			$rslt->{info}  = "L' utente $params->{user} non esiste  ";
		}
		elsif ( $refUser->{enabled} ne "1" )
		{
			$rslt->{error} = 4;
			$rslt->{info}  = "L' utente $params->{user} non e' abilitato  ";
		}
		elsif ( "$refUser->{pwd}" ne "$crypwd" && "$refUser->{pwd}" ne "" )
		{
			$rslt->{error} = 5;
			$rslt->{info}  = "Utente $params->{user} : password non valida  ";
		}
		else
		{
			$rslt->{data}->{user} = "$refUser->{user}";
			$rslt->{data}->{id}   = "$refUser->{id}";
			$rslt->{data}->{pwd}  = "$refUser->{pwd}";

			$rslt->{error} = 0;
			$rslt->{info}  = "Utente $params->{user} connesso ";

			# crea un id di sessione
			# idsession = crypt( iduser, "user + localtime")
			my ( $paramSession, $rsltSession );
			$paramSession->{idUser}   = "$rslt->{data}->{id}";
			$paramSession->{userName} = "$rslt->{data}->{user}";
			$paramSession->{pwd}      = "$rslt->{data}->{pwd}";

			$rsltSess = $self->BuildIdSession($paramSession);

			$rslt->{data}->{idSession} = $rsltSess->{idSession};
			$rslt->{info} = sprintf "Connesso utente %s Id=%s ", "$rslt->{data}->{user}", "$rslt->{data}->{id}";

			$paramSession->{idSession} = $rslt->{data}->{idSession};
			$rsltTmp = $self->SaveSessionConnection($paramSession);
		}

	};

	if ($@)
	{
		warn "[CheckLogin] error $@ ";
		$rslt->{info}  = "$@";
		$rslt->{error} = 1;
	}

	# mylog "Dump rslt " . Dumper($rslt);
	return $rslt;

}    ## _________  sub CheckLogin

# ===================================================

=head2 sub BuildIdSession

  build an IdConnection string based on idUser, userName and password
  get a crypt on ( id , "userName + password ")
  add togheter dUser + userName + password + crypt
  
  [Swim::DBUser::BuildIdSession] DUMP INP :$VAR1 = {
          'pwd' => 'pilstH2iw/zY.',
          'idUser' => '37',
          'userName' => 'pippo'
        };
        
        
   [Swim::DBUser::BuildIdSession] DUMP RSLT :$VAR1 = {
          'pwd' => 'pilstH2iw/zY.',
          'idSession' => '37 pippo piIzbflOaDn1Q',
          'idUser' => '37',
          'userName' => 'pippo'
        };     

=cut

# ===================================================
sub BuildIdSession
{
	my ( $self, $params ) = @_;
	my ( $rslt, $crypt, $k );

	eval {

		# mylog  "DUMP INP :" . Dumper( $params );
		%$rslt = ();
		foreach $k ( keys %$params ) { $rslt->{$k} = "$params->{$k}"; }
		$crypt = crypt( "$params->{idUser}", "$params->{userName}" . "$params->{pwd}" );
		$rslt->{idSession} = sprintf "%s %s %s", "$params->{idUser}", "$params->{userName}", "$crypt";
	};

	if ($@)
	{
		warn "[BuildIdConnection] error $@ ";
		$rslt->{errordata} = "$@";
		$rslt->{error}     = 1;
	}

	# mylog  "DUMP RSLT :" . Dumper( $rslt );

	return $rslt;

}    # ________  sub BuildIdSession

# ===================================================

=head2 sub SaveSessionConnection

	Table session_connect
	=====================
	id, date, id_user, hash_code, dt_mod
	---------------------
	id               int(11) PK
	date             datetime
	id_user          int(11)
	hash_code        varchar(45)
	dt_mod           timestamp

    ALTER TABLE session_connect CHANGE COLUMN `id` `id` INT(11) NOT NULL AUTO_INCREMENT  ;
    ALTER TABLE session_connect ADD UNIQUE INDEX `hash_code_UNIQUE` (`hash_code` ASC) ;
    
	$paramSession->{idUser}   = "$rslt->{data}->{id}";
	$paramSession->{idSession} = $rslt->{data}->{idSession}; 
	$rsltTmp = $self->SaveSessionConnection( $paramSession );

=cut

# ===================================================
sub SaveSessionConnection
{
	my ( $self, $params ) = @_;
	my ( $sqlcmd, $sth, $numRows, $paramTmp );
	my ($rslt) = ();

	eval {
		$rslt = $self->GetIdSession($params);
		if ( $rslt->{numrows} == 0 )
		{
			$sqlcmd = " insert into session_connect ( date, id_user, hash_code  ) ";
			$sqlcmd .= " values ( current_timestamp, ?, ? ) ";
			$sth = $self->{dbh}->prepare("$sqlcmd");
			$sth->execute( "$params->{idUser}", "$params->{idSession}" );
			$sth->finish;
		}
	};

	if ($@)
	{
		warn "[SaveSessionConnection] error $@ ";
		$rslt->{errordata} = "$@";
		$rslt->{error}     = 1;
	}

	return $rslt;

}    ## _________  sub SaveSessionConnection

# ===================================================

=head2 sub GetIdSession

  Sample input param
  
  [Swim::DBUser::GetIdSession] Dump ParamInp : $VAR1 = {
          'pwd' => 'pilstH2iw/zY.',
          'idSession' => '37 pippo piIzbflOaDn1Q',
          'idUser' => '37',
          'userName' => 'pippo'
        };


   Sample result for existent user

   [Swim::DBUser::GetIdSession] Dump RSLT : $VAR1 = {
          'id_user' => '37',
          'hash_code' => '37 pippo piIzbflOaDn1Q',
          'dt_mod' => '2011-05-12 22:55:07',
          'numrows' => '1',
          'date' => '2011-05-12 22:55:07',
          'error' => 0,
          'errordata' => '',
          'id' => '2'
        };
   
   Sample result for invalid idSession/hash_code
        
   [Swim::DBUser::GetIdSession] Dump RSLT : $VAR1 = {
          'numrows' => '0',
          'error' => 0,
          'errordata' => ''
        };        
        
=cut

# ===================================================
sub GetIdSession
{
	my ( $self, $params ) = @_;
	my ( $sqlcmd, $sth, $numRows, $paramTmp, $rsltTmp, $htmp );
	my ($rslt) = ();

	eval {
		$sqlcmd    = "select * from session_connect where hash_code like ? ";
		@$paramTmp = ("$params->{idSession}");
		$rsltTmp   = $self->ExecuteSelectCommand( $sqlcmd, $paramTmp );

		$rslt->{numrows}   = $rsltTmp->{numrows};
		$rslt->{errordata} = $rsltTmp->{errordata};
		$rslt->{error}     = $rsltTmp->{error};
		if ( $rsltTmp->{numrows} == 1 )
		{
			$htmp = $rsltTmp->{rows}->{1};
			foreach my $k ( keys %$htmp )
			{
				$rslt->{$k} = $htmp->{$k};
			}
		}
	};

	if ($@)
	{
		warn "[NewSessionConnection] error $@ ";
		$rslt->{errordata} = "$@";
		$rslt->{error}     = 1;
	}

	#mylog( "Dump RSLT : " . Dumper($rslt) );
	return $rslt;

}    ## _________  sub GetIdSession

# ===================================================
sub Template
{
	my ( $self, $param ) = @_;
	my ( $sqlcmd, $sth, $numRows, $refUser, $crypwd );
	my ($rslt) = ();

	eval {

	};

	if ($@)
	{
		warn "[Template] error $@ ";
		$rslt->{errordata} = "$@";
		$rslt->{error}     = 1;
	}

	return $rslt;

}    ## _________  sub Template

1;
