use 5.10.1;

sub term_incon {
    my ( $source, $target, $results, $number ) = @_;
    my $target_merged = join '', @$target;
    my $tm = $target_merged;

    open( RAW, "<", "/home/eb/projects/xml_parser/data/synonyms.txt" )
      or die "Can't open synonyms.txt: $!";
    my @raw = <RAW>;
    close RAW;

    # Remove empty lines test
    my @synonyms;
    foreach (@raw) {
        if ( ( defined $_ ) and !( $_ =~ /^\s*$/ ) ) {
            push( @synonyms, $_ );
        }
    }

    my $index;
    my $value;
    foreach (@synonyms) {
        $index++;
        $value = 0;
        my @field = split( '\t', $_ );
        chomp @field;
        my ( $one, $two, $three );
        if ( $tm =~ /($field[0])/ ) { $value++; $one = $1; }
        if ( defined $field[1] && $tm =~ /($field[1])/ ) {
            $value++;
            $two = $1;
        }
        if ( defined $field[2] && $tm =~ /($field[2])/ ) {
            $value++;
            $three = $1;
        }
        if ( !defined $three ) { $three = " "; }
        if ( $value >= 2 ) {
            my $count_one   = () = $tm =~ /$one/g;
            my $count_two   = () = $tm =~ /$two/g;
            my $count_three = () = $tm =~ /$three/g;
            $$results{ALL_TEXT}{"test$index"}{$one}   = $count_one;
            $$results{ALL_TEXT}{"test$index"}{$two}   = $count_two;
            $$results{ALL_TEXT}{"test$index"}{$three} = $count_three;

        }
    }
}
1;
