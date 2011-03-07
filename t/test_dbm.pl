#!perl
# ----------------------------------------------------------
# FILE : test_dbm.pl
# ----------------------------------------------------------
# perltidy -l=120 -gnu -b program.pl
# ----------------------------------------------------------
#  { }  []  `` ~
# ----------------------------------------------------------

=head1 

  [enzo@enzo7 SwimmingPool]$ perl t/test_dbm.pl  testuser data/testdbm.dbm  enzo
  
  
  [enzo@enzo7 SwimmingPool]$ perl t/test_dbm.pl  showdb  data/testdbm.dbm 
  Command : showdb 
  [ShowDB] file=[data/testdbm.dbm] => $VAR1 = bless( {
                 'enzo' => bless( {
                                    'ROW' => bless( {
                                                      '168' => 'ID[1168] 7',
                                                      '363' => 'ID[1363] 8',
                                                      '381' => 'ID[1381] 8',
                                                      ...........
                                                      '575' => 'ID[1575] 8'
                                                    }, 'DBM::Deep::Hash' ),
                                    'lastUpdate' => 'Mon Mar  7 22:32:10 2011',
                                    'maxrow' => '1999'
                                  }, 'DBM::Deep::Hash' ),
                 'maxrow' => '2000'
               }, 'DBM::Deep::Hash' );
  
=cut

use strict;
use warnings;
use feature qw( say );

use DBM::Deep;
use Data::Dumper;

Main( \@ARGV );

# ======================================
# ======================================
sub Main {
	my ($argv) = shift;
	my ( $cmd, $s1 );

	$cmd = $argv->[0];

	say "Command : $cmd ";
	if    ( "$cmd" eq "builddb" )  { BuildDB( $argv->[1] ); }
	elsif ( "$cmd" eq "showdb" )   { ShowDB( $argv->[1] ); }
	elsif ( "$cmd" eq "testuser" ) { TestUser( $argv->[1], $argv->[2]  ); }
	else {
		say "Unknown command [$cmd]  Valid values are: [builddb] [showdb]";
	}

}

# ======================================
sub BuildDB {
	my ($dbname) = shift;
	my ($hashdb);
	$hashdb = OpenDB($dbname);
	FillData($hashdb);
}

# ======================================
sub ShowDB {
	my ($dbname) = shift;
	my ($s1);
	my ($hashdb);

	$hashdb = OpenDB($dbname);
	$s1     = Dumper($hashdb);
	say "[ShowDB] file=[$dbname] => $s1 ";
}

# ======================================
sub TestUser {
	my ( $dbname, $user ) = @_;
	my ( $s1, $idx, $hashdb );

	$hashdb = OpenDB($dbname);
	$hashdb->{maxrow} = 1 if ! defined $hashdb->{maxrow};

	for ( $idx = 0 ; $idx < 1000 ; ${idx}++ ) 
	{
		$hashdb->{$user}->{lastUpdate} = localtime;

		if ( !defined $hashdb->{$user}->{maxrow} ) {
			$hashdb->{$user}->{maxrow} = 1;
		}
		else { $hashdb->{$user}->{maxrow} += 1; }

		$hashdb->{$user}->{maxrow} = $hashdb->{maxrow};
		$hashdb->{maxrow} += 1;
		$hashdb->{$user}->{ROW}->{$idx} = sprintf "ID[%d] %s", $hashdb->{$user}->{maxrow}, localtime;
	}

}

# ======================================
sub OpenDB {
	my ($dbname) = shift;
	my ($hashdb);
	$hashdb = DBM::Deep->new( file => "$dbname", locking => 1, autoflush => 1 );
	return $hashdb;
}

# ======================================
sub FillData {
	my ($hash) = shift;

	my (%monthday) = (
		january  => 31,
		february => 28,
		december => 31
	);
	my (%users) = (
		enzo    => { id => 1, user => 'enzo',    password => 'pino' },
		lilia   => { id => 2, user => 'lilia',   password => 'pino' },
		davide  => { id => 3, user => 'davide',  password => 'pino' },
		claudia => { id => 4, user => 'claudia', password => 'pino' }
	);

	foreach my $k ( keys %users ) {
		$users{$k}->{cryptpassword} =
		  crypt( $users{$k}->{user}, $users{$k}->{password} );
	}
	$hash->{test1}    = "test1";
	$hash->{bgcolor1} = '#AAAAAA';
	$hash->{monthday} = \%monthday;

	$hash->{users} = \%users;

	$hash->{lastupdate} = localtime;

	if   ( defined $hash->{maxrow} ) { $hash->{maxrow} = $hash->{maxrow} + 1; }
	else                             { $hash->{maxrow} = 1; }

	return $hash;

}    # ___________  sub FillData
