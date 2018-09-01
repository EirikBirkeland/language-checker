#/usr/bin/perl
#use strict;
#use warnings;
use utf8;
use XML::LibXML;
use Term::ANSIColor qw(:constants);

# Various dumper modules
use Data::Dumper;
use YAML;
use Data::Printer;

# Color aliases
my $normal = "\e[0m";
my $red    = "\e[1;31m";
my $green  = "\e[1;32m";
my $yellow = "\e[1;33m";
my $blue   = "\e[1;34m";

# Set output to utf8 for text files (globally?)
binmode( STDOUT, ":encoding(UTF-8)" );

# Open and parse XML
my $parser = XML::LibXML->new();
my $doc    = $parser->parse_file( $ARGV[0] );

# Load regexes from data files
open( UNTRANS, "<:encoding(UTF-8)", "tests/untranslatables.txt" )
  or die("Can't open untranslatables.txt:!\n");
open( DATA, "<:encoding(UTF-8)", "tests/advanced.txt" )
  or die("Can't open data.txt:!\n");
open( SIMPLE, "<:encoding(UTF-8)", "tests/simple.txt" )
  or die("Can't open simple.txt:!\n");
my @untransLines = <UNTRANS>;
my @dataLines    = <DATA>;
my @simpleLines  = <SIMPLE>;
close UNTRANS;
close DATA;
close SIMPLE;

%results = ();

# Apply operations to one <trans-unit> at a time.
foreach my $TU ($doc->findnodes ('xliff/file/body/trans-unit')) {

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

# First line for segment
# #print"This is segment $green$number$normal\n";
# Perhaps I can prepare a global has for unit numbers, and collect different segment data there (e.g. i can add up a 'score' for segments that had more than 1 error.)

    check_string_length( $source, $target );

    run_advanced_tests( \@dataLines, $target );

    run_simple_tests( \@simpleLines, $target );

    find_missing_untranslatables( \@untransLines, $source, $target );

    sub check_string_length {

# Compare string lengths.
# Add comparison of number of periods and commas. Suggest to user that target is missing or contains extra sentences! Also, count number of total words and compare.
        my ( $source, $target ) = ( $_[0], $_[1] );
        my $sourceLength = length($source);
        my $targetLength = length($target);
        my $percentShorter =
        sprintf( "%.f", $targetLength / $sourceLength * 100 );
        if ( $sourceLength > 50
## Please see file perltidy.ERR
            && ( $percentShorter < 60 || $percentShorter > 150 ) ) {
             print"$source\n\n$target\n\n";
               print"Translation is $percentShorter% of source\n";
                push @{ $results{$number} }, "length";

# Register a positive for this test in some kind of hash containing the ID= identifier as key, for final consolidated test results output.
        };
    }

    sub run_advanced_tests {
          my @dataLines = @{ $_[0] };
          my $target    = $_[1];
          $i = 0;
          foreach (@dataLines) {
              my @field = split /\t/, $dataLines[$i];
              chomp $field[0];
              if ( $target =~ /$field[0]/ ) {
                 print"$field[0] -- :\n\n$target\n\n";
                  push @{ $results{$number} }, "advanced";
              }
              $i += 1;
          }
    }

    sub run_simple_tests {
          my @simpleLines = @{ $_[0] };
          my $target      = $_[1];
          $i = 0;
          foreach (@simpleLines) {
              my @field = split /\t/, $simpleLines[$i];
              chomp $field[0];

#  chomp $field[1]; #this line is prolly needed, but var is sometimes empty, leading to uninitialized value error....try it again later to see.
              if ( $target =~ s/\b($field[0])\b/$red$1$normal/ ) {
print
"$field[0] -- $field[1]:\n\n$target\n$red$field[0]$normal$yellow--->$blue$field[1]$normal\n\n";
                  push @{ $results{$number} }, "simple";
              }
              $i += 1;
          }
    }

    sub find_missing_untranslatables {
          my @untrans = @{ $_[0] };
          my $s       = $_[1];
          my $t       = $_[2];
          $i = 0;
          foreach (@untrans) {
              chomp $untrans[$i];
              if ( $s =~ s/($untrans[$i])/$red$1$normal/g ) {
                  my $c_s = () = $s =~ /$untrans[$i]/g;
                  my $c_t = () = $t =~ /$untrans[$i]/g;
                  if ( $c_t != $c_s ) {
                      $t =~ s/($untrans[$i])/$red$1$normal/g;
                      my $c_miss = $c_s - $c_t;
print
"UNTRANSLATABLE: $c_miss instances of $untrans[$i] missing in Target: $t\n($s)\n\n";
                      push @{ $results{$number} }, "untranslatable";
                  }
              }
              $i += 1;
          }
    }
}
##printDumper( \%results );

# using YAM# using YAM
##print"# %results\n", Dump \%results;

# using Data::Printer
#p %results;
##print"\n";
