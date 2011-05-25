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
		my ( $obj1, $s1, $params, $snow );
        
        $snow = localtime();
	    $s1 = "Messaggio di prova inviato il $snow \n\n";
    	# foreach my $k ( keys %ENV ) { $s1 .= sprintf "[%s] => [%s] \n", "$k", "$ENV{$k}"; }

		$params->{to} = 'enzo.arlati@gmail.com';
		$params->{from} = 'swimmingpool@earlati.com';
		$params->{subject} = "[$snow] Test send mail";
		$params->{message} = "$s1";
		$obj1 = new Swim::SendMail($params);
		$obj1->Send();
	};

	if ($@)
	{
		print "Content-type: text/plain\n\n";
		print " Error: \n";
		print " $@ \n";
	}

}    ## _________ sub Run

# ===================================
sub new
{
	my $class  = shift;
	my $params = shift;
	my $self   = {
		lastUpdate => '23.05.2011'
	};

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
	open( MAIL, "|/usr/sbin/sendmail -tv" );

	print MAIL "To: $self->{to}\n";
	print MAIL "From: $self->{from}\n";
	print MAIL "Cc: $self->{cc}\n" if defined $self->{cc};
	print MAIL "Bcc: $self->{cc}\n" if defined $self->{bcc};
	print MAIL "Subject: $self->{subject}\n\n";
	print MAIL " $self->{message} \n";

	close(MAIL);

}    ## ________  sub Send

1;

