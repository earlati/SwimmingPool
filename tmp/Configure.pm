#!/usr/bin/perl
# ----------------------------------------------------------
# FILE : Configure.pm
# ----------------------------------------------------------
# perltidy -l=120 -gnu -b program.pl
# ----------------------------------------------------------
#  { }  []  `` ~
# ----------------------------------------------------------

package Configure;

use 5.006;
use strict;
use warnings;
use feature qw( say );
use Data::Dumper;
use Config::General;

our $VERSION = '0.01';


RunTest() unless caller;

# ======================================
# ======================================
sub RunTest {

	my ( $obj1, $obj2, $s1, $fname, $path, $rootPath );

	$fname = 'config-test.data';
	$obj1  = new Configure($fname);
	$obj1->FillData();
	$s1 = $obj1->ToString();

	# say "[1] ConfigFilename: %s => DATA: %s ", $obj1->ConfigFileName(), $s1 ;
	$obj1->Save();

	$obj2 = new Configure($fname);
	$obj2->Load();
	$s1 = $obj2->ToString();
	printf "[2] ConfigFilename: %s => DATA: %s \n", $obj2->ConfigFileName(), $s1;

}    # _______ sub runTest

# ======================================

=head2 new
=cut

# ======================================
sub new {
	my ($class) = shift;
	my ($fname) = shift;
	my $self    = {
		first          => undef,
		configObj      => undef,
		configData     => undef,
		rootPath       => undef,
		configFilename => 'default.conf',
		lastUpdate     => '26.02.2011'
	};
	bless $self, $class;

	$self->{rootPath} = '';

	if ( defined $fname ) { $self->{configFilename} = "$fname"; }
	
	print "ROOT $self->{rootPath} \n";
	print "CONFIG  $self->{configFilename} \n";
	
	$self->{configFilename} = sprintf "%s/data/%s", $self->{rootPath}, $self->{configFilename};

	if ( !-f $self->{configFilename} ) {
		open F, "> $self->{configFilename} "
		  or die "Can't open file [$self->{configFilename}] $! \n";
		print F "";
		close F;
	}

	$self->{configObj} = new Config::General( $self->{configFilename} );

	return $self;
}

#accessor method for ConfigFileName
sub ConfigFileName {
	my ( $self, $value ) = @_;
	$self->{configFilename} = $value if defined($value);
	return ( $self->{configFilename} );
}

# ======================================

=head2 FillData
=cut

# ======================================
sub FillData {
	my $self = shift;

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
	
	foreach my $k ( keys %users )
	{
		$users{$k}->{cryptpassword} = crypt( $users{$k}->{user}, $users{$k}->{password});
	}
	$self->{configData}->{test1}    = "test1";
	$self->{configData}->{bgcolor1} = '#AAAAAA';
	$self->{configData}->{monthday} = \%monthday;

	$self->{configData}->{users} = \%users;

	return 1;

}    # ___________  sub FillData

# ======================================

=head2 sub ToString
=cut

# ======================================
sub ToString {

	my $self = shift;
	my ($s1);

	$s1 = Dumper( $self->GetConfigData() );
	return $s1;

}    # ___________  sub ToString

# ======================================

=head2 GetConfigObj
=cut

# ======================================
sub GetConfigObj {
	my $self = shift;
	return $self->{configObj};

}    # ___________  sub   GetConfigObj

# ======================================

=head2 GetConfigData
=cut

# ======================================
sub GetConfigData {
	my $self = shift;
	my $hres = $self->{configData};
	if   ( ref($hres) eq "HASH" ) { return \%$hres; }
	else                          { return undef; }

}    # ___________  sub   GetConfigData

# ======================================

=head2 Load
=cut

# ======================================
sub Load {
	my $self = shift;

	%{ $self->{configData} } = $self->GetConfigObj()->getall();

	printf "[Load] ConfigData: %s \n", Dumper( $self->{configData} );

	return 1;

}    # ___________  sub Load

# ======================================

=head2 Save
=cut

# ======================================
sub Save {
	my $self = shift;
	my ( $confObj ) = $self->GetConfigObj();
	my ( $fconfigname ) = $self->{configFilename};
	$self->GetConfigData()->{lastUpdate} = localtime;

    $fconfigname = $self->GetUntaint( $fconfigname );
	#  -ConfigHash => \%{$self->{configData}}
	$confObj->save_file( $fconfigname, \%{ $self->{configData} } );
	return 1;
}    # ___________  sub Save


# ======================================
# ======================================
sub GetUntaint {
	my ( $self, $msgin ) = @_;
	my ($msgout);
	unless ( $msgin =~ m/^(\S+)$/ ) {
		die("Tainted => [$msgin]");
	}
	$msgout = $1;
	if( $msgin ne $msgout )
	{
		die "[GetUntaint] FAILED [$msgin] [$msgout] ";
	}
	
	return $msgout;
}


1;



