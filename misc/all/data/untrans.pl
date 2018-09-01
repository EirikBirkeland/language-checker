use Term::ANSIColor qw(:constants);
my $red    = "\e[4;31m";
my $normal = "\e[0m";

sub find_missing_untranslatables {

    my ( $untrans, $source, $target, $results, $number ) = @_;

    my $x    = 0;
    my $test = @$number;
    foreach ( @{$untrans} ) {
        chomp @{$untrans}[$x];
        for ( my $i = 0 ; $i < scalar $test ; $i++ ) {
            if ( $$source[$i] =~ /@{$untrans}[$x]/ ) {
                if ( $$source[$i] =~ s/(@{$untrans}[$x])/$red$1$normal/g ) {
                    my $count_source = () = $$source[$i] =~ /@{$untrans}[$x]/g;
                    my $count_target = () = $$target[$i] =~ /@{$untrans}[$x]/g;
                    if ( $count_target != $count_source ) {
                        $$target[$i] =~ s/(@{$untrans}[$x])/$red$1$normal/g;
                        my $c_miss = $count_source - $count_target;
                        print
"UNTRANSLATABLE: $c_miss instances of @{$untrans}[$x] missing in Target: $$target[$i]\n($$source[$i])\n\n";
                        ${$results}{"id=\"$$number[$i]\""}{untranslatable}
                          { @{$untrans}[$x] } = "$c_miss";
                    }
                }
            }
        }
        $x += 1;
    }
}
1;
