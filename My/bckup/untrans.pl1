sub find_missing_untranslatables {
    my $untrans = shift;
    my $s       = shift;
    my $t       = shift;
    my $results = shift;
    $i = 0;
    foreach ( @{$untrans} ) {
        chomp @{$untrans}[$i];
        if ( $s =~ s/(@{$untrans}[$i])/$red$1$normal/g ) {
            my $c_s = () = $s =~ /@{$untrans}[$i]/g;
            my $c_t = () = $t =~ /@{$untrans}[$i]/g;
            if ( $c_t != $c_s ) {
                $t =~ s/(@{$untrans}[$i])/$red$1$normal/g;
                my $c_miss = $c_s - $c_t;
                print
"UNTRANSLATABLE: $c_miss instances of @{$untrans}[$i] missing in Target: $t\n($s)\n\n";
                ${$results}{"id=\"$number\""}{untranslatable}{@{$untrans}[$i]} =
                  "$c_miss";
            }
        }
        $i += 1;
    }
}
1;
