#!/usr/bin/perl

use 5.006;
use strict;
use warnings;
# use Test::More tests => 1;
use Test::More qw( no_plan );
use Data::Dumper;
use File::Basename;


### 1 : check module
BEGIN { use_ok "Config::General"};
require_ok( 'Config::General' );
require_ok( 'Data::Dumper' );
require_ok( 'File::Basename' );

my ( $user, $pwd, $pwdCrypt, $path, $rootPath, $cfg );

## password 
$user = "enzo";
$pwd = "topolino",
$pwdCrypt = crypt( $user, $pwd );
ok( 1, "Passwd $user $pwd  = > $pwdCrypt ");


### 2 - 7
 $cfg = "config-test.data";
  eval {
    my $conf = new Config::General($cfg);
    my %hash = $conf->getall;
  };
  ok(!$@, "getall $cfg $@");



