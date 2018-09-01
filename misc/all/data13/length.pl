sub check_string_length {

# Compare string lengths.
# Add comparison of number of periods and commas. Suggest to user that target is missing or contains extra sentences! Also, count number of total words and compare.

    my $source       = shift;
    my $target       = shift;
    my $results      = shift;
    my $number       = shift;
    my $sourceLength = length($source);
    my $targetLength = length($target);
    my $percent      = sprintf( "%.f", $targetLength / $sourceLength * 100 );
    if ( $sourceLength > 25
        && ( $percent < 60 || $percent > 150 ) )
    {
        #  print "$source \n \n $target\n \n ";
        #  print " Translation is $percentShorter% of source \n ";
        ${$results}{"id=\"$number\""}{length} = "$percent %";

# Register a positive for this test in some kind of hash containing the ID= identifier as key, for final consolidated test results output.
    }
}
1;
