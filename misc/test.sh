#need features: -regex list from file
#               -separation of source/target
#TODO: -Rewrite in Perl in-case that turns out better.
#TODO: Make one .doc checker as well. For example it can check
#for punctuation consistency for list items.

#!/bin/bash
# file=(  )

# TODO: Read the time stamp in file, save in variable, check frequently whether it's been updated. If updated, rerun test. Otherwise, do nothing.

count="0"
while :
  do
    find . -maxdepth 1 -name '*.xlf' -type f -mmin +666 -exec mv {} .archived \;
    find . -maxdepth 1 -name '*' -type f -mmin +120 -exec mv {} .other \; 
    shopt -s nullglob
    data=( *.xlf )


# AWESOME, but TODO: need to great modTime arrays, so that each file in the folder is checked, and any new files will be autochecked. May need a hash here? Might be easier to do this in a perl script that will simply call "chk" or 15.pl.

#
# my %files
#
# $files{$filename} = "stat value"
#
#

 for xlf in ${data[@]}
  do
  modTime=$(stat -c %Y $xlf)
  modTime2=$(stat -c %Y $xlf)
    while :
    do
      if [ $count == 0 ] || [ "$modTime2" -gt "$modTime" ]; then
          chk $xlf
          count="1" 
          modTime="$modTime2" 
     else
          sleep 0.5  
          modTime2=$(stat -c %Y $xlf)
      fi
    done
done
done
