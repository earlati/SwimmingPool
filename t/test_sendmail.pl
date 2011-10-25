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

use Data::Dumper;

use lib '../lib';
use Swim::SendMail;

my ( $obj1, $s1, $snow, $params );

$snow = localtime();

print "Content-type: text/plain\n\n";

$params->{from}    = 'swimmingpool@earlati.com';
# $params->{from}    = 'enzo.arlati@libero.it';

$params->{to}      = 'suppiluliumae@libero.it';
$params->{cc}      = 'enzo.arlati@libero.it,enzo.arlati@gmail.com,enzoarlati@tiscali.it';
$params->{subject} = "Test send on date $snow ";
$params->{message} = "hello test [$snow]";

foreach my $k ( keys %ENV )
{
	$params->{message} .= sprintf "[%s] => [%s] \n", "$k", "$ENV{$k}";
}

$obj1 = new Swim::SendMail($params);
$obj1->Send();

print "Test sendmail " . Dumper($obj1);

