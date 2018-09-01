#!/bin/perl
use XML::Simple;
use Data::Dumper;

$xml = new XML::Simple;

$data = $xml->XMLin("data.xml");

print Dumper($data);
