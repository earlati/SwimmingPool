#!/usr/bin/perl
# ----------------------------------------------------------
# FILE : BaseCgi.pm
# ----------------------------------------------------------
# perltidy -l=120 -gnu -b program.pl
# ----------------------------------------------------------
#  { }  []  `` ~
# ----------------------------------------------------------

package Swim::BaseCgi;

use strict;
use warnings;

use Data::Dumper;
use CGI;

require Exporter;
our @ISA = qw( Exporter );

Run() unless caller();

# ========================================
sub Run
{
	eval {
		my ( $obj1, $s1, $params );

		# $params = 'p1=aaaaa&p2=bbbbb';
		$obj1 = new Swim::BaseCgi( 'register', $params );
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
	warn "[BaseCgi.NEW] params: $params \n";
	$self->InitObject($params);

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
sub Command
{
	my ( $self, $cmd ) = @_;
	$self->{cmd} = $cmd if defined $cmd;
	return $self->{cmd};

}    ## _______  sub Command

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
				-src      => '/SwimmingPool/js/swimUtility.js',
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
sub GetContentJson
{
	my ($self)    = @_;
	my ($ctxType) = "Content-type: application/json\n\n";
	return $ctxType;
}

# ===================================
sub GetLoadingDiv
{
	my ($self) = @_;
	my ($html) = '<div class="Loading" > <img src="/images/loading2.gif" /> </div>';
	return $html;
}

# ===================================
sub BuildHtmlBtnOk
{
	my ($self) = @_;
	my ($sres);
	$sres = $self->{cgiObj}->button(
		-name  => 'buttonOk',
		-id    => 'buttonOk',
		-value => 'Ok'
	);
	return $sres;

}    ## ________ sub BuildHtmlBtnOk

# ===================================
sub BuildHtmlBtnCancel
{
	my ($self) = @_;
	my ($sres);
	$sres = $self->{cgiObj}->button(
		-name  => 'buttonCancel',
		-id    => 'buttonCancel',
		-value => 'Cancel'
	);
	return $sres;

}    ## ________ sub BuildHtmlBtnCancel

# ===================================
sub GetReadonlyDescr
{
	my ( $self, $readonly ) = @_;
	my ($sres) = '';

	if ( $readonly == "1" ) { $sres = "readonly"; }
	return $sres;

}    ## _______ sub GetReadonlyDescr


# ===================================
sub BuildHtmlEdit
{
	my ( $self, $name, $label, $currEmail, $size, $maxlen, $readonly ) = @_;
	my ( $sres, $params );

	$params = {
		-name      => "$name",
		-value     => "$currEmail",
		-size      =>  $size,
		-maxlength =>  $maxlen
	};
	$params->{-readonly} = 'readonly' if "$readonly" eq "1";
	$sres = $self->{cgiObj}->textfield($params);
	$sres = $self->BuildHtmlWrapLabel( $name, $label, $sres );
	return $sres;

}    ## ________ sub BuildHtmlEdit


# ===================================
sub BuildHtmlWrapLabel
{
	my ( $self, $name, $label, $data ) = @_;
	my ( $sres ) = "";
	
	#  <label for="user_name">Utente</label>

	$sres = sprintf "<label for=\"%s\"> %s </label> %s", $name, $label, $data;
	return $sres;
	
}  ## ______ sub BuildHtmlWrapLabel



1;

