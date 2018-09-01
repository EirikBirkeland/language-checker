use Benchmark qw(:all);
cmpthese( -1, { a => "++\$i", b => "\$i *= 2" } ) ;
