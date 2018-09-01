use 5.20.1;

my $source = "This is the source text, containing Chrome.";
my $target = "Dette er målteksten, og inneholder chrome.";
my $match;
my @source;
my $word;

@source = split( ' ', $source );
for $word (@source) {
    if ( $source =~ /(\w+)/g ) {
        $match = $1;
        say $match;
        if ( $target =~ /($match)/i ) {
            say "it matches insensitively.($match and $1)";
        }
        if ( $source !~ /$1/ ) {
            say "but the capitalization differs.";
        }

    }
}
