use XML::LibXML::Reader;

my $reader = XML::LibXML::Reader->new(location => "test1.xlf")
    or die "cannot read file.xml\n";
while ($reader->read) {
    processNode($reader);
}

sub processNode {
    my $reader = shift;
    printf "%d %d %s %d\n", ($reader->depth,
                             $reader->nodeType,
                             $reader->name,
                             $reader->isEmptyElement);
}
