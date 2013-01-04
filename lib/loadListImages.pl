#!/usr/bin/perl
# ----------------------------------------------------------
# FILE : loadListImages.pl
# ----------------------------------------------------------
# perltidy -l=120 -gnu -b program.pl
# ----------------------------------------------------------
#  { }  []  `` ~
# ----------------------------------------------------------

use strict;
use warnings;
use LWP::Simple;
use Data::Dumper;
use File::Basename;
use Time::Local;

use lib '.';
use lib './lib';

=head1   FILE: loadListImages.pl


=cut

&main();

# ================================
# ================================
sub main()
{
    my ($filename, $sts, $afiles, $s1, $sicon, $lastMonth, $dd, $mm, $yy, $dt, $dtnow, $dtdiff);
    my ($sres)    = '';
    my ($serr)    = '';
    my ($datasts) = '';
    my ($dirname) = '../VolantiniCorse/images';
    my ($dirweb ) = '/SwimmingPool/VolantiniCorse/images';
    


    eval {

        $dtnow = getDateNowValue();

        $sres = "Content-type: text/html\n\n";

        $sts = opendir(DIR, $dirname);
        if (!defined $sts)
        {
            $serr = "Error in opening dir $dirname [$@]";
            print $serr;
        }
        else
        {
            while (($filename = readdir(DIR)))
            {
                if ($filename =~ /.jpg$/)
                {
                    push(@$afiles, $filename);
                }
            }
            closedir(DIR);
        }

        $lastMonth = '';
        foreach $filename (sort @$afiles)
        {
            $s1 = substr($filename, 0, 7);
            if ("$lastMonth" ne "$s1")
            {
                $lastMonth = $s1;                
                $sres .= sprintf "<div class=\"volantino_month blu\">  mese:   %s </div>", $lastMonth;
            }

            $yy = substr($filename, 0, 4);
            $mm = substr($filename, 5, 2);
            $dd = substr($filename, 8, 2);
            $dt = getDateValue($dd, $mm - 1, $yy);

            $sicon = '';
            $dtdiff = (( $dt - $dtnow ) / 86400 ) + 1;
            if ($dtdiff < 1 )
            {
                $datasts = 'old_data ryellow';
            }
            elsif ($dtdiff > 7 )
            {
                $datasts = 'future_data rgreen';
            }
            else
            {
                $datasts = 'current_data rorange';
                # $sicon = sprintf "  <img class=\"curr_img\" src=\"%s/%s\" width=\"40\"  height=\"50\" /> ", $dirweb, $filename;
            }

            ( $s1 = $filename ) =~ s/\.jpg$//;
            $s1 =~ s/\./ /g;
            $s1 =~ s/\-/ Localita: /;
            $sres .= sprintf "<div class=\"volantino %s \" > %s %s ", $datasts, $sicon, $s1;
            $sres .= sprintf "<a href=\"%s/%s\"/>",                $dirweb, $filename;
            $sres .= '</div>';
            
        }
    };

    if ($@)
    {
        $sres = "Content-type: text/html\n\n";
        $sres .= '<pre>';
        $sres .= " ERRORE : \n";
        $sres .= " $@  $serr";
        $sres .= '</pre>';
        warn "TEST: $sres ";
    }
    # if (length $serr > 0) { $sres .= $serr; }
    print "$sres \n";

}

# ================================
# ================================
sub getDateValue( )
{
    my ($dd, $mm, $yy) = @_;
    my ($dt);
    $dd = $dd;
    # print " DD $dd MM $mm YY $yy \n";
    if( $yy > 2030 ) { $yy = 2030; }
    $dt = timelocal(0, 0, 0, $dd, $mm, $yy);
    return $dt;
}

# ================================
# ================================
sub getDateNowValue( )
{
    my ($dt);
    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
    $dt = timelocal(0, 0, 0, $mday, $mon, $year);
    return $dt;
}
