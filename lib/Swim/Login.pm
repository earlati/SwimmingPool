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
		$obj1 = new Swim::Login( 'register', $params );
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
# ===================================
sub BuildHtmlLogin
{
	my ($self) = @_;

	my ($lastUser) = "";
	my ($sres)     = "";

	$lastUser = $self->{cgiObj}->cookie('CurrentUser') || '';
	$sres .= $self->{cgiObj}->h2("Login ");

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
	$sres .= $self->{cgiObj}->button( -name => 'buttonOk', -id => 'buttonOk', -value => 'Conferma' );
	$sres .= $self->{cgiObj}->button(
		-name  => 'buttonCancel',
		-id    => 'buttonCancel',
		-value => 'Cancella'
	);
	$sres .= $self->{cgiObj}->button(
		-name  => 'buttonRegister',
		-id    => 'buttonRegister',
		-value => 'Registra utente'
	);
	$sres .= "<p> ";

	$sres .= "<div id=\"StatusFormLogin\"> </div>";
	$sres = "<div id=\"FormLogin\"> $sres </div>";
	$self->{html} .= "$sres";

	return "$sres";

}    ## ___________ sub BuildHtmlLogin

# ===================================
# UrlQuery : /SwimmingPool/lib/swim.pl?prog=checkLogin { 'user' : 'dddd22', 'password' : 'pwdxxxxx' }
#
#Content-type: application/json
#
# { "user" : "pippo" ,"idSession" : "1330292" ,"crypt" : "HGF5Fccads7754", "error" : "0" }
# ===================================
#Table session_connect
#=====================
#id, date, id_user, hash_code, dt_mod
#---------------------
#id               int(11) PK
#date             datetime
#id_user          int(11)
#hash_code        varchar(45)
#dt_mod           timestamp
#
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
	$s1 = sprintf " \"%s\" : \"%s\" ", "user", $self->{params}->{user};
	$json .= " $s1 , ";
	$s1 = sprintf " \"%s\" : \"%s\" ", "error", "0";
	$json .= " $s1 , ";
	$s1 = sprintf " \"%s\" : \"%s\" ", "idSession", "1110";
	$json .= " $s1 ";
	$json .= ' } ';
	$sres = sprintf "%s %s", $ctxType, $json;

	return "$sres";

}    ## ___________ sub BuildAnswerCheckLogin

# ===================================
#Table users
#===========
#id, user, pwd, enabled, dt_mod, email
#-----------
#id               int(11) PK
#user             varchar(20)
#pwd              varchar(30)
#enabled          tinyint(1)
#dt_mod           timestamp
#email            varchar(90)

# ===================================
sub BuildHtmlRegister
{
	my ($self) = @_;
	my ($sres) = "";

	$sres .= $self->{cgiObj}->h2("Register");

	$sres .= '<p> Utente ';
	$sres .= $self->{cgiObj}->textfield(
		-name      => "user_name",
		-value     => "",
		-size      => 20,
		-maxlength => 30
	);

	$sres .= '<p> Enabled ';
	$sres .= $self->{cgiObj}->checkbox(-name=>'enabled_user',
      -checked=>1,
      -value=>'ON',
      -label=>'Enable user');

	$sres .= '<p> Password ';
	$sres .= $self->{cgiObj}->password_field(
		-name      => 'password',
		-value     => '',
		-size      => 20,
		-maxlength => 30
	);

	$sres .= '<p> E-mail ';
	$sres .= $self->{cgiObj}->textfield(
		-name      => 'email',
		-value     => '',
		-size      => 20,
		-maxlength => 90
	);

	$sres .= "<p> ";
	$sres .= $self->{cgiObj}->button( -name => 'buttonOk', -id => 'buttonOk', -value => 'Ok' );
	$sres .= $self->{cgiObj}->button(
		-name  => 'buttonCancel',
		-id    => 'buttonCancel',
		-value => 'Cancel'
	);
	$sres .= "<p> ";

	$sres .= "<div id=\"StatusFormRegister\"> </div>";
	$sres = "<div id=\"FormRegister\"> $sres </div>";
	$self->{html} .= "$sres";

	return "$sres";
	

}    ## ___________ sub BuildHtmlRegister



# ===================================
# ===================================
sub BuildAnswerStoreRegister
{
	my ($self) = @_;
	my ( $s1, $json );
	my ($sres)    = "";
	my ($ctxType) = "Content-type: application/json\n\n";

	warn "BuildAnswerStoreRegister ... ";

	$self->{params} = $self->{cgiObj}->Vars;

	# foreach my $k ( keys %$params ) {
	#	$sres .= $self->{cgiObj}->h2("Params: $k  $params->{$k} ");
	#}

	$json = '{ ';
	$s1 = sprintf " \"%s\" : \"%s\" ", "user", $self->{params}->{user};
	$json .= " $s1 , ";
	$s1 = sprintf " \"%s\" : \"%s\" ", "error", "0";
	$json .= " $s1 , ";
	$s1 = sprintf " \"%s\" : \"%s\" ", "idUser", "10";
	$json .= " $s1 ";
	$json .= ' } ';
	$sres = sprintf "%s %s", $ctxType, $json;

	return "$sres";

}    ## ___________ sub BuildAnswerStoreRegister

