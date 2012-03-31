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
use Swim::SendMail;
use Swim::Log;


RunTest() unless caller;

# =====================================
=head some test

	$params  = 'cmd=000001520000004700resetPwd';
	$obj1 = new Swim::Login( 'execRemoteCmd', $params );
	$s1 = $obj1->PerformExecRemoteCmd();  
	print "$s1 \n";
    ===============================================

    $params = 'email=enzo.arlati@libero.it&prog=resetPwd'; 
    $obj1 = new Swim::Login( 'reqRemoteResetPwd', $params );
    $s1 = $obj1->PerformRequestRemoteCmd();
    print "$s1 \n";
    ===============================================

    $params = 'email=enzo.arlati@libero.it&prog=enableUsr'; 
    $obj1 = new Swim::Login( 'reqEnableUsr', $params );
    $s1 = $obj1->PerformRequestRemoteCmd();
    print "$s1 \n";
    ===============================================

=cut
# =====================================
sub RunTest
{
	my ( $obj1, $s1, $params );
	 
	$params  = 'cmd=000001520000004700resetPwd';
	$obj1 = new Swim::Login( 'execRemoteCmd', $params );
	$s1 = $obj1->PerformExecRemoteCmd();  
	print "$s1 \n";

	
}  # ______ sub RunTest
	


# ===================================
# ===================================
sub BuildHtmlLogin
{
	my ($self) = @_;

	my ($currUser) = "";
	my ($currPwd)  = "";
	my ($sres)     = "";
	my ($readonly) = 0;

    $self->Log( "Build Html login " );
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

	$self->Log("BuildAnswerCheckLogin ... ");

	# $self->{params} = $self->{cgiObj}->Vars;
	$params = $self->{params};
	foreach my $k ( keys %$params )
	{
		$s1 = sprintf " Params: %s : %s", $k, $params->{$k};
		$self->Log("$s1 ");
		$dataUser->{$k} = "$params->{$k}";
	}

	$s1 = "$self->{params}->{user}" || "";
	$objUser = new Swim::DBUser();
	$self->Log( "dataUser : " . Dumper($dataUser) );
	$resUser = $objUser->CheckLogin($dataUser);
	$self->Log( "resUser : " . Dumper($resUser) );

	$json = ' ';
	$json .= sprintf " \"%s\" : \"%s\" ,", "error", "$resUser->{error}";
	$json .= sprintf " \"%s\" : \"%s\" ,", "info",  "$resUser->{info}";
	if ( $resUser->{error} == 0 )
	{
		$json .= sprintf " \"%s\" : \"%s\" ,", "user", "$resUser->{data}->{user}" if defined $resUser->{data}->{user};
		$json .= sprintf " \"%s\" : \"%s\" ,", "iduser", "$resUser->{data}->{id}" if defined $resUser->{data}->{id};
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

	$sres .= '<p> ';
	$sres .= $self->BuildHtmlCheckboxUser( $checked, 1 );
	
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
sub BuildHtmlResetPwd
{
	my ($self)      = @_;
	my ($sres)      = "";
	my ($currEmail) = '';
	my ( $readonly ) = 0;
	
	$currEmail = 'enzo.arlati@libero.it';
	$currEmail = $self->{params}->{email} if defined $self->{params}->{email};
	
	$sres .= $self->GetLoadingDiv();
	$sres .= $self->{cgiObj}->h2("Reset Password");

	$sres .= '<p> ';
	$sres .= $self->BuildHtmlEdit( 'email', 'E-mail', $currEmail, 20, 100, $readonly );

	$sres .= "<p> ";
	$sres .= $self->BuildHtmlBtnOk();
	$sres .= $self->BuildHtmlBtnCancel();
	$sres .= "<p> ";

	$sres .= "<div id=\"StatusFormResetPwd\"> </div>";
	$sres = "<div id=\"FormResetPwd\"> $sres </div>";
	$self->{html} .= "$sres";

	return "$sres";

}    ## ___________ sub BuildHtmlResetPwd



# ===================================
sub BuildHtmlEnableUser
{
	my ($self)       = @_;
	my ($sres)       = "";
	my ($currEmail)  = '';
	my ($currPwd)    = '';
	my ($readonly )  = 0;
	my ($enabled)    = 0;
	
	$currEmail = 'enzo.arlati@libero.it';
	$currEmail = $self->{params}->{email} if defined $self->{params}->{email};
	$enabled   = $self->{params}->{enabled} if defined $self->{params}->{enabled};
	
	$sres .= $self->GetLoadingDiv();
	$sres .= $self->{cgiObj}->h2("Abilita utente");

	$sres .= '<p> ';
	$sres .= $self->BuildHtmlEdit( 'email', 'E-mail', $currEmail, 20, 100, $readonly );
	$sres .= '<p> ';
	$sres .= $self->BuildHtmlCheckboxUser( $enabled, 0 );
	
	$sres .= "<p> ";
	$sres .= $self->BuildHtmlBtnOk();
	$sres .= $self->BuildHtmlBtnCancel();
	$sres .= "<p> ";

	$sres .= "<div id=\"StatusFormEnableUser\"> </div>";
	$sres = "<div id=\"FormEnableUser\"> $sres </div>";
	$self->{html} .= "$sres";

	return "$sres";

}    ## ___________ sub BuildHtmlEnableUser



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

	# $self->{params} = $self->{cgiObj}->Vars;
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




# ===================================

=head2 sub PerformRequestResetPassword

   InputParams: 
       'email'       => 'enzo.arlati@libero.it' 
       'operation'   => 'reqRemoteResetPwd'

       'email'       => 'enzo.arlati@libero.it',
       'enable_user' => 'true',
       'operation'   => 'reqRemoteEnableUser'

  
   After BuildRemoteCommand paramsOut: 
   
          'info' => '' 
          'userid' => 47 
          'cmdid' => 70 
          'username' => 'enzo' 
          'email' => 'enzo.arlati@libero.it' 
          'crypto' => '0000007000000047reqRemoteResetPwd' 
          'error' => '' 
          'operation' => 'reqRemoteResetPwd', 


   Result:
      Content-type: application/json
      {   "error" : "" , "info" : "Validazione comando remoto reqRemoteResetPwd per utente enzo"  } 


   malformed header from script. Bad header=enzo.arlati@libero.it... Conne: swim.pl, 


=cut 

# ===================================
sub PerformRequestRemoteCmd
{
	my ($self) = @_;
	my ( $s1, $json, $paramsInp, $paramsOut, $command );
	my ( $from, $to, $subject, $message, $snow );
	my ( $sres )    = "";
	my ( $ctxType ) = $self->GetContentJson();
	my ( $server )  = '127.0.0.1';

    $snow    = localtime();
    $server = $ENV{SERVER_NAME} if defined $ENV{SERVER_NAME} ;

	# Build resetpwd record and store it on db
    %$paramsInp = ();
	$paramsInp = $self->{params};
    $paramsInp->{operation} = $self->Command();
	$self->Log( sprintf( "InputParams: %s ", Dumper( $paramsInp )));

	# $self->Log( sprintf( "paramsInp: %s ", Dumper( $paramsInp )));
    $paramsOut = $self->BuildRemoteCommand( $paramsInp );
	# $self->Log( sprintf( "paramsOut: %s ", Dumper( $paramsOut )));
    

	# Send ResetPwd command to user e-mail
	$command = sprintf "http://%s/SwimmingPool/lib/swim.pl?prog=execRemoteCmd&cmd=%s", $server, $paramsOut->{crypto};
	
	$from    = 'swimmingpool@earlati.com';
	$to      = $paramsOut->{email};
	$subject = sprintf "Validazione comando remoto %s per utente %s", $paramsOut->{operation}, $paramsOut->{username} ;
	$message = "Validazione comando remoto inviato il $snow \n\n";
	$message .= sprintf "Digitare il seguente comando %s dal browser\n", $command;
    $message .= sprintf "per attivare il comando remoto %s \n", $paramsOut->{operation};
    $message .= sprintf "per l' utente %s \n", $paramsOut->{username};
    
    $paramsOut->{info} = sprintf "Inviato comando remoto %s per utente %s", 
                                 $paramsOut->{operation}, $paramsOut->{username} ;

    Swim::SendMail::BasicSendMail( $from, $to, undef, undef, $subject, $message );

	$json = ' ';
	$json .= sprintf " \"%s\" : \"%s\" ,", "error", "$paramsOut->{error}";
	$json .= sprintf " \"%s\" : \"%s\" ,", "info",  "$paramsOut->{info}";
	$json .= sprintf " \"%s\" : \"%s\" ,", "crypto",  "$paramsOut->{crypto}";
	$json .= sprintf " \"%s\" : \"%s\" ,", "username",  "$paramsOut->{username}";
	$json =~ s/\, *$//;
	$json = sprintf " { %s } ", $json;
	$sres = sprintf "%s %s", $ctxType, $json;

	return "$sres";

}    ## ___________ sub PerformRequestRemoteCmd


# ===================================

=head2 sub BuildRemoteCommand

  ALLOWED Operation mode : resetPwd enableUsr


   ParamsIn: 
          'email' => 'enzo.arlati@libero.it',
          'operation' => 'resetPwd'
          
   ParamsOut: 
          'crypto' => '000000460000004700resetPwd',
          'email' => 'enzo.arlati@libero.it',
          'userid' => 47,
          'operation' => 'resetPwd',
          'cmdid' => 46,
          'username' => 'enzo'
        
    Row saved in Database:
    '42', '0000004200000047  resetPwd', 'resetPwd', '0', 'enzo.arlati@libero.it', '2011-09-05 23:46:06', '2011-09-08 23:46:06'
    

        
=cut

# ===================================
sub BuildRemoteCommand
{
	my ($self, $paramsInp ) = @_;
	my ( $s1, $rslt, $sqlcmd, $sqlparams, $paramsOut, $objStore, $resStore );
	my ( @allowedOperations ) = qw( resetPwd enableUser );
	%$paramsOut = %$paramsInp;

    $paramsOut->{error} = "";
    $paramsOut->{info}  =  "";
	$self->Log( sprintf( "ParamsIn: %s ", Dumper( $paramsInp )));

    if( ! defined $paramsInp->{operation} )
    {
	    $paramsOut->{error} =  "BuildRemoteCommand with operation NULL";	
	    return $paramsOut;
	}
    
    if( $paramsInp->{enable_user} == 'true' )
    {
		 $paramsOut->{enable_user} = '1'; 
	}
	else
	{
		 $paramsOut->{enable_user} = '0'; 
	}

	$objStore = new Swim::DBUser(); 
	
	# get user data
    $rslt = $objStore->GetUserByEmail(  $paramsInp->{email} );
    $paramsOut->{username} = $rslt->{user};
    $paramsOut->{userid}   = $rslt->{id};
    
	# remove expired records
	$sqlcmd = 'DELETE FROM remote_cmd where dt_expire < now() '; 
	@$sqlparams = ( );  
    $rslt = $objStore->ExecuteSelectCommand( $sqlcmd, $sqlparams, 1 );
	
	# remove previous command type for the same email
	$sqlcmd = 'DELETE FROM remote_cmd WHERE email = ? and command = ? '; 
	@$sqlparams = ( $paramsInp->{email}, $paramsInp->{operation} );  
    $rslt = $objStore->ExecuteSelectCommand( $sqlcmd, $sqlparams, 1 );

	$sqlcmd  = 'INSERT INTO remote_cmd (`command`, id_user,  `email`,`dt_mod`,`dt_expire`) '; 
	$sqlcmd .= ' VALUES ( ?, ?, ?, now(), date_add( now(), interval 3 day ) )';
	@$sqlparams = ( $paramsInp->{operation}, $paramsOut->{userid},  $paramsInp->{email} );  
    $rslt = $objStore->ExecuteSelectCommand( $sqlcmd, $sqlparams, 1 );

    $paramsOut->{cmdid} = $objStore->GetLastInsertId();
    
    $paramsOut->{crypto} = sprintf "%08d%08d%010s", $paramsOut->{cmdid}, $paramsOut->{userid}, $paramsOut->{operation}; 
    # $paramsOut->{crypto} => '000000450000004700resetPwd'

    $sqlcmd = 'update remote_cmd set crypto_command = ? , dt_mod = now(), ';
    $sqlcmd .= ' enabled_user = ? ,';
    $sqlcmd .= ' dt_expire = date_add( now(), interval 3 day )  where idremote_cmd = ? ';
	@$sqlparams = ( $paramsOut->{crypto}, $paramsOut->{enable_user}, $paramsOut->{cmdid} ); 	
	 
    $rslt = $objStore->ExecuteSelectCommand( $sqlcmd, $sqlparams, 1 );
    
	$self->Log( sprintf( "ParamsOut: %s ", Dumper( $paramsOut )));    

    return $paramsOut;
	
}   ## _________  sub BuildRemoteCommand




# ===================================

=head2 sub PerformExecRemoteCmd

	http://earlati.com/SwimmingPool/lib/swim.pl?prog=execRemoteCmd&cmd=0000005800000021reqRemoteResetPwd
	http://enzo6/SwimmingPool/lib/swim.pl?prog=execRemoteCmd&cmd=0000005800000021reqRemoteResetPwd
	
	Inp params: 
          'cmd' => '0000000200000047reqRemoteResetPwd'


    Remote Cmd record params: 
          'dt_expire' => '2012-04-02 23:31:32',
          'dt_mod' => '2012-03-30 23:31:32',
          'crypto_command' => '0000000200000047reqRemoteResetPwd',
          'id_user' => '0',
          'email' => 'enzo.arlati@libero.it',
          'numrows' => 1,
          'idremote_cmd' => '2',
          'errordata' => '',
          'error' => 0,
          'command' => 'reqRemoteResetPwd'

=cut
# ===================================
sub PerformExecRemoteCmd
{
	my ($self ) = @_;
	my ( $data, $paramsInp, $rsltRec, $objStore );
    my ( $homePage ) = $self->GetHomePage();
    # $homePage = 'http://enzo6/SwimmingPool/index.html';

    $objStore = new Swim::DBUser(); 

    $paramsInp = $self->{params};
	$self->Log( sprintf( "Inp params: %s ", Dumper( $paramsInp )));
    
    $rsltRec = $objStore->GetRemoteCmdRecord( $paramsInp->{cmd} );
	# $self->Log( sprintf( "Remote Cmd record params: %s ", Dumper( $rsltRec )));
    
    if( $rsltRec->{error} == 0 )
    {
		if ( $rsltRec->{command} eq 'reqRemoteResetPwd' )
		{
			$objStore->ResetPassword( $rsltRec );
		}
		
		$data = $self->RedirectHomePage( $homePage );
        $data  = "Content-type: text/html\n\n <html>  <head> ";
        $data .= '<meta HTTP-EQUIV="REFRESH" content="1; url=' . $homePage .'">';
        $data .= "</head>   <body> redirecting ... </body>  </html>";
    }
    else
    {
        $data  = "Content-type: text/plain\n\n";
		$data .= sprintf "ERRORE [%d] %s \n", $rsltRec->{error}, $rsltRec->{errordata};
	}

    # warn "[PerformExecRemoteCmd] DATA: $data";
    return $data;
	
}  ## _________ sub PerformExecRemoteCmd


     


1;

