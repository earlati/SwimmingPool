#!/usr/bin/perl
# ----------------------------------------------------------
# FILE : CommonParent.pm
# ----------------------------------------------------------
# perltidy -l=120 -gnu -b program.pl
# ----------------------------------------------------------
#  { }  []  `` ~
# ----------------------------------------------------------

package Swim::CommonParent;

use 5.006;
use strict;
use warnings;
use File::Basename;
use feature qw( say );
use Cwd;

our $VERSION = '0.01';

require Exporter;

# use AutoLoader qw(AUTOLOAD);
our @ISA = qw( Exporter );

our %EXPORT_TAGS = ( 'all' => [qw( GetRootPath GetUntaint )] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw( GetRootPath );

# ======================================
# ======================================
sub new {
	my $class = shift;
	my $self = bless {
		
	};

	$self = bless $self, $class;

	return $self;
}


# ======================================
# ======================================
sub GetRootPath {
	my $self = shift;
	my ( $path, $rootPath, $base, $t1 );
    my ( $refBase ) = 'SwimmingPool';

	$path     = dirname( Cwd::realpath($0) );
	warn("appliPath = [$path] \n");

	$rootPath = $path;
	$base = basename $rootPath;
	# warn("rootPath = [$rootPath] base = [$base] \n");
	    
	while( $base !~ /${refBase}$/ and  $base !~ /\/$/ )
	{
    	$base = basename $rootPath,
      	$rootPath = dirname $rootPath;
     	# warn("rootPath = [$rootPath] base = [$base] \n");
	}

    if( $rootPath  =~ /\/$/ )
    {
    	$rootPath = '../SwimmingPool';
    }
    
    if( $rootPath  =~ /^\/$/ )
    {
    	die "Wrong root [$rootPath] from path [$path]";
    }
    
	# say("appliPath = [$path] \n");
	# say("rootPath = [$rootPath] \n");

	if ( !defined $rootPath ) {
		die "RootPath is NULL -> data=[$path] ";
	}

	return $rootPath;
}


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

=pod

=head1 SUPPORT

No support is available

=head1 AUTHOR

Copyright 2010 E. Arlati.


# =============================================
# Perl trim function to remove whitespace from the start and end of the string
# =============================================
sub trim($)
{
 my $string = shift;
 if ( !defined $string ) { return $string; }
 $string =~ s/^\s+//;
 $string =~ s/\s+$//;
 return $string;
} ## end sub trim($)
 
# =============================================
# Left trim function to remove leading whitespace
# =============================================
sub ltrim($)
{
 my $string = shift;
 if ( !defined $string ) { return $string; }
 $string =~ s/^\s+//;
 return $string;
} ## end sub ltrim($)
 
# =============================================
# Right trim function to remove trailing whitespace
# =============================================
sub rtrim($)
{
 my $string = shift;
 if ( !defined $string ) { return $string; }
 $string =~ s/\s+$//;
 return $string;
} ## end sub rtrim($)
 
# =============================================
# somewhere at the beginning of the code
# =============================================
# $SIG{__WARN__} = \&ae_util::Warning;
# $SIG{__DIE__}  = \&ae_util::Die;
 
# anywhere
# =============================================
# WARNING SUB
# =============================================
sub Warning
{
 my @text = @_;
 warn "------------------------------------------------------------\n";
 warn "WARNING: @text\n";
 my $count = 0;
 {
  my ( $package, $filename, $line, $sub ) = caller($count);
  last unless defined $line;
  warn( sprintf( "%02i %5i %-35s %-20s\n", $count++, $line, $sub, $filename ) );
  redo;
 }
}    # Warning
 
# =============================================
# DIE SUB
# =============================================
sub Die
{
 my @text = @_;
 warn "------------------------------------------------------------\n";
 warn "FATAL ERROR: @text\n";
 warn "------------------------------------------------------------\n";
 my $count = 0;
 {
  my ( $package, $filename, $line, $sub ) = caller($count);
  last unless defined $line;
  warn( sprintf( "%02i %5i %-35s %-20s\n", $count++, $line, $sub, $filename ) );
  redo;
 }
 
 # exit 1;
}    # Die
 

# =============================================
sub TraceString
{
 my @text = @_;
 my ($sres);
 $sres = "------------------------------------------------------------\n";
 $sres .= "TRACING: @text \n";
 $sres .= "------------------------------------------------------------\n";
 
 my $count = 0;
 {
  my ( $package, $filename, $line, $sub ) = caller($count);
  last unless defined $line;
  $sres .= sprintf( "%02i %5i %-35s %-20s\n", $count++, $line, $sub, $filename );
  redo;
 }
 return $sres;
}    # Trace
 
# ===================================================================
# ===================================================================
sub parse_string_to_hex
{
 my ($msg) = shift;
 if( ! defined $msg ) { $msg = ""; }
 $msg =~ s/(.)/sprintf("%02x",ord($1))/ge;
 return $msg;
}
# ===================================================================
# ===================================================================
sub parse_nonascii_to_hex
{
 my ($msg) = shift;
 $msg =~ s/([\x80-\xff])/sprintf("%02x",ord($1))/ge;
 $msg =~ s/([\x00-\x19])/sprintf("%02x",ord($1))/ge;
 return $msg;
}
 
# ===================================================================
# ===================================================================
sub escape_xml_data
{
 my ($msg) = @_;
 $msg =~ s/([\x80-\xff])/sprintf("&#%02d;",ord($1))/ge;
 return $msg;
}
 
# ======================================


=cut
