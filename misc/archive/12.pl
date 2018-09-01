#/usr/bin/perl
#use strict;
#use warnings;
#use v5.20.1;
use feature 'say';

# use Number::Fraction;
use utf8;
use XML::LibXML;
use Term::ANSIColor qw(:constants);
use Data::Printer;
require 'data/advanced.pl';
require 'data/simple.pl';
require 'data/length.pl';
require 'data/untrans.pl';
require 'data/comma_imp.pl';

# Benchmark output
use Benchmark qw(:hireswallclock);
my $starttime;
my $finishtime;
my $timespent;

# Color aliases
my $normal    = "\e[0m";
my $red       = "\e[4;31m";
my $red_bg    = "\e[7;31m";
my $red_under = "\e[4;41";
my $green     = "\e[1;32m";
my $yellow    = "\e[1;33m";
my $blue      = "\e[1;34m";

# Set output to utf8 for text files (globally?)
binmode( STDOUT, ":encoding(UTF-8)" );

# Open and parse XML
my $parser = XML::LibXML->new();
my $doc;

if ( !defined $ARGV[0] ) {
    $doc = $parser->parse_file('combined.xlf');
    print "Argument missing, defaulting to combined .xlf:\n";
}
else {
    $doc = $parser->parse_file( $ARGV[0] );
}

# load regexes from data files
open( UNTRANS, "<:encoding(UTF-8)", "tests/untranslatables.txt" )
  or die("Can't open untranslatables.txt:!\n");
open( SIMPLE, "<:encoding( UTF- 8 )", "tests/simple.txt" )
  or die("Can'topensimple.txt:!\n");
my @untransLines = <UNTRANS>;
my @simpleLines  = <SIMPLE>;
close UNTRANS;
close SIMPLE;

%results = ();

$starttime = Benchmark->new;

select STDOUT;

# Apply operations to one <trans-unit> at a time.
foreach my $TU ( $doc->findnodes('xliff/file/body/trans-unit') ) {

    # Put XML data into variables.
    my ($translate_ori) = $TU->findnodes('./@translate');
    my ($number_ori)    = $TU->findnodes('./@id');
    my ($source_ori)    = $TU->findnodes('./source');
    my ($target_ori)    = $TU->findnodes('./target');

    # Strip XML tags, and reassign to variables.
    my $translate = $translate_ori->to_literal;
    $number = $number_ori->to_literal;
    my $source = $source_ori->to_literal;
    my $target = $target_ori->to_literal;
    my $i      = 0;

    #        print "This is segment $green$number$normal\n";

    #        check_string_length( $source, $target );

    # run_advanced_tests( $source, $target );

            comma_imp( $target );

    #        run_simple_tests( \@simpleLines, $target );

    #        find_missing_untranslatables( \@untransLines, $source, $target );
}

foreach my $TU ( $doc->findnodes('xliff/file/body/trans-unit') ) {

    # Put XML data into variables.
    my ($translate_ori) = $TU->findnodes('./@translate');
    my ($number_ori)    = $TU->findnodes('./@id');
    my ($source_ori)    = $TU->findnodes('./source');
    my ($target_ori)    = $TU->findnodes('./target');

    # Strip XML tags, and reassign to variables.
    my $translate = $translate_ori->to_literal;
    $number = $number_ori->to_literal;
    my $source = $source_ori->to_literal;
    my $target = $target_ori->to_literal;
    my $i      = 0;

    #        print "This is segment $green$number$normal\n";

    #        check_string_length( $source, $target );

             run_advanced_tests( $source, $target );

    # comma_imp($target);

    #        run_simple_tests( \@simpleLines, $target );

    #        find_missing_untranslatables( \@untransLines, $source, $target );
}

foreach my $TU ( $doc->findnodes('xliff/file/body/trans-unit') ) {

    # Put XML data into variables.
    my ($translate_ori) = $TU->findnodes('./@translate');
    my ($number_ori)    = $TU->findnodes('./@id');
    my ($source_ori)    = $TU->findnodes('./source');
    my ($target_ori)    = $TU->findnodes('./target');

    # Strip XML tags, and reassign to variables.
    my $translate = $translate_ori->to_literal;
    $number = $number_ori->to_literal;
    my $source = $source_ori->to_literal;
    my $target = $target_ori->to_literal;
    my $i      = 0;

    #        print "This is segment $green$number$normal\n";

            check_string_length( $source, $target );

    #        run_advanced_tests( $source, $target );

    #        comma_imp( $target );

    # run_simple_tests( \@simpleLines, $target );

    #        find_missing_untranslatables( \@untransLines, $source, $target );
}

# using Data::Printer
# select STDERR;
p %results;
print "\n";

$finishtime = Benchmark->new;
$timespent = timediff( $finishtime, $starttime );
print "\n\nDone!\nSpent " . timestr($timespent);
print "\n\n";
