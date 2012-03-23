#!/usr/bin/perl

use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;
use Template;
use File::Basename;

use lib './lib';
use lib '../lib';
use Swim::DBUser;

=head1  file UserList.tt 

<p>  User list </p>

<ul>
[% FOREACH user IN stash.data.users %]
     <li>User => [% user.name %]  id => [% user.id %]
[% END %]
</ul>

=cut

eval {
	my ( $obj1, $s1, $lstusr );
    my ( $fileTT ) = '../tt/UserList.tt';

    $s1 = dirname $0;
    $fileTT  = "${s1}/${fileTT}";
   #print "file $fileTT \n"; 
   
	$obj1   = new Swim::DBUser();
        $s1     = $obj1->GetUserList();
        $lstusr = $s1->{users};
        # printf "User hash: %s \n", Dumper( $lstusr ); 

        $s1 = ProcessTemplate( $fileTT, $lstusr );

    # print "Content-type: text/plain\n\n";
	print "$s1 \n";
};

if ($@) {
	print "Content-type: text/plain\n\n";

	print " Error: \n";
	print " $@ \n";
	print "INC:  @INC  \n";
}

# ===================================
sub ProcessTemplate {
	my ( $ttFile, $hash ) = @_;
	my ( $ttFullName, $sts, $stash, $templateObj, $relPath );
	my ($sres) = "";

	$stash->{title} = "User list";
	$stash->{dt_update} = localtime;
	$stash->{users} = $hash;

    $relPath = dirname $0;
    
	$templateObj = new Template(
		{
			ABSOLUTE     => 'true',
			RELATIVE     => 'true',
			# VARIABLES    => $vars,
			PRE_PROCESS  => "${relPath}/../tt/header.tt",
			POST_PROCESS => "${relPath}/../tt/footer.tt"
		}
	);

	$templateObj->process( $ttFile, { stash => $stash }, \$sres )
		  or die "[ProcessTemplate] Template ERROR: " . $templateObj->error();

	return $sres;

}    ## __________ sub GetUserList
