use 5.20.1;
use Term::ANSIColor qw(:constants);
my ($red, $reset) = ("\e[4;31m", "\e[0m");
sub verify_ids {

    my ($number) = @_;
    my $test = @{$number};
    my $error;
    for ( my $i = 0 ; $i < scalar $test ; $i++ ) {

        if ( $$number[$i] != $i + 1 ) {

            #    say "\$i is $i and number[$i] is $$number[$i]";
            $error++;
        }
        if ( defined $error ) {
        }
    }
    say
"$red$error segments are mislabeled.$reset\nThis is an indication that your XLF may have more serious problems!";
}
1;
