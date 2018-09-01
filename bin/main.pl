#!/usr/bin/env perl

use HTML::Entities;
use utf8;
use 5.20.1;
use strict;
use warnings;
use Data::Printer;
use File::stat;
use BSD::Resource;
use XML::Bare;

# TODO: The xml parser doesn't currently handle inline xml like "</ph><xid="2" />" ... best way to handle?
die "Dude, your OS is wrong" if $^O !~ /linux/;

#if (!ARGV[0]) {
 # check last updated xlf og mqxliff in folder
#}

my $file = $ARGV[0];
die "No filename!" if !$file;

#use Readonly;
our $HTML   = "true";
our $TIMERS = "true";

# Define HTML wrappers
my @span_tags =
  qw(instruction error adv_source adv_target source target wrong suggest type desc);

for my $tag (@span_tags) {
    no strict 'refs';
    *$tag = sub {
        "<span class='$tag'>@_</span>";
    };
}

# To ensure all files opened use a particular set of I/O layers:
use open IO => ":utf8";

# use advanced';
use lib $ENV{"HOME"} . '/projects/xml_parser/';
use My::Advanced;
use My::Simple;
use My::Length;
use My::Untrans;
use My::Comma_imp;
use My::Equal;
use My::Missing_brackets;
use My::Term_incon;
use My::Camelcase;
use My::Verify_number_array;

#use My::Consistency;
use My::Color_freq;
use My::Stats;
use My::Color_def;
use My::Detect_untrans;

# Benchmark output
use Benchmark qw(:hireswallclock);
my ( $starttime, $finishtime, $timespent );

# Set output to utf8 for text files (globally?)
binmode( STDOUT, ":encoding(UTF-8)" );
binmode( STDERR, ":encoding(UTF-8)" );

# Open and parse XML
my $parser = XML::LibXML->new();
my $doc;

# Change RLIMIT_STACK (ulimit -s) according to input file size, to hopefully avoid segmentation faults when scanning huge .xlfs
my $filesize    = stat($file)->size;
my $ulimit_size = $filesize * 3;
setrlimit( RLIMIT_STACK, $ulimit_size, $ulimit_size );

our $DATA = "$ENV{HOME}/projects/xml_parser/data/";

# Load regexes from data files
open( UNTRANS, "<:encoding(UTF-8)", "$DATA/untranslatables.txt" )
  or die("Can't open untranslatables.txt:!\n");
open( SIMPLE, "<:encoding( UTF- 8 )", "$DATA/simple.txt" )
  or die("Can't open simple.txt:!\n");
my @untransLines = <UNTRANS>;
my @simpleLines  = <SIMPLE>;
close UNTRANS;
close SIMPLE;

open( UPPER, "<:encoding(UTF-8)",
    "$ENV{HOME}/projects/xml_parser/html_template/upper.html" );
undef $/;
my $upper_html = <UPPER>;
close UPPER;
$/ = "\n";

# Print HTML header
say $upper_html;

my %results = ();
$starttime = Benchmark->new;

my ( $number, $source, $target );
my ( @number, @source, @target );

foreach $_ ( $file ) {

    my $object = new XML::Bare( file => "$_" );
    my $tree = $object->parse;

    my $size = scalar @{ $tree->{xliff}->{file}->{body}->{"trans-unit"} };

    foreach my $entry ( 0 .. $size - 1 ) {
        $number =
          $tree->{xliff}->{file}->{body}->{"trans-unit"}[$entry]->{id}->{value};
        $source =
          $tree->{xliff}->{file}->{body}->{"trans-unit"}[$entry]->{source}
          ->{value};
        $target =
          $tree->{xliff}->{file}->{body}->{"trans-unit"}[$entry]->{target}
          ->{value};
        push( @number, $number );
        push( @source, $source );
        push( @target, $target );
    }
    my @sourceLength = map( length, @source );
    my @targetLength = map( length, @target );

    &flash_warn if $target[0] =~ /^This page.*Opening and ending tag mismatch/;

    sub flash_warn {
        while (42) {
            say GREEN ON_BLUE "WARNING!!! " x 49, "\n";
        }
    }

    warn "Running Simple tests...";
    say "<h3>Simple</h3>\n<div>";
    run_simple_tests( \@simpleLines, \@target, \%results, \@number );
    say "</div>";

    warn "Running String Length...";
    say "<h3>String Length</h3>\n<div>";
    check_string_length( \@source, \@target, \%results, \@number );
    say "</div>";

    warn "Running Advanced tests...";
    say "<h3>Advanced</h3>\n<div>";
    run_advanced_tests( \@source, \@target, \%results, \@number );
      say "</div>";

    warn "Running Comma After Imperatives test...";
    say "<h3>Comma After Imperatives</h3>\n<div>";
    comma_imp( \@target, \%results, \@number );
    say "</div>";

    say "<h3>Missing Untranslatables</h3>\n<div>";
    find_missing_untranslatables( \@untransLines, \@source, \@target,
        \%results, \@number );
    say "</div>";

    say "<h3>Equal Segments</h3>\n<div>";
    equal_seg( \@source, \@target, \%results, \@number );
    say "</div>";

    say "<h3>Missing Parentheses</h3>\n<div>";
    missing_paren( \@source, \@target, \%results, \@number );
    say "</div>";

    say "<h3>Terminological Inconsistency</h3>\n<div>";
    term_incon( \@source, \@target, \%results, \@number );
    say "</div>";

    say "<h3>CamelCase</h3>\n<div>";
    camelcase( \@source, \@target, \%results, \@number );
    say "</div>";

    say "<h3>Verify Number Array</h3>\n<div>";
    verify_number_array( \@number );
    say "</div>";

    #    say "<h3>Segment-level Consistency</h3>\n<div>";
    #    consistency( \@source, \@target, \%results, \@number );
    #    say "</div>";

    #    color_text( \@source, \@target, \%results, \@number );

    say "<h3>Statistics</h3>\n<div>";
    stats( \@source, \@target, \%results, \@number, \@sourceLength,
        \@targetLength );
    say "</div>";

    say "<h3>Detect Untranslatables</h3>\n<div>";
    detect_untrans( \@source, \@target, \%results );
    say "</div";
}

open( LOWER, "<:encoding(UTF-8)",
    "$ENV{HOME}/projects/xml_parser/html_template/lower.html" );
undef $/;
my $lower_html = <LOWER>;
close LOWER;
$/ = "\n";
say $lower_html;

use HTML::FromANSI;
use Data::Printer;
my $html_output = ansi2html(p(%results, colored => 1) );
$html_output =~ s/background: black/background: white/g;
$html_output =~ s/color: white/color: black/g;
$html_output =~ s/color: darkmagenta/color: orange/g;
say $html_output;

$finishtime = Benchmark->new;
$timespent = timediff( $finishtime, $starttime );
say "\nDone!\nSpent " . timestr($timespent) . "\n";
1;
