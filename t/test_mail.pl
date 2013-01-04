#!/usr/bin/perl
# ================================================
# $ curl http://earlati.com/SwimmingPool/t/test_mail.pl
# ================================================
use Mail::Sender;
use Data::Dumper;

my ( $to, $from, $subject, $message, $sender, $smtp, $s1 );

print "Content-type: text/plain\n\n";

$smtp    = 'mbox.freehostia.com';
$from    = 'swimmingpool@earlati.com';
$to      = 'suppiluliumae@libero.it';
$s1      = localtime();
$subject = "[$s1] Letterina personalissima dal tuo sito di allenamento peferito ";
$message = "
=====================
= Test SwimmingPool =
=====================
";
$message .= sprintf "Messaggio inviato il %s ", join '.', localtime;

# foreach my $k ( keys %ENV ) { $message .= sprintf "[%s] => [%s] \n", "$k", "$ENV{$k}"; }

$message .= "\n =========================================== \n ";

$sender = new Mail::Sender { smtp => "$smtp", from => "$from" }
  or die "Error creating Mail-Sender $! \n";

$sender->MailMsg(
	{
		from    => "$from",
		to      => "$to",
		subject => "$subject",
		msg     => "$message"
	}
) or warn "Error sendind mail $! \n";

print "Dump mailSender : " . Dumper($sender) . "\n";

