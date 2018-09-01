#!/usr/bin/env perl
use feature 'say';
use File::stat;
use Data::Printer;

use File::ChangeNotify;
my $watcher = File::ChangeNotify->instantiate_watcher(
    directories => ['./'],
    filter      => qr/\.(?:pl|xlf|txt)$/,
);

my @xlfs = <*.xlf>;
foreach my $xlf (@xlfs) {
    chomp;
    $hash{$xlf} = stat($xlf)->mtime;
}
p %hash;

# If any change is made to folder, do stuff between braces.
while ( my @events = $watcher->wait_for_events() ) {
    say "Something has changed, running QA on updated (or new) XLFs.";
    my @xlfs_changed = <*.xlf>;
    foreach $xlf (@xlfs_changed) {
        my $xlf_ctime = stat($xlf)->mtime;
        if ( $xlf_ctime != $hash{$xlf} ) {
            say "The old ctime is $hash{$xlf}, and the new one is $xlf_ctime";
            say "Since the mtime has changed, we will now run QA";

            # Run QA on changed file
            system("chk $xlf");

            # Update the hash so that it doesn't run more times for no reason
            $hash{$xlf} = $xlf_ctime;
        }
    }
}

# Reminder: atime - pointer to the file's datablocks & field's data is read.
#           mtime - file's data is changed
#           ctime - the file's inode is changed

# If any change in folder happens (command for this?) then make new hash and compare keys. Do tests for those files that have changed, AND any new files.

## Dunno how to use:
## if ( my @events = $watcher->new_events() ) { ... }
