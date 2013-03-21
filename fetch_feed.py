#!/usr/bin/env python

import json
import os

import requests

response = requests.get('http://api.npr.org/query?id=92071316&apiKey=%s&output=json' % os.environ['NPR_API_KEY'])

data = response.json() 

output = []

for story in data['list']['story']:
    item = {
        'Id': story['id'],
        'Title': story['title']['$text'],
        'Description': story['miniTeaser']['$text'],
        'SDPosterUrl': None,
        'HDPosterUrl': None,
        #'Length': 0,
        #'ReleaseDate': '',
        'StreamFormat': 'mp4',
        'Stream': {
            'Url': None
        }
    }

    thumbnail_url = story['thumbnail']['medium']['$text']

    item['SDPosterUrl'] = thumbnail_url.replace('s=13', 's=3')
    item['HDPosterUrl'] = thumbnail_url.replace('s=13', 's=4')

    # Audio url: http://pd.npr.org/npr-mp4/npr/asc/2013/03/20130308_asc_hayes.mp4
    # Video url: http://pd.npr.org/npr-mp4/npr/ascvid/2013/03/20130308_ascvid_hayes-n-1200000.mp4
    audio_url = story['audio'][0]['format']['mp4']['$text']
    item['Stream']['Url'] = audio_url.replace('asc', 'ascvid').replace('.mp4', '-n-1200000.mp4')

    output.append(item)

with open('source/tinydesk.json', 'w') as f:
    json.dump(output, f, indent=4)
