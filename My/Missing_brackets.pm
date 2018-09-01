use 5.10.1;
use List::MoreUtils ':all';

sub missing_paren {

    my ( $source, $target, $results, $number ) = @_;

    # Check for {}, (), []

    # These next 2 lines allow iterating through multiple arrays simultaneously.

# TODO: Must add support for 1), 2), 3), etc.

    my $ea = each_arrayref( $source, $target, $number );
    while ( my ( $source, $target, $number ) = $ea->() ) {

        if ( $source =~ /[\Q()[]{}\E]/ ) {

            my $count_paren    = () = $target =~ /[\Q()\E]/g;
            my $count_brackets = () = $target =~ /[\Q[]\E]/g;
            my $count_braces   = () = $target =~ /[\Q{}\E]/g;

            if ( $count_paren % 2 == 1 ) { # Add "If not match 1) 2) 3) or similar && ...)
                say "You have an uneven number of parenthesis.<br>";
            }
            if ( $count_brackets % 2 == 1 ) {
                say "You have an uneven number of brackets.<br>";
            }
            if ( $count_braces % 2 == 1 ) {
                say "You have an uneven number of braces.<br>";
            }
        }

# Compare source and target, enumerating missing or superfluous parenthesis symbols.
        if ( $source =~ /[\(\)]/ ) {    # if ( or ) in $source

            my $source_left_count  = () = $source =~ /\(/g;
            my $target_left_count  = () = $target =~ /\(/g;
            my $source_right_count = () = $source =~ /\)/g;
            my $target_right_count = () = $target =~ /\)/g;

            if ( $source_left_count != $target_left_count ) {
                say
"the source has $source_left_count, but target has $target_left_count left parenthesis (.<br>";
                $$results{"id=\"$number\""}{left_parentheses} += 1;
            }
            if ( $source_right_count != $target_right_count ) {
                say
"the source has $source_right_count, but target has $target_right_count right parenthesis ).<br>";
                $$results{"id=\"$number\""}{right_parentheses} += 1;
            }
        }
        if ( $source =~ /[\[\]]/ ) {    # if [ or ] in $source

            my $source_left_count  = () = $source =~ /\[/g;
            my $target_left_count  = () = $target =~ /\[/g;
            my $source_right_count = () = $source =~ /\]/g;
            my $target_right_count = () = $target =~ /\]/g;

            if ( $source_left_count != $target_left_count ) {
                say
"the source has $source_left_count, but target has $target_left_count left brackets (.<br>";
                $$results{"id=\"$number\""}{left_brackets} += 1;
            }
            if ( $source_right_count != $target_right_count ) {
                say
"the source has $source_right_count, but target has $target_right_count right brackets ).<br>";
                $$results{"id=\"$number\""}{right_brackets} += 1;
            }
        }

        if ( $source =~ /[\{\}]/ ) {    # if { or } in $source

            my $source_left_count  = () = $source =~ /\{/g;
            my $target_left_count  = () = $target =~ /\{/g;
            my $source_right_count = () = $source =~ /\}/g;
            my $target_right_count = () = $target =~ /\}/g;

            if ( $source_left_count != $target_left_count ) {
                say
"the source has $source_left_count, but target has $target_left_count left braces (.<br>";
                $$results{"id=\"$number\""}{left_braces} += 1;
            }
            if ( $source_right_count != $target_right_count ) {
                say
"the source has $source_right_count, but target has $target_right_count right braces ).<br>";
                $$results{"id=\"$number\""}{right_braces} += 1;
            }
        }
    }
}
1;
