use 5.10.1;

sub consistency {

    my ( $source, $target, $results, $number ) = @_;
    my %length = ();
    my $test;
    my ( $seg1, $seg2 );
    my $count;
    my %data = ();
    my @new;
    my $num = @$number;
    my $ea = each_arrayref( $source, $target, $number );
    while ( my ( $source, $target, $number ) = $ea->() ) {

        $data{$number}{source} = $source;
        $data{$number}{target} = $target;
    }

    for ( my $i = 1 ; $i < 50 ; $i++ ) {
        for ( my $s = 1 ; $s < 50 ; $s++ ) {

            # say "\$i = $i, \$s = $s";
            if ( $data{$i}{source} eq $data{$s}{source} && ( $i != $s ) ) {
                say "These match: $i and $s";
                my $is = "$i:$s";
                say $is;
                push( @new, $is );
            }
        }
    }

    # invert entire hash

    # Rotate values one at a time, removing all duplicates

    foreach (@new) {
        $_ =~ s/([0-9]+):([0-9]+)/$2:$1/;
        @new = uniq(@new);
    }

# New idea: put a numeric group tag in each segment that matches one another... but how to put it there in the first place?
    p @new;
    if ( defined $ARGV[2] ) {
        p %data;
    }
}
1;
__END__

    First, find source segments that are identical by first
	   * getting the length of all segments
	   * matching the actual contents of those segments (any number)
	Second, if 2 source segments are identical
         Bonus:  output all segments for comparison with highlighting for differences, where the odd one out (in the case of many segments) has its differing parts highlighted.
## Please see file perltidy.ERR
