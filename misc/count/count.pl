#!/usr/bin/env perl 
use strict;
use warnings;
use utf8;
use Data::Dumper;
use 5.18.1;

my @corpus = (
    'Chrome is made out of brome.',
    'Chrome er laget ut av Chrome',
    'Apple is a fine company, whilst BlackBerry is not even a company.',
    'BlackBerry er en cat. En setning mangler.'
);
my @untrans = ( 'Chrome', 'Apple', 'BlackBerry' );
say Dumper (@untrans);
say Dumper (@corpus);
say "^ These are some fine arrays.\n";
my %count;

foreach my $item (@untrans) {
    foreach my $line (@corpus) {
        if ( $line =~ /$item/ ) {
            $count{$item}++;
            say $item;
        }
    }
}
say "\n", Dumper (%count);
