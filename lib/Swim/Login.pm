#!/usr/bin/perl
# ----------------------------------------------------------
# FILE : Storage.pm
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

Run() unless caller();

# ========================================
sub Run
{
	eval {
		my ( $obj1, $s1, $params );

		# $params = 'p1=aaaaa&p2=bbbbb';
		$obj1 = new Swim::Login( 'login', $params );
		$obj1->EndHtml();
		$s1 = $obj1->GetHtml();
		print "$s1 \n";
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
sub new
{
	my $class  = shift;
	my $cmd    = shift;
	my $params = shift;
	my $self   = {
		cgiObj     => undef,
		dbObj      => undef,
		cmd        => "$cmd",
		params     => "$params",
		html       => '',
		lastUpdate => '17.04.2011'
	};

	bless $self, $class;
	print "[NEW] params: $params \n";
	$self->InitObject($params);

	if ( $cmd eq 'login' )
	{
		$self->BuildHtmlLogin();
	}
	elsif ( $cmd eq 'checkLogin' )
	{
		$self->BuildAnswerCheckLogin();
	}
	elsif ( $cmd eq 'register' )
	{
		$self->BuildHtmlRegister();
	}

	return $self;

}    ## __________ sub new

# ===================================
sub DESTROY
{
	my ($self) = @_;

}    ## ________  sub DESTROY

# ===================================
sub InitObject
{
	my ( $self, $params ) = @_;
	my ($s1);

	$self->{cgiObj} = new CGI($params);
	$s1 = $self->BuildBaseHtml();

	# print "[InitObject] : $s1 \n";

}    ## _______  sub InitObject

# ===================================
sub EndHtml
{
	my ($self) = @_;
	my ($html);

	$html = $self->{cgiObj}->end_html();
	$self->{html} .= "$html";

}    ## _______  sub EndHtml

# ===================================
sub GetHtml
{
	my ($self) = @_;
	my ($sres) = $self->{html};
	return $sres;
}

# ===================================
sub BuildBaseHtml
{
	my ($self) = @_;
	my ($sres) = "";

	# -----------------------------------------------------
	$sres .= $self->{cgiObj}->header( -type => 'text/html' );

	$sres .= $self->{cgiObj}->start_html(
		-title  => " SwimminPool program  ",
		-author => 'enzo.arlati@aesys.it',
		-style  => { -src => '/SwimmingPool/css/swim.css', -media => 'screen' },
		-script => [
			{ -src => '/js/jquery.min.js',    -language => 'javascript' },
			{ -src => '/js/jquery-ui.min.js', -language => 'javascript' },
			{ -src => '/js/jquery.cookie.js', -language => 'javascript' },
			{
				-src      => '/SwimmingPool/js/swim-utility.js',
				-language => 'javascript'
			}
		],
		-bgcolor => '#AAAAAA'
	);

	$self->{params} = $self->{cgiObj}->Vars;

	# foreach my $k ( keys %$params ) {
	#	$sres .= $self->{cgiObj}->h2("Params: $k  $params->{$k} ");
	#}

	$self->{html} .= "$sres";

	return $sres;

}    ## _______  sub BuildBaseHtml

# ===================================
sub BuildHtmlLogin
{
	my ($self) = @_;

	my ($lastUser) = "";
	my ($sres)     = "";
	my ($action)   = '/SwimmingPool/lib/swim.pl?prog=savelogin';

	$lastUser = $self->{cgiObj}->cookie('CurrentUser') || '';

	$sres .= $self->{cgiObj}->h2("Login ");

	# $sres .= $self->{cgiObj}->start_form( -action => "$action", -target => '#InnerChildBox');

	$sres .= '<p> Utente ';
	$sres .= $self->{cgiObj}->textfield(
		-name      => "user_name",
		-value     => "$lastUser",
		-size      => 20,
		-maxlength => 30
	);

	$sres .= '<p> Password ';
	$sres .= $self->{cgiObj}->password_field(
		-name      => 'password',
		-value     => 'pwdxxxxx',
		-size      => 20,
		-maxlength => 30
	);

	$sres .= "<p> ";
	$sres .= $self->{cgiObj}->button( -name => 'buttonOk', -id => 'buttonOk', -value => 'Ok' );
	$sres .= $self->{cgiObj}->button(
		-name  => 'buttonCancel',
		-id    => 'buttonCancel',
		-value => 'Cancel'
	);
	$sres .= "<p> ";

	# $sres .= $self->{cgiObj}->end_form();
	$sres .= "<div id=\"StatusFormLogin\"> </div>";

	$sres = "<div id=\"FormLogin\"> $sres </div>";
	$self->{html} .= "$sres";

	return "$sres";

}    ## ___________ sub BuildHtmlLogin

# ===================================
#Content-type: application/json
#
# { "user" : "pippo" ,"idSession" : "1330292" ,"crypt" : "HGF5Fccads7754", "error" : "0" }
# ===================================
sub BuildAnswerCheckLogin
{
	my ($self) = @_;
	my ( $s1, $json );
	my ($sres)    = "";
	my ($ctxType) = "Content-type: application/json\n\n";

	warn "BuildAnswerCheckLogin ... ";

	$self->{params} = $self->{cgiObj}->Vars;

	# foreach my $k ( keys %$params ) {
	#	$sres .= $self->{cgiObj}->h2("Params: $k  $params->{$k} ");
	#}

	$json = '{ ';
	$s1   = sprintf " \"%s\" : \"%s\" ", "user", $self->{params}->{user};
	$json .= " $s1 , ";
	$s1   = sprintf " \"%s\" : \"%s\" ", "error", "0";
	$json .= " $s1 , ";
	$s1   = sprintf " \"%s\" : \"%s\" ", "idSession", "1110";
	$json .= " $s1 ";
	$json .= ' } ';
	$sres = sprintf "%s %s", $ctxType, $json;

	return "$sres";

}    ## ___________ sub BuildAnswerCheckLogin

# ===================================
sub BuildHtmlRegister
{
	my ($self) = @_;

	my ($sres) = "";
	$sres .= $self->{cgiObj}->h2("Register");
	$self->{html} .= "$sres";

	return "$sres";

}    ## ___________ sub BuildHtmlRegister

