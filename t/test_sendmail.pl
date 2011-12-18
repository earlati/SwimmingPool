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

eval
{
use Data::Dumper;
use Mail::Sendmail;
use lib '../lib';
use Swim::SendMail;

my ( $obj1, $s1, $snow, $params, $k );

$snow = localtime();

print "Content-type: text/plain\n\n";

if ( defined $ENV{SERVER_NAME} &&  $ENV{SERVER_NAME} eq "earlati.com"  )
{
    $params->{from}    = 'swimmingpool@earlati.com';
}
else
{
     $params->{from}    = 'enzo.arlati@libero.it';
}

$params->{to}      = 'enzo.arlati@gmail.com';
# $params->{cc}      = 'suppiluliumae@libero.it,enzo.arlati@gmail.com,enzoarlati@tiscali.it';
$params->{cc}      = 'enzoarlati@tiscali.it,suppiluliumae@libero.it';
$params->{subject} = "Test send on date $snow ";
$params->{message} = "hello test [$snow]";

# foreach my $k ( keys %ENV )
# {
#	$params->{message} .= sprintf "[%s] => [%s] \n", "$k", "$ENV{$k}";
# }

 $k = 'PWD';
 $params->{message} .= sprintf "\n [%s] => [%s] \n", "$k", "$ENV{$k}";
 $params->{message} .= sprintf " PID $$ \n";

 my ( %mail ) = ( To      => $params->{to},
                  From    => 'enzo.arlati@libero.it',
                  Cc      => $params->{cc},
                  Subject => $params->{subject},
                  Message => "This is a very short message" . localtime()
           );

  # sendmail(%mail) or die " non va : $Mail::Sendmail::error [$!]";

  # printf "OK. Log says: %s \n", $Mail::Sendmail::log;


  $obj1 = new Swim::SendMail($params);
  $obj1->Send();
  printf "Test sendmail =>  %s \n" , Dumper($obj1);
};

if ($@)
{
	print "Content-type: text/plain\n\n";
	print " ERRORE : \n";
	print " $@ \n";
}



