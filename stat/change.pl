use File::ChangeNotify;
 
my $watcher =
    File::ChangeNotify->instantiate_watcher
        ( directories => [ './' ],
          filter      => qr/\.(?:pm|conf|yml)$/,
        );
 
if ( my @events = $watcher->new_events() ) { ... }
 
# blocking
while ( my @events = $watcher->wait_for_events() ) { print "\nA file has changed\n" }
