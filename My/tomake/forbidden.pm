forbidden {

    # How can this be done as fast as possible? perhaps non-regex way.

    if target =~ /(Google Play Music)/ {
        print "forbidden term found: $1";
      }
}
1;
