#!/usr/bin/perl
# ----------------------------------------------------------
# FILE : Login.pm
# ----------------------------------------------------------
# perltidy -l=120 -gnu -b program.pl
# ----------------------------------------------------------
#  { }  []  `` ~
# ----------------------------------------------------------

package Swim::Login;

use strict;
use warnings;

use Data::Dumper;
use CGI;

use lib '../lib';
use Swim::DBUser;
use Swim::Login;


Main();

# ========================================

=head2 sub Man

     TestRegister();
     TestCheckLogin();
     
=cut

# ========================================
sub Main
{
	eval 
	{ 
		 TestCheckLogin(); 
	};

	if ($@)
	{
		print "Content-type: text/plain\n\n";
		print " Error: \n";
		print " $@ \n";
		print "INC:  @INC  \n";
	}

}    ## _________ sub Run


# ===================================
sub TestRegister
{
	my ( $obj1, $s1, $params );

	$params = 'p1=aaaaa&p2=bbbbb';
	$obj1 = new Swim::Login( 'register', $params );
	$obj1->BuildHtmlRegister();
	$obj1->EndHtml();
	$s1 = $obj1->GetHtml();
	mylog "$s1 \n";
}

# ===================================
sub TestCheckLogin
{
	my ( $obj1, $s1, $params );

	$params = 'user=test1&pwd=test1';
	$obj1   = new Swim::Login( 'checkLogin', $params );
	$s1     = $obj1->BuildAnswerCheckLogin();
	mylog "$s1 \n";
}

# =====================================
sub TestRequestResetPassword
{
	my ( $obj1, $s1, $cmd, $params );

   $params = 'email=enzo@enzo7.localdomain&prog=reqResetPwd'; 
   $cmd    = 'reqResetPwd';
   $obj1 = new Swim::Login( $cmd, $params );
   $s1   = $obj1->PerformRequestResetPassword();
	
   mylog ( "$s1 " );	
}

# =====================================


