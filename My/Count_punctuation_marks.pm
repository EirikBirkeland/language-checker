# This should be somehow combined with segment length text: E.g. if a segment is both short in string length (words/chars) and also contains fewer commas/periods/etc., then those segments should be listed first in the test output.
#
# This could be done, possibly, by simply using JavaScript/CSS to put first those segments that have occurred in several texts, or better yet: For each error a segment gets, a value is incremented in that segment's hash enry. The output is then sorted according to that value.
#
# This of course requires some considerable reworking: The hash could be filled with ALL pertinent output data, to be output at the very end according to how one would like.
#
# It should not be THAT hard, and makes more sense than outputting text to console from each individual test .pm file.
# Merging several errors into one view would be a joy: Differently colored highlighting for "error #1" "error #2" etc.
# Seems realistic, and it's time to rework some core stuff -- the details phase has been largely covered ;) I rule *pat*.
