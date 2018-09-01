use feature 'say';

sub check_string_length {

# Compare string lengths.
# Add comparison of number of periods and commas. Suggest to user that target is missing or contains extra sentences! Also, count number of total words and compare.

    # Add word counting:

    my ( $source, $target, $results, $number ) = @_;

    for ( my $i = 0 ; $i < @{$number} ; $i++ ) {

        my $sourceWordC       = () = $$source[$i] =~ /\S+/g;
        my $targetWordC       = () = $$target[$i] =~ /\S+/g;
        my $sourcePeriodCount = () = $$source[$i] =~ /(?<!\.)\. /g;
        my $targetPeriodCount = () = $$target[$i] =~ /\./g;
        my $sourceCommaCount  = () = $$source[$i] =~ /,/g;
        my $targetCommaCount  = () = $$target[$i] =~ /,/g;

        # Not used for now:
        my $sourcePunctCount = $sourceperiodCount + $sourceCommaCount;
        my $targetPunctCount = $targetperiodCount + $targetCommaCount;

        #                  #

        my $sourceLength = length( $$source[$i] );
        my $targetLength = length( $$target[$i] );

        my $percent = sprintf( "%.f", $targetLength / $sourceLength * 100 );
        my $ratio;

# TODO: This particular if test should only be run if appropriate parameter is specified. PS. the tags below were chosen for their color only as specified in CSS already.
# if ( $targetLength > $sourceLength ) {
#    say "<p>Target in segment $$number[$i] has exceeded source length! (Source: <span class='suggest'>$sourceLength</span> chars and Target: <span class='wrong'>$targetLength</span> chars";
#   say "<br>SOURCE($sourceLength): $$source[$i]";
#   say "<br>TARGET($targetLength): $$target[$i]</p>";
#}

        if ( $sourceLength > 25
            && ( $percent < 70 || $percent > 150 ) )
        {
            if ( $percent > 150 ) {
                $temp = $$target[$i];
                substr( $temp, $sourceLength, 0 ) =
                  '<span class=\'error\'>';
            $temp .= '</span>'; # This should be changed.. so as not to have global highlighting.
            }
            say "<p>Source: $$source[$i]<br>\nTarget: $temp<br>\n";
            say "Translation is $percent% of source\n</p>";

            $$results{"id=\"$$number[$i]\""}{length}{percent} = "$percent %";
        }

        if ( $targetWordC != 0 && $targetWordC != 0 ) {
            $ratio = $targetWordC / $sourceWordC;

            if ( $ratio >= 1.5 ) {
                say
"<p>Source: $$source[$i]<br>\nTarget: $$target[$i]<br>\nThe target has "
                  . $ratio
                  . "x more words than source.</p>\n";
                $$results{"id=\"$$number[$i]\""}{length}{ratio} = "$ratio";
            }
        }
        if (   ( $targetPeriodCount < ($sourcePeriodCount) )
            && ( $ratio < 0.90 )
            && ( $percent < 90 ) )
        {
            my $missingPeriods = ( $sourcePeriodCount - $targetPeriodCount );
            say
"<p>!!! SENTENCES MISSING?:\n<br> Source: $$source[$i] and \n<br>Target: $$target[$i].<br>Possibly, $missingPeriods periods are missing</p>";
            $$results{"id=\"$$number[$i]\""}{length}{missing_periods} =
              "missingPeriods";
        }
    }
}
1;
