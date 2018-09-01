#!/bin/perl -w
use strict;
use Data::Dumper qw(Dumper);

open(FH, "data.txt") or die "Can't open data.txt for read: $!";
my @dataLines = <FH>;
print Dumper \@dataLines;

for (my $i=0; $i <= 1; $i++) {
my @field = split /\t/, $dataLines[$i];
print "The problem is that $field[0] is gogogo $field[1]";
}
