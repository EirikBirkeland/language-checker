    use feature 'say';
    use utf8;
    use XML::LibXML;
 
    sub run_advanced_tests {

my ( $source, $target, $results, $number ) = @_;

        my $i       = 0;
        $doc = XML::LibXML->new->parse_file('tests/advanced.xml');
        binmode( STDOUT, ":encoding(UTF-8)" );
        foreach my $TU ( $doc->findnodes('body/test-unit') ) {

            my $id              = $TU->findnodes('./@id')->to_literal;
            my $adv_source      = $TU->findnodes('./source')->to_literal;
            my $adv_source_attr = $TU->findnodes('./source/@attr')->to_literal;
            my $adv_target      = $TU->findnodes('./target')->to_literal;
            my $adv_target_attr = $TU->findnodes('./target/@attr')->to_literal;
            my $desc            = $TU->findnodes('./desc')->to_literal;
            my $error           = $TU->findnodes('./error')->to_literal;

# Compile regexes for increased performance (saved 50 ms in one measurement for just 15-20 tests.)
#$adv_source = qr/$adv_source/;
#$adv_target = qr/$adv_target/;

  #          say "Test ID is $id";
  #          say "Test source is $adv_source";
  #          say "Test target is $adv_target";
  #          say "Test desc is $desc";
  #          say "Test error is $error\n";

 
            my $num = @{$number};
            for ( my $i = 0 ; $i < $num ; $i++ ) {

                if ( !defined $adv_source ) {
                    $adv_source = ".";
                }

                if (   ( $adv_source_attr =~ /invert/ )
                    && ( $adv_target_attr !~ /invert/ ) )
                {
                    if (   ( ${$source}[$i] !~ /$adv_source/ )
                        && ( ${$target}[$i] =~ /$adv_target/ ) )
                    {
                        ${$results}{"id=\"${$number}[$i]\""}{advanced}{$desc}
                          += "$error";
                    }
                }
                elsif (( $adv_source_attr =~ /invert/ )
                    && ( $adv_target_attr =~ /invert/ ) )
                {
                    if (   ( ${$source}[$i] !~ /$adv_source/ )
                        && ( ${$target}[$i] !~ /$adv_target/ ) )
                    {
                        ${$results}{"id=\"${$number}[$i]\""}{advanced}{$desc}
                          += "$error";

                    }
                }
                elsif (( $adv_source_attr !~ /invert/ )
                    && ( $adv_target_attr =~ /invert/ ) )
                {
                    if (   ( ${$source}[$i] =~ /$adv_source/ )
                        && ( ${$target}[$i] !~ /$adv_target/ ) )
                    {
                        ${$results}{"id=\"${$number}[$i]\""}{advanced}{$desc}
                          += "$error";
                    }
                }
                else {

                    if (   ( ${$source}[$i] =~ /$adv_source/ )
                        && ( ${$target}[$i] =~ /$adv_target/ ) )
                    {
                        ${$results}{"id=\"${$number}[$i]\""}{advanced}{$desc}
                          += "$error";
                    }
                }
                $i += 1;
            }
        }
    }
    1;

__END__


use Number::Fraction;
my $error = Number::Fraction->new("$error");
