#use strict;
#use warnings;
#use utf8;
use Data::Printer;
use feature 'say';

open( VERB,   "<:encoding(ISO-8859-15)", "verb.txt" );
open( ADVERB, "<:encoding(ISO-8859-15)", "adv.txt" );
open( NOUN,   "<:encoding(ISO-8859-15)", "subst.txt" );
open( ADJ,    "<:encoding(ISO-8859-15)", "adj.txt" );
open( PRON,   "<:encoding(ISO-8859-15)", "pron.txt" );
open( DET,    "<:encoding(ISO-8859-15)", "det.txt" );
open( PREP,   "<:encoding(ISO-8859-15)", "prep.txt" );

my @verbs   = <VERB>;
my @adverbs = <ADVERB>;
my @nouns   = <NOUN>;
my @adj     = <ADJ>;
my @pron    = <PRON>;
my @det     = <DET>;
my @prep    = <PREP>;

close( VERB, ADVERB, NOUN, ADJ, PRON, DET, PREP );
chomp( @verbs, @adverbs, @nouns, @adj, @pron, @det, @prep );

( $verbs, $adverbs, $nouns, $adj, $pron, $det, $prep ) =
  ( @adverbs, @nouns, @adj, @pron, @det, @prep );

$verbs = @verbs;
say "There are $verbs verbs";
$adverbs = @adverbs;
say "There are $adverbs adverbs";
$nouns = @nouns;
say "There are $nouns nouns";
$adj = @adj;
say "There are $adj adjectives";
$pron = @pron;
say "There are $pron pronouns";
$det = @det;
say "There are $det determiners";
$prep = @prep;
say "There are $prep prepositions";

%verbs   = map { $_ => 1 } @verbs;
%nouns   = map { $_ => 1 } @nouns;
%adverbs = map { $_ => 1 } @adverbs;
%adj     = map { $_ => 1 } @adj;
%pron    = map { $_ => 1 } @pron;
%det     = map { $_ => 1 } @det;
%prep    = map { $_ => 1 } @prep;

while (1) {
    say "Please input string: ";
    chomp ($input = <>);
    $input =~ s/^([\w])/\l$1\E/i;
    say $input;
    @input = split (" ", $input);
    %results;
    my $parsed;
    my $i = 0;
    foreach $word (@input) {
        say $word;
        chomp $word;
        if ( exists $det{$word} ) {
            say "'$word' is a determiner.\n";
            $results{$i} = "determiner";
            $parsed .= "determiner ";
        }
        elsif ( exists $adverbs{$word} ) {
            say "'$word' is an adverb.\n";
            $results{$i} = "adverb";
            $parsed .= "adverb ";
        }
        elsif ( exists $adj{$word} ) {
            say "'$word' is an adjective.\n";
            $results{$i} = "adj";
            $parsed .= "adj ";
        }
        elsif ( exists $verbs{$word} ) {
            say "'$word' is a verb.\n";
            $results{$i} = "verb";
            $parsed .= "verb ";
        }
        elsif ( exists $nouns{$word} ) {
            say "'$word' is a noun.\n";
            $results{$i} = "noun";
            $parsed .= "noun ";
        }
        elsif ( exists $pron{$word} ) {
            say "'$word' is a pronoun.\n";
            $results{$i} = "pronoun";
            $parsed .= "pronoun ";
        }
        elsif ( exists $prep{$word} ) {
            say "'$word' is a preposition.\n";
            $results{$i} = "pronoun";
            $parsed .= "pronoun ";
        }
        elsif ( $word =~ /[A-ZÆØÅ][\w]+/ ) {
            say "'$word' is a name.\n";
            $results{$i} = "name";
            $parsed .= "name ";
        }
        else { say "wtf.\n" }
    }

    my @parsed = split( ' ', $parsed );
    if ( $parsed =~ /adverb verb/ ) {
        say "Illegal word order detected. 0012 will not like this.";

        # One word has now been processed.
        $i += 1;
    }

    if ( grep( /etter/, @ARGV ) ) {

    }

    p %results;
    say $parsed;
    p @parsed;
}
