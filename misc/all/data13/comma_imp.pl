#!/bin/perl
use feature 'say';
use utf8;
use Number::Fraction;

sub comma_imp {

# todo: weakness: sometimes get FPs like in: "Fremhev søkeord, finn bestemte ord eller hopp til relevante deler av en side."

    my $target  = shift;
    my $results = shift;
    my $number  = shift;
    my @words =
      qw( trykk installer legg koble skriv høyreklikk kom velg bruk følg gjør merk start gi slutt nevn finn åpne slå logg slett tøm fjern last begynn se del ta si sjekk lagre oppfør kommenter godta hold gå stå sett levér dra aktivér zoom vurder varsle samle ring oppdater ha erstatt avvis utløs tilpass spør rediger rapportér posisjonér overfør oppgi øk krev kjøp jobb hent angi atskil adskil viderekoble avslå vend utfør sørg pass skyv prøv tell oppgrader lad juster inviter husk filtrer delta betal behold );

    if ( $target =~ m/, [\w]+/ ) {
        foreach $word (@words) {
            if ( $target =~ m/, $word\b/g ) {
                $$results{"id=\"$number\""}{advanced}{", $word"} += 1;
            }
        }
    }
}
1;
