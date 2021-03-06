use 5.10.1;
use utf8;
use Term::ANSIColor;
use List::MoreUtils;

my $red    = "\e[4;31m";
my $reset  = "\e[0m";
my $green  = "\e[1;32m";
my $blue   = "\e[1;34m";
my $purple = "\e[1;35m";
my $orange = "\e[1;33m";

sub color_text {

    # add saving and loading of hash to save time each time this is run.
    # wget support.google.com and derive word freq list from it.
    my ( $source, $target, $results, $number ) = @_;
    my $target_merged = join( "\n\n", @$target );
    my $tm = $target_merged;
    open( FH, "<", "/home/eb/projects/xml_parser/resources/freq_tab2.txt" );
    my @raw = <FH>;
    close FH;

    my %dict;

    foreach (@raw) {
        my @field = split( '\t', $_ );
        chomp @field;
        $dict{ $field[1] } = $field[0];
    }

    my @tm = split( '\W+', $tm );
    my $before_tm = @tm;
    @tm = uniq(@tm);
    my $after_tm = @tm;
    my $removed  = $before_tm - $after_tm;
    say "\n\n$removed items were removed from the original $before_tm.\n";
    foreach (@tm) {
        chomp $_;
        if ( exists $dict{$_} ) {
            my $_count = 0;

            #    say $_;
            $_      = quotemeta($_);
            $_count = $dict{$_};

            #    say $_count;
            if ( $_count > 1000 ) { $tm =~ s/(\b$_\b)/$orange$1$reset/g; }
            elsif ( $_count > 100 ) {
                $tm =~ s/(\b$_\b)/$purple$1$reset/g;
            }
            elsif ( $_count > 30 ) {
                $tm =~ s/(\b$_\b)/$blue$1$reset/g;
            }
            elsif ( $_count > 5 ) {
                $tm =~ s/(\b$_\b)/$green$1$reset/g;
            }

        }
    }
    print $tm;
}

1;
