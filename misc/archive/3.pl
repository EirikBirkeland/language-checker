use XML::LibXML::Reader;

 my $reader = XML::LibXML::Reader->new(location => "test1.xlf")
         or die "cannot read file.xml\n";
    $reader->preservePattern('//table/tr');
    $reader->finish;
    print $reader->document->toString(1);
