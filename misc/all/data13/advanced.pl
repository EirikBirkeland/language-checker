    use feature 'say';
    use utf8;
    use Number::Fraction;
    use XML::LibXML;

    sub run_advanced_tests {

        my $source  = shift;
        my $target  = shift;
        my $i       = 0;
        my $results = shift;
        my $number = shift;
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

         #   say "Test ID is $id";
         #   say "Test source is $adv_source";
         #   say "Test target is $adv_target";
         #   say "Test desc is $desc";
         #   say "Test error is $error\n";

            # my $error = Number::Fraction->new("$error");

            if ( $adv_source =~ /none/i ) {
                $adv_source = ".";
            }

            if (   ( $adv_source_attr =~ /invert/ )
                && ( $adv_target_attr !~ /invert/ ) )
            {
                if (   ( $source !~ /$adv_source/ )
                    && ( $target =~ /$adv_target/ ) )
                {
                    ${$results}{"id=\"$number\""}{advanced}{$desc} +=
                      "$error";
                }
            }
            elsif (( $adv_source_attr =~ /invert/ )
                && ( $adv_target_attr =~ /invert/ ) )
            {
                if (   ( $source !~ /$adv_source/ )
                    && ( $target !~ /$adv_target/ ) )
                {
                    ${$results}{"id=\"$number\""}{advanced}{$desc} +=
                      "$error";

                }
            }
            elsif (( $adv_source_attr !~ /invert/ )
                && ( $adv_target_attr =~ /invert/ ) )
            {
                if (   ( $source =~ /$adv_source/ )
                    && ( $target !~ /$adv_target/ ) )
                {
                    ${$results}{"id=\"$number\""}{advanced}{$desc} +=
                      "$error";
                }
            }
            else {

                if (   ( $source =~ /$adv_source/ )
                    && ( $target =~ /$adv_target/ ) )
                {
                    ${$results}{"id=\"$number\""}{advanced}{$desc} +=
                      "$error";
                }
            }
            $i += 1;
        }
    }

    1;
