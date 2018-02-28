#!/usr/bin/env python
# -*- coding: utf-8 -*-
#  get_label_info.py Author "Nathan Wycoff <nathanbrwycoff@gmail.com>" Date 01.15.2018

### Scrape some info about record labels for each line in the target file, which should represent a song, by searching wikipedia

from bs4 import BeautifulSoup
import urllib2 
import urllib
from urlparse import urljoin
import time
import re
import sys

## Read the input file
input_file = sys.argv[1]
temp = open('label_info' + input_file, 'wb')
error_words = []
with open(input_file, 'r') as f:
    search_strings = f.readlines()

    for i, search_string in enumerate(search_strings):
        try:
            ## Given a song title, get the url
            #search_string = 'glad you came the wanted'
            url_base = 'https://en.wikipedia.org/w/index.php?'
            target = url_base + urllib.urlencode({'search' : search_string})

            ## Given the url, extract the record label
            #target = 'https://en.wikipedia.org/wiki/What_Makes_You_Beautiful'
            html = urllib2.urlopen(target).read()
            soup = BeautifulSoup(html, 'html.parser')

            #Check if it's a results page, just click the first link
            is_serp = len(soup.findAll('a', text = 'Special page')) > 0
            if (is_serp):
                rel_url = soup.findAll('ul', {'class' : 'mw-search-results'})[0].findAll('a')[0]['href']
                abs_url = urljoin(url_base, rel_url)
                html = urllib2.urlopen(abs_url).read()
                soup = BeautifulSoup(html, 'html.parser')

            record_row = soup.findAll('a', attrs = {'title' : 'Record label'})[0].parent.parent
            first_label = record_row.findAll('a')[1]['title']
            #first_label = record_row.findAll('li')[0].findAll('a')[0]['title']
            search_strings[i] = re.sub('\n', '', search_strings[i]) + \
                    ' -- label: ' + first_label + '\n'
            temp.write(search_strings[i])
            print(search_strings[i])
            print(first_label)

            #Sleep a little bit between tries
            time.sleep(1)
        except Exception:
            error_words.append(search_string)

temp.close()

print("All done, but I couldn't get these ones:")
for s in error_words:
    print(s)
