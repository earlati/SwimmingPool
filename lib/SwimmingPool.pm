#!/usr/bin/perl
#
#
package SwimmingPool;

use warnings;
use strict;
use feature qw( say );
use Data::Dumper;
use Template;
use CGI;

use Swim::GlobalData qw( Color );

use base qw( Swim::CommonParent );
use Swim::Log;
use Swim::Storage;

=head1 NAME

SwimmingPool - The great new SwimmingPool!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

Test1() unless caller;

# ===================================
sub Test1 {
	my ( $obj1, $s1, $lst, $ttFile );

	$obj1 = new SwimmingPool();
	$obj1->Log("DB PathName: [$obj1->{storageObj}->{dbFullFilename}]");

	$lst = $obj1->GetUserList();

	# printf "Dump users : %s \n", Dumper($lst);
	$s1 = $obj1->ProcessTemplate( 'UserList.tt', { users => $lst } );
	$obj1->Log("Users html : $s1 ");
	print "$s1";
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
		cgi         => undef,
		titleCgi    => 'SwimmingPool  Sport Event Planner',
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
sub DESTROY {
	my ($self) = @_;

	$self->Log("SwimmingPool is destroited ");

	# if ( defined $self->{cgi} ) { print $self->{cgi}->end_html(); }
}

# ===================================
sub Log {
	my ( $self, $msg ) = @_;

	if ( defined $self->{logObj} ) {
		$self->{logObj}->Log($msg);
	}

}    ## __________ sub Log

# ===================================
sub InitProgram {
	my ($self) = @_;
	my ( $vars, $ttPath );

	$self->{rootPath}   = $self->GetRootPath();
	$self->{logObj}     = new Swim::Log( $self->{logFilename} );
	$self->{storageObj} = new Swim::Storage( $self->{dbFilename} );

	$vars->{rootPath} = $self->{rootPath};
	$ttPath = sprintf "%s/tt/", $self->{rootPath};

	$self->{templateObj} = new Template(
		{
			ABSOLUTE     => 'true',
			RELATIVE     => 'true',
			VARIABLES    => $vars,
			PRE_PROCESS  => "${ttPath}/header.tt",
			POST_PROCESS => "${ttPath}/footer.tt"
		}
	);

	#  $self->{cgi} = new CGI();
	#  $self->PrintHeaderHtml();

}    ## __________ sub InitProgram

# ==================================
sub PrintHeaderHtml {

	my ($self) = @_;
	my ($sres) = "";

	if ( !defined $self->{cgi} ) { $self->Log("leave ... "); return $sres; }

	$sres = $self->{cgi}->header( { -type => 'text/html', -expire => '+3h' } );

	$sres .= $self->{cgi}->start_html(
		-title  => "$self->{titleCgi}",
		-author => 'enzo.arlati@libero.it',
		-style  => {
			-src   => $self->{rootPath} . '/css/config_bcm.css',
			-media => 'screen'
		},
		-script => [
			{ -src => '/js/jquery-1.4.2.min.js', -language => 'javascript' },
			{ -src => '/js/jquery.tools.min.js', -language => 'javascript' },
			{
				-src      => $self->{rootPath} . '/js/swim.js',
				-language => 'javascript'
			}
		],
		-bgcolor => Swim::GlobalData::Color('colorGrey1')
	);

}    ## __________  sub PrintHeaderHtml

# ==================================
sub PrintFooterHtml {

	my ($self) = @_;
	my ($sres) = "";

	if ( !defined $self->{cgi} ) { $self->Log("leave ... "); return $sres; }
	$sres = $self->{cgi}->end_html();
	return $sres;

}    ## _________  sub PrintFooterHtml

# ===================================
sub GetUserList {
	my ($self)  = @_;
	my ($users) = ();

	$users = $self->{storageObj}->GetUserList();

	# Log( sprintf "Dump list users : %s ", Dumper( $users));
	# Log( sprintf "user %d -> %s ", $users->{1}, $users->{1}->{user} );
	return $users;

}    ## __________ sub GetUserList

# ===================================
sub ProcessTemplate {
	my ( $self, $ttFile, $hash ) = @_;
	my ( $ttFullName, $sts, $stash );
	my ($sres) = "";

	$ttFullName = sprintf "%s/tt/%s", $self->{rootPath}, $ttFile;
	$self->Log("ttFullName : $ttFullName");

	$stash->{title} = "User list";
	$stash->{data}  = $hash;

	if ( defined $self->{templateObj} ) {
		$self->Log("Process tt");
		$self->{templateObj}
		  ->process( $ttFullName, { stash => $stash }, \$sres )
		  or die "[ProcessTemplate] Template ERROR: "
		  . $self->{templateObj}->error();

		# $self->Log( "sres: $sres ");
	}

	return $sres;

}    ## __________ sub GetUserList

1;

