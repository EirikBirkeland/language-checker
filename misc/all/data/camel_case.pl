#!/usr/bin/env perl 
use strict;
use warnings;
use utf8;

my $source = "YouTube";
my $target = "Youtube";

my ($test) = $source =~ /([a-zA-Z]{5,})/;
if ( $target =~ /$test/i ) {
    if ( $target !~ /$test/ ) {
        print
"Likely untranslatable $test was found in target, but the capitalization is incorrect.";
    }
}
