#!/usr/bin/perl
# ----------------------------------------------------------
# FILE : MyLog.pm
# ----------------------------------------------------------
# perltidy -l=120 -gnu -b program.pl
# ----------------------------------------------------------
#  { }  []  `` ~
# ----------------------------------------------------------

package MyLog;

=head1 NAME

MyLog - 

=head1 SYNOPSIS

  my $object = MyLog->new(
      foo  => 'bar',
      flag => 1,
  );
  
  $object->dummy;

=head1 DESCRIPTION

=head1 METHODS

=cut

use 5.006;
use strict;
use warnings;
use File::Basename;

our $VERSION = '0.01';


RunTest() unless caller;

# ======================================
# ======================================
sub RunTest
{
    my( $obj1, $s1, $fname );	
	
    $fname = 'test.log';	
    $obj1 = new MyLog( $fname );
    
    $obj1->log( "first row " );	
    $obj1->log( "second row " );	
	
	
	
}  # _______ sub RunTest



# ======================================
# ======================================
sub new {
	my $class = shift;
	my $fname = shift;
	my $self  = { 
		 logFilename => 'default.log',
		 maxSize =>  1999000,
		lastUpdate => '28.02.2011' 
                  };
	
	$self->{logFilename} = $fname if defined $fname;
	bless $self, $class;	
	return $self;
	
}  # _________ sub new 



# =============================================
# =============================================
sub log
{
 my ( $self, $strmsg) = @_;
 my ( $stmp, $msg, $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst );
 
 my (@ll);
 my ($funName);
 my ( $log_filename ) = $self->{logFilename};
 ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) = localtime(time);
 $year += 1900;
 $mon  += 1;
 
 @ll = caller(2);
 if (@ll)
 {
  $funName = (@ll)[3];
 }
 else
 {
  @ll = caller(1);
  if (@ll)
  {
   $funName = "-+-:" . (@ll)[3];
  }
 } ## end else [ if (@ll)
 
 if ( !defined $funName ) { $funName = "MYLOG:"; }
    $funName = sprintf( "%-20s", $funName );
 
 $stmp = uc ( basename( $0 ) );
 $msg = sprintf( "[%04s.%02s.%02s %02s:%02s:%02s] ",
                  $year, $mon, $mday, $hour, $min, $sec );
 $msg .= sprintf( "[%s.%05s] ", $stmp, $$ );
 $msg .= "[${funName}] ";
 $msg .= $strmsg;
 
 if ( defined $log_filename )
 {
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
sub truncateFileSize
{
    my( $self ) = shift;
    
 my ( $log_filename ) = $self->{logFilename};
 my ( $maxsize ) = $self->{maxSize};
 my ( $fsize, $stmp, $strmsg );
 
    if( !defined $log_filename ) { return 0; }
 $fsize = -s $log_filename;
 
 # mylog("[truncateFileSize] size of [$filename] is [$fsize] ");
 
 if ( $fsize > $maxsize )
 {
  $strmsg = "[truncateFileSize] truncate [$log_filename]  from size = [$fsize] ";
  open( F, ">$log_filename" ) or warn "..Non posso aprire il file $log_filename ($!) \n";
  close F;
   $self->log($strmsg);
 } ## end if ( $fsize > $maxsize...
 
 return $fsize;
} ## end sub truncateFileSize





1;


