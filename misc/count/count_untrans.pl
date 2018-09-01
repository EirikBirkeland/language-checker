#!/usr/bin/env perl 
#use strict;
#use warnings;
use utf8;
use v5.18.1;
open( XLF, "<:encoding(UTF-8)", "$ARGV[0]" )
  or die("Can't open :!\nDid you supply an argument?");
open( UNTRANS, "<:encoding(UTF-8)", "tests/untranslatables.txt" )
  or die("Can't open :!\nDid you supply an argument?");
my @xlf     = <XLF>;
my @untrans = <UNTRANS>;
close XLF;
close UNTRANS;

binmode( STDOUT, ":encoding(UTF-8)" );
my %count;
my $str;
my @found;

# print @xlf;die;
foreach my $test_item (@untrans) {
    $count{$str} = 0;
    chomp $test_item;
    foreach my $line (@xlf) {
        foreach my $str ( $line =~ /$test_item/g ) {
            $count{$str}++;
        }
    }
    if ( 0 == $count{$str} % 2 ) {
		say "$test_item has an even number:\n$count{$str}";
    }
    else {
        push @found, $test_item;
        say "$test_item has an uneven number:\n$count{$str}";
    }
## Please see file perltidy.ERR
}
say join( ', ', @found );
say "had an uneven number of occurrences.";
