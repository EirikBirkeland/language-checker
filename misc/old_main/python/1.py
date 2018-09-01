# -*- coding: utf-8 -*-
from operator import itemgetter
import sys
from os import path
import xml.etree.ElementTree as ET
tree = ET.parse('test1.xlf')
root = tree.getroot()

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'

###########
with open("tests/simple.txt", "r") as f:
    data = f.readlines()

    for line in data:
        line = line.rstrip('\n')
     #   words = line.split("\t")
     #   print(words) 
        words = line.split("\t") 
        error, suggestion = words[:2] 
        print(error)
        print(suggestion)
for transunit in root.iter('trans-unit'):
    print (transunit.attrib['id'])
    for source in transunit.iter('source'):
        print bcolors.OKGREEN + (source.text) + bcolors.ENDC
    for target in transunit.iter('target'):
        print (target.attrib)
        print bcolors.WARNING + (target.text) + bcolors.ENDC
