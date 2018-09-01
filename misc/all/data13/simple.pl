use Term::ANSIColor qw(:constants);
my $red   = "\e[4;31m";
my $reset = "\e[0m";

sub run_simple_tests {
    my $simpleLines = shift;
    my $target      = shift;
    my $results     = shift;
    my $number      = shift;
    $x = 0;
my $test = @{$number};
    foreach ( @{$simpleLines} ) {
        my @field = split /\t/, @{$simpleLines}[$x];
        chomp @field;
        for ( my $i = 0 ; $i < scalar $test ; $i++ ) {
                if ( ${$target}[$i] =~ s/\b($field[0])\b/$red$1$reset/ ) {
                print "${$target}[$i]\n", RED, "$field[0]",
                  YELLOW, "--->", BLUE, "$field[1]\n\n", RESET;
                ${$results}{"id=\"${$number}[$i]\""}{simple}{ $field[0] } += 1;
            }
        }
        $x += 1;
    }
}
1;
