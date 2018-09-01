#!/bin/perl -w
use strict;
use XML::LibXML;
use Term::ANSIColor qw(:constants); 

# Set output to utf8 for text files (globally?)
binmode(STDOUT, ":utf8");

# Open and parse XML
my $parser = XML::LibXML->new();
my $doc    = $parser->parse_file("combined.xlf");

# Load regexes from data.txt
open(UNTRANS, "<:encoding(UTF-8)", "tests/untranslatables.txt") or die("Can't open untranslatables.txt:!\n");
open(DATA, "<:encoding(UTF-8)", "tests/data.txt") or die("Can't open data.txt:!\n");
open(SIMPLE, "<:encoding(UTF-8)", "tests/simple.txt") or die("Can't open simple.txt:!\n");
my @untransLines = <UNTRANS>;
my @dataLines = <DATA>;
my @simpleLines = <SIMPLE>;


# Apply operations to one <trans-unit> at a time.
foreach my $TU ($doc->findnodes('xliff/file/body/trans-unit')) {

# Put XML data into variables.
  my($translate_ori) = $TU->findnodes('./@translate');
  my($number_ori) = $TU->findnodes('./@id');
  my($source_ori) = $TU->findnodes('./source');
  my($target_ori) = $TU->findnodes('./target');

# Strip XML tags, and reassign to variables.
  my($translate) = $translate_ori->to_literal;
  my($number) = $number_ori->to_literal;
  my($source) = $source_ori->to_literal; 
  my($target) = $target_ori->to_literal;

# Iterate through untranslatables.txt lines.
  my $i = 0;
#  foreach (@untransLines) {
#     my @field = split /\t/, $untransLines[$i];
#     if ($source =~ m/$field[0]/) {
#        unless ($target =~ m/$field[0]/) {
#           print "Shit's missing, man...\n";
#           print "While $field[0] is in: \n\n$source,\n but it is not in: \n\n$target\n"; 
#        }
#     }
#  $i += 1
#  }

# Iterate through data.txt lines, using regexes.
  $i = 0;
  foreach (@dataLines) {
     my @field = split /\t/, $dataLines[$i];
     chomp $field[0];     
     if ($target =~ /$field[0]/) {
         print "$field[0] -- $field[1]:\n\n$target\n\n";
     }
  $i += 1
  }
# Iterate through simple.txt lines.
  $i = 0;
  foreach (@simpleLines) {
     my @field = split /\t/, $simpleLines[$i];
     chomp $field[0];     
     if ($target =~ /\b$field[0]\b/) {
         print "$field[0] -- $field[1]:\n\n$target\n\n";
     }
  $i += 1
  }
}

# initiate untranslatable tests.
#  if ($source =~ m/Google/) {
#      $source =~ s/Google/", RED "Google", RESET, "/;
#      unless($target =~ m/Google/) {
#          print "Segment ";
#          print CYAN, "$number ", RESET, GREEN "does not contain Google from source. As you can see:\n", RESET, "$source\n$target\n\n";
#      }
#  } 

# initiate tripple letters tests
#  if ($target =~ m/ttt|lll|fff/) {
#      print "Segment ";
#      print CYAN, "$number ", RESET, GREEN "These segments contain trippled letters, omg:\n", RESET, "$target\n\n";
#  }

# get tests from data.txt .. this file could contain RegEx tests that apply to <target> only.

#  while (<DATA>) {
#      chomp $_;
#      my ($test_desc,$test_regex) = split("\t", $_);
#      print "$source\n";
#      print "$target\n";
#      if ($target =~ m/$test_regex/) {
#          print "Segment ";
#          print CYAN, "$number ", RESET, GREEN "$test_desc:\n", RESET, "$target\n\n";
#      }
#  }

