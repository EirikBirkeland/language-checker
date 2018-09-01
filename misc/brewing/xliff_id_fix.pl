#!/usr/bin/env perl 
use strict;
use warnings;
use utf8;
#use XML::LibXML;
#use Term::ANSIColor qw(:constants);
use Data::Dumper;
use XML::Simple;
my $xml = new XML::Simple;
my $in = $xml->XMLin('ALL.xlf');
print Dumper($in);


# This script should re-number the units, ID='1', ID='2', etc.

# Open and parse XML
#my $parser = XML::LibXML->new();
#my $doc    = $parser->parse_file("test1.xlf");

# Apply operations to one <trans-unit> at a time.
# foreach my $TU ( $doc->findnodes('xliff/file/body/trans-unit') ) {

