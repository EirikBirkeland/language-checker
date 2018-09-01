use strict;
use warnings;

# I did this to see how I can improve an old function now :-) There are some differences, such as just 2 scalar input values.

sub camelcase($$) {
    my ( $source, $target ) = @_;
    my @source = split( ' ', $source );

    for my $word (@source) {
        if ($word =~ /(\w{3,})/) {
            # to be continued 
        }
    }
}
