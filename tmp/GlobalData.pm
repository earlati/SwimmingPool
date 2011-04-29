#!/usr/bin/perl
#
package Swim::GlobalData;
use strict;
use warnings;
use base 'Exporter';
use Carp;

our $VERSION     = '1.071';
our $LAST_UPDATE = '16.03.2011';

our %EXPORT_TAGS = ( 'all' => [qw( GetErrors GetWarnings GetInfos Color )] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw( Color );

our ( $errors, $warnings, $infos );

# ===============================================================
# ===============================================================
sub GetErrors   { return $errors; }
sub GetWarnings { return $warnings; }
sub GetInfos    { return $infos; }

# ===============================================================
# ===============================================================
sub GetFilenames {
	my %hashTmp = (
		'ectHost'     => '/etc/hosts',
		'etcServices' => '/etc/services'
	);

	return \%hashTmp;

}

# ===============================================================
#  COLORI
# ===============================================================
sub GetColors {
	my %colors = (
		colorGrey1 => "#EEEEEE",
		colorGrey2 => "#334444",
		colorGrey3 => "#AABBCC",
		colorGrey4 => "#BBBBFF",
		colorGrey5 => "#334444",
		colorGrey6 => "#AAAAAA",

		colorGreen1 => "#CCFFCC",

		colorAzzurro1 => '#AAEFEF',
		colorAzzurro2 => '#AAFFFF',

		colorYellow => '#FFFF00'
	);
	return \%colors;
}

# ===============================================================
#  print " COLOR: " . ConfigBcm::GlobalData::Color( 'colorGrey5' ) . " \n";
# ===============================================================
sub Color {
	my ($colkey) = @_;
	my ($colval);
	$colval = GetColors->{$colkey};
	return $colval;
}

# ===============================================================
# ===============================================================
sub GetListIdPanel {
	my ( $minPanel, $maxPanel ) = @_;
	my ($lstIdPanels) = {};

	if ( !defined $minPanel ) { $minPanel = 1; }
	if ( !defined $maxPanel ) { $maxPanel = 9; }

	for ( my $k = $minPanel ; $k <= $maxPanel ; $k++ ) {
		$lstIdPanels->{$k} = "$k";
	}
	return $lstIdPanels;
}

# ===============================================================

=head2 sub GetFileName

    my $debugCr01                = ConfigBcm::GlobalData::GetFileName( 'debugCr01' );
	my $fconfig                  = ConfigBcm::GlobalData::GetFileName('cmvConfig');
	my $fconfig_autovepd_devices = ConfigBcm::GlobalData::GetFileName('configAutovepdDevices');
	my $fconfig_benzopmv         = ConfigBcm::GlobalData::GetFileName('configBenzopmv');
	my $keysDir                  = ConfigBcm::GlobalData::GetFileName('keysOpenVpn');
 
=cut

# ===============================================================
sub GetFileName {
	my ($kname) = @_;
	my ( $result, $s1, $hash );
	if ( exists GetFilenames->{$kname} ) {
		$result = GetFilenames->{$kname};
	}
	else {
		$hash   = GetFilenames();
		$result = "";
		$s1     = sprintf "INVALID KEY [$kname] valid values: %s", join ' ',
		  keys %$hash;
		push @$errors, "$s1";
		ae_util::mylog($s1);
		ae_util::Trace($s1);

		# exit(-1);
	}

	# $s1 = sprintf " KEY [$kname] VALUE [%s] ", $filesNames{$kname};
	# ae_util::mylog($s1);
	return $result;
}    ## ___________  sub GetFileName

1;

