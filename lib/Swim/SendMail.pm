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

Run() unless caller();

# ========================================
sub Run
{
	eval {
		my ( $obj1, $msg, $params, $snow );
		my ( $from, $to,  $cc,     $bcc, $subject, $message );

		$snow    = localtime();
		$from    = 'swimmingpool@earlati.com';
		$to      = 'enzo.arlati@gmail.com';
		$subject = "[$snow] Test send mail";
		$message = "Messaggio di prova inviato il $snow \n\n";

		# foreach my $k ( keys %ENV ) { $s1 .= sprintf "[%s] => [%s] \n", "$k", "$ENV{$k}"; }

#		$params->{to}      = 'enzo.arlati@gmail.com';
#		$params->{from}    = $from;
#		$params->{cc}      = $cc;
#		$params->{bcc}     = $bcc;
#		$params->{subject} = $subject;
#		$params->{message} = $message;
#		$obj1              = new Swim::SendMail($params);
#		$obj1->Send();

		BasicSendMail( $from, $to, $cc, $bcc, $subject, $message );

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
	  $params->{message} = "$message";

	  $obj1 = new Swim::SendMail($params);
	  $obj1->Send();

  }    ## _______ sub BasicSendMail

# ===================================
sub new
  {
	  my $class  = shift;
	  my $params = shift;
	  my $self   = { lastUpdate => '23.05.2011' };

	  bless $self, $class;

	  foreach my $k ( keys %$params )
	  {
		  $self->{$k} = "$params->{$k}";
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

	  # printf "[SendMail::Send] Dumper: %s ", Dumper( $self );
	  open( MAIL, "|/usr/sbin/sendmail -t" );

	  print MAIL "To: $self->{to}\n";
	  print MAIL "From: $self->{from}\n";
	  print MAIL "Cc: $self->{cc}\n"  if defined $self->{cc};
	  print MAIL "Bcc: $self->{cc}\n" if defined $self->{bcc};
	  print MAIL "Subject: $self->{subject}\n\n";
	  print MAIL " $self->{message} \n";

	  close(MAIL);

  }    ## ________  sub Send

1;

