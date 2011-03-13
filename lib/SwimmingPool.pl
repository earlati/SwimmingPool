package SwimmingPool;

use warnings;
use strict;
use feature qw( say );
use Data::Dumper;
use Template;

use base qw( Swim::CommonParent );
use Swim::Log;
use Swim::Storage;

=head1 NAME

SwimmingPool - The great new SwimmingPool!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

Test1();

# ===================================
sub Test1 {
	my ( $obj1, $s1, $lst, $ttFile );

	$obj1 = new SwimmingPool();
	$obj1->Log( "DB PathName: [$obj1->{storageObj}->{dbFullFilename}]" );

    $lst = $obj1->GetUserList();
    printf "Dump users : %s \n", Dumper($lst);
    $s1 = $obj1->ProcessTemplate( 'UserList.tt', $lst );
    $obj1->Log( "Users html : $s1 ");

	$obj1->Log("Test End ");

}    ## __________ sub Test1

# ===================================
sub new {
	my $class = shift;
	my $self  = {
		logObj      => undef,
		storageObj  => undef,
		templateObj => undef,
		rootPath    => undef,
		logFilename => 'SwimmingPool.log',
		dbFilename  => 'SwimmingPool.dbm',
		lastUpdate  => '13.03.2011'
	};

	bless $self, $class;
	$self->InitProgram();

    # $self->Log( "FULLPathName: [$self->{storageObj}->{dbFullFilename}]" );
    return $self;

}    ## __________ sub new

# ===================================
sub Log {
	my ( $self, $msg ) = @_;

    $self->{logObj}->Log( $msg );

}    ## __________ sub Log

# ===================================
sub InitProgram 
{
    my ( $self ) = @_;

 	$self->{rootPath} = $self->GetRootPath();
	$self->{logObj} = new Swim::Log( $self->{logFilename} );
	$self->{storageObj} = new Swim::Storage( $self->{dbFilename} );
	$self->{templateObj} = new Template( );


}    ## __________ sub InitProgram

# ===================================
sub GetUserList 
{
    my ( $self ) = @_;
    my ( $users ) = ();

	$users = $self->{storageObj}->GetUserList();
    return $users;

}    ## __________ sub GetUserList


# ===================================
sub ProcessTemplate 
{
    my ( $self, $ttFile, $hash ) = @_;
    my ( $ttFullName, $sts );
    my ( $sres ) = "";
 
	$ttFullName = sprintf "%s/tt/%s", $self->{rootPath},  $ttFile;
	$self->Log( "ttFullName : $ttFullName" );
 
    if( defined $self->{templateObj} )
    {
     	$self->Log( "Process tt" );
        $self->{templateObj}->process( $ttFullName, %$hash ) or die "xxxxxxx [$ttFullName] $! \n";
        # $sres = $self->{templateObj}->output;
        $self->Log( "sres: $sres ");	
    }
	
    return $sres;

}    ## __________ sub GetUserList




1;




