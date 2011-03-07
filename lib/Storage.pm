#!/usr/bin/perl
# ----------------------------------------------------------
# FILE : Storage.pm
# ----------------------------------------------------------
# perltidy -l=120 -gnu -b program.pl
# ----------------------------------------------------------
#  { }  []  `` ~
# ----------------------------------------------------------

=head1 Storage module

=cut

package Storage;

use 5.006;
use strict;
use warnings;
use feature qw( say );
use Data::Dumper;
use DBM::Deep;
use File::Basename;

use lib './';
use lib './lib/';

# use CommonParent;
use base qw( CommonParent );

our $VERSION = '0.01';

RunTest() unless caller;

# =====================================
# =====================================
sub RunTest {
	my ( $obj1, $s1 );

	$obj1 = new Storage('testStorage.dbm');

	$obj1->FillTestData();
	$s1 = $obj1->ToString();
	say("Dump obj1.data : $s1 ");

}    # ______ sub RunTest

# =====================================
# =====================================
sub new {
	my ($class) = shift;
	my ($fname) = shift;
	my ( $s1 );
	my ($self)  = {
		dbFilename     => 'default.dbm',
		dbFullFilename => undef,
		data           => undef,
		users          => undef,
		lastUpdate     => '06.03.2011'
	};

	bless $self, $class;

	$self->{rootPath} = $self->GetRootPath();
	if ( defined $fname ) { $self->{dbFilename} = "$fname"; }
	$self->{dbFullFilename} = sprintf "%s/data/%s", $self->{rootPath},
	  $self->{dbFilename};

    $self->{dbFullFilename} = $self->GetUntaint( $self->{dbFullFilename} );
    
    say "FULLPathName: [$self->{dbFullFilename}]";

    $self->{data} = $self->OpenDB();
    $self->{data}->{revision} = '1.000' if ! defined $self->{data}->{revision};
   
	return $self;
}

# ======================================
sub OpenDB {
	my ($self) = shift;
	my ( $dbname, $hashdb);
	$dbname = $self->{dbFullFilename};
	$hashdb = DBM::Deep->new( file => "$dbname", locking => 1, autoflush => 1 );
	return $hashdb;
}

# ======================================
sub GetData {
	my ($self) = shift;
	my $hres = $self->{data};
	my ( $ref ) = ref($hres);
	
	# say "[GetData] data type [$ref]";
	if   ( $ref eq "HASH" or  $ref eq "DBM::Deep::Hash") 
	{ 
		return \%$hres;
	}
	else                          
	{ 
		return undef; 
	}

}    # ___________  sub   GetData

# ======================================
sub ToString {
	my ($self) = shift;
	my ($s1);
	$s1 = Dumper( $self->GetData() );
	return $s1;

}    # ___________  sub ToString

# =====================================
sub FillTestData {
	my ($self) = @_;
	my ( $s1, $k, $v );
	my ( @ll );
    my ( $data ) = $self->GetData();

	my (%users) = (
			enzo    => { user => 'enzo',    userid => 1,  password => 'pino' },
			lilia   => { user => 'lilia',   userid => 2,  password => 'pino' },
		    davide  => { user => 'davide',  userid => 3,  password => 'pino' },
			claudia => { user => 'claudia', userid => 4,  password => 'pino' }
	);

	foreach $k ( keys %users )
	{
		$self->SetUser( $users{$k}->{userid}, $k, $users{$k}->{password} );
	}

    $self->SetSwimmingPool( 1, 'Seriate' );
    $self->SetSwimmingPool( 2, 'Ponte S. Pietro' );

    $self->SetTime( 1, '12:00', '13:30');
    $self->SetTime( 2, '07:00', '09:00');
    
    
}  ## __________  sub FillTestData 

# =====================================
# =====================================
sub SetUser {
	my ( $self, $id, $user, $pwd ) = @_;
    my ( $data ) = $self->GetData();

	$data->{users}->{$id}->{user}     = $user;
	$data->{users}->{$id}->{password} = crypt( $user, $pwd );

	# say( sprintf "Dump data : %s ", Dumper($data));

}    ## _________ sub SetUser


# =====================================
sub SetSwimmingPool {
	my ( $self, $id, $swimpool ) = @_;
    my ( $data ) = $self->GetData();

	$data->{swimmmingPools}->{$id}     = $swimpool;

	# say( sprintf "Dump data : %s ", Dumper($data));

}    ## _________ sub SetSwimmingPool



# =====================================
sub SetTime {
	my ( $self, $id, $timeStart, $timeEnd ) = @_;
    my ( $data ) = $self->GetData();

	$data->{times}->{$id}->{timeStart} = $timeStart;
	$data->{times}->{$id}->{timeEnd}   = $timeEnd;

}    ## _________ sub SetTime


1;

