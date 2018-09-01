use feature 'say';
use Term::ANSIColor qw(:constants);

sub find_missing_untranslatables {
    my ( $untrans, $source, $target, $results, $number ) = @_;
    my $x = 0;
    foreach ( @{$untrans} ) {
        chomp @{$untrans}[$x];
        my $ea = each_arrayref( $source, $target, $number );
        while ( my ( $source, $target, $number ) = $ea->() ) {

            if ( $source =~ /@{$untrans}[$x]/ ) {
                my $count_source = () = $source =~ /$$untrans[$x]/g;
                my $count_target = () = $target =~ /$$untrans[$x]/g;
                if ( $count_target != $count_source ) {
                    my $c_miss = $count_source - $count_target;

                    say
"<p>$c_miss instances of @$untrans[$x] missing in target:<br>\nSource:$source<br>\nTarget:$target)</p>";

                    $$results{"id=\"$number\""}{untranslatable}
                      { @{$untrans}[$x] } = "$c_miss";
                }
            }
        }
        $x += 1;
    }
}
1;
