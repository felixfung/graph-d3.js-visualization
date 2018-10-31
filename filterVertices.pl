#!/usr/bin/perl

###############################################################################
# given a Json graph, filter out vertices with size less than threshold
# associated edges are filtered out as well
###############################################################################

$input = $ARGV[0];
open( $hinput, $input ) or die "Can't open $input $!";

$output = $ARGV[1];
open( $houtput, ">", $output ) or die "Can't open $output $!";

$threshold = $ARGV[2];

my %vertex;
my $comma = "false";

while(<$hinput>) {
    if( /(.*?\"id\": \")(\d+)(.*?\"size\": \")([\d\.]+)(\",.*?}),?/ ) {
        if( $4 >= $threshold ) {
            print $houtput ",\n" if( $comma eq "true" );
            print $houtput "$1$2$3$4$5";
            $vertex{$2} = "true";
            $comma = "true";
        }
    }
    elsif( /(.*?\"source\": \")(\d+)(.*?\"target\": \")(\d+)(\",.*?}),?/ ) {
        if( $vertex{$2} eq "true" && $vertex{$4} eq "true" ) {
            print $houtput ",\n" if( $comma eq "true" );
            print $houtput "$1$2$3$4$5";
            $comma = "true";
        }
    }
    elsif( /(.*].*)/ ) {
        print $houtput "\n$1";
        $comma = "false";
    }
    else {
        print $houtput "$_";
        $comma = "false";
    }
}
