use 5.10.1;
use Data::Printer;
use List::MoreUtils;

# Camel-case test
sub camelcase {

    my ( $source, $target, $results, $number ) = @_;

    # Extendible list of exclusions:
    
    my $ea = each_arrayref( $source, $target, $number );
    while ( my ( $source, $target, $number ) = $ea->() ) {
        my @source = split( ' ', $source );

        for my $word (@source) {
            if ( $source =~ /(\w{3,})/g ) {
                my $smatch = $1;
                if ( $target =~ /($smatch)/i ) {
                    my $tmatch = $1;
                    if (   ( $smatch !~ /$tmatch/ )
                        && not( $tmatch =~ /^[A-Z]+$/ )
                        && not( $smatch =~ /^[A-Z]+$/ ) )
                    {
                        my ( $smatch_trunc, $tmatch_trunc );
                        ( $smatch_trunc = $smatch ) =~ s/^.//;
                        ( $tmatch_trunc = $tmatch ) =~ s/^.//;
                        if ( $tmatch_trunc !~ $smatch_trunc ) {
                            say "<p>$smatch and $tmatch<br>\n";
                            say "$source<br>\n$target<br>\n</p>";
                        }
                    }
                }
            }
        }
    }
}
1;
