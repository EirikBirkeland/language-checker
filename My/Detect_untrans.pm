use feature 'say';

sub detect_untrans {
   my ( $source, $target, $results ) = @_;

   my ( %target_hash, %source_hash );

   # TODO: Further split @source and @target arrays by individual words.
   my $source_text = join( ' ', @$source );
   my $target_text = join( ' ', @$target );
   my @source_words = split( ' ', $source_text );
   my @target_words = split( ' ', $target_text );

# but a more elegant split method should be employed. perhaps use a lib that produces good results, or write a nice RegEx using regex101.com

   # Remove periods and commas
   s/[,.]// foreach (@source_words);
   s/[,.]// foreach (@target_words);

   # Remove duplicates from array.
   @source_words = uniq(@source_words);
   @target_words = uniq(@target_words);

   # Remove unlikely candidates
   @target_words = grep !/^[a-z]{0,5}$|^\w{0,2}$/, @target_words;

   # Count occurrences and throw into hash
   foreach my $word (@source_words) {
      $source_hash{$word} += () = $source_text =~ /\Q$word\E/g;
   }
   foreach my $word (@target_words) {
      $target_hash{$word} += () = $target_text =~ /\Q$word\E/g;
   }

   # Compare frequency of occurrence by percentage.
   foreach my $word (@source_words) {
      if ( ( exists $target_hash{$word} ) && ( $source_hash{$word} != 0 ) ) {
         my $percentage = $target_hash{$word} / $source_hash{$word};
         if (   ( $percentage >= 0.7 )
            && ( $percentage <= 1.3 )
            && ( $percentage != 1 ) )
         {
            # Reformat number
            $percentage = sprintf( "%.1f", $percentage * 100 );
            say
            "$percentage%: Source: $source_hash{$word} Target: $target_hash{$word}\t$word<br>";

            #      TODO: Add Accept / reject candidate

            #   my $input = <STDIN>;
            #  if $input eq "yes" {...} elsif $input eq "no" {...};
         }
      }
   }
}
1;
