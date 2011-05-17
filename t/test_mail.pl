#!/usr/bin/perl
# ------------------------------------------
use Mail::Sender;
use Data::Dumper;

my ( $to, $from, $subject, $message, $sender, $smtp );

print "Content-type: text/plain\n\n";

$from      = 'swimmingpool@earlati.freehostia.com';
$fake_from = 'SwimmingPool@Una.Bracciata.Dopo.L.Altra';

$to      = 'enzo.arlati@gmail.com';
$to      = 'enzo.arlati@libero.it';
$cc      = '';
$bcc     = '';
$subject = "Letterina personalissima dal tuo sito di allenamento peferito " . localtime;
$message = "

Test SwimmingPool
___________________________________________________________________________________________

";

foreach my $k ( keys %ENV ) { $message .= sprintf "[%s] => [%s] \n", "$k", "$ENV{$k}"; }

$message .= "\n ______________________________________________________________ \n ";

$smtp = 'mail.libero.it';
$smtp = 'mbox.freehostia.com';
$sender = new Mail::Sender { smtp => "$smtp", from => "$from" }
  or die "Error creating Mail-Sender $! \n";

$sender->MailMsg(
	{
		from      => $from,
		fake_from => $fake_from,
		to        => $to,
		cc        => $cc,
		bcc       => $bcc,
		subject   => $subject,
		msg       => "$message"
	}
) or warn "Error sendind mail $! \n";

print "Dump mailSender : " . Dumper($sender) . "\n";

