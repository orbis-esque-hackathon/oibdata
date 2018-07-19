import os, sys, re, codecs, json, time, datetime
import random
with codecs.open('places_new_structure.geojson', 'r', 'utf8') as p:
    places = json.load(p)
    
fout = codecs.open('places_plus_te.geojson', 'w', 'utf8')
fout.write('{"type":"FeatureCollection",\n\t"features":[\n\t\t')

booly = [True, False]
for f in places['features']:
    f['properties']['althurayyaData']['ppl'] = random.randint(0,9)
    f['properties']['althurayyaData']['atWar'] = random.choice(booly)
    fout.write(json.dumps(f, indent=2)+',\n')
fout.write('\n]}')

fout.close()

with codecs.open('routes.json', 'r', 'utf8') as r:
    routes = json.load(r)
    
fout2 = codecs.open('routes_plus.geojson', 'w', 'utf8')
fout2.write('{"type":"FeatureCollection",\n\t"features":[\n\t\t')

booly = [True, False]
for r in routes['features']:
    #print(r['properties'])
    r['properties']['danger'] = '%.2f' % random.random()
    r['properties']['winter'] = random.choice(booly)
    fout2.write(json.dumps(r, indent=2)+',\n')
fout2.write('\n]}')

fout2.close()