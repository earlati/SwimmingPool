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

use lib '../';
use Swim::DBUser;
use base qw( Swim::BaseCgi );





# =====================================
sub mylog
{
	my ($msg) = @_;
	my ( $s1, $ll );
	my @call = caller(1);
	if ( "$call[3]" eq "(eval)" )
	{
		@call = caller(2);
	}

	# print "Dumer call: " . Dumper( \@call ) . "\n";
	$s1 = sprintf "[%s] %s", $call[3], $msg;
	warn sprintf "$s1 \n";

}



# ===================================
sub SelectCommand
{
	my ($self) = @_;

	if ( $self->Command() eq 'login' )
	{
		$self->BuildHtmlLogin();
	}
	elsif ( $self->Command() eq 'checkLogin' )
	{
		$self->BuildAnswerCheckLogin();
	}
	elsif ( $self->Command() eq 'register' )
	{
		$self->BuildHtmlRegister();
	}

}    ## ______ sub SelectCommand

# ===================================
# ===================================
sub BuildHtmlLogin
{
	my ($self) = @_;

	my ($currUser) = "";
	my ($currPwd)  = "";
	my ($sres)     = "";
	my ($readonly) = 0;

	$sres .= $self->GetLoadingDiv();
	$sres .= $self->{cgiObj}->h2("Login ");

	$sres .= '<p> ';
	$sres .= $self->BuildHtmlEdit( 'user_name', 'Utente', $currUser, 20, 30, $readonly );
	$sres .= '<p> ';
	$sres .= $self->BuildHtmlEdit( 'password', 'Password', $currPwd, 20, 30, $readonly );

	$sres .= "<p> ";
	$sres .= $self->BuildHtmlBtnOk();
	$sres .= $self->BuildHtmlBtnCancel();
	$sres .= "<p> ";
	$sres .= $self->BuildHtmlBtnResetPassword();
	$sres .= $self->BuildHtmlBtnRegister();
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
	my ( $s1, $json, $params, $objUser, $dataUser, $resUser );
	my ($sres)    = "";
	my ($ctxType) = $self->GetContentJson();

	mylog("BuildAnswerCheckLogin ... ");

	$self->{params} = $self->{cgiObj}->Vars;
	$params = $self->{params};
	foreach my $k ( keys %$params )
	{
		$s1 = sprintf " Params: %s : %s", $k, $params->{$k};
		mylog("$s1 ");
		$dataUser->{$k} = "$params->{$k}";
	}

	$s1 = "$self->{params}->{user}" || "";
	$objUser = new Swim::DBUser();
	warn( "dataUser : " . Dumper($dataUser) );
	$resUser = $objUser->CheckLogin($dataUser);
	warn( "resUser : " . Dumper($resUser) );

	$json = ' ';
	$json .= sprintf " \"%s\" : \"%s\" ,", "error", "$resUser->{error}";
	$json .= sprintf " \"%s\" : \"%s\" ,", "info",  "$resUser->{info}";
	if ( $resUser->{error} == 0 )
	{
		$json .= sprintf " \"%s\" : \"%s\" ,", "user", "$resUser->{data}->{user}" if defined $resUser->{data}->{user};
		$json .= sprintf " \"%s\" : \"%s\" ,", "iduser", "$resUser->{data}->{id}"
		  if defined $resUser->{data}->{id};
		$json .= sprintf " \"%s\" : \"%s\" ,", "idSession", "$resUser->{data}->{idSession}"
		  if defined $resUser->{data}->{idSession};
	}
	$json =~ s/\, *$//;
	$json = sprintf " { %s } ", $json;
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
#email2            varchar(90)

# ===================================
sub BuildHtmlRegister
{
	my ($self)      = @_;
	my ($sres)      = "";
	my ($currUser)  = "";
	my ($currPwd)   = "";
	my ($currEmail) = 'dummy@swimmingpool.org';
	my ($currEmail2) = 'dummy@running.org';
	my ($readonly)  = 0;
	my ($checked)   = 0;

	$sres .= $self->GetLoadingDiv();
	$sres .= $self->{cgiObj}->h2("Register");

	$sres .= '<p> ';
	$sres .= $self->BuildHtmlEdit( 'user_name', 'Utente', $currUser, 20, 30, $readonly );
	$sres .= '<p> ';
	$sres .= $self->BuildHtmlEdit( 'password', 'Password', $currPwd, 20, 30, $readonly );

	# $sres .= '<p> ';
	# $sres .= $self->BuildHtmlCheckboxUser( $checked, 1 );
	$sres .= '<p> ';
	$sres .= $self->BuildHtmlEdit( 'email', 'E-mail', $currEmail, 20, 100, $readonly );
	$sres .= '<p> ';
	$sres .= $self->BuildHtmlEdit( 'email2', 'Seconda E-mail', $currEmail2, 20, 100, $readonly );

	$sres .= "<p> ";
	$sres .= $self->BuildHtmlBtnOk();
	$sres .= $self->BuildHtmlBtnCancel();
	$sres .= $self->BuildHtmlBtnLogin();
	$sres .= "<p> ";

	$sres .= "<div id=\"StatusFormRegister\"> </div>";
	$sres = "<div id=\"FormRegister\"> $sres </div>";
	$self->{html} .= "$sres";

	return "$sres";

}    ## ___________ sub BuildHtmlRegister

# ===================================
sub BuildHtmlBtnLogin
{
	my ($self) = @_;
	my ($sres);
	$sres = $self->{cgiObj}->button(
		-name  => 'buttonLogin',
		-id    => 'buttonLogin',
		-value => 'Login utente'
	);
	return $sres;

}    ## ________ sub BuildHtmlBtnLogin

# ===================================
sub BuildHtmlBtnRegister
{
	my ($self) = @_;
	my ($sres);
	$sres = $self->{cgiObj}->button(
		-name  => 'buttonRegister',
		-id    => 'buttonRegister',
		-value => 'Registra utente'
	);
	return $sres;

}    ## ________ sub BuildHtmlBtnRegister


# ===================================
sub BuildHtmlBtnResetPassword
{
	my ($self) = @_;
	my ($sres);
	$sres = $self->{cgiObj}->button(
		-name  => 'buttonResetPassword',
		-id    => 'buttonResetPassword',
		-value => 'Reset Password'
	);
	return $sres;

}    ## ________ sub BuildHtmlBtnResetPassword



# ===================================
sub BuildHtmlCheckboxUser
{
	my ( $self, $checked, $readonly ) = @_;
	my ($sres, $params );
	
	$params = {
		-name    => 'enabled_user',
		-checked => $checked,
		-value   => 'ON',
		-label   => 'Enable user'		
	};
	$params->{-readonly} = 'readonly' if "$readonly" eq "1";
	$sres = $self->{cgiObj}->checkbox( $params	);
	return $sres;

}    ## ________ sub BuildHtmlCheckboxUser


# ===================================
sub BuildHtmlEditUser
{
	my ( $self, $currUser, $readonly ) = @_;
	my ($sres, $params );
    $params = {
		-name      => "user_name",
		-value     => "$currUser",
		-size      => 20,
		-maxlength => 30    	
    };
	$params->{-readonly} = 'readonly' if "$readonly" eq "1";

	$sres = "Utente";
	$sres .= $self->{cgiObj}->textfield( $params );

	return $sres;

}    ## ________ sub BuildHtmlEditUser




# ===================================

=head2 sub BuildAnswerStoreRegister

	$obj1 = new Swim::StorageDB();

	$param->{user}    = ' user2 ';
	$param->{pwd}     = ' password1 ';
	$param->{enabled} = ' 1 ';
	$param->{email}   = ' user1 @swimming . it ';
	$sres             = $obj1->SaveUser($param);
	print "Dump res: " . Dumper($sres) . " \n";
	
  Dump res: $VAR1 = {
          ' info ' => ' Creato nuovo utente user2 id = 14 ',
          ' error ' => 0,
          ' data ' => {
                      ' email ' => ' user1 @swimming . it ',
                      ' pwd ' => ' usjRS48E8ZADM ',
                      ' numrows ' => ' 1 ',
                      ' dt_mod ' => ' 2011 - 04 - 28 20 : 27 : 12 ',
                      ' user ' => ' user2 ',
                      ' id ' => ' 14 ',
                      ' enabled ' => ' 1 '
                    }
        };

=head3 Dump of result returned when the user already exists

  Dump res: $VAR1 = {
          ' info ' => ' L \' utente user2 esiste gia\' ',
		'error' => 2
	  };

=cut

# ===================================
sub BuildAnswerStoreRegister
{
	my ($self) = @_;
	my ( $s1, $json, $params, $objStore, $dataStore, $resStore );
	my ($sres)    = "";
	my ($ctxType) = $self->GetContentJson();

	$self->{params} = $self->{cgiObj}->Vars;
	$params = $self->{params};
	foreach my $k ( keys %$params )
	{
		$s1 = sprintf " Params: %s : %s", $k, $params->{$k};
		warn "[StoreRegister] $s1 ";
		$dataStore->{$k} = "$params->{$k}";
	}

	$objStore = new Swim::DBUser();
	$resStore = $objStore->SaveUser($dataStore);

	$json = ' ';
	$json .= sprintf " \"%s\" : \"%s\" ,", "error", "$resStore->{error}";
	$json .= sprintf " \"%s\" : \"%s\" ,", "info",  "$resStore->{info}";
	if ( $resStore->{error} == 0 )
	{
		$json .= sprintf " \"%s\" : \"%s\" ,", "user", "$resStore->{data}->{user}"
		  if defined $resStore->{data}->{user};
		$json .= sprintf " \"%s\" : \"%s\" ,", "iduser", "$resStore->{data}->{id}"
		  if defined $resStore->{data}->{id};
	}
	$json =~ s/\, *$//;
	$json = sprintf " { %s } ", $json;
	$sres = sprintf "%s %s", $ctxType, $json;

	return "$sres";

}    ## ___________ sub BuildAnswerStoreRegister

1;

