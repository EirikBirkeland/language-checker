import re
import collections
words = re.findall('\w+', open('combined.xlf').read().lower())
print collections.Counter(words).most_common(50)
