#!/usr/bin/env perl 
use strict;
use warnings;
use utf8;
use 5.18.1;
use Data::Printer;
if ( ! defined $ARGV[0] ) {
    open( CORPUS, '<', 'test1.xlf' );
    say "Argument missing, defaulting to test1.xlf:";
}
else {
    open( CORPUS, '<', $ARGV[0] ) || open( CORPUS, '<', 'test1.xlf' );
}

open( UNTRANS, '<', 'tests/untrans.txt' );

my @corpus  = <CORPUS>;
my @untrans = <UNTRANS>;
chomp @untrans;

close CORPUS;
close UNTRANS;

my %count;

foreach my $item (@untrans) {
    foreach my $line (@corpus) {
        if ( $line =~ /$item/ ) {
            $count{$item}++;
        }
    }
}
p %count;
