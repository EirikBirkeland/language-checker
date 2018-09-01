# List all kinds of document stats
#
#   - total length of target text compared with source
#   - 10 most common words
#   - list unusual characters in target ( ! € #)
use 5.10.1;
use List::Util qw(first max maxstr min minstr reduce shuffle sum);

sub stats {

    my ( $source, $target, $results, $number, $sourceLength, $targetLength ) =
      @_;

    my $stot = join( '', @$source );
    my $ttot = join( '', @$target );
    my $stotl = length($stot);
    my $ttotl = length($ttot);
    my $ratio = $ttotl / $stotl;

    $ratio = sprintf( "%.1f", $ratio * 100 );

    say
"\n\nThe translation has a length of $ttotl compared with source $stotl\n and is $ratio % longer than the source.\n";

}
1;
