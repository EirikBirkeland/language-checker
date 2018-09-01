use XML::LibXML;

my $parser = XML::LibXML->new();
my $doc    = $parser->parse_file("test1.xlf");

foreach my $TU ($doc->findnodes('//trans-unit')) {
  
  my($number) = $TU->findnodes('./@id');
  my($source) = $TU->findnodes('./source');
  my($target) = $TU->findnodes('./target');

#  print $number->to_literal, "\n";
  binmode(STDOUT, ":utf8");
  print $number->to_literal, "\n";
  print $source->to_literal, "\n"; 
  print $target->to_literal, "\n";
  }
