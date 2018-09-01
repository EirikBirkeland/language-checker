#!/bin/perl
use feature 'say';
use utf8;
use Number::Fraction;

sub comma_imp {

# todo: weakness: sometimes get FPs like in: "Fremhev søkeord, finn bestemte ord eller hopp til relevante deler av en side."

    my ( $target, $results, $number ) = @_;

    my @words =
      qw( trykk installer legg koble skriv høyreklikk kom velg bruk følg gjør merk start gi slutt nevn finn åpne slå logg slett tøm fjern last begynn se del ta si sjekk lagre oppfør kommenter godta hold gå stå sett levér dra aktivér zoom vurder varsle samle ring oppdater ha erstatt avvis utløs tilpass spør rediger rapportér posisjonér overfør oppgi øk krev kjøp jobb hent angi atskil adskil viderekoble avslå vend utfør sørg pass skyv prøv tell oppgrader lad juster inviter husk filtrer delta betal behold );

    my $test = @$number;

    for ( my $i = 0 ; $i < scalar $test ; $i++ ) {
        if ( length( $$target[$i] ) > 25 ) {
            if ( $$target[$i] =~ /, [\wæøå]{2,}/ ) {
                if ( $$target[$i] =~
m/, \b(?!(?:kan|og|må|men|eller|som|er|for|blir|så|med|klikker|trykker|inkludert|slik|i|vises|hvis|ser|har|går|bruker|samt|bør|får|velger|kommer|på|følger|vil|uten|ved|når|fransk|avhengig|tysk|ikke|en|spansk|selv|noe|italiensk|anbefaler|til|gjør|det|lagres|sender|musikk|bilder|sveiper|japansk|der|apper|trenger|russisk|koreansk|ber|redigere|nettbrett|mottar|mens|portugisisk|herunder|blant|angir|se|enten|engelsk|organisasjoner|filmer|et|norsk|kinesisk|foreslår|sendes|ruller|fjerner)\b)[\wæøå]{2,}\b (?!\bdu\b)/
                  )
                {
                    foreach $word (@words) {
                        if ( $$target[$i] =~ m/, $word\b/g ) {
                            $$results{"id=\"$$number[$i]\""}{advanced}
                              {", $word"} += 1;
                        }
                    }
                }
            }
        }
    }
}
1;
