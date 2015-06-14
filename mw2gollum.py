#from time import strptime, strftime
import os
import codecs
from datetime import datetime
from bs4 import BeautifulSoup

def convert(dump, folder, clean_script, user_map):
    soup = BeautifulSoup(open(dump, 'r'))
    commits = []
    for page in soup.find_all('page'):
        title = page.title.string.replace(':', ' ').replace('_', '-').replace(' ', '-')
        if title == 'Main-Page':
            title = 'Home'
        #print title
        for revision in page.find_all('revision'):
            contributor = revision.contributor.username.string
            # timestamp like 2011-10-07T21:11:55Z
            timestamp_str = revision.timestamp.string
            timestamp = datetime.strptime(timestamp_str, '%Y-%m-%dT%H:%M:%SZ')
            #print '\t', contributor
            #print '\t', timestamp
            text = revision.find('text').string
            #print '\t\t', text
            commits.append({
              'title' : title,
              'contributor' : contributor,
              'timestamp' : timestamp,
              'timestamp_str' : timestamp_str,
              'text' : text,
              })
        #break
    commits.sort(key=lambda r: r['timestamp'])
    #print commits
    os.mkdir(folder)
    os.chdir(folder)
    os.system('git init .')
    for commit in commits:
        #print commit
        fname = commit['title'] + '.mediawiki'
        update = 'Update' if os.path.exists(fname) else 'Create'
        print "author: '%s', date: '%s', title: '%s'" % (commit['contributor'], commit['timestamp_str'], commit['title'].replace('-', ' '))
        if commit['text']:
            with codecs.open(fname, 'w', 'utf-8') as page_file:
                page_file.write(commit['text'])
            if clean_script:
                os.system(clean_script + ' "' + fname + '"')
        elif update == 'Update':
            os.remove(fname)
            update = 'Remove'
        #print "author: '%s', date: '%s', title: '%s'" % args
        os.system('git add --all .')
        os.system('git commit --author="%s" --date="%s" -m "%s MediaWiki page \'%s\'"' % (user_map.get(commit['contributor'], commit['contributor'] + ' <' + commit['contributor'].replace(' ', '_') + '@rswiki.moparisthebest.com>'), commit['timestamp_str'], update, commit['title'].replace('-', ' ')))

user_map = {
  'Admin':          't4 <t4@rswiki.moparisthebest.com>',
  'Ambokile':       'Jameskmonger <jameskmonger@hotmail.co.uk>',
  'Arham 4':        'Arham Siddiqui <tryusyo@yahoo.com>',
  'AtomicInt':      'Ryley Kimmel <ryley.kimmel@live.com>',
  'Graham':         'Graham Edgecombe <grahamedgecombe@gmail.com>',
  'Major':          'Major- <major@emulate.rs>',
  'Moparisthebest': 'moparisthebest <admin@moparisthebest.com>',
  'Pure':           'Pure_ <mail@pure2.net>',
  'Sini':           'Sini <hadyn.richard@gmail.com>',
  }

dump = 'RSWiki-20150610160818.xml'
dump = 'RSWiki-20150610171636.xml'

convert(dump, './pywiki/', '../mwbashclean.sh', user_map)
