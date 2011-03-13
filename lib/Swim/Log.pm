#!/usr/bin/perl
# ----------------------------------------------------------
# FILE : Log.pm
# ----------------------------------------------------------
# perltidy -l=120 -gnu -b program.pl
# ----------------------------------------------------------
#  { }  []  `` ~
# ----------------------------------------------------------

package Swim::Log;

=head1 NAME

        sub Log( ) 

=head1 SYNOPSIS

	$obj1  = new Swim::Log($fname);
	$obj1->Log("first row ");
	$obj1->Trace( " test trace " );
	
=head1 DESCRIPTION

=head1 METHODS

=cut

use 5.006;
use strict;
use warnings;
use File::Basename;

use base qw( Swim::CommonParent );

our $VERSION = '0.01';

RunTest() unless caller;

# ======================================

=head2 sub RunTest
   
    [enzo@enzo7 SwimmingPool]$ perl  -Ilib    lib/Swim/Log.pm
    
=cut 

# ======================================
sub RunTest {
	my ( $obj1, $s1, $fname );

	$fname = 'test.log';
	$obj1  = new Swim::Log($fname);

	$obj1->Log("first row ");
	$obj1->Log("second row ");
	$obj1->Trace( " test trace " );

}    # _______ sub RunTest

# ======================================
# ======================================
sub new {
	my $class = shift;
	my $fname = shift;
	my $self  = {
		logFilename => 'default.log',
		maxSize     => 1999000,
		rootPath    => undef,
		lastUpdate  => '28.02.2011'
	};

	bless $self, $class;

	$self->{rootPath} = $self->GetRootPath();
	$self->{logFilename} = $fname if defined $fname;

	$self->{logFilename} = sprintf "%s/logs/%s", $self->{rootPath},
	  $self->{logFilename};

	$self->{logFilename} = $self->GetUntaint( $self->{logFilename} );

	# printf "logfilename: %s \n", $self->{logFilename};

	return $self;

}    # _________ sub new

# =============================================
# =============================================
sub Log {
	my ( $self, $strmsg ) = @_;
	my (
		$stmp, $msg,  $sec,  $min,  $hour, $mday,
		$mon,  $year, $wday, $yday, $isdst
	);

	my (@ll);
	my ($funName);
	my ($log_filename) = $self->{logFilename};
	( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) =
	  localtime(time);
	$year += 1900;
	$mon  += 1;

	@ll = caller(2);
	if (@ll) {
		$funName = (@ll)[3];
	}
	else {
		@ll = caller(1);
		if (@ll) {
			$funName = "-+-:" . (@ll)[3];
		}
	} ## end else [ if (@ll)

	if ( !defined $funName ) { $funName = "MYLOG:"; }
	$funName = sprintf( "%-20s", $funName );

	$stmp = uc( basename($0) );
	$msg  = sprintf( "[%04s.%02s.%02s %02s:%02s:%02s] ",
		$year, $mon, $mday, $hour, $min, $sec );
	$msg .= sprintf( "[%s.%05s] ", $stmp, $$ );
	$msg .= "[${funName}] ";
	$msg .= $strmsg;

	if ( defined $log_filename ) {
		open( F, ">>$log_filename" )
		  or open( F, ">$log_filename" )
		  or warn "..Non posso aprire il file $log_filename ($!) \n";
		print F "$msg \n";
		close F;
	} ## end if ( defined $log_filename...
	    # else
	{
		warn "$msg \n";
	}
} ## end sub log

# =============================================
# =============================================
sub TruncateFileSize {
	my ($self) = shift;

	my ($log_filename) = $self->{logFilename};
	my ($maxsize)      = $self->{maxSize};
	my ( $fsize, $stmp, $strmsg );

	if ( !defined $log_filename ) { return 0; }
	$fsize = -s $log_filename;

	# mylog("[TruncateFileSize] size of [$filename] is [$fsize] ");

	if ( $fsize > $maxsize ) {
		$strmsg =
		  "[truncateFileSize] truncate [$log_filename]  from size = [$fsize] ";
		open( F, ">$log_filename" )
		  or warn "..Non posso aprire il file $log_filename ($!) \n";
		close F;
		$self->log($strmsg);
	} ## end if ( $fsize > $maxsize...

	return $fsize;
} ## end sub TruncateFileSize

# =============================================
# TRACE SUB
# =============================================
sub Trace {
	my ( $self, $text ) = @_;

	$self->Log("------------------------------------------------------------");
	$self->Log("TRACING: $text");
	$self->Log("------------------------------------------------------------");

	my $count = 0;
	{
		my ( $package, $filename, $line, $sub ) = caller($count);
		last unless defined $line;
		$self->Log(
			sprintf( "%02i %5i %-35s %-20s", $count++, $line, $sub, $filename )
		);
		redo;
	}
}    # end sub Trace

1;

