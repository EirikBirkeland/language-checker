use 5.10.1;
use feature 'say';
use utf8;
sub run_simple_tests {

my $red = "\e[1;31m";
my $reset = "\e[0m";

    my ( $simpleLines, $target, $results, $number ) = @_;
    for ( my $x = 0 ; $x < @{$simpleLines} ; $x++ ) {
        my @field = split /\t/, @{$simpleLines}[$x];
        chomp @field;
        my $ea = each_arrayref( $target, $number );
        while ( my ( $target, $number ) = $ea->() ) {
            if ( $target =~ /$field[0]/ ) {

                my $target_html = $target;
                my $field0_html = $field[0];
                my $field1_html = $field[1];

                $target_html =~ s/(.*)/target($1)/e;
                $field0_html =~ s/(.*)/wrong($1)/e;
                $field1_html =~ s/(.*)/suggest($1)/e;

                my $target_ansi = $target;
                my $field0_ansi = $field[0];
                my $field1_ansi = $field[1];

                $field0_ansi =~ s/(.*)/$red$1$reset/;

                say "<p>$target<br>$field[0] -> $field[1]</p>";
                warn "$target_ansi\n$field0_ansi -> $field1_ansi\n\n";
                ${$results}{"id=\"$number\""}{simple}{ $field[0] } += "1";
            }
        }
    }
}
1;
