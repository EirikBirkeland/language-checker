#!/bin/bash

echo "**=- Installing xml2 and libxml2-dev -=**"
sudo apt-get install xml2 libxml2-dev
echo "**=- Installing XML::LibXML -=**"
sudo cpan install XML::LibXML
