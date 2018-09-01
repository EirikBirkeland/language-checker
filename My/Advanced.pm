    use feature 'say';
    use utf8;
    use XML::LibXML;
    use Data::Printer;
    use Time::HiRes 'time';

    sub run_advanced_tests {

        my ( $source, $target, $results, $number ) = @_;
        my ( $id, $adv_source, $adv_source_attr, $adv_target, $adv_target_attr,
            $desc, $error, $instruction );
        my ( @id, @adv_source, @adv_source_attr, @adv_target, @adv_target_attr,
            @desc, @error, @instruction );

        my $doc = XML::LibXML->new->parse_file("$DATA/advanced.xml");

        #    binmode( STDOUT, ":encoding(UTF-8)" );
        foreach my $TU ( $doc->findnodes('body/test-unit') ) {

            $id              = $TU->findvalue('./@id');
            $adv_source      = $TU->findvalue('./source');
            $adv_source_attr = $TU->findvalue('./source/@attr');
            $adv_target      = $TU->findvalue('./target');
            $adv_target_attr = $TU->findvalue('./target/@attr');
            $desc            = $TU->findvalue('./desc');
            $error           = $TU->findvalue('./error');
            $speed           = $TU->findvalue('./speed');
            $instruction     = $TU->findvalue('./instruction');

            push( @id,              $id );
            push( @adv_source,      $adv_source );
            push( @adv_source_attr, $adv_source_attr );
            push( @adv_target,      $adv_target );
            push( @adv_target_attr, $adv_target_attr );
            push( @desc,            $desc );
            push( @error,           $error );
            push( @speed,           $speed );
            push( @instruction,     $instruction );
        }

# my @all = ( \@id, \@adv_source, \@adv_source_attr, \@adv_target, \@adv_target_attr, \@dec, \@error, \@speed )
        my $startTime;
        my $stopTime;

# Compile regexes for increased performance (saved 50 ms in one measurement for just 15-20 tests.)
#$adv_source = qr/$adv_source/;
#$adv_target = qr/$adv_target/;
        my $num_test = @id;
        my $num      = @{$number};

        my $ea = each_arrayref(
            \@speed,           \@adv_source,      \@adv_target,
            \@adv_source_attr, \@adv_target_attr, \@desc,
            \@error,           \@id,              \@instruction
        );

        while (
            my (
                $speed,           $adv_source,      $adv_target,
                $adv_source_attr, $adv_target_attr, $desc,
                $error,           $id,              $instruction
            )
            = $ea->()
          )
        {

            $x++
              if ( defined $ARGV[2]
                && $ARGV[2] =~ /fast/
                && $speed =~ /[0-9]/
                && $speed >= 0.05 );

# ToDO: Add counting of number of matches, and raise exception if numbers indicate more than the single error reported.
# .
            $startTime = time();

            my $ab = each_arrayref( $source, $target, $number );

            while ( my ( $source, $target, $number ) = $ab->() ) {

                if (   ( $adv_source_attr =~ /invert/ )
                    && ( $adv_target_attr !~ /invert/ ) )
                {
                    if (   ( $source !~ /$adv_source/ )
                        && ( $target =~ /$adv_target/ ) )
                    {
                        ${$results}{"id=\"$number\""}{advanced}{$desc} +=
                          "$error";
                        say
"\n<p>\n$source<br>\n$target<br>\n$adv_source  ->  $adv_target<br>\n$desc ($error)\n<br>$instruction</p>";
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
                        say
"\n<p>\n$source<br>\n$target<br>\n$adv_source  ->  $adv_target<br>\n$desc ($error)\n<br>$instruction</p>";
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
                        say
"\n<p>\n$source<br>\n$target<br>\n$adv_source  ->  $adv_target<br>\n$desc ($error)\n<br>$instruction</p>";
                    }
                }
                else {
                    if (   ( $source =~ /$adv_source/ )
                        && ( $target =~ /$adv_target/ ) )
                    {
                        ${$results}{"id=\"$number\""}{advanced}{$desc} +=
                          "$error";
                        my $source_h      = $source;
                        my $target_h      = $target;
                        my $desc_h        = $desc;
                        my $error_h       = $error;
                        my $adv_source_h  = $adv_source;
                        my $adv_target_h  = $adv_target;
                        my $instruction_h = $instruction;

                        $source_h =~ s/($adv_source)/adv_source("$1")/ge;
                        $target_h =~ s/($adv_target)/adv_target("$1")/ge;

                        $instruction_h =~ s/(.*)/instruction("$1")/e;
                        $source_h =~ s/(.*)/source("$1")/e;
                        $target_h =~ s/(.*)/target("$1")/e;
                        $desc_h =~ s/(.*)/desc("$1")/e;
                        $error_h =~ s/(.*)/error("$1")/e;
                        $adv_source_h =~ s/(.*)/adv_source("$1")/e;
                        $adv_target_h =~ s/(.*)/adv_target("$1")/e;

                        say
"\n<p>\n$source_h<br>\n$target_h<br>\n$adv_source_h  ->  $adv_target_h<br>\n$desc_h ($error_h)\n<br>$instruction_h</p>";
                    }
                }
                $i += 1;
            }
            $stopTime = time();

#  printf("Test source: $adv_source target: $adv_target took %.5f seconds.\n",$stopTime - $startTime );
            if ( $stopTime - $startTime > 0.1 ) {
                warn
                  "Test $id about $adv_source / $adv_target is very slow:",
                  $stopTime - $startTime, "\nConsider optimizing.";
            }
        }
    }
    1;
