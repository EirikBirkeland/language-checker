#!/usr/bin/env perl 
#      CREATED: 01. okt. 2015 kl. 13.55 +0200
use strict;
use warnings;
use utf8;
use 5.10.1;
use Data::Printer;
use Term::ANSIColor qw(:constants);

sub flash_warn {
    while (42) {
        say GREEN ON_BLUE "WARNING!!! " x 49, "\n";
    }
}

flash_warn();
