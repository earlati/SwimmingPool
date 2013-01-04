#!/usr/bin/perl
# ----------------------------------------------------------
# FILE : SendMail.pm
# ----------------------------------------------------------
# perltidy -l=120 -gnu -b program.pl
# ----------------------------------------------------------
#  { }  []  `` ~
# ----------------------------------------------------------

package Swim::SendMail;

use strict;
use warnings;

use Data::Dumper;
use Swim::Log;

Run() unless caller();

# ========================================
sub Run
{
	eval {
		my ( $obj1, $msg, $params, $snow );
		my ( $from, $to,  $cc,     $bcc, $subject, $message );

		$snow    = localtime();
		$from    = 'swimmingpool@earlati.com';
		$from    = 'enzo.arlati@gmail.com';
		$to      = 'enzo.arlati@gmail.com';
		$subject = "[$snow] Test send mail";
		$message = "Messaggio di prova inviato il $snow \n\n";

		# foreach my $k ( keys %ENV ) { $message .= sprintf "[%s] => [%s] \n", "$k", "$ENV{$k}"; }

		$params->{to}      = 'enzo.arlati@gmail.com';
		$params->{from}    = $from;
		$params->{cc}      = $cc;
		$params->{bcc}     = $bcc;
		$params->{subject} = $subject;
		$params->{message} = $message;

		$obj1              = new Swim::SendMail($params);
		$obj1->Send();

		# BasicSendMail( $from, $to, $cc, $bcc, $subject, $message );

	};

	if ($@)
	  {
		  print "Content-type: text/plain\n\n";
		  print " Error: \n";
		  print " $@ \n";
	}

}    ## _________ sub Run

# ========================================

=head2 sub BasicSendMail

=cut

# ========================================
sub BasicSendMail
  {
	  my ( $from, $to, $cc, $bcc, $subject, $message ) = @_;
	  my ( $obj1, $params );

	  $params->{from}    = $from;
	  $params->{to}      = $to;
	  $params->{cc}      = $cc if defined $cc;
	  $params->{bcc}     = $cc if defined $bcc;
	  $params->{subject} = $subject;

	  #foreach my $k ( keys %ENV ) { $message .= sprintf "[%s] => [%s] \n", "$k", "$ENV{$k}"; }
	  
	  # [REMOTE_ADDR] => [151.55.75.117]
	  $message .= "\n\n";
	  $message .= sprintf "Messaggio inviato da un utente connesso dall' indirizzo IP %s\n", $ENV{REMOTE_ADDR};
	  
	  $params->{message} = "$message";
	  
	  $obj1 = new Swim::SendMail($params);
	  $obj1->Send();

  }    ## _______ sub BasicSendMail

# ===================================
sub new
  {
	  my $class  = shift;
	  my $params = shift;
	  my $self   = { lastUpdate => '20.11.2011' 
	               };
      my ( $logPath );

	  bless $self, $class;
	  
	  foreach my $k ( keys %$params )
	  {
		  $self->{$k} = "$params->{$k}";
	  }
	  
      if( -d '../logs/' ) { $logPath = '../logs/' }
	  elsif( -d '../../logs/' ) { $logPath = '../../logs/' }
	  else { $logPath = '/tmp/' }

	  $self->{logObj} = new Swim::Log(  "$logPath/SwimmingPool.log" );
	  	  

      if ( defined $ENV{SERVER_NAME} &&  $ENV{SERVER_NAME} eq "earlati.com"  )
      {
         $self->{from}    = 'swimmingpool@earlati.com';
      }
      else
      {
         $self->{from}  = 'enzo@enzo7.localdomain';
         $self->{to}    = 'enzo@enzo7.localdomain';
      }	  

	  return $self;

  }    ## __________ sub new

# ===================================
sub DESTROY
  {
	  my ($self) = @_;

  }    ## ________  sub DESTROY




# ===================================
sub Send
  {
	  my ($self) = @_;
	  my ( $msg ) = "";

	  $msg .= "To: $self->{to}\n";
	  $msg .= "From: $self->{from}\n";
	  $msg .= "Cc: $self->{cc}\n"  if defined $self->{cc};
	  $msg .= "Bcc: $self->{cc}\n" if defined $self->{bcc};
	  $msg .= "Subject: $self->{subject}\n\n";
	  $msg .= " $self->{message} \n";

      $self->{logObj}->Log( "msg: $msg " ); 
	  # printf "[SendMail::Send] Dumper: %s ", Dumper( $self );
	  open( MAIL, "| /usr/sbin/sendmail -t" );
      print MAIL "$msg"; 
	  close(MAIL);

  }    ## ________  sub Send

1;

