#!perl
# ----------------------------------------------------------
# FILE : 01-cgi.t
# ----------------------------------------------------------
# perltidy -l=120 -gnu -b program.pl
# ----------------------------------------------------------
#  { }  []  `` ~
# ----------------------------------------------------------

use strict;
use warnings;
use CGI;

my ( $q );

$q = CGI->new;                 # create new CGI object
print $q->header,              # create the HTTP header
$q->start_html('hello world'), # start the HTML
$q->h1('hello world'),         # level 1 header
$q->end_html;                  # end the HTML




