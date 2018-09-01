use feature 'say';

sub equal_seg {

    my ( $source, $target, $results, $number ) = @_;
    my $num = @$number;
    for ( my $i = 0 ; $i < $num ; $i++ ) {
        if ( $$source[$i] eq $$target[$i] ) {
${$results}{"id=\"${$number}[$i]\""}{equal} += 1;
        }
    }
}
1;
