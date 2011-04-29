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
# =====================================
sub RunTest
{
	my ( $obj1, $sres, $param );

	$obj1 = new Swim::DBUser();

	$param->{user}    = 'user2';
	$param->{pwd}     = 'password1';
	$param->{enabled} = '1';
	$param->{email}   = 'user1@swimming.it';
	$sres             = $obj1->StoreUser($param);
	print "Dump res: " . Dumper($sres) . " \n";

	$sres = $obj1->GetDumpUsers();
	print "$sres \n";


}    # ______ sub RunTest


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