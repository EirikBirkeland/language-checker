use 5.20.1;

sub check_string_length {

# Compare string lengths.
# Add comparison of number of periods and commas. Suggest to user that target is missing or contains extra sentences! Also, count number of total words and compare.

    my ($source, $target, $results, $number) = @_;

    my $test = @{$number};

    # foreach my $i (@number) {
    for ( my $i = 0 ; $i < scalar $test ; $i++ ) {
        my $sourceLength = length( ${$source}[$i] );
        my $targetLength = length( ${$target}[$i] );
        my $percent = sprintf( "%.f", $targetLength / $sourceLength * 100 );
        if ( $sourceLength > 25
            && ( $percent < 60 || $percent > 150 ) )
        {
            #  print "${$source}[$i] \n \n $target\n \n ";
            #  print " Translation is $percentShorter% of source \n ";
            ${$results}{"id=\"${$number}[$i]\""}{length} = "$percent %";
        }
    }
}
1;
