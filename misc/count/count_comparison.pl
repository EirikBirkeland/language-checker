use v5.10;
my $text = 'asdf asdf asdf asdf asdf';

sub count_array {
   my @text_words = split(/\s+/, $text);
   scalar(@text_words);
}

sub count_list {
   my $x =()= $text =~ /\S+/g;       #/
}

sub count_while {
   my $num; 
   $num++ while $text =~ /\S+/g;     #/
   $num
}

sub count_tr {
    1 + ($text =~ tr{ }{ });
}

say count_array; # 5
say count_list;  # 5
say count_while; # 5
say count_tr; # 5

use Benchmark 'cmpthese';

cmpthese -2 => {
    array => \&count_array,
    list  => \&count_list,
    while => \&count_while,
    tr    => \&count_tr,
}
