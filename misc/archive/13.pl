# TODO: Fix the other data/.pl files so that they add results to the hash properly.

#/usr/bin/perl
use strict;
use warnings;
use v5.20.1;
use Perl::Critic;
use File::stat;
use BSD::Resource;
use Switch;

# use Number::Fraction;
use utf8;
use XML::LibXML;
use Term::ANSIColor qw(:constants);
use Data::Printer;
require 'data13/advanced.pl';
require 'data13/simple.pl';
require 'data13/length.pl';
require 'data13/untrans.pl';
require 'data13/comma_imp.pl';

# Benchmark output
use Benchmark qw(:hireswallclock);
my ( $starttime, $finishtime, $timespent );

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
my $file = "combined.xlf";
if ( !defined $ARGV[0] ) {
    $doc = $parser->parse_file("$file");
    say "Argument missing, defaulting to combined .xlf:\n";
}
else {
    $doc  = $parser->parse_file( $ARGV[0] );
    $file = $ARGV[0];
}

# Change RLIMIT_STACK (ulimit -s) according to input file size, to hopefully avoid segmentation faults.
my $filesize    = stat("$file")->size;
my $ulimit_size = $filesize * 3;
setrlimit( RLIMIT_STACK, $ulimit_size, $ulimit_size );

# load regexes from data files
open( UNTRANS, "<:encoding(UTF-8)", "tests/untranslatables.txt" )
  or die("Can't open untranslatables.txt:!\n");
open( SIMPLE, "<:encoding( UTF- 8 )", "tests/simple.txt" )
  or die("Can't open simple.txt:!\n");
my @untransLines = <UNTRANS>;
my @simpleLines  = <SIMPLE>;
close UNTRANS;
close SIMPLE;

my %results = ();
$starttime = Benchmark->new;

select STDOUT;

# Apply operations to one <trans-unit> at a time.

# $starttime2 = Benchmark->new;

my ( $number, $source, $target );
my ( @number, @source, @target );

# Feed into arrays:
foreach my $TU ( $doc->findnodes('xliff/file/body/trans-unit') ) {

    # @translate = $TU->findvalue('./@translate');
    $number = $TU->findvalue('./@id');
    $source = $TU->findvalue('./source');
    $target = $TU->findvalue('./target');

    push( @number, $number );
    push( @source, $source );
    push( @target, $target );
}

#TODO if @number is not a perfect sequence,
#	warn user.

my ( $start1, $finish1, $spent1 );
if ( !defined $ARGV[1] || $ARGV[1] =~ /1/ ) {
    $start1 = Benchmark->new;
    for ( my $i = 0 ; $i < scalar @number ; $i++ ) {
        run_simple_tests( \@simpleLines, $target[$i], \%results, $number[$i] );
    }
    $finish1 = Benchmark->new;
    $spent1 = timestr( timediff( $finish1, $start1 ) );
}
my $simple_spent = "run_simple_tests took $spent1 seconds";

my ( $start2, $finish2, $spent2 );
if ( !defined $ARGV[1] || $ARGV[1] =~ /2/ ) {
    $start2 = Benchmark->new;
    for ( my $i = 0 ; $i < scalar @number ; $i++ ) {

        check_string_length( $source[$i], $target[$i], \%results, $number[$i] );
    }
    $finish2 = Benchmark->new;
    $spent2 = timestr( timediff( $finish2, $start2 ) );
}
my $string_spent = "check_string_length took $spent2 seconds";

my ( $start3, $finish3, $spent3 );
if ( !defined $ARGV[1] || $ARGV[1] =~ /3/ ) {
    $start3 = Benchmark->new;
    for ( my $i = 0 ; $i < scalar @number ; $i++ ) {

        run_advanced_tests( $source[$i], $target[$i], \%results, $number[$i] );
    }
    $finish3 = Benchmark->new;
    $spent3 = timestr( timediff( $finish3, $start3 ) );
}
my $advanced_spent = "run_advanced_tests took $spent3 seconds";

my ( $start4, $finish4, $spent4 );
if ( !defined $ARGV[1] || $ARGV[1] =~ /4/ ) {

    $start4 = Benchmark->new;
    for ( my $i = 0 ; $i < scalar @number ; $i++ ) {

        comma_imp( $target[$i], \%results, $number[$i] );
    }
    $finish4 = Benchmark->new;
    $spent4 = timestr( timediff( $finish4, $start4 ) );
}
my $comma_imp_spent = "comma_imp_spent took $spent4 seconds";

my ( $start5, $finish5, $spent5 );
if ( !defined $ARGV[1] || $ARGV[1] =~ /5/ ) {

    $start5 = Benchmark->new;
    for ( my $i = 0 ; $i < scalar @number ; $i++ ) {

        find_missing_untranslatables( \@untransLines, $source[$i], $target[$i],
            \%results, $number );
    }
    $finish5 = Benchmark->new;
    $spent5 = timestr( timediff( $finish5, $start5 ) );
}
my $find_missing_untranslatables_spent =
  "find_missing_untranslatables took $spent5 seconds";

# using Data::Printer
# select STDERR;
p %results;
say "\n";
say "1: ", $simple_spent,    "\n";
say "2: ", $string_spent,    "\n";
say "3: ", $advanced_spent,  "\n";
say "4: ", $comma_imp_spent, "\n";
say "5: ", $find_missing_untranslatables_spent;

$finishtime = Benchmark->new;
$timespent = timediff( $finishtime, $starttime );
print "\n\nDone!\nSpent " . timestr($timespent);
print "\n\n";
p @ARGV;
