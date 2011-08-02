#!/usr/bin/perl
# ----------------------------------------------------------
# FILE : test_sendmail.pl
# ----------------------------------------------------------
# perltidy -l=120 -gnu -b program.pl
# ----------------------------------------------------------
#  { }  []  `` ~
# ----------------------------------------------------------
use strict;
use warnings;

=head1


=head2 example send message

  [enzo@enzo7 SwimmingPool]$ curl  http://earlati.com/SwimmingPool/t/test_sendmail.pl
   open status : 22571 
   close status : 1 
  Sended message to enzo.arlati@libero.it 

=head2 example message received
  
 Messaggio inviato il Mon May 23 22:42:11 2011 

 [SCRIPT_NAME] => [/SwimmingPool/t/test_sendmail.pl] 
 [SERVER_NAME] => [earlati.com] 
 [SERVER_ADMIN] => [support@freehostia.com] 
 [HTTP_ACCEPT_ENCODING] => [gzip,deflate] 
 [HTTP_CONNECTION] => [keep-alive] 
 [REQUEST_METHOD] => [GET] 
 [HTTP_ACCEPT] => [text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8] 
 [SCRIPT_FILENAME] => [/home/www/earlati.com/SwimmingPool/t/test_sendmail.pl] 
 [SERVER_SOFTWARE] => [Apache/1.3.33 (Unix) mod_ssl/2.8.22 OpenSSL/0.9.7d SE/0.5.3] 
 [HTTP_ACCEPT_CHARSET] => [ISO-8859-1,utf-8;q=0.7,*;q=0.7] 
 [REMOTE_USER] => [] 
 [AUTH_TYPE] => [Basic] 
 [QUERY_STRING] => [] 
 [REMOTE_PORT] => [52052] 
 [HTTP_USER_AGENT] => [Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.6.17-1.fc14 Firefox/3.6.17] 
 [PHP_DOCUMENT_ROOT] => [/home/www/earlati.com] 
 [SERVER_PORT] => [80] 
 [REDIRECT_STATUS] => [200] 
 [HTTP_ACCEPT_LANGUAGE] => [en-us,en;q=0.5] 
 [REMOTE_ADDR] => [151.64.144.132] 
 [HTTP_KEEP_ALIVE] => [115] 
 [SERVER_PROTOCOL] => [HTTP/1.0] 
 [PATH] => [/usr/local/bin:/usr/bin:/bin] 
 [REQUEST_URI] => [/SwimmingPool/t/test_sendmail.pl] 
 [GATEWAY_INTERFACE] => [CGI/1.1] 
 [SERVER_ADDR] => [66.40.52.76] 
 [DOCUMENT_ROOT] => [/home/www/earlati.com] 
 [HTTP_HOST] => [earlati.com]  

=cut

my ( $message, $strnow, $title, $from, $to, $subject, $sts );

$title = 'Perl Mail demo';
$from  = 'swimmingpool@earlati.com';
$to      = 'enzo.arlati@libero.it';
$strnow  = localtime();
$subject = "[$strnow] Test sendmail";

print "Content-type: text/plain\n\n";

$sts = open( MAIL, "|/usr/sbin/sendmail -tv" );

print " open status : $sts \n";

if ( !defined $sts )
{
	print " ERROR open $! \n";
}

## Mail Header
print MAIL "To: $to\n";
print MAIL "From: $from\n";
print MAIL "Subject: $subject\n\n";
## Mail Body

$message = "Messaggio inviato il $strnow \n\n";

foreach my $k ( keys %ENV ) { $message .= sprintf "[%s] => [%s] \n", "$k", "$ENV{$k}"; }

print MAIL " $message \n";

$sts = close(MAIL);

print " close status : $sts \n";

if ( !defined $sts )
{
	print " ERROR close $! \n";
}

print "Sended message to $to \n\n";

