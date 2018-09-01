#!/bin/perl -w
use strict;
use Tie::File;

my @array;
tie @array, 'Tie::File', "data.txt" or die $!;
print $array[2];
