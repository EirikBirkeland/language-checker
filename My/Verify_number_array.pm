use feature 'say';
use Term::ANSIColor qw(:constants);
my ( $red, $reset ) = ( "\e[4;31m", "\e[0m" );

sub verify_number_array {

    my ($number) = @_;
    my $test = @{$number};
    my $error;
    for ( my $i = 0 ; $i < scalar $test ; $i++ ) {
        if ( $$number[$i] != $i + 1 ) {

            #  say "\$i is $i and number[$i] is $$number[$i]";
            $error++;
        }
    }
    if ( defined $error && $error >= 1 ) {
        if ( $HTML eq "true" ) {
            say
"$red\nYour XML's ID= numbers are not sequential.$reset\nThis is an indication that your XLF may have more serious problems!";
        }
    }
}
1;
