use feature 'say';

sub equal_seg {
    my ( $source, $target, $results, $number ) = @_;
    my $num = 0 + @$number;
    for ( my $i = 0 ; $i < $num ; $i++ ) {
        if ( $$source[$i] eq $$target[$i] ) {
            say
"<p>#$$number[$i]: $$source[$i]</p>";
            $$results{"id=\"$$number[$i]\""}{identical} += 1;
        }
    }
}
1;
