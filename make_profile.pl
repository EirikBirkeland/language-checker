#!/usr/bin/env perl
#use strict;
#use warnings;

my $var = $ARGV[0];

if ( $var =~ /\.xlf/ ) {
    $var =~ s/\.xlf//;
    print "\n$var\n";
}
if ( $var =~ /^\s*$/ ) {
    print "\nDude, you forgot the dayumed argument\n";
    exit;
}

## Please see file perltidy.ERR
system("perl -d:NYTProf bin/main.pl xlfs/$var.xlf");
system("nytprofhtml --open");
